import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/import/data/parsers/pdf_bank_parsers.dart';

/// Этап 24: текстовые парсеры PDF-выписок (Этап 15).
/// Даты парсятся вместе со временем, суммы — в копейки со знаком.
void main() {
  group('normalize', () {
    test('неразрывные пробелы и длинные тире приводятся к обычным', () {
      expect(
        BankTextParsers.normalize('  ООО\u00A0\u00A0Ромашка –  перевод  '),
        'ООО Ромашка - перевод',
      );
    });
  });

  group('detectBank', () {
    test('банки определяются по названию в тексте', () {
      expect(BankTextParsers.detectBank('Выписка Яндекс Банк'), 'yandex');
      expect(BankTextParsers.detectBank('ТБанк выписка'), 'tbank');
      expect(BankTextParsers.detectBank('СберБанк Онлайн'), 'sber');
      expect(BankTextParsers.detectBank('ВТБ Онлайн'), 'vtb');
      expect(BankTextParsers.detectBank('Ozon Банк справка'), 'ozon');
    });

    test('неизвестный банк — null', () {
      expect(BankTextParsers.detectBank('Ромашка Банк'), isNull);
    });
  });

  group('Яндекс Банк', () {
    test('описание идёт до даты, знак суммы сохраняется', () {
      final rows = BankTextParsers.parse('yandex', [
        'Пятёрочка 01.07.2026 -1 500,00 ₽',
        'Капитализация процентов 02.07.2026 +100,00 ₽',
      ]);

      expect(rows.length, 2);
      expect(rows[0].merchantName, 'Пятёрочка');
      expect(rows[0].amountKopecks, -150000);
      expect(rows[1].amountKopecks, 10000);
      expect(rows[1].bankCategory, 'income');
    });

    test('перевод между своими счетами получает категорию transfer', () {
      final rows = BankTextParsers.parse('yandex', [
        'Перевод между счетами одного клиента 01.07.2026 -1 000,00 ₽',
      ]);

      expect(rows.single.bankCategory, 'transfer');
    });
  });

  group('Т-Банк', () {
    test('две даты со временем и две суммы, описание в конце', () {
      final rows = BankTextParsers.parse('tbank', [
        '01.07.2026 10:00 01.07.2026 10:05 -1 500.00 ₽ -1 500.00 ₽ Пятёрочка',
      ]);

      expect(rows.length, 1);
      expect(rows.single.amountKopecks, -150000);
      expect(rows.single.merchantName, 'Пятёрочка');
      expect(rows.single.date.toLocal().hour, 10);
    });

    test('кэшбэк получает категорию income', () {
      final rows = BankTextParsers.parse('tbank', [
        '01.07.2026 10:00 01.07.2026 10:05 +100.00 ₽ +100.00 ₽ Кэшбэк за июнь',
      ]);

      expect(rows.single.amountKopecks, 10000);
      expect(rows.single.bankCategory, 'income');
    });
  });

  group('Ozon Банк', () {
    test('строка документа и двойная сумма', () {
      final rows = BankTextParsers.parse('ozon', [
        '01.07.2026 10:00:00 12345 Покупка в магазине',
        '- 1 500.00 ₽ - 1 500.00 ₽',
      ]);

      expect(rows.length, 1);
      expect(rows.single.amountKopecks, -150000);
      expect(rows.single.merchantName, 'Покупка в магазине');
      expect(rows.single.bankTransactionId, '12345');
    });

    test('назначение собирается из нескольких строк', () {
      final rows = BankTextParsers.parse('ozon', [
        '01.07.2026 10:00:00 777 Оплата заказа',
        'номер 12345 в магазине',
        '+ 2 000.00 ₽',
      ]);

      expect(rows.single.amountKopecks, 200000);
      expect(rows.single.merchantName, 'Оплата заказа номер 12345 в магазине');
    });
  });

  group('Универсальный fallback', () {
    test('неизвестный банк и много строк — парсим по дате и сумме', () {
      final rows = BankTextParsers.parse(null, [
        for (var i = 0; i < 16; i++) '01.07.2026 Пятёрочка -1 500,00',
      ]);

      expect(rows.length, 16);
      expect(rows.first.merchantName, 'Пятёрочка');
      expect(rows.first.amountKopecks, -150000);
    });

    test('мало строк без банка — пусто (нет ложных строк)', () {
      final rows = BankTextParsers.parse(null, [
        '01.07.2026 Пятёрочка -1 500,00',
        '02.07.2026 Магазин -200,00',
      ]);

      expect(rows, isEmpty);
    });

    test('служебные строки выписки отбрасываются', () {
      final rows = BankTextParsers.parse(null, [
        'Входящий остаток 01.07.2026 -1 500,00',
        for (var i = 0; i < 16; i++) '01.07.2026 Пятёрочка -1 500,00',
      ]);

      expect(rows.length, 16);
      expect(rows.every((r) => r.merchantName == 'Пятёрочка'), isTrue);
    });
  });
}
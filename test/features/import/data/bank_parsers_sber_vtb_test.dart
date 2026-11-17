import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/import/data/parsers/pdf_bank_parsers.dart';

/// Этап 24: текстовые парсеры Сбера и ВТБ (дополнение к 24.6a).
/// Сбер: расход без знака, доход с «+», 6-значный id операции.
/// ВТБ: суммы с RUB, префикс «Оплата товаров и услуг.» снимается.
void main() {
  group('Сбер', () {
    test('расход без знака становится отрицательным', () {
      final rows = BankTextParsers.parse('sber', [
        '01.07.2026 10:00 Супермаркеты -1 500,00 12 345,67 02.07.2026 123456 Пятёрочка',
      ]);

      expect(rows.length, 1);
      expect(rows.single.amountKopecks, -150000);
      expect(rows.single.merchantName, 'Пятёрочка');
      expect(rows.single.bankCategory, 'Супермаркеты');
      expect(rows.single.bankTransactionId, '123456');
    });

    test('доход со знаком «+» остаётся положительным', () {
      final rows = BankTextParsers.parse('sber', [
        '02.07.2026 11:00 Зарплата +50 000,00 62 345,67 02.07.2026 654321 ООО Ромашка',
      ]);

      expect(rows.single.amountKopecks, 5000000);
      expect(rows.single.merchantName, 'ООО Ромашка');
    });

    test('дата парсится вместе со временем', () {
      final rows = BankTextParsers.parse('sber', [
        '01.07.2026 10:05 Кафе -300,00 12 045,67 02.07.2026 111222 Кофейня',
      ]);

      expect(rows.single.date.toLocal().hour, 10);
      expect(rows.single.date.toLocal().minute, 5);
    });
  });

  group('ВТБ', () {
    test('сумма в RUB и снятие префикса описания', () {
      final rows = BankTextParsers.parse('vtb', [
        '01.07.2026 10:00:00 02.07.2026 -1500.00 RUB 10000.00 1500.00 RUB Оплата товаров и услуг. Пятёрочка',
      ]);

      expect(rows.length, 1);
      expect(rows.single.amountKopecks, -150000);
      expect(rows.single.merchantName, 'Пятёрочка');
    });

    test('описание без префикса остаётся как есть', () {
      final rows = BankTextParsers.parse('vtb', [
        '01.07.2026 10:00:00 02.07.2026 -200.00 RUB 9800.00 200.00 RUB Магазин',
      ]);

      expect(rows.single.merchantName, 'Магазин');
      expect(rows.single.amountKopecks, -20000);
    });

    test('положительная сумма сохраняет знак', () {
      final rows = BankTextParsers.parse('vtb', [
        '01.07.2026 10:00:00 02.07.2026 +5000.00 RUB 15000.00 5000.00 RUB Возврат средств',
      ]);

      expect(rows.single.amountKopecks, 500000);
    });
  });
}
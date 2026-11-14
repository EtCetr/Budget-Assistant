import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';

/// Этап 24: матрица приватности (ТЗ 6.6) в двух режимах (D19-14).
/// Разряды в ru-локали — неразрывные пробелы, поэтому убираем все пробелы.
String _clean(String value) => value.replaceAll(RegExp(r'\s'), '');

void main() {
  const formatter = PrivacyFormatter();
  const visible = BalanceVisibilityMode.visible;
  const hidden = BalanceVisibilityMode.hidden;

  group('Суммы', () {
    test('visible: рубли и копейки из целых копеек', () {
      expect(
        _clean(formatter.formatAmount(15000000, 'RUB', visible)),
        '150000,00RUB',
      );
    });

    test('visible: отрицательная сумма сохраняет знак', () {
      expect(
        _clean(formatter.formatAmount(-210000, 'RUB', visible)),
        '-2100,00RUB',
      );
    });

    test('visible: ноль', () {
      expect(_clean(formatter.formatAmount(0, 'RUB', visible)), '0,00RUB');
    });

    test('hidden: сумма полностью скрыта', () {
      expect(formatter.formatAmount(15000000, 'RUB', hidden), '•••');
      expect(formatter.formatAmount(0, 'RUB', hidden), '•••');
    });
  });

  group('Текстовые персональные данные', () {
    test('мерчант: виден в visible, скрыт в hidden', () {
      expect(formatter.formatMerchant('Перекрёсток', visible), 'Перекрёсток');
      expect(formatter.formatMerchant('Перекрёсток', hidden), '•••');
      expect(formatter.formatMerchant(null, visible), '');
    });

    test('комментарий: виден в visible, скрыт в hidden', () {
      expect(formatter.formatComment('Подарок маме', visible), 'Подарок маме');
      expect(formatter.formatComment('Подарок маме', hidden), '•••');
      expect(formatter.formatComment(null, visible), '');
    });

    test('имя участника: скрыто в hidden', () {
      expect(formatter.formatName('Мария И.', visible), 'Мария И.');
      expect(formatter.formatName('Мария И.', hidden), '•••');
    });

    test('email: скрыт в hidden', () {
      expect(formatter.formatEmail('a@b.ru', visible), 'a@b.ru');
      expect(formatter.formatEmail('a@b.ru', hidden), '•••');
    });

    test('название пространства: скрыто в hidden', () {
      expect(formatter.formatSpaceName('Семья', visible), 'Семья');
      expect(formatter.formatSpaceName('Семья', hidden), '•••');
    });

    test('название товара: скрыто в hidden', () {
      expect(formatter.formatProductName('Хлеб', visible), 'Хлеб');
      expect(formatter.formatProductName('Хлеб', hidden), '•••');
    });
  });

  group('Номер карты', () {
    test('visible: маска как есть', () {
      expect(formatter.formatCardNumber('*1234', visible), '*1234');
    });

    test('hidden: четыре точки', () {
      expect(formatter.formatCardNumber('*1234', hidden), '••••');
    });

    test('пустой номер остаётся пустым в обоих режимах', () {
      expect(formatter.formatCardNumber(null, visible), '');
      expect(formatter.formatCardNumber('', hidden), '');
    });
  });

  group('Проценты', () {
    test('обычный процент: виден в visible, пуст в hidden', () {
      expect(formatter.formatPercent(42, visible), '42%');
      expect(formatter.formatPercent(42, hidden), '');
    });

    test('базисные пункты: 500 -> 5%, 250 -> 2.5%', () {
      expect(formatter.formatPercentBps(500, visible), '5%');
      expect(formatter.formatPercentBps(250, visible), '2.5%');
      expect(formatter.formatPercentBps(0, visible), '0%');
      expect(formatter.formatPercentBps(500, hidden), '');
    });
  });

  group('Тренды цен', () {
    test('тренд и процент тренда скрываются в hidden', () {
      expect(formatter.formatPriceTrend('up', visible), 'up');
      expect(formatter.formatPriceTrend('up', hidden), '');
      expect(formatter.formatPriceTrend(null, visible), '');
      expect(formatter.formatPriceTrendPercent('+12%', visible), '+12%');
      expect(formatter.formatPriceTrendPercent('+12%', hidden), '');
    });
  });

  group('Флаги визуальных маркеров', () {
    test('в visible всё показано', () {
      expect(formatter.shouldShowFamilyColors(visible), isTrue);
      expect(formatter.shouldShowChart(visible), isTrue);
      expect(formatter.shouldShowCategoryColors(visible), isTrue);
      expect(formatter.shouldShowPriceChart(visible), isTrue);
      expect(formatter.shouldShowBrandColors(visible), isTrue);
      expect(formatter.shouldShowReceiptImage(visible), isTrue);
      expect(formatter.shouldShowCelebration(visible), isTrue);
    });

    test('в hidden визуальные маркеры отключены', () {
      expect(formatter.shouldShowFamilyColors(hidden), isFalse);
      expect(formatter.shouldShowChart(hidden), isFalse);
      expect(formatter.shouldShowCategoryColors(hidden), isFalse);
      expect(formatter.shouldShowPriceChart(hidden), isFalse);
      expect(formatter.shouldShowBrandColors(hidden), isFalse);
      expect(formatter.shouldShowReceiptImage(hidden), isFalse);
      expect(formatter.shouldShowCelebration(hidden), isFalse);
    });
  });
}
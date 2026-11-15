import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/formatting/money_formatter.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/features/receipts/presentation/utils/receipt_money_utils.dart';

/// Этап 24: деньги вводятся и форматируются без потери копеек.
/// Разряды в ru-локали — неразрывные пробелы, поэтому убираем все пробелы.
String _clean(String value) => value.replaceAll(RegExp(r'\s'), '');

void main() {
  group('MoneyInputParser', () {
    test('пробелы и запятая: 1 234,56 -> 123456 копеек', () {
      expect(MoneyInputParser.parseKopecks('1 234,56'), 123456);
    });

    test('неразрывный пробел тоже разделитель разрядов', () {
      expect(MoneyInputParser.parseKopecks('1\u00A0234,56'), 123456);
    });

    test('точка как разделитель и одна цифра дробной части', () {
      expect(MoneyInputParser.parseKopecks('1234.5'), 123450);
    });

    test('целое число без дробной части', () {
      expect(MoneyInputParser.parseKopecks('1234'), 123400);
    });

    test('ноль', () {
      expect(MoneyInputParser.parseKopecks('0'), 0);
    });

    test('только дробная часть', () {
      expect(MoneyInputParser.parseKopecks(',5'), 50);
    });

    test('пустая строка -> null', () {
      expect(MoneyInputParser.parseKopecks(''), isNull);
    });

    test('мусор -> null', () {
      expect(MoneyInputParser.parseKopecks('abc'), isNull);
    });

    test('три знака после запятой -> null', () {
      expect(MoneyInputParser.parseKopecks('1,234'), isNull);
    });

    test('отрицательная сумма -> null', () {
      expect(MoneyInputParser.parseKopecks('-100'), isNull);
    });

    test('два разделителя -> null', () {
      expect(MoneyInputParser.parseKopecks('1,2,3'), isNull);
    });
  });

  group('MoneyFormatter', () {
    test('копейки в рубли с символом валюты', () {
      expect(_clean(MoneyFormatter.formatKopecks(15000000, 'RUB')), '150000₽');
    });

    test('дробные копейки показываются двумя знаками', () {
      expect(_clean(MoneyFormatter.formatKopecks(123456, 'RUB')), '1234,56₽');
    });

    test('отрицательная сумма со знаком', () {
      expect(
        _clean(MoneyFormatter.formatKopecks(-210000, 'RUB', showSign: true)),
        '-2100₽',
      );
    });

    test('положительная сумма со знаком получает плюс', () {
      expect(
        _clean(MoneyFormatter.formatKopecks(210000, 'RUB', showSign: true)),
        '+2100₽',
      );
    });

    test('неизвестная валюта выводится кодом', () {
      expect(_clean(MoneyFormatter.formatKopecks(100, 'XYZ')), '1XYZ');
    });
  });

  group('MoneyTextInputFormatter', () {
    // Конструктор не const (см. журнал фиксов Этапа 12).
    final formatter = MoneyTextInputFormatter();

    TextEditingValue edit(String text) => formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          TextEditingValue(text: text),
        );

    test('группировка разрядов по мере ввода', () {
      expect(edit('1234').text, '1 234');
    });

    test('дробная часть сохраняется', () {
      expect(edit('1234,5').text, '1 234,5');
    });

    test('точка заменяется на запятую', () {
      expect(edit('1234.5').text, '1 234,5');
    });

    test('буквы отклоняются', () {
      expect(edit('abc').text, '');
    });

    test('три знака дробной части отклоняются', () {
      expect(edit('1,234').text, '');
    });

    test('пустой ввод очищает поле', () {
      expect(edit('').text, '');
    });

    test('копейки в текст для префилла без символа валюты', () {
      expect(MoneyTextInputFormatter.formatKopecks(50000000), '500 000');
      expect(MoneyTextInputFormatter.formatKopecks(123456), '1 234,56');
      expect(MoneyTextInputFormatter.formatKopecks(-123456), '-1 234,56');
    });

    test('алиас для провайдеров совпадает с formatKopecks', () {
      expect(
        MoneyTextInputFormatter.kopecksToInputText(123456),
        MoneyTextInputFormatter.formatKopecks(123456),
      );
    });
  });

  group('ReceiptMoneyUtils', () {
    test('парсинг суммы чека', () {
      expect(ReceiptMoneyUtils.parseKop('1 234,56'), 123456);
      expect(ReceiptMoneyUtils.parseKop('12'), 1200);
      expect(ReceiptMoneyUtils.parseKop(''), isNull);
      expect(ReceiptMoneyUtils.parseKop('abc'), isNull);
    });

    test('форматирование суммы чека', () {
      expect(ReceiptMoneyUtils.formatKop(123456), '1234,56');
      expect(ReceiptMoneyUtils.formatKop(-150), '-1,50');
    });

    test('количество: целое без дробной части', () {
      expect(ReceiptMoneyUtils.formatQty(2), '2');
      expect(ReceiptMoneyUtils.formatQty(1.5), '1.5');
    });

    test('парсинг количества с запятой', () {
      expect(ReceiptMoneyUtils.parseQty('1,5'), 1.5);
      expect(ReceiptMoneyUtils.parseQty('abc'), isNull);
    });
  });
}
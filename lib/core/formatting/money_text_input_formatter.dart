import 'package:flutter/services.dart';

/// Форматтер ввода денег с группировкой разрядов («500 000,00»).
///
/// Разрешает цифры, один разделитель (, или .), до 2 знаков после.
/// Группирует тысячи пробелом по мере ввода. Парсеры (MoneyInputParser)
/// умеют снимать пробелы, поэтому группировка не ломает парсинг.
class MoneyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final cleaned = text.replaceAll(' ', '').replaceAll('\u00A0', '');
    if (cleaned.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    if (RegExp(r'^\d*[,.]?\d{0,2}$').firstMatch(cleaned) == null) {
      return oldValue;
    }
    final sepIndex = cleaned.indexOf(RegExp('[,.]'));
    final intPart = sepIndex == -1 ? cleaned : cleaned.substring(0, sepIndex);
    final fracPart = sepIndex == -1 ? '' : cleaned.substring(sepIndex);
    final result = '${_group(intPart)}${fracPart.replaceFirst('.', ',')}';
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }

  static String _group(String digits) {
    if (digits.isEmpty) return digits;
    final buf = StringBuffer();
    final len = digits.length;
    for (var i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    return buf.toString();
  }

  /// Копейки -> группированная строка рублей БЕЗ кода валюты
  /// (для полей ввода и префиллов): 50000000 -> «500 000».
  static String formatKopecks(int kopecks) {
    final abs = kopecks.abs();
    final sign = kopecks < 0 ? '-' : '';
    final rub = abs ~/ 100;
    final kop = abs % 100;
    if (kop == 0) return '$sign${_group('$rub')}';
    return '$sign${_group('$rub')},${kop.toString().padLeft(2, '0')}';
  }

  /// Алиас для провайдеров формы целей (группированный префилл).
  static String kopecksToInputText(int kopecks) => formatKopecks(kopecks);
}
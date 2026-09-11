import 'package:intl/intl.dart';

class CurrencySymbols {
  static String forCode(String code) {
    switch (code.toUpperCase()) {
      case 'RUB':
        return '₽';
      case 'USD':
        return r'$';
      case 'EUR':
        return '€';
      default:
        return code.toUpperCase();
    }
  }
}

class MoneyFormatter {
  static String formatKopecks(
    int kopecks,
    String currencyCode, {
    bool showSign = false,
  }) {
    final abs = kopecks.abs();
    final rubles = abs ~/ 100;
    final kop = abs % 100;

    final sign = switch (showSign) {
      true when kopecks < 0 => '-',
      true when kopecks > 0 => '+',
      _ => '',
    };

    final rubFormatted = NumberFormat.decimalPattern('ru').format(rubles);
    final kopFormatted = kop == 0 ? '' : ',${kop.toString().padLeft(2, '0')}';
    final symbol = CurrencySymbols.forCode(currencyCode);

    return '$sign$rubFormatted$kopFormatted $symbol';
  }
}

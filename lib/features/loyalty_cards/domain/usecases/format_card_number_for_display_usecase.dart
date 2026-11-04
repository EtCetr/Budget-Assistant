import 'package:logger/logger.dart';

/// Группировка номера карты по 4 цифры для экрана кассира (ТЗ 6.3.21.6).
class FormatCardNumberForDisplayUseCase {
  FormatCardNumberForDisplayUseCase({required Logger logger})
      : _logger = logger;

  final Logger _logger;

  String call(String rawData) {
    try {
      final digits = rawData.replaceAll(RegExp(r'\D'), '');
      final buffer = StringBuffer();
      for (var i = 0; i < digits.length; i++) {
        if (i > 0 && i % 4 == 0) buffer.write(' ');
        buffer.write(digits[i]);
      }
      return buffer.toString();
    } catch (e, st) {
      _logger.e('FormatCardNumberForDisplay failed', error: e, stackTrace: st);
      return rawData;
    }
  }
}
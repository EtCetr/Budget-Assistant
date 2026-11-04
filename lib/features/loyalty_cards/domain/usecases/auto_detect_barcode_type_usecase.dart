import 'package:logger/logger.dart';
import '../entities/loyalty_card.dart';
import 'validate_loyalty_card_form_usecase.dart';

/// Автоопределение типа кода по сырой строке (ТЗ 6.3.20.13).
/// Со сканера тип приходит от mobile_scanner; этот UseCase — фолбэк
/// для ручного ввода и перепроверки.
class AutoDetectBarcodeTypeUseCase {
  AutoDetectBarcodeTypeUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  BarcodeType call(String raw) {
    try {
      final v = raw.trim();
      if (ValidateLoyaltyCardFormUseCase.isValidEan13(v)) {
        return BarcodeType.ean13;
      }
      if (RegExp(r'^[A-Za-z0-9]{1,80}$').hasMatch(v) &&
          RegExp(r'[A-Za-z]').hasMatch(v)) {
        return BarcodeType.code128;
      }
      if (RegExp(r'^\d{4,32}$').hasMatch(v)) {
        return BarcodeType.manual;
      }
      if (v.length <= 500) {
        return BarcodeType.qr;
      }
      return BarcodeType.manual;
    } catch (e, st) {
      _logger.e('AutoDetectBarcodeType failed', error: e, stackTrace: st);
      return BarcodeType.manual;
    }
  }
}
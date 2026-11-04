import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../entities/loyalty_card.dart';
import '../entities/loyalty_card_form_data.dart';

/// Валидация формы карты (ТЗ 6.3.20.13: валидация по типам кода + cross-field).
class ValidateLoyaltyCardFormUseCase {
  ValidateLoyaltyCardFormUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  /// Контрольная сумма EAN-13: веса 1/3, check = (10 - sum % 10) % 10.
  static bool isValidEan13(String value) {
    if (!RegExp(r'^\d{13}$').hasMatch(value)) return false;
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      final d = value.codeUnitAt(i) - 48;
      sum += (i % 2 == 0) ? d : d * 3;
    }
    return (10 - sum % 10) % 10 == value.codeUnitAt(12) - 48;
  }

  Result<LoyaltyCardFormData> call({
    required LoyaltyCardFormData form,
    String? currentSpaceId,
  }) {
    try {
      final store = form.storeName.trim();
      if (store.isEmpty) {
        return const Error<LoyaltyCardFormData>(
            Failure.validation('Укажите название магазина'));
      }
      if (store.length > 50) {
        return const Error<LoyaltyCardFormData>(
            Failure.validation('Название магазина: не более 50 символов'));
      }
      final data = form.barcodeData.trim();
      final String? dataError = switch (form.barcodeType) {
        BarcodeType.ean13 => data.isEmpty
            ? 'Укажите данные кода'
            : (isValidEan13(data) ? null : 'EAN-13: ровно 13 цифр с верной контрольной суммой'),
        BarcodeType.code128 => RegExp(r'^[A-Za-z0-9]{1,80}$').hasMatch(data)
            ? null
            : 'Code 128: 1-80 символов (буквы и цифры)',
        BarcodeType.qr => data.isEmpty
            ? 'Укажите данные кода'
            : (data.length <= 500 ? null : 'QR: не более 500 символов'),
        BarcodeType.pdf417 => data.isEmpty
            ? 'Укажите данные кода'
            : (data.length <= 1000 ? null : 'PDF417: не более 1000 символов'),
        BarcodeType.manual => RegExp(r'^\d{4,32}$').hasMatch(data)
            ? null
            : 'Номер карты: только цифры, 4-32 символа',
      };
      if (dataError != null) {
        return Error<LoyaltyCardFormData>(Failure.validation(dataError));
      }
      if (form.brandColor != null &&
          !RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(form.brandColor!)) {
        return const Error<LoyaltyCardFormData>(
            Failure.validation('Цвет бренда: формат #RRGGBB'));
      }
      if (form.visibility == 'family' && currentSpaceId == null) {
        return const Error<LoyaltyCardFormData>(Failure.validation(
            'Сначала присоединитесь к семейному пространству'));
      }
      return Success<LoyaltyCardFormData>(form);
    } catch (e, st) {
      _logger.e('ValidateLoyaltyCardForm failed', error: e, stackTrace: st);
      return Error<LoyaltyCardFormData>(
          Failure.unexpected('Ошибка валидации формы: $e'));
    }
  }
}
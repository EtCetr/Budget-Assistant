import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/security/data/repositories/pin_code_repository.dart';

/// Проверка введённого PIN (хэш SHA-256 + соль из SecureStorage).
/// ФИКС Этапа 21: раньше здесь был record-каст `(data:, failure:) as Result`,
/// который падал TypeError при первом вызове.
class VerifyPinCodeUseCase {
  VerifyPinCodeUseCase(this._repository);

  final PinCodeRepository _repository;

  Future<Result<bool>> call(String pin) async {
    try {
      return await _repository.verifyPin(pin);
    } catch (e, st) {
      AppLogger.e('VerifyPinCodeUseCase failed', e, st);
      return Result.failure(
        Failure.unexpected('Failed to verify PIN: $e', st),
      );
    }
  }
}
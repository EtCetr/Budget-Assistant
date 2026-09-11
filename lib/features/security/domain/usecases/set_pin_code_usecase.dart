// lib/features/security/domain/usecases/set_pin_code_usecase.dart
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/utils/result.dart';
// ✅ Репозиторий живёт в data-слое
import '../../data/repositories/pin_code_repository.dart';

class SetPinCodeUseCase {
  final PinCodeRepository _repository;

  const SetPinCodeUseCase(this._repository);

  Future<Result<void>> call(String pin, String confirmPin) async {
    try {
      if (pin.length != 4) {
        return Result.failure(
          const Failure.validation('PIN-код должен содержать 4 цифры'),
        );
      }
      if (pin != confirmPin) {
        return Result.failure(const Failure.validation('PIN-коды не совпадают'));
      }

      final result = await _repository.savePin(pin);
      return result.when(
        success: (_) => Result.success(null),
        failure: (f) => Result.failure(f),
      );
    } catch (e, stackTrace) {
      AppLogger.e('SetPinCodeUseCase failed', e, stackTrace);
      return Result.failure(Failure.unexpected(e.toString(), stackTrace));
    }
  }
}

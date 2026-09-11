import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/security/data/repositories/pin_code_repository.dart';

class VerifyPinCodeUseCase {
  final PinCodeRepository _repository;

  VerifyPinCodeUseCase(this._repository);

  Future<Result<bool>> call(String pin) async {
    try {
      final isValid = await _repository.verifyPin(pin);
      return (data: isValid, failure: null) as Result<bool>;
    } on Failure catch (f) {
      return (data: null, failure: f) as Result<bool>;
    } catch (e, st) {
      return (
            data: null,
            failure: Failure.unexpected('Failed to verify PIN: $e', st),
          )
          as Result<bool>;
    }
  }
}

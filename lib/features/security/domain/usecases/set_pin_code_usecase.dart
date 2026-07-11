import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/security/data/repositories/pin_code_repository.dart';

class SetPinCodeUseCase {
  final PinCodeRepository _repository;

  SetPinCodeUseCase(this._repository);

  Future<Result<void>> call(String pin) async {
    try {
      await _repository.savePin(pin);
      return (data: null, failure: null) as Result<void>;
    } on Failure catch (f) {
      return (data: null, failure: f) as Result<void>;
    } catch (e, st) {
      return (
            data: null,
            failure: Failure.unexpected('Failed to set PIN: $e', st),
          )
          as Result<void>;
    }
  }
}

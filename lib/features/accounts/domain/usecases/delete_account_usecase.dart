// lib/features/accounts/domain/usecases/delete_account_usecase.dart
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import '../repositories/account_repository.dart';

class DeleteAccountUseCase {
  final AccountRepository _repository;
  final Logger _logger;

  DeleteAccountUseCase({
    required AccountRepository repository,
    required Logger logger,
  }) : _repository = repository,
       _logger = logger;

  Future<Result<void>> execute(String accountId) async {
    try {
      await _repository.deleteAccount(accountId);
      _logger.i('Account deleted: $accountId');
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.e(
        'DeleteAccountUseCase failed',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}

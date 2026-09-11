// lib/features/accounts/domain/usecases/update_account_usecase.dart
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import '../entities/account_types.dart';
import '../repositories/account_repository.dart';

class UpdateAccountUseCase {
  final AccountRepository _repository;
  final Logger _logger;

  UpdateAccountUseCase({
    required AccountRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<Result<void>> execute({
    required String accountId,
    required String bankName,
    required String customName,
    required String accountType,
    required String currency,
    required int currentBalance,
    String? cardNumberMask,
    int? creditLimit,
  }) async {
    try {
      if (customName.trim().isEmpty) {
        return Result.failure(
          const Failure.validation('Account name cannot be empty'),
        );
      }
      if (!AccountTypes.isValid(accountType)) {
        return Result.failure(
          Failure.validation('Unknown account type: $accountType'),
        );
      }

      return await _repository.updateAccount(
        accountId: accountId,
        bankName: bankName.trim(),
        customName: customName.trim(),
        accountType: accountType,
        currency: currency,
        currentBalance: currentBalance,
        cardNumberMask: cardNumberMask,
        creditLimit: creditLimit,
      );
    } catch (e, stackTrace) {
      _logger.e('UpdateAccountUseCase failed', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}
// lib/features/accounts/domain/usecases/calculate_net_worth_usecase.dart
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:logger/logger.dart';
import '../repositories/account_repository.dart';

class CalculateNetWorthUseCase {
  final AccountRepository _repository;
  final Logger _logger;

  CalculateNetWorthUseCase({
    required AccountRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  /// Calculate Net Worth = Assets - Liabilities + Mortgage Equity
  /// Formula: Sum(Assets) - Sum(Liabilities) + Sum(property_value - current_loan_balance)
  Future<Result<int>> execute(String userId) async {
    try {
      final accounts = await _repository.getAccountsByUserId(userId);

      int netWorth = 0;

      // 1. Sum all assets (excluding mortgages and loans)
      for (final account in accounts) {
        if (account.accountType != 'mortgage' && account.accountType != 'loan') {
          netWorth += account.currentBalance;
        }
      }

      // 2. Handle mortgages: Net Worth contribution = property_value - current_loan_balance
      for (final account in accounts) {
        if (account.accountType == 'mortgage') {
          final mortgage = await _repository.getMortgageByAccountId(account.id);
          if (mortgage != null) {
            final equity = mortgage.propertyValue - account.currentBalance;
            netWorth += equity;
            _logger.d('Mortgage ${account.id}: property=${mortgage.propertyValue}, '
                'loan=${account.currentBalance}, equity=$equity');
          }
        } else if (account.accountType == 'loan') {
          // Subtract loan balance (liability)
          netWorth -= account.currentBalance;
        }
      }

      _logger.i('Net Worth calculated for user $userId: $netWorth kopecks');
      return Result.success(netWorth);
    } catch (e, stackTrace) {
      _logger.e('CalculateNetWorthUseCase failed', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}
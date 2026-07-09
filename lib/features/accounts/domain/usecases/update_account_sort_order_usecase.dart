// lib/features/accounts/domain/usecases/update_account_sort_order_usecase.dart
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:logger/logger.dart';
import '../repositories/account_repository.dart';

class UpdateAccountSortOrderUseCase {
  final AccountRepository _repository;
  final Logger _logger;

  UpdateAccountSortOrderUseCase({
    required AccountRepository repository,
    required Logger logger,
  }) : _repository = repository,
       _logger = logger;

  /// Update sort order for a single account
  /// sort_order is [LOCAL] field - NOT synced to Supabase
  Future<Result<void>> execute({
    required String accountId,
    required int? sortOrder,
  }) async {
    try {
      await _repository.updateAccountSortOrder(accountId, sortOrder);
      _logger.i('Sort order updated for account $accountId: $sortOrder');
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.e(
        'UpdateAccountSortOrderUseCase failed',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }

  /// Batch update sort orders after drag-and-drop reorder
  Future<Result<void>> executeBatch({
    required List<String> orderedAccountIds,
  }) async {
    try {
      for (int i = 0; i < orderedAccountIds.length; i++) {
        await _repository.updateAccountSortOrder(orderedAccountIds[i], i);
      }
      _logger.i(
        'Batch sort order updated for ${orderedAccountIds.length} accounts',
      );
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.e(
        'UpdateAccountSortOrderUseCase batch failed',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}

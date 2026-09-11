import 'package:logger/logger.dart';

import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';

class DeleteTransactionUseCase {
  final TransactionsRepository _repository;
  final Logger _logger;

  const DeleteTransactionUseCase({
    required TransactionsRepository repository,
    required Logger logger,
  }) : _repository = repository,
       _logger = logger;

  Future<Result<void>> call({
    required String id,
    required String userId,
  }) async {
    try {
      final deletedCount = await _repository.deleteTransaction(id, userId);

      if (deletedCount == 0) {
        return const Error(Failure.notFound('Transaction not found'));
      }

      return const Success(null);
    } catch (e, stack) {
      _logger.e('DeleteTransactionUseCase failed', error: e, stackTrace: stack);

      return Error(Failure.database(e.toString()));
    }
  }
}

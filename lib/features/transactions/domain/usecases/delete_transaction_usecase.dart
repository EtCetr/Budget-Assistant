import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';

class DeleteTransactionUseCase {
  final TransactionsRepository _repository;
  final Logger _logger;

  DeleteTransactionUseCase({
    required TransactionsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<Result<void>> call({
    required String id,
    required String userId,
  }) async {
    try {
      // Этап 23.6 (D23.6-2): удаление применяется ко всем копиям группы.
      final db = AppDatabase();
      final row = await (db.select(db.transactions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      final gid = row?.copyGroupId;
      final deletedCount = await _repository.deleteTransaction(id, userId);
      if (deletedCount == 0) {
        return const Error(Failure.notFound('Transaction not found'));
      }
      if (gid != null) {
        final copies = await (db.select(db.transactions)
              ..where((t) => t.copyGroupId.equals(gid)))
            .get();
        for (final c in copies) {
          await (db.delete(db.transactionSplits)
                ..where((s) => s.transactionId.equals(c.id)))
              .go();
          await (db.delete(db.transactions)
                ..where((t) => t.id.equals(c.id)))
              .go();
        }
      }
      return const Success(null);
    } catch (e, stack) {
      _logger.e('DeleteTransactionUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString()));
    }
  }
}
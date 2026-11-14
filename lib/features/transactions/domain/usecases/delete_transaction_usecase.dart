import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';

/// Удаление операции.
///
/// Этап 23.6 (D23.6-2): удаление применяется ко всем копиям группы.
/// Этап 24: БД подключается необязательным параметром (тесты передают
/// in-memory), а её недоступность не отменяет удаление самой операции.
class DeleteTransactionUseCase {
  DeleteTransactionUseCase({
    required TransactionsRepository repository,
    required Logger logger,
    AppDatabase? db,
  })  : _repository = repository,
        _logger = logger,
        _dbOverride = db;

  final TransactionsRepository _repository;
  final Logger _logger;
  final AppDatabase? _dbOverride;

  AppDatabase get _db => _dbOverride ?? AppDatabase();

  Future<Result<void>> call({
    required String id,
    required String userId,
  }) async {
    try {
      // Сначала проверяем существование через репозиторий: БД копий не нужна,
      // если удалять нечего.
      final existing = await _repository.getTransactionById(id);
      if (existing == null || existing.userId != userId) {
        return const Error(Failure.notFound('Transaction not found'));
      }

      final gid = await _readGroupId(id);

      final deletedCount = await _repository.deleteTransaction(id, userId);
      if (deletedCount == 0) {
        return const Error(Failure.notFound('Transaction not found'));
      }

      if (gid != null) {
        await _deleteCopies(gid);
      }

      return const Success(null);
    } catch (e, stack) {
      _logger.e('DeleteTransactionUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString()));
    }
  }

  /// Читает copy_group_id. Ошибка не мешает удалению основной операции.
  Future<String?> _readGroupId(String id) async {
    try {
      final db = _db;
      final row = await (db.select(db.transactions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return row?.copyGroupId;
    } catch (e, st) {
      _logger.e('Read copy group failed', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> _deleteCopies(String gid) async {
    try {
      final db = _db;
      final copies = await (db.select(db.transactions)
            ..where((t) => t.copyGroupId.equals(gid)))
          .get();
      for (final c in copies) {
        await (db.delete(db.transactionSplits)
              ..where((s) => s.transactionId.equals(c.id)))
            .go();
        await (db.delete(db.transactions)..where((t) => t.id.equals(c.id))).go();
      }
    } catch (e, st) {
      _logger.e('Delete copies failed', error: e, stackTrace: st);
    }
  }
}

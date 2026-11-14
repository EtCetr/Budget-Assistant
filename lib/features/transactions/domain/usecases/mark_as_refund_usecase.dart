import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_ui_model.dart';
import '../repositories/transactions_log_repository.dart';

/// Компенсирующая операция (сторно) для расхода.
///
/// Этап 23.8 (D23.8-1): сторно применяется ко ВСЕМ копиям группы
/// (transactions.copy_group_id) — так же, как правка и удаление (D23.6-2).
/// Для каждой копии вызывается тот же метод репозитория, поэтому правила
/// создания компенсации не дублируются.
///
/// Этап 23.8 (D23.8-2): созданные компенсации связываются отдельным
/// copy_group_id — их правка/удаление тоже работают по группе.
class MarkAsRefundUseCase {
  MarkAsRefundUseCase(this._repository, {AppDatabase? db}) : _dbOverride = db;

  final TransactionsLogRepository _repository;
  final AppDatabase? _dbOverride;
  final Logger _log = Logger();

  AppDatabase get _db => _dbOverride ?? AppDatabase();

  Future<Result<void>> call(TransactionUiModel original) async {
    try {
      if (original.type != TransactionType.expense) {
        return const Error(
          Failure.validation(
            'Компенсирующую операцию можно создавать только для расходов',
          ),
        );
      }

      final db = _db;
      final source = await (db.select(db.transactions)
            ..where((t) => t.id.equals(original.id)))
          .getSingleOrNull();
      final gid = source?.copyGroupId;
      final copies = gid == null
          ? <TransactionDb>[]
          : await (db.select(db.transactions)
                ..where((t) =>
                    t.copyGroupId.equals(gid) & t.id.equals(original.id).not()))
              .get();

      // Снапшот id доходов ДО сторно: нужен, чтобы детерминированно найти
      // созданные компенсации и связать их в группу.
      final before =
          copies.isEmpty ? <String>{} : await _incomeIds(db, original.userId);

      await _repository.createCompensatingIncome(original.id);

      if (copies.isNotEmpty) {
        await _propagate(db, copies, original.userId, before);
      }
      return const Success(null);
    } catch (e, s) {
      _log.e('Failed to create compensating income', error: e, stackTrace: s);
      return Error(
        Failure.unexpected('Не удалось создать компенсирующую операцию: $e', s),
      );
    }
  }

  /// D23.8-3: ошибка пропагации не отменяет уже созданное сторно.
  Future<void> _propagate(
    AppDatabase db,
    List<TransactionDb> copies,
    String userId,
    Set<String> before,
  ) async {
    var created = 0;
    for (final c in copies) {
      try {
        await _repository.createCompensatingIncome(c.id);
        created++;
      } catch (e, st) {
        _log.e(
          'Refund propagation failed for copy ${c.id}',
          error: e,
          stackTrace: st,
        );
      }
    }
    if (created == 0) return;
    try {
      final after = await _incomeIds(db, userId);
      final newIds = after.difference(before).toList();
      if (newIds.length < 2) return;
      final refundGroupId = const Uuid().v4();
      final now = DateTime.now().toUtc();
      await (db.update(db.transactions)..where((t) => t.id.isIn(newIds)))
          .write(TransactionsCompanion(
        copyGroupId: Value(refundGroupId),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
      ));
      _log.i('Refund propagated: copies=$created, linked=${newIds.length}');
    } catch (e, st) {
      _log.e('Linking refund copies failed', error: e, stackTrace: st);
    }
  }

  Future<Set<String>> _incomeIds(AppDatabase db, String userId) async {
    final rows = await (db.select(db.transactions)
          ..where((t) =>
              t.userId.equals(userId) & t.type.equals(TransactionType.income.name)))
        .get();
    return rows.map((r) => r.id).toSet();
  }
}

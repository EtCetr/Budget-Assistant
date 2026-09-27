import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../domain/entities/recurring_transaction.dart';

part 'recurring_transactions_dao.g.dart';

@DriftAccessor(tables: [RecurringTransactions])
class RecurringTransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringTransactionsDaoMixin {
  RecurringTransactionsDao(super.db);

  Stream<List<RecurringTransactionDb>> watchByStatus({
    required String userId,
    required String status,
  }) {
    return (select(recurringTransactions)
      ..where((t) => t.userId.equals(userId) & t.status.equals(status))
      ..orderBy([(t) => OrderingTerm.desc(t.lastSeenDate, nulls: NullsOrder.last)]))
        .watch();
  }

  Future<RecurringTransactionDb?> getById(String id) {
    return (select(recurringTransactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<RecurringTransactionDb?> getByKey({
    required String userId,
    required String merchantNormalized,
    required int amountBucket,
  }) {
    return (select(recurringTransactions)
      ..where((t) =>
          t.userId.equals(userId) &
          t.merchantNameNormalized.equals(merchantNormalized) &
          t.averageAmountBucket.equals(amountBucket)))
        .getSingleOrNull();
  }

  Future<void> insertOne(RecurringTransactionDb row) {
    return into(recurringTransactions).insert(row);
  }

  Future<void> insertMany(List<RecurringTransactionDb> rows) {
    return batch((b) {
      b.insertAll(recurringTransactions, rows);
    });
  }

  Future<int> updateStats({
    required String id,
    required int occurrenceCount,
    required int averageAmount,
    required int averageDayOfMonth,
    DateTime? lastSeenDate,
    String? status,
  }) {
    return (update(recurringTransactions)..where((t) => t.id.equals(id))).write(
      RecurringTransactionsCompanion(
        occurrenceCount: Value(occurrenceCount),
        averageAmount: Value(averageAmount),
        averageDayOfMonth: Value(averageDayOfMonth),
        lastSeenDate: Value(lastSeenDate),
        status: status == null ? const Value.absent() : Value(status),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<int> setStatus(String id, String status) {
    return (update(recurringTransactions)..where((t) => t.id.equals(id))).write(
      RecurringTransactionsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<int> setLinkedReminder({
    required String recurringId,
    String? reminderId,
  }) {
    return (update(recurringTransactions)..where((t) => t.id.equals(recurringId)))
        .write(
      RecurringTransactionsCompanion(
        linkedReminderId: Value(reminderId),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<List<RecurringTransactionDb>> getPendingConfirmation(String userId) {
    return (select(recurringTransactions)
      ..where((t) =>
          t.userId.equals(userId) &
          t.status.equals(RecurringStatus.pendingConfirmation)))
        .get();
  }

  Future<int> deleteByStatus({
    required String userId,
    required String status,
  }) {
    return (delete(recurringTransactions)
      ..where((t) => t.userId.equals(userId) & t.status.equals(status)))
        .go();
  }
}
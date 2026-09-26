import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
part 'debts_dao.g.dart';

@DriftAccessor(tables: [Debts, DebtDrafts])
class DebtsDao extends DatabaseAccessor<AppDatabase> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  /// Долги пользователя (должник ИЛИ кредитор), любые статусы.
  /// Сортировка: срок погашения (null в конце), затем новее созданные.
  Stream<List<DebtDb>> watchForUser(String userId) {
    return (select(debts)
          ..where((d) =>
              d.creditorId.equals(userId) | d.debtorId.equals(userId))
          ..orderBy([
            (d) => OrderingTerm.asc(d.dueDate, nulls: NullsOrder.last),
            (d) => OrderingTerm.desc(d.createdAt),
          ]))
        .watch();
  }

  Future<DebtDb?> getById(String id) {
    return (select(debts)..where((d) => d.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertDebt(DebtDb row) => into(debts).insert(row);

  Future<int> updateDebt(DebtDb row) {
    return (update(debts)..where((d) => d.id.equals(row.id)))
        .write(row.toCompanion(true));
  }

  Future<int> deleteDebt(String id) {
    return (delete(debts)..where((d) => d.id.equals(id))).go();
  }

  /// Закрытие долга (resolved / forgiven / paid_offline).
  Future<int> resolve(String id, String status) {
    final now = DateTime.now().toUtc();
    return (update(debts)..where((d) => d.id.equals(id))).write(
      DebtsCompanion(
        resolutionStatus: Value(status),
        resolvedAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  /// Продление срока (ТЗ 6.3.13.9 «Продлить срок»).
  Future<int> extendDueDate(String id, DateTime newDueDateUtc) {
    final now = DateTime.now().toUtc();
    return (update(debts)..where((d) => d.id.equals(id))).write(
      DebtsCompanion(
        dueDate: Value(newDueDateUtc),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  /// Пометка долгов ex-члена семьи (ТЗ 6.3.13.8): только активные,
  /// статус разрешения не меняется.
  Future<int> markExMember(String memberUserId) {
    final now = DateTime.now().toUtc();
    return (update(debts)
          ..where((d) =>
              (d.debtorId.equals(memberUserId) |
                  d.creditorId.equals(memberUserId)) &
              d.resolutionStatus.equals('active')))
        .write(
          DebtsCompanion(
            isExMemberDebt: const Value(true),
            updatedAt: Value(now),
            syncStatus: const Value(SyncStatus.pending),
          ),
        );
  }

  Future<List<DebtDb>> getPending() {
    return (select(debts)
          ..where((d) => d.syncStatus.equals('pending'))
          ..limit(200))
        .get();
  }

  Future<int> markSynced(List<String> ids) {
    if (ids.isEmpty) return Future.value(0);
    return (update(debts)..where((d) => d.id.isIn(ids))).write(
      DebtsCompanion(
        syncStatus: const Value(SyncStatus.synced),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  // ─── Локальные черновики формы (без sync) ───
  Future<DebtDraftDb?> getFreshDraft(String draftId, DateTime sinceUtc) {
    return (select(debtDrafts)
          ..where((d) =>
              d.id.equals(draftId) &
              d.updatedAt.isBiggerOrEqualValue(sinceUtc)))
        .getSingleOrNull();
  }

  Future<void> upsertDraft({
    required String id,
    required String userId,
    String? debtId,
    required String formDataJson,
    required DateTime updatedAt,
  }) {
    return into(debtDrafts).insertOnConflictUpdate(
      DebtDraftsCompanion(
        id: Value(id),
        userId: Value(userId),
        debtId: Value(debtId),
        formDataJson: Value(formDataJson),
        createdAt: Value(updatedAt),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<int> deleteDraft(String draftId) {
    return (delete(debtDrafts)..where((d) => d.id.equals(draftId))).go();
  }

  Future<int> cleanupOldDrafts(DateTime olderThanUtc) {
    return (delete(debtDrafts)
          ..where((d) => d.updatedAt.isSmallerThanValue(olderThanUtc)))
        .go();
  }
}
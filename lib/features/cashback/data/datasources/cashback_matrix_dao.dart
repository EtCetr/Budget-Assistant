import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'cashback_matrix_dao.g.dart';

@DriftAccessor(tables: [CashbackMatrix, Accounts])
class CashbackMatrixDao extends DatabaseAccessor<AppDatabase>
    with _$CashbackMatrixDaoMixin {
  CashbackMatrixDao(super.db);

  Stream<List<CashbackMatrixDb>> watchByAccount(String accountId) {
    return (select(cashbackMatrix)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<CashbackMatrixDb>> getByAccount(String accountId) {
    return (select(cashbackMatrix)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<void> insert(CashbackMatrixCompanion entry) =>
      into(cashbackMatrix).insert(entry);

  Future<int> deleteById(String id) =>
      (delete(cashbackMatrix)..where((t) => t.id.equals(id))).go();

  Future<String?> getAccountCurrency(String accountId) async {
    final row = await (select(accounts)
          ..where((t) => t.id.equals(accountId)))
        .getSingleOrNull();
    return row?.currency;
  }

  /// Мои счета: только текущего пользователя, без системных и архивных.
  Future<List<Account>> getMyAccounts(String userId) {
    return (select(accounts)
          ..where((t) =>
              t.userId.equals(userId) &
              t.isSystem.equals(false) &
              t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Счета активной группы: любой владелец (участники семьи).
  /// Локально появляются только после синхронизации (Этап 8/25).
  Future<List<Account>> getFamilyAccounts(String spaceId) {
    return (select(accounts)
          ..where((t) =>
              t.spaceId.equals(spaceId) &
              t.isSystem.equals(false) &
              t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Смена статуса записи матрицы + возврат в очередь синхронизации.
  Future<int> updateStatus(String id, String status) {
    return (update(cashbackMatrix)..where((t) => t.id.equals(id))).write(
      CashbackMatrixCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  /// Триггер матрицы: максимум updated_at по трём таблицам.
  /// ВАЖНО: readsFrom обязателен, иначе watch() не перезапускается.
  Stream<String> watchCashbackRelevantChanges() {
    return customSelect(
      'SELECT '
      '(SELECT IFNULL(MAX(updated_at), 0) FROM cashback_matrix) AS m, '
      '(SELECT IFNULL(MAX(updated_at), 0) FROM transactions) AS t, '
      '(SELECT IFNULL(MAX(updated_at), 0) FROM accounts) AS a',
      readsFrom: {cashbackMatrix, accounts, attachedDatabase.transactions},
    ).watch().map((rows) {
      final r = rows.first;
      return '${r.read<int>('m')}|${r.read<int>('t')}|${r.read<int>('a')}';
    });
  }
}
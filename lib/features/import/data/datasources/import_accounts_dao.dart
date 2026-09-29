import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'import_accounts_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class ImportAccountsDao extends DatabaseAccessor<AppDatabase>
    with _$ImportAccountsDaoMixin {
  ImportAccountsDao(super.db);

  /// Целевые счета импорта (ТЗ 6.3.25.16): не архивные, не системные.
  /// familyOnly = true → только счета текущего пространства.
  Future<List<Account>> getTargetAccounts({
    required String userId,
    String? spaceId,
    required bool familyOnly,
  }) {
    final query = select(accounts)
      ..where((t) =>
          t.userId.equals(userId) &
          t.isArchived.equals(false) &
          t.isSystem.equals(false));
    if (familyOnly && spaceId != null) {
      query.where((t) => t.spaceId.equals(spaceId));
    }
    query.orderBy([
      (t) => OrderingTerm.asc(t.sortOrder),
      (t) => OrderingTerm.desc(t.currentBalance),
    ]);
    return query.get();
  }
}
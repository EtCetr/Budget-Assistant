import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'cashback_matrix_dao.g.dart';

@DriftAccessor(tables: [CashbackMatrix])
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
    final row = await (select(db.accounts)
          ..where((t) => t.id.equals(accountId)))
        .getSingleOrNull();
    return row?.currency;
  }
}
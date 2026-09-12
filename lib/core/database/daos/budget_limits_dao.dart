import 'package:drift/drift.dart';
import '../app_database.dart';

part 'budget_limits_dao.g.dart';

@DriftAccessor(tables: [BudgetLimits])
class BudgetLimitsDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetLimitsDaoMixin {
  BudgetLimitsDao(super.db);

  /// Получить лимит по его ID (для экрана редактирования).
  Future<BudgetLimitDb?> getById(String id) {
    return (select(
      budgetLimits,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<BudgetLimitDb>> getForMonth({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  }) {
    return (select(budgetLimits)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                (spaceId == null
                    ? t.spaceId.isNull()
                    : t.spaceId.equals(spaceId)) &
                t.year.equals(year) &
                t.month.equals(month),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.categoryId)]))
        .get();
  }

  Stream<List<BudgetLimitDb>> watchForMonth({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  }) {
    return (select(budgetLimits)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                (spaceId == null
                    ? t.spaceId.isNull()
                    : t.spaceId.equals(spaceId)) &
                t.year.equals(year) &
                t.month.equals(month),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.categoryId)]))
        .watch();
  }

  Future<BudgetLimitDb?> getForCategory({
    required String userId,
    String? spaceId,
    required String categoryId,
    required int year,
    required int month,
  }) {
    return (select(budgetLimits)..where(
          (t) =>
              t.userId.equals(userId) &
              (spaceId == null
                  ? t.spaceId.isNull()
                  : t.spaceId.equals(spaceId)) &
              t.categoryId.equals(categoryId) &
              t.year.equals(year) &
              t.month.equals(month),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(BudgetLimitsCompanion entry) async {
    await into(budgetLimits).insertOnConflictUpdate(entry);
  }

  Future<int> deleteById(String id) {
    return (delete(budgetLimits)..where((t) => t.id.equals(id))).go();
  }

  /// sync_status — обычная строка (колонка text()), используем литералы.
  Future<List<BudgetLimitDb>> getPending() {
    return (select(budgetLimits)
          ..where((t) => t.syncStatus.equals('pending'))
          ..limit(200))
        .get();
  }

  Future<int> markSynced(List<String> ids) {
    if (ids.isEmpty) return Future.value(0);
    return (update(budgetLimits)..where((t) => t.id.isIn(ids))).write(
      const BudgetLimitsCompanion(syncStatus: Value('synced')),
    );
  }
}

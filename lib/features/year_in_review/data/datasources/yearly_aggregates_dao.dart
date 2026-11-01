import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/tables/yearly_aggregates.dart';

part 'yearly_aggregates_dao.g.dart';

@DriftAccessor(tables: [YearlyAggregates])
class YearlyAggregatesDao extends DatabaseAccessor<AppDatabase>
    with _$YearlyAggregatesDaoMixin {
  YearlyAggregatesDao(super.db);

  Future<YearlyAggregateDb?> getForScope({
    required String userId,
    required String? spaceId,
    required int year,
  }) {
    final query = select(yearlyAggregates)
      ..where((t) => t.userId.equals(userId) & t.year.equals(year));
    if (spaceId == null) {
      query.where((t) => t.spaceId.isNull());
    } else {
      query.where((t) => t.spaceId.equals(spaceId));
    }
    return query.getSingleOrNull();
  }

  Future<void> upsertAggregate({
    required String newId,
    required String userId,
    required String? spaceId,
    required int year,
    required String dataJson,
  }) async {
    final existing =
        await getForScope(userId: userId, spaceId: spaceId, year: year);
    final now = DateTime.now().toUtc();
    if (existing == null) {
      await into(yearlyAggregates).insert(
        YearlyAggregatesCompanion.insert(
          id: newId,
          userId: userId,
          year: year,
          dataJson: dataJson,
          lastCalculatedAt: now,
          spaceId: Value(spaceId),
        ),
      );
      return;
    }
    await (update(yearlyAggregates)
          ..where((t) => t.id.equals(existing.id)))
        .write(
      YearlyAggregatesCompanion(
        dataJson: Value(dataJson),
        lastCalculatedAt: Value(now),
        syncStatus: const Value('pending'),
      ),
    );
  }

  Future<void> markViewed({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    final existing =
        await getForScope(userId: userId, spaceId: spaceId, year: year);
    if (existing == null) return;
    await (update(yearlyAggregates)
          ..where((t) => t.id.equals(existing.id)))
        .write(
      const YearlyAggregatesCompanion(
        isViewed: Value(true),
        syncStatus: Value('pending'),
      ),
    );
  }

  /// Минимальный и максимальный год транзакций пользователя
  /// (для списка экрана «Статистика по годам»).
  Future<(int, int)?> transactionYearBounds(String userId) async {
    final rows = await customSelect(
      'SELECT MIN(date) AS mn, MAX(date) AS mx FROM transactions '
      'WHERE user_id = ?',
      variables: [Variable.withString(userId)],
    ).get();
    if (rows.isEmpty) return null;
    final mn = rows.first.readNullable<DateTime>('mn');
    final mx = rows.first.readNullable<DateTime>('mx');
    if (mn == null || mx == null) return null;
    return (mn.year, mx.year);
  }

  /// Число транзакций пользователя за год (любое пространство).
  Future<int> countTransactionsInYear(String userId, int year) async {
    final rows = await customSelect(
      'SELECT COUNT(*) AS c FROM transactions '
      'WHERE user_id = ? AND date >= ? AND date < ?',
      variables: [
        Variable.withString(userId),
        Variable.withDateTime(DateTime.utc(year, 1, 1)),
        Variable.withDateTime(DateTime.utc(year + 1, 1, 1)),
      ],
    ).get();
    if (rows.isEmpty) return 0;
    return rows.first.read<int>('c');
  }

  /// Личные агрегаты по всем годам.
  Future<Map<int, YearlyAggregateDb>> personalAggregatesByYear(
      String userId) async {
    final rows = await (select(yearlyAggregates)
          ..where((t) => t.userId.equals(userId) & t.spaceId.isNull()))
        .get();
    return {for (final r in rows) r.year: r};
  }
}
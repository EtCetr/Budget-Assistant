import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/forecast_cache_entry.dart';

part 'forecast_cache_dao.g.dart';

@DriftAccessor(tables: [ForecastCache])
class ForecastCacheDao extends DatabaseAccessor<AppDatabase>
    with _$ForecastCacheDaoMixin {
  ForecastCacheDao(super.db);

  Future<List<ForecastCacheDb>> getForMonth({
    required String userId,
    String? spaceId,
    required String monthYear,
  }) {
    return (select(forecastCache)
      ..where((f) =>
          f.userId.equals(userId) &
          f.monthYear.equals(monthYear) &
          (spaceId == null
              ? f.spaceId.isNull()
              : f.spaceId.equals(spaceId))))
        .get();
  }

  Future<DateTime?> getLastUpdated({
    required String userId,
    String? spaceId,
    required String monthYear,
  }) async {
    final rows = await getForMonth(
      userId: userId,
      spaceId: spaceId,
      monthYear: monthYear,
    );
    if (rows.isEmpty) return null;
    return rows.map((r) => r.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  Future<void> replaceMonth({
    required String userId,
    String? spaceId,
    required String monthYear,
    required List<ForecastCacheEntry> entries,
  }) {
    return transaction(() async {
      await (delete(forecastCache)
        ..where((f) =>
            f.userId.equals(userId) &
            f.monthYear.equals(monthYear) &
            (spaceId == null
                ? f.spaceId.isNull()
                : f.spaceId.equals(spaceId))))
          .go();
      for (final e in entries) {
        await into(forecastCache).insert(
          ForecastCacheCompanion.insert(
            id: e.id,
            userId: e.userId,
            spaceId: Value(e.spaceId),
            monthYear: e.monthYear,
            categoryId: Value(e.categoryId),
            forecastedAmount: Value(e.forecastedAmount),
            updatedAt: Value(e.updatedAt),
          ),
        );
      }
    });
  }
}
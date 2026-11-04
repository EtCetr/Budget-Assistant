import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/tables/product_analytics_cache.dart';

part 'product_analytics_cache_dao.g.dart';

@DriftAccessor(tables: [ProductAnalyticsCache])
class ProductAnalyticsCacheDao extends DatabaseAccessor<AppDatabase>
    with _$ProductAnalyticsCacheDaoMixin {
  ProductAnalyticsCacheDao(super.db);

  /// Атомарный пересчёт: удаляем все строки пользователя и вставляем новые
  /// агрегаты. drift выполняет batch в одной транзакции (идемпотентно,
  /// решение D20 вместо upsert по составному ключу с NULL).
  Future<void> replaceAllForUser({
    required String userId,
    required List<ProductAnalyticsCacheCompanion> rows,
  }) async {
    await batch((b) {
      b.deleteWhere(productAnalyticsCache, (t) => t.userId.equals(userId));
      if (rows.isNotEmpty) {
        b.insertAll(productAnalyticsCache, rows);
      }
    });
  }

  /// Агрегаты за период (ТЗ 6.3.24.3): fromDay/toDay включительно,
  /// 'YYYY-MM-DD'; null = без границы. При [includeFamily] дополнительно
  /// берутся строки семейного пространства (Multi-group скоуп).
  Future<List<ProductAnalyticsCacheDb>> forPeriod({
    required String userId,
    String? familySpaceId,
    bool includeFamily = false,
    String? fromDay,
    String? toDay,
  }) {
    return (select(productAnalyticsCache)
          ..where((t) {
            Expression<bool> scope = t.userId.equals(userId);
            if (includeFamily && familySpaceId != null) {
              scope = scope | t.spaceId.equals(familySpaceId);
            }
            if (fromDay != null) {
              scope = scope & t.day.isBiggerOrEqualValue(fromDay);
            }
            if (toDay != null) {
              scope = scope & t.day.isSmallerOrEqualValue(toDay);
            }
            return scope;
          })
          ..orderBy([(t) => OrderingTerm.asc(t.day)]))
        .get();
  }

  /// Свежесть кэша (баннер cache_stale, ТЗ 6.3.24.9).
  Future<DateTime?> lastUpdatedAt(String userId) async {
    final rows = await customSelect(
      'SELECT MAX(updated_at) AS m FROM product_analytics_cache '
      'WHERE user_id = ?',
      variables: [Variable.withString(userId)],
    ).get();
    if (rows.isEmpty) return null;
    return rows.first.readNullable<DateTime>('m');
  }
}
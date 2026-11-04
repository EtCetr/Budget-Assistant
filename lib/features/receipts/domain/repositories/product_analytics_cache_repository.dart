import '../entities/product_analytics_cache_entry.dart';

/// Репозиторий кэша аналитики товаров (ТЗ 6.3.24.12.2).
///
/// Синхронизация кэша — Этап 25 (если будет принято решение шарить
/// агрегаты в Multi-group); пока — строго локально (данные E2E).
abstract interface class ProductAnalyticsCacheRepository {
  /// Атомарно заменить все агрегаты пользователя (пересчёт).
  Future<void> replaceAllForUser(
      String userId, List<ProductAnalyticsCacheEntry> rows);

  Future<List<ProductAnalyticsCacheEntry>> forPeriod({
    required String userId,
    String? familySpaceId,
    bool includeFamily = false,
    String? fromDay,
    String? toDay,
  });

  Future<DateTime?> lastUpdatedAt(String userId);
}
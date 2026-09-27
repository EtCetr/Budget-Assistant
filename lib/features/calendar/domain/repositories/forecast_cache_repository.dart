import '../entities/forecast_cache_entry.dart';

abstract interface class ForecastCacheRepository {
  Future<List<ForecastCacheEntry>> getForMonth({
    required String userId,
    String? spaceId,
    required String monthYear,
  });
  Future<DateTime?> getLastUpdated({
    required String userId,
    String? spaceId,
    required String monthYear,
  });
  /// Атомарно заменяет все строки месяца (пересчёт кэша).
  Future<void> replaceMonth({
    required String userId,
    String? spaceId,
    required String monthYear,
    required List<ForecastCacheEntry> entries,
  });
}
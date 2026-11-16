import 'package:budget_assistant/features/calendar/domain/entities/forecast_cache_entry.dart';
import 'package:budget_assistant/features/calendar/domain/repositories/forecast_cache_repository.dart';

/// Этап 24: заглушка кэша прогноза баланса.
class FakeForecastCacheRepository implements ForecastCacheRepository {
  final Map<String, List<ForecastCacheEntry>> stored =
      <String, List<ForecastCacheEntry>>{};
  final Map<String, DateTime> lastUpdated = <String, DateTime>{};
  final List<String> replacedMonths = <String>[];

  @override
  Future<List<ForecastCacheEntry>> getForMonth({
    required String userId,
    String? spaceId,
    required String monthYear,
  }) async =>
      stored[monthYear] ?? const <ForecastCacheEntry>[];

  @override
  Future<DateTime?> getLastUpdated({
    required String userId,
    String? spaceId,
    required String monthYear,
  }) async =>
      lastUpdated[monthYear];

  @override
  Future<void> replaceMonth({
    required String userId,
    String? spaceId,
    required String monthYear,
    required List<ForecastCacheEntry> entries,
  }) async {
    replacedMonths.add(monthYear);
    stored[monthYear] = entries;
    lastUpdated[monthYear] = DateTime.now().toUtc();
  }
}
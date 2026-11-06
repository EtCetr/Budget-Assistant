// lib/features/settings/domain/usecases/clear_local_cache_usecase.dart
// Этап 21 (ТЗ 6.3.38.9): очистка ЛОКАЛЬНОГО кэша.
// Удаляет: forecast_cache, yearly_aggregates, product_analytics_cache.
// НЕ удаляет: транзакции, счета, цели, долги, напоминания.
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';

class ClearLocalCacheUseCase {
  const ClearLocalCacheUseCase({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  Future<int> call() async {
    try {
      var deleted = 0;
      deleted += await _db.delete(_db.forecastCache).go();
      deleted += await _db.delete(_db.yearlyAggregates).go();
      deleted += await _db.delete(_db.productAnalyticsCache).go();
      AppLogger.i('Local cache cleared: $deleted rows');
      return deleted;
    } catch (e, st) {
      AppLogger.e('ClearLocalCacheUseCase failed', e, st);
      rethrow;
    }
  }
}
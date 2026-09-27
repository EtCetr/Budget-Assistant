import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/forecast_cache_dao.dart';
import '../../data/repositories/forecast_cache_repository_impl.dart';
import '../../domain/repositories/forecast_cache_repository.dart';

final Logger _logger = Logger();

final forecastCacheDaoProvider = Provider<ForecastCacheDao>((ref) {
  return ForecastCacheDao(ref.watch(appDatabaseProvider));
});

final forecastCacheRepositoryProvider = Provider<ForecastCacheRepository>((ref) {
  return ForecastCacheRepositoryImpl(
    dao: ref.watch(forecastCacheDaoProvider),
    logger: _logger,
  );
});
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/product_analytics_cache_dao.dart';
import '../../data/repositories/product_analytics_cache_repository_impl.dart';
import '../../domain/repositories/product_analytics_cache_repository.dart';

final Logger _logger = Logger();

final productAnalyticsCacheDaoProvider =
    Provider<ProductAnalyticsCacheDao>((ref) {
  return ProductAnalyticsCacheDao(ref.watch(appDatabaseProvider));
});

final productAnalyticsCacheRepositoryProvider =
    Provider<ProductAnalyticsCacheRepository>((ref) {
  return ProductAnalyticsCacheRepositoryImpl(
    dao: ref.watch(productAnalyticsCacheDaoProvider),
    logger: _logger,
  );
});
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/product_analytics_cache_entry.dart';
import '../../domain/repositories/product_analytics_cache_repository.dart';
import '../datasources/product_analytics_cache_dao.dart';

class ProductAnalyticsCacheRepositoryImpl
    implements ProductAnalyticsCacheRepository {
  ProductAnalyticsCacheRepositoryImpl({
    required ProductAnalyticsCacheDao dao,
    required Logger logger,
  })  : _dao = dao,
        _logger = logger;

  final ProductAnalyticsCacheDao _dao;
  final Logger _logger;

  @override
  Future<void> replaceAllForUser(
      String userId, List<ProductAnalyticsCacheEntry> rows) async {
    try {
      await _dao.replaceAllForUser(
        userId: userId,
        rows: [
          for (final r in rows)
            ProductAnalyticsCacheCompanion.insert(
              id: r.id,
              userId: userId,
              day: r.day,
              productHash: r.productHash,
              spaceId: Value(r.spaceId),
              categoryId: Value(r.categoryId),
              purchases: Value(r.purchases),
              totalSpendKopecks: Value(r.totalSpendKopecks),
              totalQuantity: Value(r.totalQuantity),
              avgPriceKopecks: Value(r.avgPriceKopecks),
              updatedAt: Value(r.updatedAt),
            ),
        ],
      );
    } catch (e, st) {
      _logger.e('replaceAllForUser failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<ProductAnalyticsCacheEntry>> forPeriod({
    required String userId,
    String? familySpaceId,
    bool includeFamily = false,
    String? fromDay,
    String? toDay,
  }) async {
    try {
      final rows = await _dao.forPeriod(
        userId: userId,
        familySpaceId: familySpaceId,
        includeFamily: includeFamily,
        fromDay: fromDay,
        toDay: toDay,
      );
      return rows.map(_mapEntry).toList();
    } catch (e, st) {
      _logger.e('forPeriod failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DateTime?> lastUpdatedAt(String userId) async {
    try {
      return await _dao.lastUpdatedAt(userId);
    } catch (e, st) {
      _logger.e('lastUpdatedAt failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  ProductAnalyticsCacheEntry _mapEntry(ProductAnalyticsCacheDb db) {
    return ProductAnalyticsCacheEntry(
      id: db.id,
      userId: db.userId,
      spaceId: db.spaceId,
      day: db.day,
      productHash: db.productHash,
      categoryId: db.categoryId,
      purchases: db.purchases,
      totalSpendKopecks: db.totalSpendKopecks,
      totalQuantity: db.totalQuantity,
      avgPriceKopecks: db.avgPriceKopecks,
      updatedAt: db.updatedAt,
    );
  }
}
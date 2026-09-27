import 'package:logger/logger.dart';
import '../../domain/entities/forecast_cache_entry.dart';
import '../../domain/repositories/forecast_cache_repository.dart';
import '../datasources/forecast_cache_dao.dart';

class ForecastCacheRepositoryImpl implements ForecastCacheRepository {
  ForecastCacheRepositoryImpl({
    required ForecastCacheDao dao,
    required Logger logger,
  })  : _dao = dao,
        _logger = logger;

  final ForecastCacheDao _dao;
  final Logger _logger;

  @override
  Future<List<ForecastCacheEntry>> getForMonth({
    required String userId,
    String? spaceId,
    required String monthYear,
  }) async {
    try {
      final rows = await _dao.getForMonth(
        userId: userId,
        spaceId: spaceId,
        monthYear: monthYear,
      );
      return rows
          .map((r) => ForecastCacheEntry(
                id: r.id,
                userId: r.userId,
                spaceId: r.spaceId,
                monthYear: r.monthYear,
                categoryId: r.categoryId,
                forecastedAmount: r.forecastedAmount,
                updatedAt: r.updatedAt,
              ))
          .toList();
    } catch (e, st) {
      _logger.e('getForMonth failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DateTime?> getLastUpdated({
    required String userId,
    String? spaceId,
    required String monthYear,
  }) async {
    try {
      return _dao.getLastUpdated(
        userId: userId,
        spaceId: spaceId,
        monthYear: monthYear,
      );
    } catch (e, st) {
      _logger.e('getLastUpdated failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> replaceMonth({
    required String userId,
    String? spaceId,
    required String monthYear,
    required List<ForecastCacheEntry> entries,
  }) async {
    try {
      await _dao.replaceMonth(
        userId: userId,
        spaceId: spaceId,
        monthYear: monthYear,
        entries: entries,
      );
    } catch (e, st) {
      _logger.e('replaceMonth failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
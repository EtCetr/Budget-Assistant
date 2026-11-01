import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/yearly_aggregate.dart';
import '../../domain/repositories/yearly_aggregates_repository.dart';
import '../datasources/yearly_aggregates_dao.dart';

class YearlyAggregatesRepositoryImpl implements YearlyAggregatesRepository {
  YearlyAggregatesRepositoryImpl({
    required YearlyAggregatesDao dao,
    required Logger logger,
  })  : _dao = dao,
        _logger = logger;

  final YearlyAggregatesDao _dao;
  final Logger _logger;
  static const Uuid _uuid = Uuid();

  @override
  Future<YearlyAggregate?> getForScope({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    try {
      final row =
          await _dao.getForScope(userId: userId, spaceId: spaceId, year: year);
      if (row == null) return null;
      return YearlyAggregate(
        id: row.id,
        userId: row.userId,
        spaceId: row.spaceId,
        year: row.year,
        dataJson: row.dataJson,
        isViewed: row.isViewed,
        lastCalculatedAt: row.lastCalculatedAt,
        syncStatus: row.syncStatus,
      );
    } catch (e, st) {
      _logger.e('YearlyAggregatesRepo.getForScope failed',
          error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> upsert({
    required String userId,
    required String? spaceId,
    required int year,
    required String dataJson,
  }) async {
    try {
      await _dao.upsertAggregate(
        newId: _uuid.v4(),
        userId: userId,
        spaceId: spaceId,
        year: year,
        dataJson: dataJson,
      );
    } catch (e, st) {
      _logger.e('YearlyAggregatesRepo.upsert failed',
          error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> markViewed({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    try {
      await _dao.markViewed(userId: userId, spaceId: spaceId, year: year);
    } catch (e, st) {
      _logger.e('YearlyAggregatesRepo.markViewed failed',
          error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<YearInReviewYearInfo>> availableYears({
    required String userId,
  }) async {
    try {
      final bounds = await _dao.transactionYearBounds(userId);
      if (bounds == null) return const [];
      final aggregates = await _dao.personalAggregatesByYear(userId);
      final currentYear = DateTime.now().year;
      final result = <YearInReviewYearInfo>[];
      // Защита от аномальных дат: не глубже 20 лет.
      final fromYear = bounds.$1 < currentYear - 20
          ? currentYear - 20
          : bounds.$1;
      for (var year = bounds.$2; year >= fromYear; year--) {
        if (year > currentYear) continue;
        final count = await _dao.countTransactionsInYear(userId, year);
        if (count == 0) continue;
        final agg = aggregates[year];
        result.add(YearInReviewYearInfo(
          year: year,
          isCalculated: agg != null,
          isViewed: agg?.isViewed ?? false,
          transactionCount: count,
        ));
      }
      return result;
    } catch (e, st) {
      _logger.e('YearlyAggregatesRepo.availableYears failed',
          error: e, stackTrace: st);
      rethrow;
    }
  }
}
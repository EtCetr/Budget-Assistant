import '../models/yearly_aggregate.dart';

abstract interface class YearlyAggregatesRepository {
  Future<YearlyAggregate?> getForScope({
    required String userId,
    required String? spaceId,
    required int year,
  });

  Future<void> upsert({
    required String userId,
    required String? spaceId,
    required int year,
    required String dataJson,
  });

  Future<void> markViewed({
    required String userId,
    required String? spaceId,
    required int year,
  });

  /// Годы с данными для экрана «Статистика по годам» (по убыванию).
  Future<List<YearInReviewYearInfo>> availableYears({required String userId});

Future<DateTime?> lastTransactionUpdate({
required String userId,
required String? spaceId,
});
}
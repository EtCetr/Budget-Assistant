import 'package:budget_assistant/features/year_in_review/domain/models/yearly_aggregate.dart';
import 'package:budget_assistant/features/year_in_review/domain/repositories/yearly_aggregates_repository.dart';

/// Этап 24: заглушка репозитория годовых итогов для доменных тестов.
class FakeYearlyAggregatesRepository implements YearlyAggregatesRepository {
  final Map<String, YearlyAggregate> rows = <String, YearlyAggregate>{};
  List<YearInReviewYearInfo> years = <YearInReviewYearInfo>[];
  DateTime? lastTxUpdate;

  Object? error;
  final List<String> calls = <String>[];
  final List<({String userId, String? spaceId, int year, String dataJson})>
      upserts = <({String userId, String? spaceId, int year, String dataJson})>[];
  final List<({String userId, String? spaceId, int year})> viewed =
      <({String userId, String? spaceId, int year})>[];
  final List<({String userId, String? spaceId, int year})> reads =
      <({String userId, String? spaceId, int year})>[];

  static String keyOf(String userId, String? spaceId, int year) =>
      '$userId|${spaceId ?? ''}|$year';

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  /// Удобный посев строки кэша.
  void seed(YearlyAggregate row) {
    rows[keyOf(row.userId, row.spaceId, row.year)] = row;
  }

  @override
  Future<YearlyAggregate?> getForScope({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    _enter('getForScope');
    reads.add((userId: userId, spaceId: spaceId, year: year));
    return rows[keyOf(userId, spaceId, year)];
  }

  @override
  Future<void> upsert({
    required String userId,
    required String? spaceId,
    required int year,
    required String dataJson,
  }) async {
    _enter('upsert');
    upserts.add((
      userId: userId,
      spaceId: spaceId,
      year: year,
      dataJson: dataJson,
    ));
  }

  @override
  Future<void> markViewed({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    _enter('markViewed');
    viewed.add((userId: userId, spaceId: spaceId, year: year));
  }

  @override
  Future<List<YearInReviewYearInfo>> availableYears({
    required String userId,
  }) async {
    _enter('availableYears');
    return years;
  }

  @override
  Future<DateTime?> lastTransactionUpdate({
    required String userId,
    required String? spaceId,
  }) async {
    _enter('lastTransactionUpdate');
    return lastTxUpdate;
  }
}

/// Фабрика строки кэша годовых итогов.
YearlyAggregate makeAggregate({
  String id = 'ya1',
  String userId = 'u1',
  String? spaceId,
  int year = 2026,
  String dataJson = '{}',
  bool isViewed = false,
  DateTime? lastCalculatedAt,
}) =>
    YearlyAggregate(
      id: id,
      userId: userId,
      spaceId: spaceId,
      year: year,
      dataJson: dataJson,
      isViewed: isViewed,
      lastCalculatedAt: lastCalculatedAt ?? DateTime.utc(2026, 7, 15),
      syncStatus: 'pending',
    );
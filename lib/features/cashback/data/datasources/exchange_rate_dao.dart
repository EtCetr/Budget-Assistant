import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'exchange_rate_dao.g.dart';

@DriftAccessor(tables: [ExchangeRates])
class ExchangeRateDao extends DatabaseAccessor<AppDatabase>
    with _$ExchangeRateDaoMixin {
  ExchangeRateDao(super.db);

  /// Последний известный курс не позже [upperBoundUtc] и не старше [lowerBoundUtc].
  Future<double?> getLatestRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime upperBoundUtc,
    required DateTime lowerBoundUtc,
  }) async {
    final row = await (select(exchangeRates)
          ..where((t) =>
              t.fromCurrency.equals(fromCurrency) &
              t.toCurrency.equals(toCurrency) &
              t.date.isSmallerOrEqualValue(upperBoundUtc) &
              t.date.isBiggerOrEqualValue(lowerBoundUtc))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    return row?.rate;
  }

  Future<void> insert(ExchangeRatesCompanion entry) =>
      into(exchangeRates).insert(entry);

  Future<int> deleteByCurrencyDate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
  }) {
    return (delete(exchangeRates)
          ..where((t) =>
              t.fromCurrency.equals(fromCurrency) &
              t.toCurrency.equals(toCurrency) &
              t.date.equals(dateUtc)))
        .go();
  }

  Future<List<ExchangeRateDb>> getRecent(int limit) {
    return (select(exchangeRates)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .get();
  }

  Stream<List<ExchangeRateDb>> watchRecent(int limit) {
    return (select(exchangeRates)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .watch();
  }

  Future<int> deleteById(String id) =>
      (delete(exchangeRates)..where((t) => t.id.equals(id))).go();
}
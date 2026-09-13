import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'exchange_rate_dao.g.dart';

@DriftAccessor(tables: [ExchangeRates])
class ExchangeRateDao extends DatabaseAccessor<AppDatabase>
    with _$ExchangeRateDaoMixin {
  ExchangeRateDao(super.db);

  /// Приоритет 1: ручное исключение ровно на дату.
  Future<double?> getManualRateOnDate(
    String fromCurrency,
    String toCurrency,
    DateTime dayUtc,
  ) async {
    final row = await (select(exchangeRates)
          ..where((t) =>
              t.fromCurrency.equals(fromCurrency) &
              t.toCurrency.equals(toCurrency) &
              t.date.equals(dayUtc) &
              t.source.equals('manual')))
        .getSingleOrNull();
    return row?.rate;
  }

  /// Официальный курс (source != 'manual') пары к RUB в окне дат.
  Future<double?> getOfficialRubPer(
    String fromCurrency,
    DateTime upperBoundUtc,
    DateTime lowerBoundUtc,
  ) async {
    final row = await (select(exchangeRates)
          ..where((t) =>
              t.fromCurrency.equals(fromCurrency) &
              t.toCurrency.equals('RUB') &
              t.source.equals('manual').not() &
              t.date.isSmallerOrEqualValue(upperBoundUtc) &
              t.date.isBiggerOrEqualValue(lowerBoundUtc))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    return row?.rate;
  }

  /// Последний официальный курс к RUB любой даты (offline-fallback).
  Future<double?> getLatestOfficialRubPer(String fromCurrency) async {
    final row = await (select(exchangeRates)
          ..where((t) =>
              t.fromCurrency.equals(fromCurrency) &
              t.toCurrency.equals('RUB') &
              t.source.equals('manual').not())
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    return row?.rate;
  }

  /// Приоритет 4: ручное исключение в окне 7 дней.
  Future<double?> getManualRateInRange(
    String fromCurrency,
    String toCurrency,
    DateTime upperBoundUtc,
    DateTime lowerBoundUtc,
  ) async {
    final row = await (select(exchangeRates)
          ..where((t) =>
              t.fromCurrency.equals(fromCurrency) &
              t.toCurrency.equals(toCurrency) &
              t.source.equals('manual') &
              t.date.isSmallerOrEqualValue(upperBoundUtc) &
              t.date.isBiggerOrEqualValue(lowerBoundUtc))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    return row?.rate;
  }

  /// Массовый кэш официальных курсов даты (X -> RUB).
  ///
  /// insertOrIgnore: ручные исключения и уже существующие строки НЕ затираются.
  /// id детерминированный (cbr_CODE_YYYYMMDD) — идемпотентность без uuid.
  Future<void> cacheOfficialRates(
    DateTime dayUtc,
    Map<String, double> rubPer,
  ) async {
    if (rubPer.isEmpty) return;
    final stamp = '${dayUtc.year.toString().padLeft(4, '0')}'
        '${dayUtc.month.toString().padLeft(2, '0')}'
        '${dayUtc.day.toString().padLeft(2, '0')}';
    final now = DateTime.now().toUtc();
    await batch((b) {
      b.insertAll(
        exchangeRates,
        rubPer.entries
            .where((e) => e.key != 'RUB' && e.value > 0)
            .map((e) => ExchangeRatesCompanion(
                  id: Value('cbr_${e.key}_$stamp'),
                  fromCurrency: Value(e.key),
                  toCurrency: const Value('RUB'),
                  date: Value(dayUtc),
                  rate: Value(e.value),
                  source: const Value('CBR'),
                  createdAt: Value(now),
                ))
            .toList(),
        mode: InsertMode.insertOrIgnore,
      );
    });
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
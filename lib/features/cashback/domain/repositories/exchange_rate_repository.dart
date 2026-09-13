import '../entities/exchange_rate_entry.dart';

abstract interface class ExchangeRateRepository {
  /// Курс с fallback до 7 дней назад (ТОМ 4 §4.2).
  Future<double?> getRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
  });
  Future<void> upsertRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
    required double rate,
    required String source,
  });
  Future<List<ExchangeRateEntry>> getRecent({int limit = 30});
  Stream<List<ExchangeRateEntry>> watchRecent({int limit = 30});
  Future<void> deleteRate(String id);
}
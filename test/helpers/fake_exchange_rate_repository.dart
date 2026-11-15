import 'package:budget_assistant/features/cashback/domain/entities/exchange_rate_entry.dart';
import 'package:budget_assistant/features/cashback/domain/repositories/exchange_rate_repository.dart';

/// Этап 24: заглушка курсов валют для доменных тестов.
/// Возвращает фиксированный курс (или null) и пишет обращения.
class FakeExchangeRateRepository implements ExchangeRateRepository {
  FakeExchangeRateRepository(this.rate);

  final double? rate;
  final List<String> calls = <String>[];

  @override
  Future<double?> getRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
  }) async {
    calls.add('$fromCurrency->$toCurrency');
    return rate;
  }

  @override
  Future<void> upsertRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
    required double rate,
    required String source,
  }) async {}

  @override
  Future<List<ExchangeRateEntry>> getRecent({int limit = 30}) async =>
      const <ExchangeRateEntry>[];

  @override
  Stream<List<ExchangeRateEntry>> watchRecent({int limit = 30}) =>
      const Stream<List<ExchangeRateEntry>>.empty();

  @override
  Future<void> deleteRate(String id) async {}
}
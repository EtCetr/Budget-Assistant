// lib/features/cashback/presentation/providers/exchange_rates_screen_providers.dart
// Этап 21 (ТЗ 6.3.38.8): провайдеры экрана истории курсов.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/cashback/data/datasources/exchange_rate_dao.dart';

final exchangeRatesScreenDaoProvider = Provider<ExchangeRateDao>(
  (ref) => ExchangeRateDao(ref.watch(appDatabaseProvider)),
);

final rateCurrenciesProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(exchangeRatesScreenDaoProvider).distinctFromCurrencies(),
);

/// Ключ пары: базовая валюта -> к базовой валюте приложения.
class RatePairQuery {
  const RatePairQuery({required this.from, required this.to});

  final String from;
  final String to;

  @override
  bool operator ==(Object other) =>
      other is RatePairQuery && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

final pairRatesProvider =
    StreamProvider.family<List<ExchangeRateDb>, RatePairQuery>((ref, q) {
  return ref.watch(exchangeRatesScreenDaoProvider).watchPair(q.from, q.to);
});
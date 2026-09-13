import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import '../../domain/entities/cashback_category_summary.dart';
import '../../domain/entities/cashback_entry.dart';
import '../../domain/entities/exchange_rate_entry.dart';
import '../../domain/repositories/cashback_repository.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../../data/repositories/cashback_repository_impl.dart';
import '../../data/repositories/exchange_rate_repository_impl.dart';
import '../../data/remote/cbr_rate_remote_source.dart';
import '../../domain/usecases/calculate_cashback_usecase.dart';
import '../../domain/usecases/convert_currency_usecase.dart';
import '../../domain/usecases/get_cashback_cycle_bounds_usecase.dart';

final Logger _logger = Logger();

final cashbackRepositoryProvider = Provider<CashbackRepository>((ref) {
  return CashbackRepositoryImpl(
    db: ref.watch(appDatabaseProvider),
    logger: _logger,
  );
});

/// Открытый источник официальных курсов ЦБ РФ (Dio, без API-ключа).
final cbrRateRemoteSourceProvider = Provider<CbrRateRemoteSource>((ref) {
  return CbrRateRemoteSource(logger: _logger);
});

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>((ref) {
  return ExchangeRateRepositoryImpl(
    db: ref.watch(appDatabaseProvider),
    logger: _logger,
    uuid: const Uuid(),
    remote: ref.watch(cbrRateRemoteSourceProvider),
  );
});

final getCashbackCycleBoundsUseCaseProvider =
    Provider<GetCashbackCycleBoundsUseCase>(
  (ref) => GetCashbackCycleBoundsUseCase(logger: _logger),
);

final convertCurrencyUseCaseProvider = Provider<ConvertCurrencyUseCase>(
  (ref) => ConvertCurrencyUseCase(
    rateRepository: ref.watch(exchangeRateRepositoryProvider),
    logger: _logger,
  ),
);

final calculateCashbackUseCaseProvider = Provider<CalculateCashbackUseCase>(
  (ref) => CalculateCashbackUseCase(
    cashbackRepository: ref.watch(cashbackRepositoryProvider),
    convertCurrency: ref.watch(convertCurrencyUseCaseProvider),
    cycleBounds: ref.watch(getCashbackCycleBoundsUseCaseProvider),
    logger: _logger,
  ),
);

/// Список карт/счетов (без системных и архивных) для выбора в экране кэшбэка.
///
/// Реактивный: зависит от accountsListProvider, который экран счетов
/// инвалидирует при создании/редактировании/удалении счёта. Новый счёт
/// появляется в селекторе кэшбэка сразу, без перезапуска приложения.
final cashbackAccountsProvider = FutureProvider<List<Account>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final accounts = await ref.watch(accountsListProvider(userId).future);
  return accounts.where((a) => !a.isSystem && !a.isArchived).toList();
});

/// Реактивный список записей матрицы кэшбэка по счёту.
final cashbackEntriesProvider =
    StreamProvider.family<List<CashbackEntry>, String>((ref, accountId) {
  final repo = ref.watch(cashbackRepositoryProvider);
  return repo.watchByAccount(accountId);
});

/// Реактивный триггер: изменение транзакций счёта -> пересчёт кэшбэка.
final cashbackTransactionsTriggerProvider =
    StreamProvider.family<int, String>((ref, accountId) {
  final repo = ref.watch(cashbackRepositoryProvider);
  return repo.watchRelevantTransactionsCount(accountId);
});

/// Итоговый расчёт кэшбэка по счёту. Реактивный: зависит от триггера
/// транзакций и списка записей матрицы.
final cashbackSummariesProvider =
    FutureProvider.family<List<CashbackCategorySummary>, String>(
        (ref, accountId) async {
  ref.watch(cashbackTransactionsTriggerProvider(accountId));
  ref.watch(cashbackEntriesProvider(accountId));
  final useCase = ref.watch(calculateCashbackUseCaseProvider);
  return useCase(accountId: accountId, now: DateTime.now());
});

/// Последние курсы валют (для меню исключений).
final exchangeRatesRecentProvider =
    StreamProvider<List<ExchangeRateEntry>>((ref) {
  final repo = ref.watch(exchangeRateRepositoryProvider);
  return repo.watchRecent(limit: 30);
});
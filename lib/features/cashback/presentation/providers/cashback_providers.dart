import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/cashback_account_ref.dart';
import '../../domain/entities/cashback_category_summary.dart';
import '../../domain/entities/cashback_entry.dart';
import '../../domain/entities/cashback_matrix_models.dart';
import '../../domain/entities/exchange_rate_entry.dart';
import '../../domain/repositories/cashback_repository.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../../data/repositories/cashback_repository_impl.dart';
import '../../data/repositories/exchange_rate_repository_impl.dart';
import '../../data/remote/cbr_rate_remote_source.dart';
import '../../domain/usecases/calculate_cashback_usecase.dart';
import '../../domain/usecases/calculate_cashback_matrix_usecase.dart';
import '../../domain/usecases/convert_currency_usecase.dart';
import '../../domain/usecases/get_cashback_cycle_bounds_usecase.dart';
import '../../domain/usecases/update_cashback_entry_status_usecase.dart';

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

final calculateCashbackMatrixUseCaseProvider =
    Provider<CalculateCashbackMatrixUseCase>(
  (ref) => CalculateCashbackMatrixUseCase(
    calculateCashback: ref.watch(calculateCashbackUseCaseProvider),
    logger: _logger,
  ),
);

final updateCashbackEntryStatusUseCaseProvider =
    Provider<UpdateCashbackEntryStatusUseCase>(
  (ref) => UpdateCashbackEntryStatusUseCase(
    repository: ref.watch(cashbackRepositoryProvider),
    logger: _logger,
  ),
);

/// Источник счетов для кэшбэка и матрицы выгоды:
/// mine — только мои карты; family — счета участников активной группы.
enum CashbackAccountsSource { mine, family }

class CashbackAccountsSourceNotifier extends Notifier<CashbackAccountsSource> {
  @override
  CashbackAccountsSource build() => CashbackAccountsSource.mine;

  void set(CashbackAccountsSource source) => state = source;
}

final cashbackAccountsSourceProvider =
    NotifierProvider<CashbackAccountsSourceNotifier, CashbackAccountsSource>(
  CashbackAccountsSourceNotifier.new,
);

/// Единый триггер матрицы выгоды: любое изменение cashback_matrix,
/// transactions или accounts.
final cashbackMatrixTriggerProvider = StreamProvider<String>((ref) {
  return ref.watch(cashbackRepositoryProvider).watchCashbackRelevantChanges();
});

/// Мои счета (без системных и архивных).
final cashbackAccountsProvider = FutureProvider<List<CashbackAccountRef>>((
  ref,
) async {
  ref.watch(cashbackMatrixTriggerProvider);
  final repo = ref.watch(cashbackRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return repo.getMyAccounts(userId);
});

/// Счета активной группы (участники семьи).
/// Локально пусто, пока не работает синхронизация (Этап 25) —
/// экран показывает явное объяснение вместо молчаливой пустоты.
final cashbackFamilyAccountsProvider =
    FutureProvider<List<CashbackAccountRef>>((ref) async {
  ref.watch(cashbackMatrixTriggerProvider);
  final repo = ref.watch(cashbackRepositoryProvider);
  final spaceId = ref.watch(currentSpaceIdProvider);
  if (spaceId == null) return const [];
  return repo.getFamilyAccounts(spaceId);
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

/// Итоговый расчёт кэшбэка по счёту (реактивный).
final cashbackSummariesProvider =
    FutureProvider.family<List<CashbackCategorySummary>, String>(
        (ref, accountId) async {
  ref.watch(cashbackTransactionsTriggerProvider(accountId));
  ref.watch(cashbackEntriesProvider(accountId));
  final useCase = ref.watch(calculateCashbackUseCaseProvider);
  return useCase(accountId: accountId, now: DateTime.now());
});

/// Матрица выгоды по текущему источнику счетов (мои / семья).
final cashbackMatrixProvider = FutureProvider<List<CashbackMatrixRow>>((
  ref,
) async {
  final source = ref.watch(cashbackAccountsSourceProvider);
  final accounts = source == CashbackAccountsSource.mine
      ? await ref.watch(cashbackAccountsProvider.future)
      : await ref.watch(cashbackFamilyAccountsProvider.future);
  final useCase = ref.watch(calculateCashbackMatrixUseCaseProvider);
  return useCase(now: DateTime.now(), accounts: accounts);
});

/// Последние добавленные курсы валют (для меню исключений).
final exchangeRatesRecentProvider =
    StreamProvider<List<ExchangeRateEntry>>((ref) {
  final repo = ref.watch(exchangeRateRepositoryProvider);
  return repo.watchRecent(limit: 30);
});
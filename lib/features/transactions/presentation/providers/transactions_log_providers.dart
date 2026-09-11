import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/providers/database_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';

import '../../../../core/providers/security_providers.dart';
import '../../data/repositories/drift_transactions_log_repository.dart';
import '../../domain/entities/lookup_item.dart';
import '../../domain/entities/transaction_day_group.dart';
import '../../domain/entities/transaction_ui_model.dart';
import '../../domain/entities/transactions_filter_state.dart';
import '../../domain/repositories/transactions_log_repository.dart';
import '../../domain/usecases/calculate_day_summary_usecase.dart';
import '../../domain/usecases/get_transactions_log_page_usecase.dart';
import '../../domain/usecases/group_transactions_by_day_usecase.dart';
import '../../domain/usecases/hide_transaction_as_gift_usecase.dart';
import '../../domain/usecases/ignore_transaction_usecase.dart';
import '../../domain/usecases/mark_as_refund_usecase.dart';
import '../../domain/usecases/update_transaction_category_usecase.dart';
import '../../domain/usecases/unhide_transaction_as_gift_usecase.dart';
import '../../domain/usecases/restore_transaction_usecase.dart';
abstract interface class SyncService {
  Future<int> forceSyncNow();
}

class LocalOnlySyncService implements SyncService {
  final Logger _log = Logger();

  @override
  Future<int> forceSyncNow() async {
    _log.i('Local-only refresh. Real Supabase sync will be added in Stage 8.');
    return 0;
  }
}

final syncServiceProvider = Provider<SyncService>(
  (ref) => LocalOnlySyncService(),
);

final transactionsLogRepositoryProvider = Provider<TransactionsLogRepository>(
  (ref) => DriftTransactionsLogRepository(ref.watch(appDatabaseProvider)),
);

final getTransactionsLogPageUseCaseProvider = Provider(
  (ref) => GetTransactionsLogPageUseCase(
    ref.watch(transactionsLogRepositoryProvider),
  ),
);

final calculateDaySummaryUseCaseProvider = Provider(
  (ref) => CalculateDaySummaryUseCase(),
);

final groupTransactionsByDayUseCaseProvider = Provider(
  (ref) => GroupTransactionsByDayUseCase(
    ref.watch(calculateDaySummaryUseCaseProvider),
  ),
);

final hideTransactionAsGiftUseCaseProvider = Provider(
  (ref) => HideTransactionAsGiftUseCase(
    ref.watch(transactionsLogRepositoryProvider),
  ),
);

final ignoreTransactionUseCaseProvider = Provider(
  (ref) =>
      IgnoreTransactionUseCase(ref.watch(transactionsLogRepositoryProvider)),
);

final markAsRefundUseCaseProvider = Provider(
  (ref) => MarkAsRefundUseCase(ref.watch(transactionsLogRepositoryProvider)),
);

final updateTransactionCategoryUseCaseProvider = Provider(
  (ref) => UpdateTransactionCategoryUseCase(
    ref.watch(transactionsLogRepositoryProvider),
  ),
);

final transactionCategoryLookupProvider = FutureProvider<List<LookupItem>>(
  (ref) => ref.watch(transactionsLogRepositoryProvider).fetchCategories(),
);

final transactionAccountLookupProvider = FutureProvider<List<LookupItem>>(
  (ref) => ref.watch(transactionsLogRepositoryProvider).fetchAccounts(),
);

final hasPendingSyncProvider = StreamProvider<bool>(
  (ref) => ref
      .watch(transactionsLogRepositoryProvider)
      .watchPendingSyncCount()
      .map((count) => count > 0),
);

// ---------------------------------------------------------------------------
// Фильтры (Riverpod 3: Notifier вместо StateNotifier)
// ---------------------------------------------------------------------------

class TransactionsFilterNotifier extends Notifier<TransactionsFilterState> {
  @override
  TransactionsFilterState build() => const TransactionsFilterState();

  void setScope(TransactionsScope scope) =>
      state = state.copyWith(scope: scope);

  void setType(TransactionTypeFilter type) =>
      state = state.copyWith(type: type);

  void setCategoryIds(List<String> ids) =>
      state = state.copyWith(categoryIds: ids);

  void setAccountIds(List<String> ids) =>
      state = state.copyWith(accountIds: ids);

  void setPeriod(TransactionsPeriodPreset period) =>
      state = state.copyWith(period: period);

  void setCustomPeriod(DateTime from, DateTime to) => state = state.copyWith(
    period: TransactionsPeriodPreset.custom,
    customFrom: from,
    customTo: to,
  );

  void setAmountRange(int? fromKopecks, int? toKopecks) => state = state
      .copyWith(amountFromKopecks: fromKopecks, amountToKopecks: toKopecks);

  void toggleOnlyWithReceipt() =>
      state = state.copyWith(onlyWithReceipt: !state.onlyWithReceipt);

  void toggleOnlySplit() => state = state.copyWith(onlySplit: !state.onlySplit);

  void toggleOnlyDebts() => state = state.copyWith(onlyDebts: !state.onlyDebts);

  void setSearch(String value) => state = state.copyWith(search: value);

  void reset() => state = const TransactionsFilterState();

  void toggleExcludeOwn() =>
      state = state.copyWith(excludeOwn: !state.excludeOwn);  
}

final transactionsFilterProvider =
    NotifierProvider<TransactionsFilterNotifier, TransactionsFilterState>(
      TransactionsFilterNotifier.new,
    );

// ---------------------------------------------------------------------------
// Состояние списка
// ---------------------------------------------------------------------------

class TransactionsLogState {
  const TransactionsLogState({
    required this.groups,
    required this.loadedItems,
    required this.isLoadingMore,
    required this.hasMore,
    required this.page,
  });

  factory TransactionsLogState.initial() => const TransactionsLogState(
    groups: AsyncLoading(),
    loadedItems: [],
    isLoadingMore: false,
    hasMore: true,
    page: 0,
  );

  final AsyncValue<List<TransactionDayGroupUi>> groups;
  final List<TransactionUiModel> loadedItems;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;

  TransactionsLogState copyWith({
    AsyncValue<List<TransactionDayGroupUi>>? groups,
    List<TransactionUiModel>? loadedItems,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
  }) {
    return TransactionsLogState(
      groups: groups ?? this.groups,
      loadedItems: loadedItems ?? this.loadedItems,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class TransactionsLogNotifier extends Notifier<TransactionsLogState> {
  final Logger _log = Logger();

  late TransactionsFilterState _filter;
  late String _userId;
  late String? _spaceId;

  @override
  TransactionsLogState build() {
    // Перечитываем зависимости: при смене фильтров/пространства build
    // выполнится заново и список перезагрузится с первой страницы.
    _filter = ref.watch(transactionsFilterProvider);

    try {
      _userId = ref.watch(currentUserIdProvider);
    } catch (_) {
      _userId = '';
    }

    _spaceId = ref.watch(currentSpaceIdProvider);

    Future.microtask(loadFirst);
    return TransactionsLogState.initial();
  }

  Future<void> loadFirst() async {
    state = TransactionsLogState.initial();
    await _load(page: 0, append: false);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.groups.isLoading) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    await _load(page: state.page + 1, append: true);
  }

  Future<void> _load({required int page, required bool append}) async {
    if (_userId.isEmpty) {
      state = state.copyWith(
        groups: const AsyncError(
          'Нет авторизованного пользователя',
          StackTrace.empty,
        ),
        isLoadingMore: false,
      );
      return;
    }

    final result = await ref.read(getTransactionsLogPageUseCaseProvider)(
      filter: _filter,
      currentUserId: _userId,
      currentSpaceId: _spaceId,
      page: page,
    );

    switch (result) {
      case Success<TransactionPageUi>(:final value):
        final allItems = append
            ? [...state.loadedItems, ...value.items]
            : value.items;

        // Защита по спеке 6.7: если группировка/форматирование упадёт,
        // переходим в error-state с кнопкой Retry, а не в вечный skeleton.
        final List<TransactionDayGroupUi> grouped;
        try {
          grouped = ref.read(groupTransactionsByDayUseCaseProvider)(allItems);
        } catch (e, s) {
          _log.e(
            'Grouping transactions by day failed',
            error: e,
            stackTrace: s,
          );
          state = state.copyWith(
            groups: AsyncError('Не удалось сгруппировать транзакции', s),
            isLoadingMore: false,
          );
          return;
        }

        state = state.copyWith(
          groups: AsyncData(grouped),
          loadedItems: allItems,
          isLoadingMore: false,
          hasMore: value.hasMore,
          page: page,
        );

      case Error<TransactionPageUi>(:final failure):
        _log.e('Failed to load transactions page', error: failure);

        if (!append || state.loadedItems.isEmpty) {
          state = state.copyWith(
            groups: AsyncError(
              'Не удалось загрузить транзакции',
              StackTrace.current,
            ),
            isLoadingMore: false,
          );
        } else {
          state = state.copyWith(isLoadingMore: false);
        }
    }
  }
}

final unhideTransactionAsGiftUseCaseProvider = Provider(
  (ref) => UnhideTransactionAsGiftUseCase(
    ref.watch(transactionsLogRepositoryProvider),
  ),
);

final restoreTransactionUseCaseProvider = Provider(
  (ref) =>
      RestoreTransactionUseCase(ref.watch(transactionsLogRepositoryProvider)),
);

final transactionsLogProvider =
    NotifierProvider<TransactionsLogNotifier, TransactionsLogState>(
      TransactionsLogNotifier.new,
    );

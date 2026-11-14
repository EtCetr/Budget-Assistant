import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/transactions/data/repositories/drift_transactions_log_repository.dart';
import 'package:budget_assistant/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:budget_assistant/features/transactions/domain/entities/transaction_day_group.dart';
import 'package:budget_assistant/features/transactions/domain/entities/transactions_filter_state.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/calculate_day_summary_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/get_transactions_log_page_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/group_transactions_by_day_usecase.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/transactions_log_providers.dart';
import '../helpers/sqlite_probe.dart';
import '../helpers/test_db.dart';

/// Этап 24 (Integration, вариант B): сквозной офлайн-сценарий
/// «создать операцию -> pending -> синк -> pull-to-refresh».
///
/// Настоящие UseCases, репозитории и Drift в памяти.
/// Сеть заменена заглушкой: она только помечает записи синхронизированными.
/// Из drift берём только Value: остальные имена конфликтуют с matcher.
class _FakeClock implements ClockPort {
  const _FakeClock();

  @override
  Future<int> elapsedRealtimeMs() async => 1000;
}

class _FakeSyncService implements SyncService {
  _FakeSyncService(this.db);

  final AppDatabase db;
  int calls = 0;

  @override
  Future<int> forceSyncNow() async {
    calls++;
    return (db.update(db.transactions)
          ..where((t) => t.syncStatus.equalsValue(SyncStatus.pending)))
        .write(const TransactionsCompanion(syncStatus: Value(SyncStatus.synced)));
  }
}

void main() {
  final skip = sqliteSkipReason();

  setUpAll(() async {
    await initializeDateFormatting('ru');
    Intl.defaultLocale = 'ru';
  });

  group('Offline-First: создать -> pending -> синк -> refresh', () {
    late AppDatabase db;
    late TestSeed seed;
    late TransactionsRepositoryImpl repo;
    late DriftTransactionsLogRepository logRepo;
    late CreateTransactionUseCase create;
    late GetTransactionsLogPageUseCase getPage;
    late GroupTransactionsByDayUseCase groupByDay;
    late _FakeSyncService sync;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      final logger = Logger(level: Level.off);
      repo = TransactionsRepositoryImpl(db: db, logger: logger);
      logRepo = DriftTransactionsLogRepository(db);
      create = CreateTransactionUseCase(
        repository: repo,
        logger: logger,
        clock: const _FakeClock(),
      );
      getPage = GetTransactionsLogPageUseCase(logRepo);
      groupByDay = GroupTransactionsByDayUseCase(CalculateDaySummaryUseCase());
      sync = _FakeSyncService(db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<String> createExpense({int amount = 25000}) async {
      final result = await create(
        draft: TransactionDraft(
          accountId: kAccountId,
          date: testDate(2026, 7, 15),
          amount: amount,
          type: TransactionType.expense,
          customCategoryId: 'c1',
          merchantName: 'Перекрёсток',
        ),
        userId: kUserId,
      );
      expect(result, isA<Success<Transaction>>());
      return (result as Success<Transaction>).value.id;
    }

    test('новая операция сохраняется локально со статусом pending', () async {
      final id = await createExpense();

      final row = await (db.select(db.transactions)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      expect(row.syncStatus, SyncStatus.pending);
      expect(row.amount, 25000);
      expect(await logRepo.watchPendingSyncCount().first, 1);
    });

    test('операция сразу видна на странице журнала', () async {
      final id = await createExpense();

      final page = await getPage(
        filter: const TransactionsFilterState(),
        currentUserId: kUserId,
        currentSpaceId: null,
        page: 0,
      );

      final items = (page as Success<TransactionPageUi>).value.items;
      expect(items.map((e) => e.id), contains(id));
      expect(items.single.categoryName, 'Продукты');
      expect(items.single.syncStatus, SyncStatus.pending);
    });

    test('группировка по дням считает сумму трат', () async {
      await createExpense(amount: 25000);
      await createExpense(amount: 15000);

      final page = await getPage(
        filter: const TransactionsFilterState(),
        currentUserId: kUserId,
        currentSpaceId: null,
        page: 0,
      );
      final items = (page as Success<TransactionPageUi>).value.items;
      final groups = groupByDay(items);

      expect(groups.length, 1);
      expect(groups.single.summary.spentKopecks, 40000);
      expect(groups.single.summary.incomeKopecks, 0);
      expect(groups.single.summary.operationsCount, 2);
      expect(groups.single.title, isNotEmpty);
    });

    test('синк снимает pending, индикатор гаснет', () async {
      await createExpense();
      expect(await logRepo.watchPendingSyncCount().first, 1);

      final pushed = await sync.forceSyncNow();

      expect(pushed, 1);
      expect(sync.calls, 1);
      expect(await logRepo.watchPendingSyncCount().first, 0);
    });

    test('pull-to-refresh через нотифаер: данные -> синк -> свежий статус',
        () async {
      final id = await createExpense();
      final container = ProviderContainer(
        overrides: [
          currentUserIdProvider.overrideWithValue(kUserId),
          transactionsLogRepositoryProvider.overrideWithValue(logRepo),
          syncServiceProvider.overrideWithValue(sync),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(transactionsLogProvider, (_, __) {});
      addTearDown(sub.close);

      await container.read(transactionsLogProvider.notifier).loadFirst();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final before = container.read(transactionsLogProvider).groups;
      final groupsBefore = switch (before) {
        AsyncData(:final value) => value,
        _ => null,
      };
      expect(groupsBefore != null, isTrue, reason: 'Состояние: $before');
      expect(
        groupsBefore!.first.transactions
            .firstWhere((t) => t.id == id)
            .syncStatus,
        SyncStatus.pending,
      );

      await container.read(syncServiceProvider).forceSyncNow();
      await container.read(transactionsLogProvider.notifier).loadFirst();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final after = container.read(transactionsLogProvider).groups;
      final groupsAfter = switch (after) {
        AsyncData(:final value) => value,
        _ => null,
      };
      expect(groupsAfter != null, isTrue, reason: 'Состояние: $after');
      expect(
        groupsAfter!.first.transactions
            .firstWhere((t) => t.id == id)
            .syncStatus,
        SyncStatus.synced,
      );
      expect(await logRepo.watchPendingSyncCount().first, 0);
    });
  }, skip: skip);
}
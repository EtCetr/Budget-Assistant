import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/transactions/data/repositories/drift_transactions_log_repository.dart';
import 'package:budget_assistant/features/transactions/domain/entities/transactions_filter_state.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: фильтры журнала работают в SQL (DECISIONS: не в UI).
void main() {
  final skip = sqliteSkipReason();

  group('DriftTransactionsLogRepository (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DriftTransactionsLogRepository repo;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await seed.user(kOtherUserId);
      repo = DriftTransactionsLogRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<List<String>> ids({
      TransactionsFilterState filter = const TransactionsFilterState(),
      String? spaceId,
      int limit = 50,
      int offset = 0,
    }) async {
      final rows = await repo.fetchPage(
        filter: filter,
        currentUserId: kUserId,
        currentSpaceId: spaceId,
        limit: limit,
        offset: offset,
      );
      return rows.map((r) => r.id).toList();
    }

    test('без выбранного пространства видны все мои операции, чужие скрыты',
        () async {
      await seed.tx(id: 'mine', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(
        id: 'mine-family',
        amountKopecks: 2000,
        categoryId: 'c1',
        spaceId: kSpaceId,
      );
      await seed.tx(
        id: 'other-family',
        amountKopecks: 3000,
        categoryId: 'c1',
        spaceId: kSpaceId,
        userId: kOtherUserId,
      );

      expect((await ids()).toSet(), {'mine', 'mine-family'});
    });

    test('семейный скоуп без выбранного пространства пуст', () async {
      await seed.tx(
        id: 'family',
        amountKopecks: 2000,
        categoryId: 'c1',
        spaceId: kSpaceId,
      );

      expect(
        await ids(filter: const TransactionsFilterState(scope: TransactionsScope.family)),
        isEmpty,
      );
    });

    test('семейный скоуп: все операции группы, включая чужие', () async {
      await seed.tx(
        id: 'mine-family',
        amountKopecks: 1000,
        categoryId: 'c1',
        spaceId: kSpaceId,
      );
      await seed.tx(
        id: 'other-family',
        amountKopecks: 2000,
        categoryId: 'c1',
        spaceId: kSpaceId,
        userId: kOtherUserId,
      );
      await seed.tx(id: 'mine-personal', amountKopecks: 3000, categoryId: 'c1');

      final result = await ids(
        filter: const TransactionsFilterState(scope: TransactionsScope.family),
        spaceId: kSpaceId,
      );

      expect(result.toSet(), {'mine-family', 'other-family'});
    });

    test('скоуп «Все» в пространстве: группа + мои личные', () async {
      await seed.tx(
        id: 'other-family',
        amountKopecks: 2000,
        categoryId: 'c1',
        spaceId: kSpaceId,
        userId: kOtherUserId,
      );
      await seed.tx(id: 'mine-personal', amountKopecks: 3000, categoryId: 'c1');

      final result = await ids(spaceId: kSpaceId);

      expect(result.toSet(), {'other-family', 'mine-personal'});
    });

    test('«Без моих» исключает собственные операции', () async {
      await seed.tx(
        id: 'mine-family',
        amountKopecks: 1000,
        categoryId: 'c1',
        spaceId: kSpaceId,
      );
      await seed.tx(
        id: 'other-family',
        amountKopecks: 2000,
        categoryId: 'c1',
        spaceId: kSpaceId,
        userId: kOtherUserId,
      );

      final result = await ids(
        filter: const TransactionsFilterState(excludeOwn: true),
        spaceId: kSpaceId,
      );

      expect(result, ['other-family']);
    });

    test('фильтр типа: только расходы', () async {
      await seed.tx(id: 'exp', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(
        id: 'inc',
        amountKopecks: 2000,
        categoryId: 'i1',
        type: TransactionType.income,
      );

      final result = await ids(
        filter: const TransactionsFilterState(type: TransactionTypeFilter.expense),
      );

      expect(result, ['exp']);
    });

    test('сумма фильтруется по модулю: расход и доход в одном окне', () async {
      await seed.tx(id: 'exp', amountKopecks: 25000, categoryId: 'c1');
      await seed.tx(
        id: 'inc',
        amountKopecks: 28000,
        categoryId: 'i1',
        type: TransactionType.income,
      );
      await seed.tx(id: 'small', amountKopecks: 1000, categoryId: 'c1');

      final result = await ids(
        filter: const TransactionsFilterState(
          amountFromKopecks: 20000,
          amountToKopecks: 30000,
        ),
      );

      expect(result.toSet(), {'exp', 'inc'});
    });

    test('«Только сплиты»', () async {
      await seed.tx(id: 'plain', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(
        id: 'spl',
        amountKopecks: 30000,
        categoryId: 'c1',
        isSplit: true,
      );

      expect(
        await ids(filter: const TransactionsFilterState(onlySplit: true)),
        ['spl'],
      );
    });

    test('секретные: hideAsGift включает флаг, unhideAsGift снимает', () async {
      await seed.tx(id: 'gift', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(id: 'plain', amountKopecks: 2000, categoryId: 'c1');

      await repo.hideAsGift('gift');
      expect(
        await ids(filter: const TransactionsFilterState(onlySecret: true)),
        ['gift'],
      );

      await repo.unhideAsGift('gift');
      expect(
        await ids(filter: const TransactionsFilterState(onlySecret: true)),
        isEmpty,
      );
    });

    test('«Без крупных трат» исключает is_large_expense', () async {
      await seed.tx(id: 'plain', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(
        id: 'big',
        amountKopecks: 900000,
        categoryId: 'c1',
        isLargeExpense: true,
      );

      expect(
        await ids(
          filter: const TransactionsFilterState(excludeLargeExpenses: true),
        ),
        ['plain'],
      );
    });

    test('поиск по комментарию', () async {
      await seed.tx(
        id: 'coffee',
        amountKopecks: 1000,
        categoryId: 'c1',
        comment: 'Кофе с собой',
      );
      await seed.tx(
        id: 'fuel',
        amountKopecks: 2000,
        categoryId: 'c2',
        comment: 'Бензин',
      );

      expect(
        await ids(filter: const TransactionsFilterState(search: 'Кофе')),
        ['coffee'],
      );
    });

    test('фильтр по категории и счёту', () async {
      await seed.tx(id: 'c1-tx', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(id: 'c2-tx', amountKopecks: 2000, categoryId: 'c2');

      expect(
        await ids(filter: const TransactionsFilterState(categoryIds: ['c2'])),
        ['c2-tx'],
      );
      expect(
        await ids(filter: const TransactionsFilterState(accountIds: [kAccountId])),
        containsAll(<String>['c1-tx', 'c2-tx']),
      );
    });

    test('только с чеком', () async {
      await seed.tx(id: 'with-receipt', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(id: 'no-receipt', amountKopecks: 2000, categoryId: 'c1');
      await (db.update(db.transactions)
            ..where((t) => t.id.equals('with-receipt')))
          .write(const TransactionsCompanion(receiptId: Value('rec-1')));

      expect(
        await ids(filter: const TransactionsFilterState(onlyWithReceipt: true)),
        ['with-receipt'],
      );
    });

    test('сортировка по дате и пагинация', () async {
      await seed.tx(
        id: 'd10',
        amountKopecks: 1000,
        categoryId: 'c1',
        date: testDate(2026, 7, 10),
      );
      await seed.tx(
        id: 'd12',
        amountKopecks: 2000,
        categoryId: 'c1',
        date: testDate(2026, 7, 12),
      );
      await seed.tx(
        id: 'd11',
        amountKopecks: 3000,
        categoryId: 'c1',
        date: testDate(2026, 7, 11),
      );

      expect(await ids(limit: 2), ['d12', 'd11']);
      expect(await ids(limit: 2, offset: 2), ['d10']);
    });

    test('смена категории помечает операцию как pending', () async {
      await seed.tx(
        id: 'tx',
        amountKopecks: 1000,
        categoryId: 'c1',
        syncStatus: SyncStatus.synced,
      );

      await repo.updateCategory(transactionId: 'tx', categoryId: 'c2');

      final row = await (db.select(db.transactions)
            ..where((t) => t.id.equals('tx')))
          .getSingle();
      expect(row.customCategoryId, 'c2');
      expect(row.syncStatus, SyncStatus.pending);
    });

    test('toggleLargeExpense инвертирует флаг', () async {
      await seed.tx(id: 'tx', amountKopecks: 1000, categoryId: 'c1');

      await repo.toggleLargeExpense('tx');
      var row = await (db.select(db.transactions)
            ..where((t) => t.id.equals('tx')))
          .getSingle();
      expect(row.isLargeExpense, isTrue);

      await repo.toggleLargeExpense('tx');
      row = await (db.select(db.transactions)
            ..where((t) => t.id.equals('tx')))
          .getSingle();
      expect(row.isLargeExpense, isFalse);
    });

    test('счётчик pending реагирует на синхронизацию', () async {
      await seed.tx(id: 'p1', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(id: 'p2', amountKopecks: 2000, categoryId: 'c1');

      expect(await repo.watchPendingSyncCount().first, 2);

      await (db.update(db.transactions)
            ..where((t) => t.syncStatus.equalsValue(SyncStatus.pending)))
          .write(const TransactionsCompanion(syncStatus: Value(SyncStatus.synced)));

      expect(await repo.watchPendingSyncCount().first, 0);
    });

    test('справочники категорий и счетов', () async {
      final categories = await repo.fetchCategories();
      final accounts = await repo.fetchAccounts();

      expect(categories.map((c) => c.id), containsAll(<String>['c1', 'c2', 'i1']));
      expect(accounts.single.id, kAccountId);
      expect(accounts.single.name, 'Карта');
    });
  }, skip: skip);
}
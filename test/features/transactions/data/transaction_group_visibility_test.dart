import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/transactions/data/repositories/drift_transactions_log_repository.dart';
import 'package:budget_assistant/features/transactions/domain/entities/transactions_filter_state.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/add_transaction_copies_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/calculate_day_summary_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24 (D24-9): журнал показывает одну строку на группу копий.
/// «Личное» = группы с личной копией, «Семейные» = копии пространства.
void main() {
  final skip = sqliteSkipReason();

  setUpAll(() async {
    await initializeDateFormatting('ru');
    Intl.defaultLocale = 'ru';
  });

  group('Видимость групп копий в журнале (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DriftTransactionsLogRepository repo;
    late AddTransactionCopiesUseCase addCopies;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      repo = DriftTransactionsLogRepository(db);
      addCopies = AddTransactionCopiesUseCase(
        db: db,
        logger: Logger(level: Level.off),
      );
      await seed.tx(id: 'src', amountKopecks: 30000, categoryId: 'c1');
    });

    tearDown(() async {
      await db.close();
    });

    Future<List<String>> ids({
      TransactionsFilterState filter = const TransactionsFilterState(),
      String? spaceId,
    }) async {
      final rows = await repo.fetchPage(
        filter: filter,
        currentUserId: kUserId,
        currentSpaceId: spaceId,
        limit: 50,
        offset: 0,
      );
      return rows.map((r) => r.id).toList();
    }

    test('«Все» в пространстве: одна строка, представитель — личная копия',
        () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: [kSpaceId],
        userId: kUserId,
      );

      final rows = await repo.fetchPage(
        filter: const TransactionsFilterState(),
        currentUserId: kUserId,
        currentSpaceId: kSpaceId,
        limit: 50,
        offset: 0,
      );

      expect(rows.length, 1);
      expect(rows.single.id, 'src');
      expect(rows.single.copyGroupId, isNotNull);
      expect(rows.single.hasPersonalCopy, isTrue);
      expect(rows.single.groupSpaceIds, [kSpaceId]);
    });

    test('«Все» без пространства: тоже одна строка на группу', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: [kSpaceId],
        userId: kUserId,
      );

      expect(await ids(), ['src']);
    });

    test('«Личное»: только группы с личной копией', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: [kSpaceId],
        userId: kUserId,
      );
      await seed.tx(
        id: 'fam-only',
        amountKopecks: 5000,
        categoryId: 'c1',
        spaceId: kSpaceId,
      );

      final result = await ids(
        filter: const TransactionsFilterState(scope: TransactionsScope.mine),
        spaceId: kSpaceId,
      );

      expect(result, ['src']);
    });

    test('«Семейные»: копия пространства и операции без группы', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: [kSpaceId],
        userId: kUserId,
      );
      await seed.tx(
        id: 'fam-only',
        amountKopecks: 5000,
        categoryId: 'c1',
        spaceId: kSpaceId,
      );

      final result = await ids(
        filter: const TransactionsFilterState(scope: TransactionsScope.family),
        spaceId: kSpaceId,
      );

      expect(result.length, 2);
      expect(result, contains('fam-only'));
      expect(result, isNot(contains('src')));
    });

    test('сводка дня считает группу один раз', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: [kSpaceId],
        userId: kUserId,
      );

      final rows = await repo.fetchPage(
        filter: const TransactionsFilterState(),
        currentUserId: kUserId,
        currentSpaceId: kSpaceId,
        limit: 50,
        offset: 0,
      );
      // Сводку считаем напрямую: форматирование заголовка дня
      // проверяется в интеграционном тесте, здесь важна только математика.
      final summary = CalculateDaySummaryUseCase()(rows);

      expect(rows.length, 1);
      expect(summary.spentKopecks, 30000);
      expect(summary.incomeKopecks, 0);
      expect(summary.operationsCount, 1);
    });

    test('одиночная операция: состав скоупа без группы', () async {
      final rows = await repo.fetchPage(
        filter: const TransactionsFilterState(),
        currentUserId: kUserId,
        currentSpaceId: null,
        limit: 50,
        offset: 0,
      );

      expect(rows.single.copyGroupId, isNull);
      expect(rows.single.hasPersonalCopy, isTrue);
      expect(rows.single.groupSpaceIds, isEmpty);
    });
  }, skip: skip);
}
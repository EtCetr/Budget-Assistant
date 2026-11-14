import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/year_budget/data/repositories/year_budget_repository_impl.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24 (TODO(24)): carryOver, saveLimit для семьи, агрегация лимитов,
/// «Выделено» и слияние сплитов с обычными тратами.
void main() {
  final skip = sqliteSkipReason();

  group('YearBudgetRepositoryImpl (in-memory)', () {
    late AppDatabase db;
    late YearBudgetRepositoryImpl repo;
    late TestSeed seed;

    setUp(() async {
      db = openTestDb();
      repo = YearBudgetRepositoryImpl(db: db, logger: Logger(level: Level.off));
      seed = TestSeed(db);
      await seed.base();
    });

    tearDown(() async {
      await db.close();
    });

    test('saveLimit для семьи: остаётся одна строка на группу', () async {
      await seed.user(kOtherUserId);
      await seed.limit(
        id: 'old',
        categoryId: 'c1',
        year: 2026,
        month: 7,
        kopecks: 11100,
        userId: kOtherUserId,
        spaceId: kSpaceId,
      );

      await repo.saveLimit(
        userId: kUserId,
        spaceId: kSpaceId,
        year: 2026,
        month: 7,
        categoryId: 'c1',
        kopecks: 20000,
      );

      final rows = await (db.select(db.budgetLimits)
            ..where((b) => b.spaceId.equals(kSpaceId)))
          .get();

      expect(rows.length, 1);
      expect(rows.single.userId, kUserId);
      expect(rows.single.limitAmount, 20000);
      expect(rows.single.syncStatus, 'pending');
    });

    test('повторный saveLimit обновляет строку, а не плодит дубли', () async {
      await repo.saveLimit(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
        categoryId: 'c1',
        kopecks: 20000,
      );
      await repo.saveLimit(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
        categoryId: 'c1',
        kopecks: 25000,
      );

      final rows = await db.select(db.budgetLimits).get();

      expect(rows.length, 1);
      expect(rows.single.limitAmount, 25000);
    });

    test('лимиты семьи складываются по участникам', () async {
      await seed.user(kOtherUserId);
      await seed.limit(
        id: 'l1',
        categoryId: 'c1',
        year: 2026,
        month: 7,
        kopecks: 10000,
        spaceId: kSpaceId,
      );
      await seed.limit(
        id: 'l2',
        categoryId: 'c1',
        year: 2026,
        month: 7,
        kopecks: 5000,
        userId: kOtherUserId,
        spaceId: kSpaceId,
      );

      final limits = await repo.limitsForMonth(
        userId: kUserId,
        spaceId: kSpaceId,
        year: 2026,
        month: 7,
      );

      expect(limits, {'c1': 15000});
    });

    test('carryOver копирует лимиты и Выделено', () async {
      await seed.limit(
        id: 'l1',
        categoryId: 'c1',
        year: 2026,
        month: 6,
        kopecks: 20000,
      );
      await seed.limit(
        id: 'l2',
        categoryId: 'c2',
        year: 2026,
        month: 6,
        kopecks: 5000,
      );
      await seed.allocated(
        id: 'm6',
        year: 2026,
        month: 6,
        kopecks: 30000,
      );

      final copied = await repo.carryOver(
        userId: kUserId,
        spaceId: null,
        fromYear: 2026,
        fromMonth: 6,
        toYear: 2026,
        toMonth: 7,
      );

      expect(copied, 3);
      expect(
        await repo.limitsForMonth(
          userId: kUserId,
          spaceId: null,
          year: 2026,
          month: 7,
        ),
        {'c1': 20000, 'c2': 5000},
      );
      expect(
        await repo.allocated(
          userId: kUserId,
          spaceId: null,
          year: 2026,
          month: 7,
        ),
        30000,
      );
    });

    test('carryOver не перезаписывает уже заданное Выделено', () async {
      await seed.limit(
        id: 'l1',
        categoryId: 'c1',
        year: 2026,
        month: 6,
        kopecks: 20000,
      );
      await seed.allocated(id: 'm6', year: 2026, month: 6, kopecks: 30000);
      await seed.allocated(id: 'm7', year: 2026, month: 7, kopecks: 10000);

      final copied = await repo.carryOver(
        userId: kUserId,
        spaceId: null,
        fromYear: 2026,
        fromMonth: 6,
        toYear: 2026,
        toMonth: 7,
      );

      expect(copied, 1);
      expect(
        await repo.allocated(
          userId: kUserId,
          spaceId: null,
          year: 2026,
          month: 7,
        ),
        10000,
      );
    });

    test('previousBudgetMonth находит ближайший месяц со значениями', () async {
      await seed.allocated(id: 'm12', year: 2025, month: 12, kopecks: 40000);

      final prev = await repo.previousBudgetMonth(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 2,
      );

      expect(prev?.year, 2025);
      expect(prev?.month, 12);
    });

    test('previousBudgetMonth = null, если истории нет', () async {
      final prev = await repo.previousBudgetMonth(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
      );

      expect(prev, isNull);
    });

    test('Выделено: личный скоуп хранится с space_id = ""', () async {
      await seed.allocated(id: 'm7', year: 2026, month: 7, kopecks: 12345);

      final personal = await repo.allocated(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
      );
      final family = await repo.allocated(
        userId: kUserId,
        spaceId: kSpaceId,
        year: 2026,
        month: 7,
      );

      expect(personal, 12345);
      expect(family, isNull);
    });

    test('saveAllocated обновляет существующую строку месяца', () async {
      await repo.saveAllocated(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
        kopecks: 10000,
      );
      await repo.saveAllocated(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
        kopecks: 20000,
      );

      final rows = await db.select(db.monthlyBudgets).get();

      expect(rows.length, 1);
      expect(rows.single.allocatedAmount, 20000);
      expect(rows.single.syncStatus, 'pending');
    });

    test('матрица трат: сплиты и обычные трата сливаются в одну ячейку',
        () async {
      await seed.tx(id: 'plain', amountKopecks: 5000, categoryId: 'c1');
      await seed.tx(
        id: 'spl',
        amountKopecks: 10000,
        categoryId: 'c1',
        isSplit: true,
      );
      await seed.split(
        id: 'sp1',
        transactionId: 'spl',
        categoryId: 'c1',
        amountKopecks: 10000,
      );

      final rows = await repo.expenseMatrix(
        userId: kUserId,
        spaceId: null,
        year: 2026,
      );

      expect(rows.length, 1);
      expect(rows.single.categoryId, 'c1');
      expect(rows.single.month, 7);
      expect(rows.single.totalKopecks, 15000);
    });
  }, skip: skip);
}
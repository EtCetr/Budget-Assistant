import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/budget/data/repositories/budget_limits_repository_impl.dart';
import 'package:budget_assistant/features/budget/domain/entities/monthly_pnl.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/add_transaction_copies_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24 (D24-9): P&L и расход категории не задваивают копии группы.
void main() {
  final skip = sqliteSkipReason();

  group('BudgetLimitsRepository P&L (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late BudgetLimitsRepositoryImpl repo;
    late AddTransactionCopiesUseCase addCopies;
    late DateTime now;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      now = DateTime.now();
      repo = BudgetLimitsRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
      addCopies = AddTransactionCopiesUseCase(
        db: db,
        logger: Logger(level: Level.off),
      );
      await seed.tx(
        id: 'src',
        amountKopecks: 1500,
        categoryId: 'c1',
        date: now,
      );
      await addCopies(
        transactionId: 'src',
        spaceIds: [kSpaceId],
        userId: kUserId,
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<MonthlyPnl> pnl({String? spaceId}) async {
      final result = await repo.calculateMonthlyPnl(
        userId: kUserId,
        spaceId: spaceId,
        year: now.year,
        month: now.month,
      );
      return (result as Success<MonthlyPnl>).value;
    }

    test('личный P&L: группа копий считается один раз', () async {
      final p = await pnl();
      expect(p.totalExpense, 1500);
      expect(p.transactionCount, 1);
    });

    test('семейный P&L: только копия пространства, без задвоения', () async {
      final p = await pnl(spaceId: kSpaceId);
      expect(p.totalExpense, 1500);
      expect(p.transactionCount, 1);
    });

    test('расход категории не задваивается', () async {
      final result = await repo.calculateCategoryExpense(
        userId: kUserId,
        spaceId: null,
        categoryId: 'c1',
        year: now.year,
        month: now.month,
      );
      expect((result as Success<int>).value, 1500);
    });

    test('одиночная операция без группы считается как раньше', () async {
      await seed.tx(
        id: 'solo',
        amountKopecks: 2000,
        categoryId: 'c1',
        date: now,
      );
      final p = await pnl();
      expect(p.totalExpense, 3500);
      expect(p.transactionCount, 2);
    });
  }, skip: skip);
}
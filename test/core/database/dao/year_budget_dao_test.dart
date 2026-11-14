import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/daos/year_budget_dao.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24 (TODO(24)): SQL-математика годовых матриц на Drift in-memory.
/// Сплиты, крупные покупки, фильтры P&L, скоупы, локальный месяц.
Map<String, int> sumByCat(List<CatMonthSum> rows) {
  final out = <String, int>{};
  for (final r in rows) {
    out[r.categoryId] = (out[r.categoryId] ?? 0) + r.total;
  }
  return out;
}

void main() {
  final skip = sqliteSkipReason();

  group('YearBudgetDao (in-memory)', () {
    late AppDatabase db;
    late YearBudgetDao dao;
    late TestSeed seed;

    setUp(() async {
      db = openTestDb();
      dao = YearBudgetDao(db);
      seed = TestSeed(db);
      await seed.base();
    });

    tearDown(() async {
      await db.close();
    });

    test('обычная трата попадает в свою категорию и локальный месяц', () async {
      await seed.tx(id: 't1', amountKopecks: 15000, categoryId: 'c1');

      final rows = await dao.expenseMatrix(
        userId: kUserId,
        spaceId: null,
        year: 2026,
      );

      expect(rows.length, 1);
      expect(rows.single.categoryId, 'c1');
      expect(rows.single.month, 7);
      expect(rows.single.total, 15000);
    });

    test('сплит: исходная исключена, позиции учтены по своим категориям',
        () async {
      await seed.tx(
        id: 't2',
        amountKopecks: 30000,
        categoryId: 'c1',
        isSplit: true,
      );
      await seed.split(
        id: 'sp1',
        transactionId: 't2',
        categoryId: 'c1',
        amountKopecks: 10000,
      );
      await seed.split(
        id: 'sp2',
        transactionId: 't2',
        categoryId: 'c2',
        amountKopecks: 20000,
      );

      final rows = await dao.expenseMatrix(
        userId: kUserId,
        spaceId: null,
        year: 2026,
      );

      expect(sumByCat(rows), {'c1': 10000, 'c2': 20000});
    });

    test('крупная трата уходит в строку __large__', () async {
      await seed.tx(
        id: 't3',
        amountKopecks: 500000,
        categoryId: 'c1',
        isLargeExpense: true,
      );

      final rows = await dao.expenseMatrix(
        userId: kUserId,
        spaceId: null,
        year: 2026,
      );

      expect(sumByCat(rows), {'__large__': 500000});
    });

    test('фильтры P&L: переводы, цели, изъятия и ignored исключены', () async {
      await seed.tx(id: 'ok', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(
        id: 'tr',
        amountKopecks: 2000,
        categoryId: 'c1',
        type: TransactionType.transfer,
        linkedAccountId: kAccountId,
      );
      await seed.tx(
        id: 'goal',
        amountKopecks: 3000,
        categoryId: 'c1',
        savingsGoalId: 'g1',
      );
      await seed.tx(
        id: 'wd',
        amountKopecks: 4000,
        categoryId: 'c1',
        isWithdrawal: true,
      );
      await seed.tx(
        id: 'ig',
        amountKopecks: 5000,
        categoryId: 'c1',
        auditStatus: AuditStatus.ignored,
      );

      final rows = await dao.expenseMatrix(
        userId: kUserId,
        spaceId: null,
        year: 2026,
      );

      expect(sumByCat(rows), {'c1': 1000});
    });

    test('трата без категории попадает в __none__', () async {
      await seed.tx(id: 't4', amountKopecks: 700);

      final rows = await dao.expenseMatrix(
        userId: kUserId,
        spaceId: null,
        year: 2026,
      );

      expect(sumByCat(rows), {'__none__': 700});
    });

    test('скоупы изолированы: личное и семейное не смешиваются', () async {
      await seed.tx(id: 'p', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(
        id: 'f',
        amountKopecks: 2000,
        categoryId: 'c1',
        spaceId: kSpaceId,
      );

      final personal = await dao.expenseMatrix(
        userId: kUserId,
        spaceId: null,
        year: 2026,
      );
      final family = await dao.expenseMatrix(
        userId: kUserId,
        spaceId: kSpaceId,
        year: 2026,
      );

      expect(sumByCat(personal), {'c1': 1000});
      expect(sumByCat(family), {'c1': 2000});
    });

    test('доходы: только income, без изъятий, целей и ignored', () async {
      await seed.tx(
        id: 'in',
        amountKopecks: 50000,
        categoryId: 'i1',
        type: TransactionType.income,
      );
      await seed.tx(
        id: 'in-wd',
        amountKopecks: 10000,
        categoryId: 'i1',
        type: TransactionType.income,
        isWithdrawal: true,
      );
      await seed.tx(
        id: 'in-goal',
        amountKopecks: 11000,
        categoryId: 'i1',
        type: TransactionType.income,
        savingsGoalId: 'g1',
      );
      await seed.tx(
        id: 'in-ig',
        amountKopecks: 12000,
        categoryId: 'i1',
        type: TransactionType.income,
        auditStatus: AuditStatus.ignored,
      );
      await seed.tx(id: 'out', amountKopecks: 900, categoryId: 'c1');

      final rows = await dao.incomeMatrix(
        userId: kUserId,
        spaceId: null,
        year: 2026,
      );

      expect(sumByCat(rows), {'i1': 50000});
    });

    test('availableYears: годы только выбранного скоупа', () async {
      await seed.tx(
        id: 'y25',
        amountKopecks: 100,
        categoryId: 'c1',
        date: testDate(2025, 3),
      );
      await seed.tx(id: 'y26', amountKopecks: 100, categoryId: 'c1');
      await seed.tx(
        id: 'y24',
        amountKopecks: 100,
        categoryId: 'c1',
        spaceId: kSpaceId,
        date: testDate(2024, 5),
      );

      final years = await dao.availableYears(userId: kUserId, spaceId: null);

      expect(years, [2025, 2026]);
    });

    test('лимиты месяца: только active и только свой скоуп', () async {
      await seed.limit(
        id: 'l1',
        categoryId: 'c1',
        year: 2026,
        month: 7,
        kopecks: 20000,
      );
      await seed.limit(
        id: 'l2',
        categoryId: 'c2',
        year: 2026,
        month: 7,
        kopecks: 5000,
        status: 'cancelled',
      );
      await seed.limit(
        id: 'l3',
        categoryId: 'c1',
        year: 2026,
        month: 7,
        kopecks: 30000,
        spaceId: kSpaceId,
      );

      final rows = await dao.limitsForMonth(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
      );

      expect(rows.length, 1);
      expect(rows.single.categoryId, 'c1');
      expect(rows.single.limitAmount, 20000);
    });

    test('операции месяца: сплит-позиции отдельными строками', () async {
      await seed.tx(id: 'plain', amountKopecks: 1500, categoryId: 'c1');
      await seed.tx(
        id: 'spl',
        amountKopecks: 30000,
        categoryId: 'c1',
        isSplit: true,
      );
      await seed.split(
        id: 'sp1',
        transactionId: 'spl',
        categoryId: 'c1',
        amountKopecks: 10000,
      );
      await seed.split(
        id: 'sp2',
        transactionId: 'spl',
        categoryId: 'c2',
        amountKopecks: 20000,
      );
      await seed.tx(
        id: 'ig',
        amountKopecks: 9999,
        categoryId: 'c1',
        auditStatus: AuditStatus.ignored,
      );

      final rows = await dao.monthTransactions(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
        type: 'expense',
      );

      expect(rows.length, 3);
      expect(rows.where((r) => r.read<int>('ispos') == 1).length, 2);
      final plain = rows.firstWhere((r) => r.read<String>('id') == 'plain');
      expect(plain.read<int>('amt'), 1500);
      expect(plain.read<String>('cat'), 'Продукты');
      expect(plain.read<String>('acc'), 'Карта');
    });
  }, skip: skip);
}
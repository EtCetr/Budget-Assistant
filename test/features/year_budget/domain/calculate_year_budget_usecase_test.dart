import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/year_budget/domain/models/year_budget_models.dart';
import 'package:budget_assistant/features/year_budget/domain/usecases/calculate_year_budget_usecase.dart';
import '../../../helpers/fake_year_budget_repository.dart';

/// Этап 24: математика годовых матриц (D23.5-2 / D23.5-3 / D23.5-4).
/// Деньги — только целые копейки.
YearCatMonthSum _sum(String categoryId, int month, int kopecks) =>
    YearCatMonthSum(
      categoryId: categoryId,
      month: month,
      totalKopecks: kopecks,
    );

CategoryInfo _cat(String id, String name, {String type = 'expense'}) =>
    CategoryInfo(id: id, name: name, type: type);

YearCategoryRow _row(List<YearCategoryRow> rows, String id) =>
    rows.firstWhere((r) => r.categoryId == id);

void main() {
  late FakeYearBudgetRepository repo;
  late CalculateYearBudgetUseCase useCase;

  setUp(() {
    repo = FakeYearBudgetRepository();
    useCase = CalculateYearBudgetUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );
  });

  Future<YearBudgetData> run({String? spaceId, int year = 2026}) =>
      useCase(userId: 'user-1', year: year, spaceId: spaceId);

  group('Средняя: деление на месяцы с данными (D23.5-3)', () {
    test('пустые месяцы не участвуют в делении', () async {
      repo.scopeCats = [_cat('c1', 'Продукты')];
      repo.expenseSums = [_sum('c1', 1, 10000), _sum('c1', 3, 20000)];

      final row = _row((await run()).expenseRows, 'c1');

      expect(row.sumKopecks, 30000);
      expect(row.avgKopecks, 15000); // 30000 / 2, а не / 12
      expect(row.months.length, 12);
      expect(row.months[0], 10000);
      expect(row.months[1], isNull);
      expect(row.months[2], 20000);
    });

    test('явный ноль считается месяцем с данными', () async {
      repo.scopeCats = [_cat('c1', 'Продукты')];
      repo.expenseSums = [_sum('c1', 1, 10000), _sum('c1', 2, 0)];

      final row = _row((await run()).expenseRows, 'c1');

      expect(row.sumKopecks, 10000);
      expect(row.avgKopecks, 5000);
      expect(row.months[1], 0);
    });

    test('категория без данных: сумма и средняя равны нулю', () async {
      repo.scopeCats = [_cat('c1', 'Продукты')];

      final row = _row((await run()).expenseRows, 'c1');

      expect(row.sumKopecks, 0);
      expect(row.avgKopecks, 0);
      expect(row.months.every((m) => m == null), isTrue);
      expect(row.percentBps, 0);
    });
  });

  group('Крупные покупки без задвоения (D23.5-2)', () {
    setUp(() {
      repo.scopeCats = [_cat('c1', 'Продукты')];
      repo.expenseSums = [
        _sum('c1', 5, 10000),
        _sum(CalculateYearBudgetUseCase.largeId, 5, 500000),
      ];
    });

    test('крупные вынесены в отдельную строку', () async {
      final data = await run();
      final large = _row(data.expenseRows, CalculateYearBudgetUseCase.largeId);
      final c1 = _row(data.expenseRows, 'c1');

      expect(large.sumKopecks, 500000);
      expect(c1.sumKopecks, 10000);
      expect(data.totalExpenseKopecks, 510000);
    });

    test('сумма строк равна итогу (нет задвоения)', () async {
      final data = await run();
      final rowsSum =
          data.expenseRows.fold<int>(0, (s, r) => s + r.sumKopecks);

      expect(rowsSum, data.totalExpenseKopecks);
    });

    test('проценты считаются от общего итога', () async {
      final data = await run();

      expect(_row(data.expenseRows, 'c1').percentBps, 196);
      expect(
        _row(data.expenseRows, CalculateYearBudgetUseCase.largeId).percentBps,
        9803,
      );
    });

    test('строка крупных есть всегда, но только в тратах и лимитах', () async {
      repo.expenseSums = [];
      repo.incomeSums = [_sum('i1', 1, 5000)];
      repo.scopeCats = [_cat('c1', 'Продукты'), _cat('i1', 'Зарплата', type: 'income')];

      final data = await run();

      expect(
        data.expenseRows
            .any((r) => r.categoryId == CalculateYearBudgetUseCase.largeId),
        isTrue,
      );
      expect(
        data.limitRows
            .any((r) => r.categoryId == CalculateYearBudgetUseCase.largeId),
        isTrue,
      );
      expect(
        data.incomeRows
            .any((r) => r.categoryId == CalculateYearBudgetUseCase.largeId),
        isFalse,
      );
    });
  });

  group('Состав категорий: Без категории и чужой скоуп', () {
    setUp(() {
      repo.scopeCats = [_cat('c1', 'Продукты')];
      repo.allCats = [_cat('c1', 'Продукты'), _cat('f1', 'Чужая семья')];
      repo.expenseSums = [
        _sum('c1', 1, 1000),
        _sum('f1', 1, 2000),
        _sum('x9', 1, 500),
        _sum(CalculateYearBudgetUseCase.noneId, 1, 300),
      ];
    });

    test('операция без категории показывается отдельной строкой', () async {
      final row =
          _row((await run()).expenseRows, CalculateYearBudgetUseCase.noneId);

      expect(row.name, 'Без категории');
      expect(row.sumKopecks, 300);
    });

    test('категория чужого скоупа резолвится по имени из БД', () async {
      expect(_row((await run()).expenseRows, 'f1').name, 'Чужая семья');
    });

    test('неизвестная категория получает нейтральное имя', () async {
      expect(
        _row((await run()).expenseRows, 'x9').name,
        'Категория (другой скоуп)',
      );
    });

    test('все строки попадают в итог', () async {
      final data = await run();

      expect(data.totalExpenseKopecks, 3800);
      expect(
        data.expenseRows.fold<int>(0, (s, r) => s + r.sumKopecks),
        3800,
      );
    });
  });

  group('Профицит и движение (D23.5-4)', () {
    setUp(() {
      repo.scopeCats = [_cat('c1', 'Продукты'), _cat('i1', 'Зарплата', type: 'income')];
      repo.incomeSums = [_sum('i1', 1, 100000), _sum('i1', 2, 50000)];
      repo.expenseSums = [_sum('c1', 1, 40000)];
    });

    test('профицит = доходы минус расходы', () async {
      final data = await run();

      expect(data.totalIncomeKopecks, 150000);
      expect(data.totalExpenseKopecks, 40000);
      expect(data.totalSurplusKopecks, 110000);
      expect(data.surplusPercentBps, 7333);
    });

    test('помесячное движение и проценты', () async {
      final data = await run();

      expect(data.monthsWithData, [1, 2]);
      expect(data.cashflow.length, 2);

      expect(data.cashflow[0].incomeKopecks, 100000);
      expect(data.cashflow[0].expenseKopecks, 40000);
      expect(data.cashflow[0].surplusKopecks, 60000);
      expect(data.cashflow[0].percentBps, 6000);

      expect(data.cashflow[1].incomeKopecks, 50000);
      expect(data.cashflow[1].expenseKopecks, isNull);
      expect(data.cashflow[1].surplusKopecks, 50000);
      expect(data.cashflow[1].percentBps, 10000);
    });

    test('доходная категория не попадает в матрицу трат', () async {
      final data = await run();

      expect(data.expenseRows.map((r) => r.categoryId).toSet(),
          {'c1', CalculateYearBudgetUseCase.largeId});
      expect(data.incomeRows.map((r) => r.categoryId).toSet(), {'i1'});
      expect(_row(data.incomeRows, 'i1').avgKopecks, 75000);
    });
  });

  group('Лимиты', () {
    test('месяц только с лимитами попадает в движение', () async {
      repo.scopeCats = [_cat('c1', 'Продукты')];
      repo.yearLimits = {
        'c1': {3: 20000},
      };

      final data = await run();

      expect(data.totalLimitKopecks, 20000);
      expect(data.monthsWithData, [3]);
      expect(data.cashflow.single.incomeKopecks, isNull);
      expect(data.cashflow.single.expenseKopecks, isNull);
      expect(data.cashflow.single.surplusKopecks, 0);
      expect(data.cashflow.single.percentBps, isNull);
      expect(_row(data.limitRows, 'c1').sumKopecks, 20000);
    });

    test('сумма строк лимитов равна итогу лимитов', () async {
      repo.scopeCats = [_cat('c1', 'Продукты')];
      repo.yearLimits = {
        'c1': {1: 20000},
        CalculateYearBudgetUseCase.largeId: {1: 5000},
      };

      final data = await run();

      expect(data.totalLimitKopecks, 25000);
      expect(data.limitRows.fold<int>(0, (s, r) => s + r.sumKopecks), 25000);
    });
  });

  test('Пустой год: нули, без движения и без процента', () async {
    repo.scopeCats = [_cat('c1', 'Продукты')];

    final data = await run();

    expect(data.totalExpenseKopecks, 0);
    expect(data.totalIncomeKopecks, 0);
    expect(data.totalLimitKopecks, 0);
    expect(data.totalSurplusKopecks, 0);
    expect(data.surplusPercentBps, isNull);
    expect(data.cashflow, isEmpty);
    expect(data.monthsWithData, isEmpty);
    expect(data.expenseRows.length, 2); // категория + крупные
  });

  test('Скоуп и пользователь пробрасываются в репозиторий', () async {
    await run(spaceId: 'space-1');

    expect(repo.lastUserId, 'user-1');
    expect(repo.lastSpaceId, 'space-1');
    expect(repo.lastYear, 2026);
    expect(
      repo.calls,
      containsAll(<String>[
        'categories',
        'allCategories',
        'expenseMatrix',
        'incomeMatrix',
        'limitsYear',
      ]),
    );
  });

  test('Ошибка репозитория логируется и пробрасывается', () async {
    repo.error = Exception('db down');

    await expectLater(run(), throwsA(isA<Exception>()));
  });
}
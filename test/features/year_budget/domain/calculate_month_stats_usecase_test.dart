import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/year_budget/domain/models/year_budget_models.dart';
import 'package:budget_assistant/features/year_budget/domain/usecases/calculate_month_stats_usecase.dart';
import 'package:budget_assistant/features/year_budget/domain/usecases/calculate_year_budget_usecase.dart';
import '../../../helpers/fake_year_budget_repository.dart';

/// Этап 24: месячная статистика — Сумма / Лимит / Осталось, Нераспределено,
/// состав категорий и баннер переноса из прошлого месяца.
YearCatMonthSum _sum(String categoryId, int month, int kopecks) =>
    YearCatMonthSum(
      categoryId: categoryId,
      month: month,
      totalKopecks: kopecks,
    );

CategoryInfo _cat(String id, String name, {String type = 'expense'}) =>
    CategoryInfo(id: id, name: name, type: type);

MonthTxRow _tx(String id, int kopecks) => MonthTxRow(
      id: id,
      dateUtc: DateTime.utc(2026, 7, 10, 12),
      accountName: 'Карта',
      categoryName: 'Продукты',
      amountKopecks: kopecks,
      isSplitPosition: false,
    );

MonthCategoryRow _row(List<MonthCategoryRow> rows, String id) =>
    rows.firstWhere((r) => r.categoryId == id);

void main() {
  late FakeYearBudgetRepository repo;
  late CalculateMonthStatsUseCase useCase;

  const key = MonthStatsKey(year: 2026, month: 7);

  setUp(() {
    repo = FakeYearBudgetRepository();
    useCase = CalculateMonthStatsUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );

    repo.scopeCats = [
      _cat('c1', 'Продукты'),
      _cat('c2', 'Транспорт'),
      _cat('i1', 'Зарплата', type: 'income'),
    ];
    repo.allCats = [...repo.scopeCats, _cat('f1', 'Чужая категория')];
    repo.expenseSums = [
      _sum('c1', 7, 15000),
      _sum('c1', 8, 99999), // соседний месяц не должен попасть
      _sum('c2', 7, 5000),
      _sum(CalculateYearBudgetUseCase.noneId, 7, 700),
      _sum(CalculateYearBudgetUseCase.largeId, 7, 200000),
      _sum('f1', 7, 3000),
    ];
    repo.monthLimits = {'c1': 20000, 'c2': 4000};
    repo.allocatedValue = 30000;
    repo.expenseTx = [_tx('t-out', 15000)];
    repo.incomeTx = [_tx('t-in', 50000)];
  });

  Future<MonthStatsData> run({MonthStatsKey k = key}) =>
      useCase(userId: 'user-1', key: k);

  group('Сумма / Лимит / Осталось', () {
    test('остаток = лимит минус факт', () async {
      final data = await run();

      expect(_row(data.categories, 'c1').sumKopecks, 15000);
      expect(_row(data.categories, 'c1').limitKopecks, 20000);
      expect(_row(data.categories, 'c1').remainingKopecks, 5000);
    });

    test('перерасход даёт отрицательный остаток', () async {
      final data = await run();

      expect(_row(data.categories, 'c2').sumKopecks, 5000);
      expect(_row(data.categories, 'c2').remainingKopecks, -1000);
    });

    test('без лимита остаток равен минус факту', () async {
      final large = _row(
        (await run()).categories,
        CalculateYearBudgetUseCase.largeId,
      );

      expect(large.limitKopecks, isNull);
      expect(large.sumKopecks, 200000);
      expect(large.remainingKopecks, -200000);
    });

    test('берётся только выбранный месяц', () async {
      final data = await run();

      expect(_row(data.categories, 'c1').sumKopecks, 15000);
      expect(data.sumExpensesKopecks, 223700);
    });
  });

  group('Выделено и Нераспределено', () {
    test('нераспределено = выделено минус сумма лимитов', () async {
      final data = await run();

      expect(data.allocatedKopecks, 30000);
      expect(data.sumLimitsKopecks, 24000);
      expect(data.unallocatedKopecks, 6000);
    });

    test('если Выделено не задано — Нераспределено null', () async {
      repo.allocatedValue = null;

      final data = await run();

      expect(data.allocatedKopecks, isNull);
      expect(data.unallocatedKopecks, isNull);
    });
  });

  group('Состав категорий', () {
    test('скоуп + крупные + категории из данных и лимитов', () async {
      repo.monthLimits = {...repo.monthLimits, 'f1': 1000};

      final ids = (await run()).categories.map((r) => r.categoryId).toSet();

      expect(
        ids,
        {
          'c1',
          'c2',
          CalculateYearBudgetUseCase.largeId,
          CalculateYearBudgetUseCase.noneId,
          'f1',
        },
      );
    });

    test('доходные категории не попадают в список трат', () async {
      final ids = (await run()).categories.map((r) => r.categoryId);

      expect(ids, isNot(contains('i1')));
    });

    test('категория только с лимитом: факт 0, остаток = лимит', () async {
      repo.monthLimits = {'f1': 8000};
      repo.expenseSums = [];

      final row = _row((await run()).categories, 'f1');

      expect(row.name, 'Чужая категория');
      expect(row.sumKopecks, 0);
      expect(row.limitKopecks, 8000);
      expect(row.remainingKopecks, 8000);
    });

    test('операция без категории называется Без категории', () async {
      final row = _row(
        (await run()).categories,
        CalculateYearBudgetUseCase.noneId,
      );

      expect(row.name, 'Без категории');
      expect(row.sumKopecks, 700);
    });
  });

  group('Списки операций и доходы', () {
    test('списки месяца приходят из репозитория', () async {
      final data = await run();

      expect(data.expenses.map((e) => e.id), ['t-out']);
      expect(data.incomes.map((e) => e.id), ['t-in']);
      expect(data.sumIncomesKopecks, 50000);
    });
  });

  group('Баннер переноса из прошлого месяца', () {
    test('показан, когда месяц пустой и прошлый найден', () async {
      repo.previous = (year: 2026, month: 6);
      repo.allocatedValue = null;
      repo.monthLimits = {};

      final data = await run();

      expect(data.carryFromYear, 2026);
      expect(data.carryFromMonth, 6);
    });

    test('скрыт, если Выделено уже задано', () async {
      repo.previous = (year: 2026, month: 6);
      repo.monthLimits = {};
      repo.allocatedValue = 10000;

      final data = await run();

      expect(data.carryFromYear, isNull);
      expect(data.carryFromMonth, isNull);
    });

    test('скрыт, если лимиты уже заданы', () async {
      repo.previous = (year: 2026, month: 6);
      repo.allocatedValue = null;

      final data = await run();

      expect(data.carryFromYear, isNull);
    });

    test('скрыт, если прошлого месяца нет', () async {
      repo.previous = null;
      repo.allocatedValue = null;
      repo.monthLimits = {};

      final data = await run();

      expect(data.carryFromYear, isNull);
      expect(data.carryFromMonth, isNull);
    });
  });

  test('Пустой месяц: категории скоупа + крупные, суммы нулевые', () async {
    repo.expenseSums = [];
    repo.monthLimits = {};
    repo.allocatedValue = null;
    repo.expenseTx = [];
    repo.incomeTx = [];

    final data = await run();

    expect(data.categories.length, 3);
    expect(data.sumExpensesKopecks, 0);
    expect(data.sumIncomesKopecks, 0);
    expect(data.sumLimitsKopecks, 0);
    expect(data.unallocatedKopecks, isNull);
  });

  test('Скоуп пробрасывается в репозиторий', () async {
    await run(k: const MonthStatsKey(year: 2026, month: 7, spaceId: 'space-1'));

    expect(repo.lastSpaceId, 'space-1');
    expect(repo.lastUserId, 'user-1');
    expect(repo.lastMonth, 7);
  });

  test('Ошибка репозитория логируется и пробрасывается', () async {
    repo.error = Exception('db down');

    await expectLater(run(), throwsA(isA<Exception>()));
  });
}
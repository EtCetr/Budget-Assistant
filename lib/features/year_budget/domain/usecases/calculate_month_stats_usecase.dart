import 'package:logger/logger.dart';
import '../models/year_budget_models.dart';
import '../repositories/year_budget_repository.dart';

/// «Месячная статистика»: Выделено/Нераспределено, категории Сумма/Лимит/
/// Осталось, списки расходов и доходов месяца.
class CalculateMonthStatsUseCase {
  CalculateMonthStatsUseCase({
    required YearBudgetRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final YearBudgetRepository _repository;
  final Logger _logger;

  Future<MonthStatsData> call({
    required String userId,
    required MonthStatsKey key,
  }) async {
    try {
      final spaceId = key.spaceId;
      final cats = await _repository.categories(userId: userId, spaceId: spaceId);
      final expenseSums = await _repository.expenseMatrix(
          userId: userId, spaceId: spaceId, year: key.year);
      final limits = await _repository.limitsForMonth(
          userId: userId, spaceId: spaceId, year: key.year, month: key.month);
      final allocated = await _repository.allocated(
          userId: userId, spaceId: spaceId, year: key.year, month: key.month);

      int sumOf(String categoryId) => expenseSums
          .where((e) => e.month == key.month && e.categoryId == categoryId)
          .fold<int>(0, (s, e) => s + e.totalKopecks);

      final expenseCats = cats.where((c) => c.type == 'expense').toList();
      final categoryRows = <MonthCategoryRow>[
        for (final c in expenseCats)
          MonthCategoryRow(
            categoryId: c.id,
            name: c.name,
            colorHex: c.colorHex,
            emoji: c.emoji,
            sumKopecks: sumOf(c.id),
            limitKopecks: limits[c.id],
            remainingKopecks: (limits[c.id] ?? 0) - sumOf(c.id),
          ),
        MonthCategoryRow(
          categoryId: CalculateYearBudgetLargeId.value,
          name: 'Крупные покупки',
          emoji: '💎',
          sumKopecks: sumOf('__large__'),
          limitKopecks: limits['__large__'],
          remainingKopecks: (limits['__large__'] ?? 0) - sumOf('__large__'),
        ),
      ];

      final expenses = await _repository.monthTransactions(
          userId: userId,
          spaceId: spaceId,
          year: key.year,
          month: key.month,
          type: 'expense');
      final incomes = await _repository.monthTransactions(
          userId: userId,
          spaceId: spaceId,
          year: key.year,
          month: key.month,
          type: 'income');

      final sumExpenses = categoryRows.fold<int>(0, (s, r) => s + r.sumKopecks);
      final sumIncomes = incomes.fold<int>(0, (s, r) => s + r.amountKopecks);
      final sumLimits = limits.values.fold<int>(0, (a, b) => a + b);

      final carry = await _repository.previousBudgetMonth(
          userId: userId, spaceId: spaceId, year: key.year, month: key.month);
      final showCarry = carry != null && allocated == null && sumLimits == 0;

      return MonthStatsData(
        year: key.year,
        month: key.month,
        allocatedKopecks: allocated,
        unallocatedKopecks: allocated == null ? null : allocated - sumLimits,
        categories: categoryRows,
        expenses: expenses,
        incomes: incomes,
        sumExpensesKopecks: sumExpenses,
        sumIncomesKopecks: sumIncomes,
        sumLimitsKopecks: sumLimits,
        carryFromYear: showCarry ? carry.year : null,
        carryFromMonth: showCarry ? carry.month : null,
      );
    } catch (e, st) {
      _logger.e('CalculateMonthStats failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

/// Общая константа id синтетической строки крупных покупок.
class CalculateYearBudgetLargeId {
  static const value = '__large__';
}
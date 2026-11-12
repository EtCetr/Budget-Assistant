// TODO(24): unit-тесты месячной статистики - Сумма/Лимит/Осталось,
// Нераспределено, состав категорий (скоуп + категории из данных).
import 'package:logger/logger.dart';
import '../models/year_budget_models.dart';
import '../repositories/year_budget_repository.dart';
import 'calculate_year_budget_usecase.dart';

/// «Месячная статистика»: Выделено/Нераспределено, категории, списки операций.
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
      final cats =
          await _repository.categories(userId: userId, spaceId: spaceId);
      final allCats = await _repository.allCategories(userId: userId);
      final nameById = <String, CategoryInfo>{
        for (final c in allCats) c.id: c,
      };
      final expenseSums = await _repository.expenseMatrix(
          userId: userId, spaceId: spaceId, year: key.year);
      final limits = await _repository.limitsForMonth(
          userId: userId, spaceId: spaceId, year: key.year, month: key.month);
      final allocated = await _repository.allocated(
          userId: userId, spaceId: spaceId, year: key.year, month: key.month);

      final monthSums = <String, int>{};
      for (final e in expenseSums) {
        if (e.month != key.month) continue;
        monthSums[e.categoryId] =
            (monthSums[e.categoryId] ?? 0) + e.totalKopecks;
      }

      MonthCategoryRow row(String id, String name, String? emoji, String? color) {
        final sum = monthSums[id] ?? 0;
        final limit = limits[id];
        return MonthCategoryRow(
          categoryId: id,
          name: name,
          colorHex: color,
          emoji: emoji,
          sumKopecks: sum,
          limitKopecks: limit,
          remainingKopecks: (limit ?? 0) - sum,
        );
      }

      final covered = <String>{};
      final categoryRows = <MonthCategoryRow>[];
      for (final c in cats.where((c) => c.type == 'expense')) {
        categoryRows.add(row(c.id, c.name, c.emoji, c.colorHex));
        covered.add(c.id);
      }
      categoryRows.add(row(
          CalculateYearBudgetUseCase.largeId, 'Крупные покупки', '💎', null));
      covered.add(CalculateYearBudgetUseCase.largeId);
      for (final id in {...monthSums.keys, ...limits.keys}) {
        if (covered.contains(id)) continue;
        final c = nameById[id];
        final name = id == CalculateYearBudgetUseCase.noneId
            ? 'Без категории'
            : (c?.name ?? 'Категория (другой скоуп)');
        categoryRows.add(row(id, name, c?.emoji, c?.colorHex));
        covered.add(id);
      }

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

      final sumExpenses =
          categoryRows.fold<int>(0, (s, r) => s + r.sumKopecks);
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
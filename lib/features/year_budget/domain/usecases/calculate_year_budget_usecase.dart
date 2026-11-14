import 'package:logger/logger.dart';
import '../models/year_budget_models.dart';
import '../repositories/year_budget_repository.dart';

/// Годовой отчёт. Строки строятся из ОБЪЕДИНЕНИЯ категорий скоупа и всех
/// категорий, встречающихся в данных (фикс 23.6b: пустые ячейки при сумме).
class CalculateYearBudgetUseCase {
  CalculateYearBudgetUseCase({
    required YearBudgetRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final YearBudgetRepository _repository;
  final Logger _logger;

  static const largeId = '__large__';
  static const noneId = '__none__';

  Future<YearBudgetData> call({
    required String userId,
    required int year,
    String? spaceId,
  }) async {
    try {
      final cats =
          await _repository.categories(userId: userId, spaceId: spaceId);
      final allCats = await _repository.allCategories(userId: userId);
      final nameById = <String, CategoryInfo>{
        for (final c in allCats) c.id: c,
      };
      final expenseSums = await _repository.expenseMatrix(
          userId: userId, spaceId: spaceId, year: year);
      final incomeSums = await _repository.incomeMatrix(
          userId: userId, spaceId: spaceId, year: year);
      final limits = await _repository.limitsYear(
          userId: userId, spaceId: spaceId, year: year);

      final expenseMap = _toMap(expenseSums);
      final incomeMap = _toMap(incomeSums);

      final totalExpense =
          expenseSums.fold<int>(0, (s, e) => s + e.totalKopecks);
      final totalIncome = incomeSums.fold<int>(0, (s, e) => s + e.totalKopecks);
      final totalLimit = limits.values
          .fold<int>(0, (s, m) => s + m.values.fold<int>(0, (a, b) => a + b));

      List<YearCategoryRow> buildRows(
        List<CategoryInfo> scopeCats,
        Map<String, Map<int, int>> source,
        int totalForPercent, {
        bool withLarge = false,
      }) {
        YearCategoryRow row(String id, String name, String? emoji, String? color) {
          final byMonth = source[id] ?? const <int, int>{};
          final months = List<int?>.generate(12, (i) => byMonth[i + 1]);
          final sum = byMonth.values.fold<int>(0, (a, b) => a + b);
          final withData = months.where((v) => v != null).length;
          return YearCategoryRow(
            categoryId: id,
            name: name,
            colorHex: color,
            emoji: emoji,
            months: months,
            sumKopecks: sum,
            avgKopecks: withData == 0 ? 0 : sum ~/ withData,
            percentBps:
                totalForPercent > 0 ? (sum * 10000 ~/ totalForPercent) : 0,
          );
        }

        final covered = <String>{};
        final rows = <YearCategoryRow>[];
        for (final c in scopeCats) {
          rows.add(row(c.id, c.name, c.emoji, c.colorHex));
          covered.add(c.id);
        }
        if (withLarge) {
          rows.add(row(largeId, 'Крупные покупки', '💎', null));
          covered.add(largeId);
        }
        // Категории из данных, которых нет в списке скоупа.
        for (final id in source.keys) {
          if (covered.contains(id)) continue;
          final c = nameById[id];
          final name = id == noneId
              ? 'Без категории'
              : (c?.name ?? 'Категория (другой скоуп)');
          rows.add(row(id, name, c?.emoji, c?.colorHex));
          covered.add(id);
        }
        return rows;
      }

      final expenseCats = cats.where((c) => c.type == 'expense').toList();
      final incomeCats = cats.where((c) => c.type == 'income').toList();

      final expenseRows =
          buildRows(expenseCats, expenseMap, totalExpense, withLarge: true);
      final incomeRows = buildRows(incomeCats, incomeMap, totalIncome);
      final limitRows =
          buildRows(expenseCats, limits, totalLimit, withLarge: true);

      final cashflow = <YearCashflowMonth>[];
      final monthsWithData = <int>[];
      for (var m = 1; m <= 12; m++) {
        final inc = incomeSums
            .where((e) => e.month == m)
            .fold<int>(0, (s, e) => s + e.totalKopecks);
        final exp = expenseSums
            .where((e) => e.month == m)
            .fold<int>(0, (s, e) => s + e.totalKopecks);
        final hasLimits = limits.values.any((mm) => mm.containsKey(m));
        final hasInc = incomeSums.any((e) => e.month == m);
        final hasExp = expenseSums.any((e) => e.month == m);
        if (!hasInc && !hasExp && !hasLimits) continue;
        monthsWithData.add(m);
        final surplus = inc - exp;
        cashflow.add(YearCashflowMonth(
          month: m,
          incomeKopecks: hasInc ? inc : null,
          expenseKopecks: hasExp ? exp : null,
          surplusKopecks: surplus,
          percentBps: inc > 0 ? (surplus * 10000 ~/ inc) : null,
        ));
      }

      final totalSurplus = totalIncome - totalExpense;
      return YearBudgetData(
        limitRows: limitRows,
        expenseRows: expenseRows,
        incomeRows: incomeRows,
        cashflow: cashflow,
        totalLimitKopecks: totalLimit,
        totalExpenseKopecks: totalExpense,
        totalIncomeKopecks: totalIncome,
        totalSurplusKopecks: totalSurplus,
        surplusPercentBps:
            totalIncome > 0 ? (totalSurplus * 10000 ~/ totalIncome) : null,
        monthsWithData: monthsWithData,
      );
    } catch (e, st) {
      _logger.e('CalculateYearBudget failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Map<String, Map<int, int>> _toMap(List<YearCatMonthSum> sums) {
    final out = <String, Map<int, int>>{};
    for (final e in sums) {
      out.putIfAbsent(e.categoryId, () => {})[e.month] = e.totalKopecks;
    }
    return out;
  }
}

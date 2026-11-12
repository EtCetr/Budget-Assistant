// TODO(25): Semantics для графиков (доступность, долг Этапа 22).
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../domain/models/year_budget_models.dart';

/// Столбцы «Доходы / Расходы» по месяцам (файл владельца, лист Анализ 2).
class CashflowChart extends StatelessWidget {
  const CashflowChart({super.key, required this.months});
  final List<YearCashflowMonth> months;

  @override
  Widget build(BuildContext context) {
    return _MonthBars(
      months: months,
      rods: (m) => [
        BarChartRodData(
          toY: (m.incomeKopecks ?? 0) / 100.0,
          color: AppColors.colorIncome,
          width: 8,
        ),
        BarChartRodData(
          toY: (m.expenseKopecks ?? 0) / 100.0,
          color: AppColors.colorExpense,
          width: 8,
        ),
      ],
    );
  }
}

/// Столбцы «Профицит» (доходы − расходы) по месяцам.
class SurplusBarChart extends StatelessWidget {
  const SurplusBarChart({super.key, required this.months});
  final List<YearCashflowMonth> months;

  @override
  Widget build(BuildContext context) {
    return _MonthBars(
      months: months,
      rods: (m) => [
        BarChartRodData(
          toY: m.surplusKopecks / 100.0,
          color: m.surplusKopecks >= 0
              ? AppColors.colorIncome
              : AppColors.colorExpense,
          width: 12,
        ),
      ],
    );
  }
}

/// Столбцы «Сумма трат» по месяцам.
class ExpenseBarChart extends StatelessWidget {
  const ExpenseBarChart({super.key, required this.months});
  final List<YearCashflowMonth> months;

  @override
  Widget build(BuildContext context) {
    return _MonthBars(
      months: months,
      rods: (m) => [
        BarChartRodData(
          toY: (m.expenseKopecks ?? 0) / 100.0,
          color: AppColors.colorExpense,
          width: 12,
        ),
      ],
    );
  }
}

class _MonthBars extends StatelessWidget {
  const _MonthBars({required this.months, required this.rods});
  final List<YearCashflowMonth> months;
  final List<BarChartRodData> Function(YearCashflowMonth) rods;

  @override
  Widget build(BuildContext context) {
    if (months.isEmpty) return const SizedBox.shrink();
    final maxY = months
        .expand((m) => rods(m).map((r) => r.toY.abs()))
        .fold<double>(0, (a, b) => a > b ? a : b);
    return SizedBox(
      height: 170,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY * 1.2,
          minY: 0,
          barTouchData: const BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (final m in months)
              BarChartGroupData(x: m.month, barRods: rods(m)),
          ],
        ),
      ),
    );
  }
}
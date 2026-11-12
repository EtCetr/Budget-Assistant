import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../domain/models/year_budget_models.dart';

/// График «Доходы / Расходы» по месяцам (fl_chart, Этап 23.5).
class CashflowChart extends StatelessWidget {
  const CashflowChart({super.key, required this.months});
  final List<YearCashflowMonth> months;

  @override
  Widget build(BuildContext context) {
    if (months.isEmpty) return const SizedBox.shrink();
    final maxY = months
        .map((m) => [
              (m.incomeKopecks ?? 0) / 100.0,
              (m.expenseKopecks ?? 0) / 100.0,
            ])
        .expand((e) => e)
        .reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY * 1.2,
          barTouchData: const BarTouchData(enabled: false),
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (final m in months)
              BarChartGroupData(
                x: m.month,
                barRods: [
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
              ),
          ],
        ),
      ),
    );
  }
}
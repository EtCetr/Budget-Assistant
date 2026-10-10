import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';

/// Карточка общей активности (ТЗ 6.3.34.4). Количества не чувствительны
/// к privacy-режимам (матрица 6.3.34.8).
class OverallStatsCard extends StatelessWidget {
  const OverallStatsCard({
    super.key,
    required this.stats,
    required this.periodLabel,
  });
  final OverallActivityStats stats;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    final percent = stats.activePercent;
    final Color color;
    if (percent > 70) {
      color = AppColors.colorIncome;
    } else if (percent >= 30) {
      color = AppColors.colorWarning;
    } else {
      color = AppColors.colorExpense;
    }
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusLg)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Общая активность пространства',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing12),
          Text(
            'Транзакций за $periodLabel: ${stats.totalTransactions}',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Среднее в день: ${stats.averagePerDay.toStringAsFixed(1)}',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Активных участников: ${stats.activeMembers} из ${stats.totalMembers}',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
          const SizedBox(height: AppSpacing.spacing12),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 8,
              color: color,
              backgroundColor: AppColors.surfaceElevated,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$percent% участников активны',
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
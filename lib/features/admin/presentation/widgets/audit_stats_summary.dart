import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/usecases/audit_log_usecases.dart';

/// Сводка количеств действий за период (ТЗ 6.3.35.4). Количества не чувствительны
/// к privacy-режимам (матрица 6.3.35.8).
class AuditStatsSummary extends StatelessWidget {
  const AuditStatsSummary({
    super.key,
    required this.stats,
    required this.periodLabel,
  });
  final AuditStats stats;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
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
          Text(
            '📊 Статистика действий за $periodLabel',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing12),
          Wrap(
            spacing: AppSpacing.spacing16,
            runSpacing: AppSpacing.spacing8,
            children: [
              _item('👥 Приглашений: ${stats.invitations}', AppColors.textPrimary),
              _item('❌ Удалений: ${stats.removals}', AppColors.colorExpense),
              _item('🔄 Смен ролей: ${stats.roleChanges}', AppColors.colorTransfer),
              _item('👑 Передач прав: ${stats.adminTransfers}', AppColors.colorWarning),
              _item('⚠️ Аварийных: ${stats.emergencyPromotions}', AppColors.colorExpense),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(String text, Color color) => Text(
        text,
        style: TextStyle(color: color, fontSize: 14),
      );
}
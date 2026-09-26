import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../debts_strings.dart';
import '../providers/debts_providers.dart';

/// Сводка «Общий долг / Ожидают возврата» (6.3.13.4).
/// Маскирование сумм — только PrivacyFormatter.
class DebtsStatsSummary extends ConsumerWidget {
  const DebtsStatsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(debtsStatsProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing16,
        vertical: AppSpacing.spacing8,
      ),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Value(
              label: DebtsStrings.statsTotalDebt,
              value: formatter.formatAmount(
                statsAsync.payableTotalKopecks,
                'RUB',
                mode,
              ),
              color: AppColors.colorExpense,
              theme: theme,
            ),
          ),
          Expanded(
            child: _Value(
              label: DebtsStrings.statsExpectedReturn,
              value: formatter.formatAmount(
                statsAsync.receivableTotalKopecks,
                'RUB',
                mode,
              ),
              color: AppColors.colorIncome,
              theme: theme,
            ),
          ),
          if (statsAsync.overdueCount > 0)
            Text(
              '${statsAsync.overdueCount} ${DebtsStrings.statsOverdueSuffix}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.colorExpense,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value({
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
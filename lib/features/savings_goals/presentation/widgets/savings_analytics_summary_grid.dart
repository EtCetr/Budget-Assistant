import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/savings_analytics_providers.dart';
import '../providers/savings_goals_screen_providers.dart';
import '../savings_goals_strings.dart';

/// Сетка 2×2 ключевых метрик (ТЗ 6.3.18.4). Маскирование — только PrivacyFormatter.
class SavingsAnalyticsSummaryGrid extends ConsumerWidget {
  const SavingsAnalyticsSummaryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(savingsAnalyticsSummaryProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final baseCurrency =
        ref.watch(savingsBaseCurrencyProvider).value ?? 'RUB';
    return summaryAsync.when(
      loading: () => const SkeletonShimmer(height: 200),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) {
        final percentText =
            formatter.formatPercent(summary.overallProgressPercent, mode);
        final targetDelta = summary.targetDeltaPercent;
        final contribDelta = summary.contributionDeltaPercent;
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: SavingsGoalsStrings.statGoals,
                    value: '${summary.activeGoalsCount} '
                        '${SavingsGoalsStrings.statActiveSuffix}',
                    valueColor: AppColors.textPrimary,
                    sub: summary.goalsCreatedInPeriod > 0
                        ? '+${summary.goalsCreatedInPeriod} '
                            '${SavingsGoalsStrings.statNewInPeriod}'
                        : SavingsGoalsStrings.statNoChanges,
                    subColor: summary.goalsCreatedInPeriod > 0
                        ? AppColors.colorIncome
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: _StatCard(
                    label: SavingsGoalsStrings.statTarget,
                    value: formatter.formatAmount(
                        summary.totalTargetKopecks, baseCurrency, mode),
                    valueColor: AppColors.colorTransfer,
                    sub: targetDelta == null
                        ? ''
                        : '${targetDelta >= 0 ? SavingsGoalsStrings.statIncreasePrefix : SavingsGoalsStrings.statDecreasePrefix}${targetDelta.abs()}% '
                            '${SavingsGoalsStrings.statVsPrevPeriod}',
                    subColor: targetDelta == null
                        ? AppColors.textSecondary
                        : (targetDelta >= 0
                            ? AppColors.colorIncome
                            : AppColors.colorExpense),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: SavingsGoalsStrings.statSaved,
                    value: formatter.formatAmount(
                        summary.totalCurrentKopecks, baseCurrency, mode),
                    valueColor: AppColors.colorIncome,
                    sub: '${contribDelta == null ? '' : '${contribDelta >= 0 ? SavingsGoalsStrings.statIncreasePrefix : SavingsGoalsStrings.statDecreasePrefix}${contribDelta.abs()}% '}'
                        '${formatter.formatAmount(summary.contributedInPeriodKopecks, baseCurrency, mode)} '
                        '${SavingsGoalsStrings.statNewInPeriod}',
                    subColor: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: _StatCard(
                    label: SavingsGoalsStrings.statProgress,
                    value: percentText,
                    valueColor: AppColors.colorIncome,
                    progress: summary.overallProgressPercent,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
    this.sub = '',
    this.subColor = AppColors.textSecondary,
    this.progress,
  });

  final String label;
  final String value;
  final Color valueColor;
  final String sub;
  final Color subColor;
  final int? progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
            style: theme.textTheme.titleLarge
                ?.copyWith(color: valueColor, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.spacing4),
          if (progress != null)
            ClipRRect(
              borderRadius: AppRadius.radiusFull,
              child: Container(
                height: 6,
                color: AppColors.borderDivider,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: (progress! / 100).clamp(0.0, 1.0),
                    child: Container(color: AppColors.colorIncome),
                  ),
                ),
              ),
            )
          else
            Text(
              sub,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(color: subColor),
            ),
        ],
      ),
    );
  }
}
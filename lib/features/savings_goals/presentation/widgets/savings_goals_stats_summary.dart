import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/savings_goals_screen_providers.dart';
import '../savings_goals_strings.dart';

/// Мультивалютная сводка по активным целям (ТЗ 6.3.16.4).
///
/// Маскирование сумм и процентов — только через PrivacyFormatter.
class SavingsGoalsStatsSummary extends ConsumerWidget {
  const SavingsGoalsStatsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(savingsGoalsSummaryProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final baseCurrency =
        ref.watch(savingsBaseCurrencyProvider).value ?? 'RUB';
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
      child: summaryAsync.when(
        loading: () => const SkeletonShimmer(height: 72),
        error: (_, __) => const SizedBox.shrink(),
        data: (summary) {
          if (summary == null) {
            return const SkeletonShimmer(height: 72);
          }
          final percentText =
              formatter.formatPercent(summary.overallProgressPercent, mode);
          final progress = (summary.overallProgressPercent / 100).clamp(0.0, 1.0);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryValue(
                      label: SavingsGoalsStrings.summaryGoals,
                      value: '${summary.count}',
                      valueColor: AppColors.textPrimary,
                      theme: theme,
                    ),
                  ),
                  Expanded(
                    child: _SummaryValue(
                      label: SavingsGoalsStrings.summaryTarget,
                      value: formatter.formatAmount(
                        summary.totalTargetKopecks,
                        baseCurrency,
                        mode,
                      ),
                      valueColor: AppColors.colorTransfer,
                      theme: theme,
                    ),
                  ),
                  Expanded(
                    child: _SummaryValue(
                      label: SavingsGoalsStrings.summarySaved,
                      value: formatter.formatAmount(
                        summary.totalCurrentKopecks,
                        baseCurrency,
                        mode,
                      ),
                      valueColor: AppColors.colorIncome,
                      theme: theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacing12),
              ClipRRect(
                borderRadius: AppRadius.radiusFull,
                child: Container(
                  height: 8,
                  color: AppColors.borderDivider,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(color: AppColors.colorIncome),
                    ),
                  ),
                ),
              ),
              if (percentText.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.spacing4),
                Center(
                  child: Text(
                    percentText,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.colorIncome,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (summary.hasStaleRates) ...[
                const SizedBox(height: AppSpacing.spacing8),
                Text(
                  SavingsGoalsStrings.summaryStaleRate,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.colorWarning,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Статистика архива (ТЗ 6.3.47.4).
class SavingsArchiveStatsSummary extends ConsumerWidget {
  const SavingsArchiveStatsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(savingsArchiveStatsProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final baseCurrency =
        ref.watch(savingsBaseCurrencyProvider).value ?? 'RUB';
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
      child: statsAsync.when(
        loading: () => const SkeletonShimmer(height: 40),
        error: (_, __) => const SizedBox.shrink(),
        data: (stats) {
          if (stats == null) {
            return const SkeletonShimmer(height: 40);
          }
          final percentText =
              formatter.formatPercent(stats.averageProgressPercent, mode);
          final savedText = formatter.formatAmount(
            stats.totalSavedKopecks,
            baseCurrency,
            mode,
          );
          return Row(
            children: [
              Expanded(
                child: Text(
                  '${SavingsGoalsStrings.archiveStatsSaved}: $savedText',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.colorIncome,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (percentText.isNotEmpty)
                Text(
                  '${SavingsGoalsStrings.archiveStatsProgress}: $percentText',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.colorTransfer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.theme,
  });

  final String label;
  final String value;
  final Color valueColor;
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
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
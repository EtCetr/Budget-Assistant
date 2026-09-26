import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../providers/savings_analytics_providers.dart';
import '../providers/savings_goals_screen_providers.dart';
import '../savings_goals_strings.dart';

/// Баннер валют (ТЗ 6.3.18): показывается, если цели в нескольких валютах
/// (информация о конвертации) или если часть курсов устарела (hasStaleRates).
class AnalyticsCurrencyBanner extends ConsumerWidget {
  const AnalyticsCurrencyBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(analyticsAllGoalsProvider);
    final summaryAsync = ref.watch(savingsAnalyticsSummaryProvider);
    final baseAsync = ref.watch(savingsBaseCurrencyProvider);
    return goalsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (goals) {
        final currencies = goals.map((g) => g.currency).toSet();
        final stale = summaryAsync.value?.hasStaleRates ?? false;
        if (currencies.length < 2 && !stale) return const SizedBox.shrink();
        final base = baseAsync.value ?? '';
        final text = stale
            ? SavingsGoalsStrings.bannerStaleRate
            : SavingsGoalsStrings.bannerConverted(base);
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
          padding: const EdgeInsets.all(AppSpacing.spacing12),
          decoration: BoxDecoration(
            color: stale
                ? AppColors.colorExpense.withValues(alpha: 0.12)
                : AppColors.colorTransfer.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                stale ? Icons.warning_amber_rounded : Icons.currency_exchange,
                size: 18,
                color: stale ? AppColors.colorExpense : AppColors.colorTransfer,
              ),
              const SizedBox(width: AppSpacing.spacing8),
              Expanded(
                child: Text(text, style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../labels/product_analytics_strings.dart';
import '../providers/product_analytics_providers.dart';

/// Сводка: уникальных товаров + среднее число позиций в чеке.
class ProductAnalyticsSummaryRow extends ConsumerWidget {
  const ProductAnalyticsSummaryRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(productAnalyticsSummaryProvider).value;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing8,
        AppSpacing.spacing16,
        0,
      ),
      child: Row(
        children: [
          const Text(
            ProductAnalyticsStrings.summaryUnique,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(width: AppSpacing.spacing4),
          Text(
            '${summary?.uniqueProducts ?? 0}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.spacing16),
          const Text(
            ProductAnalyticsStrings.summaryAvgCheck,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(width: AppSpacing.spacing4),
          Text(
            summary == null
                ? '—'
                : ProductAnalyticsStrings.itemsPerCheck(
                    summary.avgItemsPerCheck),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
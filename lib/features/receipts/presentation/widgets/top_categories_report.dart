import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/product_analytics_models.dart';
import '../labels/product_analytics_strings.dart';
import '../providers/product_analytics_providers.dart';
import 'product_analytics_empty_state.dart';

/// Отчёт 2: категории товаров с прогресс-барами доли трат.
class TopCategoriesReport extends ConsumerWidget {
  const TopCategoriesReport({
    super.key,
    this.onScan,
    required this.onPickPeriod,
  });

  final VoidCallback? onScan;
  final VoidCallback onPickPeriod;

  Color _parseColor(String? hex) {
    if (hex == null || hex.length != 7) return AppColors.colorFAB;
    final v = int.tryParse(hex.substring(1), radix: 16);
    return v == null ? AppColors.colorFAB : Color(0xFF000000 | v);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(topCategoriesProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final categories =
        ref.watch(productCategoriesMapProvider).value ?? const {};
    return async.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        itemCount: 4,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
          child: SkeletonShimmer.card(),
        ),
      ),
      error: (_, __) => ProductAnalyticsEmptyState(
        kind: 'error',
        onRetry: () => ref.invalidate(topCategoriesProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          final checks = ref
              .watch(productAnalyticsSummaryProvider)
              .value
              ?.checksCount ?? 0;
          return ProductAnalyticsEmptyState(
            kind: checks == 0 ? 'all' : 'period',
            onScan: onScan,
            onPickPeriod: onPickPeriod,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          itemCount: list.length,
          itemBuilder: (context, i) =>
              _row(list[i], formatter, categories, mode),
        );
      },
    );
  }

  Widget _row(
    TopCategory c,
    PrivacyFormatter formatter,
    Map<String, (String, String?, String?)> categories,
    BalanceVisibilityMode mode,
  ) {
    final meta = categories[c.categoryId];
    final color = _parseColor(meta?.$2);
    const cur = ProductAnalyticsStrings.analyticsCurrency;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        decoration: const BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(meta?.$3 ?? '📦', style: const TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.spacing8),
                Expanded(
                  child: Text(
                    meta?.$1 ?? c.categoryId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  formatter.formatAmount(c.totalSpendKopecks, cur, mode),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing8),
            ClipRRect(
              borderRadius: AppRadius.radiusFull,
              child: LinearProgressIndicator(
                value: (c.percent / 100).clamp(0.0, 1.0),
                minHeight: 6,
                color: color,
                backgroundColor: AppColors.surfaceElevated,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              '${c.percent.toStringAsFixed(0)}% '
              '${ProductAnalyticsStrings.percentOfTotal} · '
              '${c.uniqueProducts} уникальных · '
              '${ProductAnalyticsStrings.itemsPerCheck(c.avgQuantityPerPurchase)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../labels/product_analytics_strings.dart';
import '../providers/product_analytics_providers.dart';
import 'analytics_trend_ui.dart';
import 'sparkline_chart.dart';

/// Детальная аналитика товара (ТЗ 6.3.24.6): история цены, мин/макс/средняя,
/// волатильность, разбивка по магазинам.
class ProductDetailsSheet extends ConsumerWidget {
  const ProductDetailsSheet({
    super.key,
    required this.productHash,
  });

  final String productHash;

  static Future<void> show(
    BuildContext context, {
    required String productHash,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ProductDetailsSheet(
        productHash: productHash,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final details = ref.watch(productDetailsProvider(productHash)).value;
    const cur = ProductAnalyticsStrings.analyticsCurrency;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        if (details == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            Text(
              formatter.formatProductName(details.name, mode),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            if (formatter.shouldShowPriceChart(mode))
              SparklineChart(
                points: details.points,
                color: TrendUi.color(details.trend),
                width: double.infinity,
                height: 160,
              ),
            const SizedBox(height: AppSpacing.spacing16),
            _row(ProductAnalyticsStrings.detailsMin,
                '${formatter.formatAmount(details.minPriceKopecks, cur, mode)} (${details.minDay})'),
            _row(ProductAnalyticsStrings.detailsMax,
                '${formatter.formatAmount(details.maxPriceKopecks, cur, mode)} (${details.maxDay})'),
            _row(ProductAnalyticsStrings.detailsAvg,
                formatter.formatAmount(details.avgPriceKopecks, cur, mode)),
            _row(ProductAnalyticsStrings.detailsTrend,
                TrendUi.label(details.trend)),
            _row('Волатильность:',
                '±${formatter.formatAmount(details.volatilityKopecks.round(), cur, mode)}'),
            const SizedBox(height: AppSpacing.spacing16),
            const Text(
              ProductAnalyticsStrings.detailsStores,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            for (final s in details.stores)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatter.formatMerchant(s.storeName, mode),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ProductAnalyticsStrings.purchases(s.purchases),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing12),
                    Text(formatter.formatAmount(s.avgPriceKopecks, cur, mode)),
                  ],
                ),
              ),
            // TODO(25): кнопка «Показать все покупки» — cross-filter
            // транзакций по product_hash после синхронизации.
            const SizedBox(height: AppSpacing.spacing16),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(ProductAnalyticsStrings.detailsClose),
            ),
          ],
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
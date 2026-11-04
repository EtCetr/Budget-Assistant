import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/product_analytics_models.dart';
import '../labels/product_analytics_strings.dart';
import '../providers/product_analytics_providers.dart';
import 'product_analytics_empty_state.dart';
import 'product_details_sheet.dart';
import 'sparkline_chart.dart';

/// Отчёт 3: динамика цен (ТЗ 6.3.24.5, отчёт 3).
class PriceDynamicsReport extends ConsumerWidget {
  const PriceDynamicsReport({
    super.key,
    required this.onScan,
    required this.onPickPeriod,
  });

  final VoidCallback onScan;
  final VoidCallback onPickPeriod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(priceDynamicsProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
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
        onRetry: () => ref.invalidate(priceDynamicsProvider),
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
              _card(context, list[i], formatter, mode),
        );
      },
    );
  }

  Widget _card(
    BuildContext context,
    PriceChangeEntry e,
    PrivacyFormatter formatter,
    BalanceVisibilityMode mode,
  ) {
    final rising = e.changePercent > 0;
    final color = rising ? AppColors.colorExpense : AppColors.colorIncome;
    const cur = ProductAnalyticsStrings.analyticsCurrency;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () {
          MotionTokens.light();
          ProductDetailsSheet.show(
            context,
            productHash: e.productHash,
            categoryId: e.categoryId,
          );
        },
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
                  Expanded(
                    child: Text(
                      formatter.formatProductName(e.name, mode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    rising ? Icons.trending_up : Icons.trending_down,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.spacing4),
                  Text(
                    formatter.formatPriceTrendPercent(
                      '${e.changePercent >= 0 ? '+' : ''}'
                      '${e.changePercent.toStringAsFixed(1)}%',
                      mode,
                    ),
                    style: TextStyle(color: color, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacing8),
              Row(
                children: [
                  Text(
                    '${e.firstMonthLabel}: '
                    '${formatter.formatAmount(e.firstPriceKopecks, cur, mode)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing12),
                  Text(
                    '${e.lastMonthLabel}: '
                    '${formatter.formatAmount(e.lastPriceKopecks, cur, mode)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  SparklineChart(points: e.points, color: color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
import 'analytics_trend_ui.dart';
import 'product_analytics_empty_state.dart';
import 'product_details_sheet.dart';
import 'sparkline_chart.dart';

/// Отчёт 1: топ товаров с пагинацией по 20 (ТЗ 6.3.24.5).
class TopProductsReport extends ConsumerStatefulWidget {
  const TopProductsReport({
    super.key,
    this.onScan,
    required this.onPickPeriod,
  });

  final VoidCallback? onScan;
  final VoidCallback onPickPeriod;

  @override
  ConsumerState<TopProductsReport> createState() => _TopProductsReportState();
}

class _TopProductsReportState extends ConsumerState<TopProductsReport> {
  int _shown = 20;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(topProductsProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final categories =
        ref.watch(productCategoriesMapProvider).value ?? const {};
    return async.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        itemCount: 6,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
          child: SkeletonShimmer.card(),
        ),
      ),
      error: (_, __) => ProductAnalyticsEmptyState(
        kind: 'error',
        onRetry: () => ref.invalidate(topProductsProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          final checks = ref
              .watch(productAnalyticsSummaryProvider)
              .value
              ?.checksCount ?? 0;
          return ProductAnalyticsEmptyState(
            kind: checks == 0 ? 'all' : 'period',
            onScan: widget.onScan,
            onPickPeriod: widget.onPickPeriod,
          );
        }
        final visible = list.take(_shown).toList();
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          itemCount: visible.length + (list.length > _shown ? 1 : 0),
          itemBuilder: (context, i) {
            if (i >= visible.length) {
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.spacing8),
                child: OutlinedButton(
                  onPressed: () {
                    MotionTokens.light();
                    setState(() => _shown += 20);
                  },
                  child: Text(
                    ProductAnalyticsStrings.showMore(_shown, list.length),
                  ),
                ),
              );
            }
            return _card(visible[i], mode, formatter, categories);
          },
        );
      },
    );
  }

  Widget _card(
    TopProduct p,
    BalanceVisibilityMode mode,
    PrivacyFormatter formatter,
    Map<String, (String, String?, String?)> categories,
  ) {
    final cat = p.categoryId == null ? null : categories[p.categoryId];
    const cur = ProductAnalyticsStrings.analyticsCurrency;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () {
          MotionTokens.light();
          ProductDetailsSheet.show(
            context,
            productHash: p.productHash,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spacing12),
          decoration: const BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(cat?.$3 ?? '🛒',
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: AppSpacing.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatter.formatProductName(p.name, mode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      '${ProductAnalyticsStrings.purchases(p.purchases)} · '
                      '${formatter.formatAmount(p.avgPriceKopecks, cur, mode)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (formatter.shouldShowPriceChart(mode)) ...[
                SparklineChart(
                  points: p.points,
                  color: TrendUi.color(p.trend),
                ),
                const SizedBox(width: AppSpacing.spacing8),
              ],
              Icon(
                TrendUi.icon(p.trend),
                color: TrendUi.color(p.trend),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
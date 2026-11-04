import 'package:flutter/material.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import '../labels/product_analytics_strings.dart';

/// Empty states аналитики (ТЗ 6.3.24.8): нет за период / нет вообще / ошибка.
class ProductAnalyticsEmptyState extends StatelessWidget {
  const ProductAnalyticsEmptyState({
    super.key,
    required this.kind,
    this.onScan,
    this.onPickPeriod,
    this.onRetry,
  });

  /// 'period' | 'all' | 'error'
  final String kind;
  final VoidCallback? onScan;
  final VoidCallback? onPickPeriod;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case 'all':
        return EmptyStateWidget(
          icon: Icons.insights_outlined,
          title: ProductAnalyticsStrings.emptyAllTitle,
          subtitle: ProductAnalyticsStrings.emptyAllSub,
          primaryAction: onScan == null
              ? null
              : EmptyStateAction(
                  label: ProductAnalyticsStrings.emptyAllCta,
                  onPressed: onScan!,
                ),
        );
      case 'error':
        return EmptyStateWidget(
          icon: Icons.error_outline,
          title: ProductAnalyticsStrings.errorTitle,
          subtitle: ProductAnalyticsStrings.errorSub,
          primaryAction: onRetry == null
              ? null
              : EmptyStateAction(
                  label: ProductAnalyticsStrings.errorRetry,
                  onPressed: onRetry!,
                ),
        );
      default:
        return EmptyStateWidget(
          icon: Icons.calendar_month_outlined,
          title: ProductAnalyticsStrings.emptyPeriodTitle,
          subtitle: ProductAnalyticsStrings.emptyPeriodSub,
          primaryAction: onScan == null
              ? null
              : EmptyStateAction(
                  label: ProductAnalyticsStrings.emptyPeriodCtaScan,
                  onPressed: onScan!,
                ),
          secondaryAction: onPickPeriod == null
              ? null
              : EmptyStateAction(
                  label: ProductAnalyticsStrings.emptyPeriodCtaPeriod,
                  onPressed: onPickPeriod!,
                  isPrimary: false,
                ),
        );
    }
  }
}
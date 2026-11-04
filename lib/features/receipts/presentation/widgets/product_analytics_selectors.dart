import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../../domain/entities/product_analytics_models.dart';
import '../labels/product_analytics_strings.dart';
import '../providers/product_analytics_providers.dart';

/// Селектор периода: месяц / квартал / год / всё время (ТЗ 6.3.24.3).
class ProductAnalyticsPeriodSelector extends ConsumerWidget {
  const ProductAnalyticsPeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(productAnalyticsPeriodProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
      child: Row(
        children: [
          _segment(
            ProductAnalyticsStrings.periodMonth,
            'month',
            period,
            () => ref.read(productAnalyticsPeriodProvider.notifier).set('month'),
          ),
          _segment(
            ProductAnalyticsStrings.periodQuarter,
            'quarter',
            period,
            () => ref
                .read(productAnalyticsPeriodProvider.notifier)
                .set('quarter'),
          ),
          _segment(
            ProductAnalyticsStrings.periodYear,
            'year',
            period,
            () => ref.read(productAnalyticsPeriodProvider.notifier).set('year'),
          ),
          _segment(
            ProductAnalyticsStrings.periodAll,
            'all',
            period,
            () => ref.read(productAnalyticsPeriodProvider.notifier).set('all'),
          ),
        ],
      ),
    );
  }

  Widget _segment(
    String label,
    String value,
    String current,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.spacing4),
        child: InkWell(
          borderRadius: AppRadius.radiusFull,
          onTap: () {
            MotionTokens.selection();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
            decoration: BoxDecoration(
              color: current == value
                  ? AppColors.colorFAB
                  : AppColors.surfaceCard,
              borderRadius: AppRadius.radiusFull,
              border: Border.all(color: AppColors.borderDivider),
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: current == value
                      ? Colors.white
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Скоуп Multi-group (ТЗ 6.3.24.4); виден только при наличии пространства.
class ProductAnalyticsScopeSelector extends ConsumerWidget {
  const ProductAnalyticsScopeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(productAnalyticsScopeProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing8,
        AppSpacing.spacing16,
        0,
      ),
      child: Row(
        children: [
          _segment(
            label: ProductAnalyticsStrings.scopePersonal,
            active: scope == ProductAnalyticsScope.personal,
            activeColor: AppColors.colorTransfer,
            onTap: () => ref
                .read(productAnalyticsScopeProvider.notifier)
                .set(ProductAnalyticsScope.personal),
          ),
          const SizedBox(width: AppSpacing.spacing8),
          _segment(
            label: ProductAnalyticsStrings.scopeFamily,
            active: scope == ProductAnalyticsScope.family,
            activeColor: AppColors.colorIncome,
            onTap: () => ref
                .read(productAnalyticsScopeProvider.notifier)
                .set(ProductAnalyticsScope.family),
          ),
        ],
      ),
    );
  }

  Widget _segment({
    required String label,
    required bool active,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: AppRadius.radiusFull,
        onTap: () {
          MotionTokens.selection();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
          decoration: BoxDecoration(
            color: active ? activeColor : AppColors.surfaceCard,
            borderRadius: AppRadius.radiusFull,
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Переключатель трёх отчётов (ТЗ 6.3.24.5).
class ProductAnalyticsTabs extends ConsumerWidget {
  const ProductAnalyticsTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(productAnalyticsTabProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing8,
        AppSpacing.spacing16,
        0,
      ),
      child: Row(
        children: [
          _tab(
            ProductAnalyticsStrings.tabTopProducts,
            'top_products',
            tab,
            () => ref
                .read(productAnalyticsTabProvider.notifier)
                .set('top_products'),
          ),
          _tab(
            ProductAnalyticsStrings.tabCategories,
            'categories',
            tab,
            () => ref.read(productAnalyticsTabProvider.notifier).set('categories'),
          ),
          _tab(
            ProductAnalyticsStrings.tabDynamics,
            'dynamics',
            tab,
            () => ref.read(productAnalyticsTabProvider.notifier).set('dynamics'),
          ),
        ],
      ),
    );
  }

  Widget _tab(
    String label,
    String value,
    String current,
    VoidCallback onTap,
  ) {
    final active = current == value;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.spacing4),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            MotionTokens.selection();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
            decoration: BoxDecoration(
              color: active ? AppColors.surfaceElevated : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                color: active ? AppColors.colorFAB : AppColors.borderDivider,
              ),
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: active
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
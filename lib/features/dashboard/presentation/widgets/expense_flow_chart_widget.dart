import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/offline_error_card.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../../features/budget/presentation/providers/budget_providers.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../dashboard_strings.dart';
import '../providers/dashboard_providers.dart';

class ExpenseFlowChartWidget extends ConsumerWidget {
  const ExpenseFlowChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowAsync = ref.watch(dashboardExpenseFlowProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    final pnlAsync = ref.watch(monthlyPnlForCurrentMonthProvider);

    return flowAsync.when(
      loading: () => const SkeletonShimmer(height: 220),
      error: (error, _) => OfflineErrorCard(
        message: DashboardStrings.loadingError,
        retryLabel: DashboardStrings.retry,
        onRetry: () => ref.invalidate(dashboardExpenseFlowProvider),
      ),
      data: (points) {
        final total = points.fold<int>(
          0,
          (sum, point) => sum + point.totalKopecks,
        );

        if (total == 0) {
          return const EmptyStateWidget(
            animationAsset: 'assets/animations/empty_chart.json',
            title: DashboardStrings.expenseEmptyTitle,
            subtitle: DashboardStrings.expenseEmptySubtitle,
          );
        }

        final spots = <FlSpot>[];
        for (int i = 0; i < points.length; i++) {
          spots.add(
            FlSpot(i.toDouble(), points[i].totalKopecks / 100.0),
          );
        }

        final pnl = pnlAsync.value;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DashboardStrings.expenseFlowTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.spacing16),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.colorExpense,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.colorExpense.withValues(alpha: 0.18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (privacyMode != BalanceVisibilityMode.hidden && pnl != null) ...[
                const SizedBox(height: AppSpacing.spacing16),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: AppColors.colorIncome,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatter.formatAmount(
                        pnl.totalIncome,
                        'RUB',
                        privacyMode,
                      ),
                      style: const TextStyle(color: AppColors.colorIncome),
                    ),
                    const SizedBox(width: AppSpacing.spacing24),
                    const Icon(
                      Icons.arrow_downward,
                      size: 18,
                      color: AppColors.colorExpense,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatter.formatAmount(
                        pnl.totalExpense,
                        'RUB',
                        privacyMode,
                      ),
                      style: const TextStyle(color: AppColors.colorExpense),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
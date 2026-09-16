import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/savings_analytics_providers.dart';
import '../savings_goals_strings.dart';

/// Карточка графика накопления: линия «Накоплено», пунктир «Целевая»,
/// точечная «Прогноз» (ТЗ 6.3.18.5). В hidden график скрыт целиком.
class AccumulationChart extends ConsumerWidget {
  const AccumulationChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartAsync = ref.watch(accumulationChartProvider);
    final range = ref.watch(analyticsPeriodRangeProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SavingsGoalsStrings.chartTitle,
            style:
                theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.spacing12),
          chartAsync.when(
            loading: () => const SkeletonShimmer(height: 220),
            error: (_, __) => OfflineErrorCard(
              message: SavingsGoalsStrings.loadingError,
              retryLabel: SavingsGoalsStrings.retry,
              onRetry: () => ref.invalidate(accumulationChartProvider),
            ),
            data: (data) {
              if (mode == BalanceVisibilityMode.hidden) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.spacing24),
                  child: Center(
                    child: Text(
                      SavingsGoalsStrings.chartHiddenNote,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }
              if (data.points.isEmpty) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/pause_savings.json',
                      height: 140,
                      repeat: false,
                    ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Text(
                      SavingsGoalsStrings.chartEmptyTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      SavingsGoalsStrings.chartEmptySubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: _Chart(
                      data: data,
                      rangeStart: range.start,
                      totalDays: range.totalDays,
                      showYNumbers: mode == BalanceVisibilityMode.visible,
                      formatter: formatter,
                      mode: mode,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacing8),
                  Wrap(
                    spacing: AppSpacing.spacing16,
                    runSpacing: AppSpacing.spacing4,
                    children: [
                      _legend(AppColors.colorIncome,
                          SavingsGoalsStrings.legendAccumulated),
                      _legend(AppColors.colorTransfer,
                          SavingsGoalsStrings.legendTarget),
                      if (data.forecast.isNotEmpty)
                        _legend(AppColors.textSecondary,
                            SavingsGoalsStrings.legendForecast),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 2, color: color),
        const SizedBox(width: AppSpacing.spacing4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({
    required this.data,
    required this.rangeStart,
    required this.totalDays,
    required this.showYNumbers,
    required this.formatter,
    required this.mode,
  });

  final dynamic data;
  final DateTime rangeStart;
  final int totalDays;
  final bool showYNumbers;
  final dynamic formatter;
  final BalanceVisibilityMode mode;

  double _x(DateTime date) =>
      date.difference(rangeStart).inDays.toDouble();

  String? _xLabel(double value) {
    final date = rangeStart.add(Duration(days: value.round()));
    if (totalDays > 1200) {
      return (date.month == 1 && date.day == 1)
          ? DateFormat.y().format(date)
          : null;
    }
    if (totalDays > 100) {
      return date.day == 1 ? DateFormat.MMM('ru').format(date) : null;
    }
    return (date.day == 1 || date.day % 7 == 1)
        ? DateFormat('dd.MM').format(date)
        : null;
  }

  String _compact(double rubles) {
    final rounded = rubles.round();
    if (rounded >= 1000000) return '${(rounded / 1000000).toStringAsFixed(1)}M';
    if (rounded >= 1000) return '${(rounded / 1000).round()}k';
    return '$rounded';
  }

  @override
  Widget build(BuildContext context) {
    final points = data.points as List<dynamic>;
    final forecast = data.forecast as List<dynamic>;
    final targetKopecks = data.targetLineKopecks as int;
    final baseCurrency = data.baseCurrency as String;
    final spots = points
        .map((p) => FlSpot(
              _x(p.date as DateTime),
              (p.cumulativeAmountKopecks as int) / 100.0,
            ))
        .toList();
    final forecastSpots = forecast
        .map((p) => FlSpot(
              _x(p.date as DateTime),
              (p.forecastedAmountKopecks as int) / 100.0,
            ))
        .toList();
    var maxKopecks = targetKopecks;
    for (final p in points) {
      final v = p.cumulativeAmountKopecks as int;
      if (v > maxKopecks) maxKopecks = v;
    }
    for (final p in forecast) {
      final v = p.forecastedAmountKopecks as int;
      if (v > maxKopecks) maxKopecks = v;
    }
    final maxY = maxKopecks <= 0 ? 1.0 : (maxKopecks / 100.0) * 1.15;
    final bars = <LineChartBarData>[
      LineChartBarData(
        spots: spots.cast<FlSpot>(),
        isCurved: true,
        curveSmoothness: 0.2,
        color: AppColors.colorIncome,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: points.length <= 60),
        belowBarData: BarAreaData(
          show: true,
          color: AppColors.colorIncome.withValues(alpha: 0.15),
        ),
      ),
      if (forecastSpots.length > 1)
        LineChartBarData(
          spots: forecastSpots.cast<FlSpot>(),
          isCurved: false,
          color: AppColors.textSecondary,
          barWidth: 1,
          dashArray: const [2, 4],
          dotData: const FlDotData(show: false),
        ),
    ];
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: showYNumbers,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                _compact(value),
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final label = _xLabel(value);
                if (label == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    label,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary),
                  ),
                );
              },
            ),
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: targetKopecks / 100.0,
              color: AppColors.colorTransfer,
              strokeWidth: 1,
              dashArray: const [4, 4],
            ),
          ],
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touched) => touched
                .map((s) {
                  if (s.barIndex != 0 || s.spotIndex >= points.length) {
                    return null;
                  }
                  final point = points[s.spotIndex];
                  return LineTooltipItem(
                    '${DateFormat('dd.MM.yyyy').format((point.date as DateTime).toLocal())}\n'
                    '${formatter.formatAmount(point.cumulativeAmountKopecks as int, baseCurrency, mode)}',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                })
                .toList(),
          ),
        ),
        lineBarsData: bars,
      ),
    );
  }
}
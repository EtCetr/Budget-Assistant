import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/usecases/get_goal_history_usecase.dart';
import '../providers/savings_goals_providers.dart';
import '../savings_goals_strings.dart';

/// BottomSheet «История цели» (ТЗ 6.3.47.6): график накопления + транзакции.
/// Все суммы — через PrivacyFormatter; в hidden график скрыт полностью.
Future<void> showGoalHistorySheet(BuildContext context, SavingsGoal goal) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => GoalHistorySheet(goal: goal),
  );
}

class GoalHistorySheet extends ConsumerWidget {
  const GoalHistorySheet({super.key, required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(goalHistoryProvider(goal.id));
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    final hidden = mode == BalanceVisibilityMode.hidden;
    final percentText = formatter.formatPercent(goal.progressPercent, mode);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FractionallySizedBox(
          heightFactor: 0.85,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.spacing16,
                  AppSpacing.spacing16,
                  AppSpacing.spacing16,
                  AppSpacing.spacing8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SavingsGoalsStrings.historySheetTitle,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      formatter.formatName(goal.name, mode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      '${formatter.formatAmount(goal.currentAmount, goal.currency, mode)} / '
                      '${formatter.formatAmount(goal.targetAmount, goal.currency, mode)}'
                      '${percentText.isEmpty ? '' : ' · $percentText'}',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: historyAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.spacing16),
                      child: Text(
                        SavingsGoalsStrings.loadingError,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  data: (history) => ListView(
                    padding: const EdgeInsets.all(AppSpacing.spacing16),
                    children: [
                      if (hidden)
                        Text(
                          SavingsGoalsStrings.historyChartHidden,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        )
                      else if (history.chartData.isNotEmpty)
                        SizedBox(
                          height: 220,
                          child: _AccumulationChart(
                            goal: goal,
                            history: history,
                            mode: mode,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.spacing16),
                      Text(
                        '${SavingsGoalsStrings.historyTransactionsHeader} (${history.transactions.length})',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.spacing8),
                      if (history.transactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.spacing16,
                          ),
                          child: Text(
                            SavingsGoalsStrings.historyEmpty,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        )
                      else
                        for (final t in history.transactions)
                          _HistoryRow(
                            date: t.date,
                            amountKopecks: t.amount,
                            isWithdrawal: t.isWithdrawal,
                            currency: goal.currency,
                            mode: mode,
                          ),
                      const SizedBox(height: AppSpacing.spacing16),
                      Center(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(SavingsGoalsStrings.historyClose),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Строка транзакции: тип, дата,signed-сумма через PrivacyFormatter.
class _HistoryRow extends ConsumerWidget {
  const _HistoryRow({
    required this.date,
    required this.amountKopecks,
    required this.isWithdrawal,
    required this.currency,
    required this.mode,
  });

  final DateTime date;
  final int amountKopecks;
  final bool isWithdrawal;
  final String currency;
  final BalanceVisibilityMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    final dateText = DateFormat('dd.MM.yyyy').format(date.toLocal());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
      child: Row(
        children: [
          Text(
            isWithdrawal ? '💸' : '💰',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(width: AppSpacing.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWithdrawal
                      ? SavingsGoalsStrings.historyWithdraw
                      : SavingsGoalsStrings.historyContribute,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  dateText,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '${isWithdrawal ? '−' : '+'} '
            '${formatter.formatAmount(amountKopecks, currency, mode)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isWithdrawal
                  ? AppColors.colorExpense
                  : AppColors.colorIncome,
            ),
          ),
        ],
      ),
    );
  }
}

/// Линейный график кумулятивного накопления (fl_chart).
/// double используется ТОЛЬКО для отображения (копейки / 100).
class _AccumulationChart extends ConsumerWidget {
  const _AccumulationChart({
    required this.goal,
    required this.history,
    required this.mode,
  });

  final SavingsGoal goal;
  final GoalHistory history;
  final BalanceVisibilityMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(privacyFormatterProvider);
    final points = history.chartData;
    final spots = <FlSpot>[];
    final labels = <String>[];
    final fullLabels = <String>[];
    for (var i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i].cumulativeAmountKopecks / 100.0));
      final local = points[i].date.toLocal();
      labels.add(DateFormat('dd.MM').format(local));
      fullLabels.add(DateFormat('dd.MM.yyyy').format(local));
    }
    final maxKopecks = math.max(
      points.last.cumulativeAmountKopecks,
      goal.targetAmount,
    );
    final maxY = maxKopecks <= 0 ? 1.0 : (maxKopecks / 100.0) * 1.15;
    final step = math.max(1, (points.length / 4).floor());
    final showAxisNumbers = mode == BalanceVisibilityMode.visible;

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
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: showAxisNumbers,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                _compactRubles(value),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= labels.length || i % step != 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    labels[i],
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: goal.targetAmount / 100.0,
              color: AppColors.colorTransfer,
              strokeWidth: 1,
              dashArray: const [6, 4],
            ),
          ],
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touched) => touched
                .map((s) => LineTooltipItem(
                      '${s.spotIndex < fullLabels.length ? fullLabels[s.spotIndex] : ''}\n'
                      '${formatter.formatAmount((s.y * 100).round(), goal.currency, mode)}',
                      const TextStyle(color: Colors.white, fontSize: 12),
                    ))
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.25,
            color: AppColors.colorIncome,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: points.length <= 40),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.colorIncome.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }

  /// Компактная подпись оси Y («50k», «1.2M») — только презентация.
  String _compactRubles(double rubles) {
    final rounded = rubles.round();
    if (rounded >= 1000000) return '${(rounded / 1000000).toStringAsFixed(1)}M';
    if (rounded >= 1000) return '${(rounded / 1000).round()}k';
    return '$rounded';
  }
}
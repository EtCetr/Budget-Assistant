import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'family_colors.dart';

/// Стек-бар активности по дням (ТЗ 6.3.34.5): каждый цвет = член семьи.
/// В hidden все стеки серые (матрица 6.3.34.8). Тап по столбику = детали дня.
class ActivityChart extends ConsumerWidget {
  const ActivityChart({
    super.key,
    required this.data,
    required this.membersById,
    required this.onDayTap,
  });
  final List<ChartDayData> data;
  final Map<String, MemberInfo> membersById;
  final ValueChanged<ChartDayData> onDayTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    final pf = ref.watch(privacyFormatterProvider);
    var maxTotal = 0;
    for (final d in data) {
      if (d.total > maxTotal) {
        maxTotal = d.total;
      }
    }
    final groups = <BarChartGroupData>[];
    for (var i = 0; i < data.length; i++) {
      final d = data[i];
      final stacks = <BarChartRodStackItem>[];
      var acc = 0;
      final userIds = d.perUser.keys.toList()..sort();
      for (final u in userIds) {
        final c = d.perUser[u] ?? 0;
        if (c <= 0) {
          continue;
        }
        stacks.add(BarChartRodStackItem(
          acc.toDouble(),
          (acc + c).toDouble(),
          hidden ? Colors.grey : familyColorFor(u),
        ));
        acc += c;
      }
      groups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: acc.toDouble(),
            width: 8,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            rodStackItems: stacks,
            color: hidden ? Colors.grey : AppColors.colorTransfer,
          ),
        ],
      ));
    }
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusLg)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📈 Активность по дням (последние 30 дней)',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing12),
          SizedBox(
            height: 200,
            child: BarChart(BarChartData(
              maxY: (maxTotal == 0 ? 5 : maxTotal + 2).toDouble(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= data.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        '${data[idx].dayOfMonth}',
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchCallback: (event, response) {
                  final spot = response?.spot;
                  if (spot == null || event is! FlTapUpEvent) {
                    return;
                  }
                  final idx = spot.touchedBarGroupIndex;
                  if (idx >= 0 && idx < data.length) {
                    onDayTap(data[idx]);
                  }
                },
              ),
              barGroups: groups,
            )),
          ),
          const SizedBox(height: AppSpacing.spacing8),
          Wrap(
            spacing: AppSpacing.spacing12,
            runSpacing: 4,
            children: [
              for (final m in membersById.values)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: hidden ? Colors.grey : familyColorFor(m.userId),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pf.formatName(m.displayName, mode),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
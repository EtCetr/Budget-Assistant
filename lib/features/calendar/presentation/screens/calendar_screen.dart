import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';
import '../calendar_strings.dart';
import '../providers/calendar_screen_providers.dart';
import '../providers/date_forecast_providers.dart';
import '../widgets/calendar_day_panel.dart';
import '../../../recurring_payments/presentation/widgets/recurring_detection_indicator.dart';

/// Экран календаря (ТЗ 6.3.5): сетка с заливкой дней и маркерами,
/// сводка выбранного дня СНИЗУ, bar-chart доходов/расходов за видимый период
/// (месяц / 2 недели / неделя), легенда топ-5, превью событий на 14 дней.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  String _monthTitleRu(DateTime month) {
    final s = DateFormat('LLLL yyyy', 'ru').format(month);
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Color? _parseCategoryColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final value = hex.startsWith('#') ? hex.substring(1) : hex;
    if (value.length != 6 && value.length != 8) return null;
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return null;
    return Color(value.length == 6 ? parsed + 0xFF000000 : parsed);
  }

  /// Видимые дни для графика: зависят от формата и сфокусированного дня,
  /// поэтому график обновляется при листании и смене формата.
  List<DateTime> _visibleDays(DateTime focusedDay, CalendarFormat format) {
    final start = focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    switch (format) {
      case CalendarFormat.week:
        return List.generate(
            7, (i) => DateTime(start.year, start.month, start.day + i));
      case CalendarFormat.twoWeeks:
        return List.generate(
            14, (i) => DateTime(start.year, start.month, start.day + i));
      case CalendarFormat.month:
        final n = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
        return List.generate(
            n, (i) => DateTime(focusedDay.year, focusedDay.month, i + 1));
    }
  }

  Widget _flowChart(Map<String, dynamic> flow, List<DateTime> days) {
    double maxRub = 1;
    final groups = <BarChartGroupData>[];
    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final key =
          '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final row = flow[key];
      final income = (row as dynamic)?.income as int? ?? 0;
      final expense = (row as dynamic)?.expense as int? ?? 0;
      final incomeRub = income / 100.0;
      final expenseRub = expense / 100.0;
      if (incomeRub > maxRub) maxRub = incomeRub;
      if (expenseRub > maxRub) maxRub = expenseRub;
      groups.add(BarChartGroupData(x: i, barsSpace: 1, barRods: [
        BarChartRodData(
            toY: incomeRub,
            color: AppColors.colorIncome,
            width: 3,
            borderRadius: BorderRadius.circular(1)),
        BarChartRodData(
            toY: expenseRub,
            color: AppColors.colorExpense,
            width: 3,
            borderRadius: BorderRadius.circular(1)),
      ]));
    }
    return SizedBox(
      height: 140,
      child: BarChart(BarChartData(
        maxY: maxRub * 1.1,
        barTouchData: const BarTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= days.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  days[idx].day.toString(),
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textSecondary),
                );
              },
            ),
          ),
        ),
        barGroups: groups,
      )),
    );
  }

  Widget _dayCell(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
    Map<String, DayAggregate> aggregates,
    Map<String, dynamic> flow,
    Set<String> forecastDays,
    DateTime selectedDay,
    WidgetRef ref,
  ) {
    final key = calendarDayKey(day);
    final agg = aggregates[key];
    final dayFlow = flow[key];
    final mode = ref.read(privacyModeProvider);
    final formatter = ref.read(privacyFormatterProvider);
    final categories = ref.read(categoriesMapCalendarProvider);
    final showColors = formatter.shouldShowCategoryColors(mode);
    final today = DateTime.now();
    final isToday = day.year == today.year &&
        day.month == today.month &&
        day.day == today.day;
    final isOtherMonth = day.month != focusedDay.month;
    final isFuture = !isToday && day.isAfter(today);
    final expense = (dayFlow as dynamic)?.expense as int? ?? 0;
    final income = (dayFlow as dynamic)?.income as int? ?? 0;
    final freeDay =
        !isFuture && !isOtherMonth && expense == 0 && (income > 0 || agg != null);
    final holiday = agg?.holidays.isNotEmpty ?? false;
    final isSelected = isSameDay(day, selectedDay);
    Color background = Colors.transparent;
    Border? border;
    if (isSelected) {
      border = Border.all(color: AppColors.colorTransfer, width: 1.5);
    }
    if (isToday) {
      background = AppColors.colorIncome.withValues(alpha: 0.2);
    } else if (!isOtherMonth && holiday) {
      background = AppColors.surfaceElevated;
    } else if (!isOtherMonth && !isFuture && expense > 0) {
      background = AppColors.surfaceCard;
    } else if (freeDay) {
      background = AppColors.surfaceCard;
      border = Border.all(color: AppColors.colorIncome.withValues(alpha: 0.4));
    }
    final dominant = agg?.dominantCategoryId;
    final catColor = _parseCategoryColor(
      dominant == null ? null : categories[dominant]?.colorHex,
    );
    final hasForecast = forecastDays.contains(key);
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: background,
        border: border,
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: isOtherMonth
                    ? AppColors.textSecondary.withValues(alpha: 0.5)
                    : isToday
                        ? AppColors.colorIncome
                        : AppColors.textPrimary,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (!isOtherMonth && holiday)
            Positioned(
              top: 2,
              left: 3,
              child: Text(agg!.holidays.first.iconEmoji ?? '🎉',
                  style: const TextStyle(fontSize: 10)),
            ),
          if (!isOtherMonth &&
              !isFuture &&
              expense > 0 &&
              showColors &&
              catColor != null)
            Positioned(
              top: 3,
              right: 3,
              child: Container(
                width: 7,
                height: 7,
                decoration:
                    BoxDecoration(color: catColor, shape: BoxShape.circle),
              ),
            ),
          if (!isOtherMonth &&
              !isFuture &&
              expense > 0 &&
              (!showColors || catColor == null))
            Positioned(
              top: 3,
              right: 3,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                    color: AppColors.textSecondary, shape: BoxShape.circle),
              ),
            ),
          if (freeDay)
            const Positioned(
                bottom: 1, right: 2, child: Text('🎉', style: TextStyle(fontSize: 9))),
          if (!isOtherMonth && (agg?.reminderCount ?? 0) > 0)
            const Positioned(
              bottom: 1,
              left: 3,
              child: Icon(Icons.notifications_active,
                  size: 9, color: AppColors.colorWarning),
            ),
          if (!isOtherMonth && isFuture && hasForecast)
            const Positioned(
              bottom: 2,
              right: 3,
              child: Icon(Icons.circle, size: 6, color: AppColors.colorTransfer),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency = ref.watch(calendarBaseCurrencyProvider).value ?? 'RUB';
    final focusedMonth = ref.watch(focusedMonthProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final calendarFormat = ref.watch(calendarFormatProvider);
    final monthKey = ref.watch(calendarMonthKeyProvider);
    final aggregates = ref.watch(monthAggregatesProvider(monthKey));
    final flow = ref.watch(monthFlowProvider(monthKey)).value ?? const {};
    final legend = ref.watch(monthLegendProvider(monthKey));
    final categories = ref.watch(categoriesMapCalendarProvider);
    final upcomingAsync = ref.watch(upcomingEventsPreviewProvider);
    final events = ref.watch(forecastEventsProvider(monthKey));
    final forecastDays = {
      for (final e in events) calendarDayKey(e.dateUtc.toLocal()),
    };
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/calendar'),
      appBar: AppBar(
        title: Text(_monthTitleRu(focusedMonth)),
        actions: [
          IconButton(
            tooltip: CalendarStrings.openHolidaysTooltip,
            icon: const Icon(Icons.celebration_outlined),
            onPressed: () {
              MotionTokens.light();
              context.push('/calendar/holidays');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing8),
        children: [
          const RecurringDetectionIndicator(),
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2100, 12, 31),
            focusedDay: focusedMonth,
            calendarFormat: calendarFormat,
            headerStyle: HeaderStyle(
              titleTextFormatter: (date, _) => _monthTitleRu(date),
            ),
            locale: 'ru',
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (selected, focused) {
              MotionTokens.selection();
              ref.read(selectedDayProvider.notifier).set(selected);
              ref.read(focusedMonthProvider.notifier).set(focused);
            },
            onFormatChanged: (format) {
              MotionTokens.selection();
              ref.read(calendarFormatProvider.notifier).set(format);
            },
            onPageChanged: (focused) {
              MotionTokens.light();
              ref.read(focusedMonthProvider.notifier).set(focused);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focused) => _dayCell(
                context,
                day,
                focused,
                aggregates,
                flow,
                forecastDays,
                selectedDay,
                ref,
              ),
            ),
          ),
          const CalendarDayPanel(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing8),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: AppColors.colorIncome, shape: BoxShape.circle),
                ),
                const SizedBox(width: AppSpacing.spacing4),
                const Text(CalendarStrings.incomeLegend,
                    style: TextStyle(fontSize: 12)),
                const SizedBox(width: AppSpacing.spacing16),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: AppColors.colorExpense, shape: BoxShape.circle),
                ),
                const SizedBox(width: AppSpacing.spacing4),
                const Text(CalendarStrings.expenseLegend,
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spacing8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing8),
            child: Text(CalendarStrings.chartTitle,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing8),
            child: _flowChart(flow, _visibleDays(focusedMonth, calendarFormat)),
          ),
          if (legend.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.spacing8),
            Text(CalendarStrings.legendTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.spacing8),
            SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: legend.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.spacing8),
                itemBuilder: (context, index) {
                  final entry = legend[index];
                  final cat = categories[entry.key];
                  final color =
                      _parseCategoryColor(cat?.colorHex) ?? AppColors.textSecondary;
                  return ActionChip(
                    backgroundColor: color.withValues(alpha: 0.2),
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cat?.name ?? '—',
                            style: TextStyle(color: color, fontSize: 12)),
                        Text(
                          formatter.formatAmount(entry.value, currency, mode),
                          style: TextStyle(color: color, fontSize: 11),
                        ),
                      ],
                    ),
                    onPressed: () {
                      MotionTokens.light();
                      context.push('/transactions?category_id=${entry.key}');
                    },
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.spacing16),
          Text(CalendarStrings.upcomingTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.spacing8),
          upcomingAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (items) {
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.spacing8),
                  child: Text(CalendarStrings.noEventsUpcoming,
                      style:
                          TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                );
              }
              return Column(
                children: [
                  for (final item in items)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        item.emoji ?? (item.kind == 'recurring' ? '💳' : '🔔'),
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(formatter.formatName(item.title, mode),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(DateFormat('d MMMM', 'ru').format(item.date),
                          style: const TextStyle(fontSize: 12)),
                      trailing: item.amountKopecks == null
                          ? null
                          : Text(
                              formatter.formatAmount(
                                  item.amountKopecks!, currency, mode),
                              style: const TextStyle(
                                  color: AppColors.colorExpense, fontSize: 13)),
                      onTap: item.reminderId == null
                          ? null
                          : () {
                              MotionTokens.light();
                              context.push('/reminders/${item.reminderId}');
                            },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
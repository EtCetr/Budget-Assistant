import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../calendar_strings.dart';
import '../providers/calendar_screen_providers.dart';
import '../widgets/calendar_day_panel.dart';

/// Экран календаря (ТЗ 6.3.5): table_calendar с маркерами
/// (доминирующая категория дня, напоминания, праздники) + панель дня.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  /// Безопасный парсинг цвета категории '#RRGGBB' или '#AARRGGBB'.
  /// Возвращает null, если строка не является корректным цветом.
  Color? _parseCategoryColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final value = hex.startsWith('#') ? hex.substring(1) : hex;
    if (value.length != 6 && value.length != 8) return null;
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return null;
    return Color(value.length == 6 ? parsed + 0xFF000000 : parsed);
  }

  Widget? _buildMarker(
    BuildContext context,
    DateTime day,
    Map<String, DayAggregate> aggregates,
    WidgetRef ref,
  ) {
    final agg = aggregates[calendarDayKey(day)];
    if (agg == null) return null;
    if (agg.expenseTotal == 0 &&
        agg.reminderCount == 0 &&
        agg.holidays.isEmpty) {
      return null;
    }
    final mode = ref.read(privacyModeProvider);
    final formatter = ref.read(privacyFormatterProvider);
    final categories = ref.read(categoriesMapCalendarProvider);
    final showColors = formatter.shouldShowCategoryColors(mode);
    final dominant = agg.dominantCategoryId;
    final cat = dominant == null ? null : categories[dominant];
    final categoryColor = _parseCategoryColor(cat?.colorHex);
    final color = !showColors
        ? AppColors.textSecondary
        : categoryColor ?? AppColors.colorExpense;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (agg.holidays.isNotEmpty)
            Text(agg.holidays.first.iconEmoji ?? '🎉',
                style: const TextStyle(fontSize: 10)),
          if (agg.expenseTotal > 0)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          if (agg.reminderCount > 0)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: const BoxDecoration(
                color: AppColors.colorTransfer,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Реактивность на смену privacy-режима (цвета маркеров).
    ref.watch(privacyModeProvider);
    final focusedMonth = ref.watch(focusedMonthProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final monthKey = ref.watch(calendarMonthKeyProvider);
    final aggregates = ref.watch(monthAggregatesProvider(monthKey));
    return Scaffold(
      appBar: AppBar(
        title: const Text(CalendarStrings.navCalendar),
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
        children: [
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2100, 12, 31),
            focusedDay: focusedMonth,
            locale: 'ru',
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (selected, focused) {
              MotionTokens.selection();
              ref.read(selectedDayProvider.notifier).set(selected);
              ref.read(focusedMonthProvider.notifier).set(focused);
            },
            onPageChanged: (focused) {
              ref.read(focusedMonthProvider.notifier).set(focused);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, _) =>
                  _buildMarker(context, day, aggregates, ref),
            ),
          ),
          const CalendarDayPanel(),
        ],
      ),
    );
  }
}
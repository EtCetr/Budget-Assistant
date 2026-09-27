import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/categories/domain/entities/category.dart';
import 'package:budget_assistant/features/categories/presentation/providers/category_providers.dart';
import '../../../reminders/presentation/providers/reminders_repository_providers.dart';
import '../../data/datasources/calendar_dao.dart';
import '../../domain/entities/holiday.dart';
import 'date_forecast_providers.dart';
import 'holidays_repository_providers.dart';

final calendarDaoProvider = Provider<CalendarDao>((ref) {
  return CalendarDao(ref.watch(appDatabaseProvider));
});

final calendarSettingsDaoProvider = Provider<AppSettingsDao>((ref) {
  return AppSettingsDao(ref.watch(appDatabaseProvider));
});

final calendarBaseCurrencyProvider = FutureProvider<String>((ref) async {
  final dao = ref.watch(calendarSettingsDaoProvider);
  final settings = await dao.getForUser(ref.watch(currentUserIdProvider));
  return settings.baseCurrency;
});

class SelectedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();
  void set(DateTime day) => state = DateTime(day.year, day.month, day.day);
}

final selectedDayProvider = NotifierProvider<SelectedDayNotifier, DateTime>(
  SelectedDayNotifier.new,
);

class FocusedMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();
  void set(DateTime month) => state = DateTime(month.year, month.month, 1);
}

final focusedMonthProvider =
    NotifierProvider<FocusedMonthNotifier, DateTime>(
  FocusedMonthNotifier.new,
);

/// Формат сетки (месяц / 2 недели / неделя) — кнопка table_calendar
/// работает только при явном onFormatChanged (фикс 14.4e-2).
class CalendarFormatNotifier extends Notifier<CalendarFormat> {
  @override
  CalendarFormat build() => CalendarFormat.month;
  void set(CalendarFormat format) => state = format;
}

final calendarFormatProvider =
    NotifierProvider<CalendarFormatNotifier, CalendarFormat>(
  CalendarFormatNotifier.new,
);

final calendarMonthKeyProvider = Provider<String>((ref) {
  final m = ref.watch(focusedMonthProvider);
  return '${m.year.toString().padLeft(4, '0')}-'
      '${m.month.toString().padLeft(2, '0')}';
});

/// 'YYYY-MM-DD' локальной даты (ключ агрегатов).
String calendarDayKey(DateTime day) {
  return '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}

(DateTime, DateTime) calendarMonthUtcRange(String monthKey) {
  final y = int.parse(monthKey.substring(0, 4));
  final m = int.parse(monthKey.substring(5, 7));
  final startLocal = DateTime(y, m, 1);
  final endLocal = DateTime(y, m + 1, 1);
  return (
    startLocal.subtract(const Duration(days: 1)).toUtc(),
    endLocal.add(const Duration(days: 1)).toUtc(),
  );
}

final monthExpenseTotalsProvider =
    StreamProvider.family<List<DayCategoryTotalRow>, String>((ref, key) {
  final range = calendarMonthUtcRange(key);
  return ref.watch(calendarDaoProvider).watchMonthExpenseTotals(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: range.$1,
        endUtc: range.$2,
      );
});

/// P&L-поток по дням месяца (bar-chart + заливка дней).
final monthFlowProvider =
    StreamProvider.family<Map<String, DayFlowRow>, String>((ref, key) {
  final range = calendarMonthUtcRange(key);
  return ref
      .watch(calendarDaoProvider)
      .watchMonthFlowTotals(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: range.$1,
        endUtc: range.$2,
      )
      .map((rows) => {for (final r in rows) r.day: r});
});

final monthReminderCountsProvider =
    StreamProvider.family<Map<String, int>, String>((ref, key) {
  final range = calendarMonthUtcRange(key);
  return ref
      .watch(calendarDaoProvider)
      .watchMonthReminderCounts(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: range.$1,
        endUtc: range.$2,
      )
      .map((rows) => {for (final r in rows) r.day: r.count});
});

final enabledHolidaysProvider = StreamProvider<List<Holiday>>((ref) {
  return ref.watch(holidaysRepositoryProvider).watchAllEnabled(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
      );
});

/// Агрегат дня: категории расходов, напоминания, праздники.
class DayAggregate {
  const DayAggregate({
    this.categoryTotals = const {},
    this.reminderCount = 0,
    this.holidays = const [],
  });

  final Map<String, int> categoryTotals;
  final int reminderCount;
  final List<Holiday> holidays;

  int get expenseTotal => categoryTotals.values.fold(0, (a, b) => a + b);

  String? get dominantCategoryId {
    String? best;
    int bestTotal = 0;
    for (final e in categoryTotals.entries) {
      if (e.value > bestTotal) {
        bestTotal = e.value;
        best = e.key;
      }
    }
    return best;
  }

  List<MapEntry<String, int>> get topCategories {
    final list = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list.take(3).toList();
  }

  DayAggregate copyWith({
    Map<String, int>? categoryTotals,
    int? reminderCount,
    List<Holiday>? holidays,
  }) {
    return DayAggregate(
      categoryTotals: categoryTotals ?? this.categoryTotals,
      reminderCount: reminderCount ?? this.reminderCount,
      holidays: holidays ?? this.holidays,
    );
  }

  DayAggregate addExpense(String? categoryId, int total) {
    if (categoryId == null) return this;
    final next = Map<String, int>.from(categoryTotals);
    next[categoryId] = (next[categoryId] ?? 0) + total;
    return copyWith(categoryTotals: next);
  }
}

final monthAggregatesProvider =
    Provider.family<Map<String, DayAggregate>, String>((ref, monthKey) {
  final totals =
      ref.watch(monthExpenseTotalsProvider(monthKey)).value ?? const [];
  final counts =
      ref.watch(monthReminderCountsProvider(monthKey)).value ?? const {};
  final holidays = ref.watch(enabledHolidaysProvider).value ?? const [];
  final map = <String, DayAggregate>{};
  for (final t in totals) {
    final agg = map.putIfAbsent(t.day, () => const DayAggregate());
    map[t.day] = agg.addExpense(t.categoryId, t.total);
  }
  for (final e in counts.entries) {
    final agg = map.putIfAbsent(e.key, () => const DayAggregate());
    map[e.key] = agg.copyWith(reminderCount: e.value);
  }
  final range = calendarMonthUtcRange(monthKey);
  for (DateTime d = range.$1.toLocal();
      d.isBefore(range.$2.toLocal());
      d = d.add(const Duration(days: 1))) {
    final matching = holidays.where((h) => h.matchesDay(d)).toList();
    if (matching.isEmpty) continue;
    final key = calendarDayKey(d);
    final agg = map.putIfAbsent(key, () => const DayAggregate());
    map[key] = agg.copyWith(holidays: matching);
  }
  return map;
});

/// Легенда: топ-5 категорий месяца с суммами (ТЗ 6.3.5.5).
final monthLegendProvider =
    Provider.family<List<MapEntry<String, int>>, String>((ref, monthKey) {
  final totals =
      ref.watch(monthExpenseTotalsProvider(monthKey)).value ?? const [];
  final byCategory = <String, int>{};
  for (final t in totals) {
    final id = t.categoryId;
    if (id == null) continue;
    byCategory[id] = (byCategory[id] ?? 0) + t.total;
  }
  final list = byCategory.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return list.take(5).toList();
});

/// Элемент превью «Ближайшие 14 дней» (ТЗ 6.3.5.6).
class UpcomingPreviewItem {
  const UpcomingPreviewItem({
    required this.kind,
    required this.date,
    required this.title,
    this.amountKopecks,
    this.emoji,
    this.reminderId,
  });

  /// 'reminder' | 'holiday' | 'recurring'
  final String kind;
  final DateTime date;
  final String title;
  final int? amountKopecks;
  final String? emoji;
  final String? reminderId;
}

final upcomingEventsPreviewProvider =
    StreamProvider<List<UpcomingPreviewItem>>((ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 14));
  return ref
      .watch(calendarDaoProvider)
      .watchMonthReminders(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: start.toUtc(),
        endUtc: end.add(const Duration(days: 1)).toUtc(),
      )
      .map((rows) {
        final holidays = ref.read(enabledHolidaysProvider).value ?? const [];
        final recurring =
            ref.read(activeRecurringCalendarProvider).value ?? const [];
        final items = <UpcomingPreviewItem>[
          for (final r in rows)
            UpcomingPreviewItem(
              kind: 'reminder',
              date: r.remindAt,
              title: r.title,
              amountKopecks: r.expectedAmount,
              reminderId: r.id,
            ),
          for (final h in holidays)
            if (_holidayDayInWindow(h, start, end) != null)
              UpcomingPreviewItem(
                kind: 'holiday',
                date: _holidayDayInWindow(h, start, end)!,
                title: h.name,
                emoji: h.iconEmoji,
              ),
          for (final r in recurring)
            if (_recurringDayInWindow(r.averageDayOfMonth, start, end) !=
                null)
              UpcomingPreviewItem(
                kind: 'recurring',
                date:
                    _recurringDayInWindow(r.averageDayOfMonth, start, end)!,
                title: r.merchantName,
                amountKopecks: r.averageAmount,
              ),
        ];
        items.sort((a, b) => a.date.compareTo(b.date));
        return items.take(10).toList();
      });
});

DateTime? _holidayDayInWindow(Holiday h, DateTime start, DateTime end) {
  for (DateTime d = start;
      d.isBefore(end) || d.isAtSameMomentAs(end);
      d = d.add(const Duration(days: 1))) {
    if (h.matchesDay(d)) return d;
  }
  return null;
}

DateTime? _recurringDayInWindow(int dayOfMonth, DateTime start, DateTime end) {
  for (DateTime d = start;
      d.isBefore(end) || d.isAtSameMomentAs(end);
      d = d.add(const Duration(days: 1))) {
    if (d.day == dayOfMonth.clamp(1, 28)) return d;
  }
  return null;
}

final categoriesMapCalendarProvider = Provider<Map<String, Category>>((ref) {
  final list =
      ref.watch(categoriesListProvider(ref.watch(currentUserIdProvider)))
          .value ??
      const [];
  return {for (final c in list) c.id: c};
});

/// Напоминания выбранного дня (панель сводки, ТЗ 6.3.5/6.3.6).
final dayRemindersListProvider =
    StreamProvider.family<List<ReminderEntityLite>, String>((ref, dateIso) {
  final day = DateTime.tryParse(dateIso);
  if (day == null) return Stream.value(const <ReminderEntityLite>[]);
  final start = DateTime.utc(day.year, day.month, day.day);
  final end = start.add(const Duration(days: 1));
  return ref
      .watch(calendarDaoProvider)
      .watchMonthReminders(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: start,
        endUtc: end,
      )
      .map((rows) => [
            for (final r in rows)
              ReminderEntityLite(
                id: r.id,
                title: r.title,
                remindAt: r.remindAt,
                expectedAmount: r.expectedAmount,
                priority: r.priority,
              ),
          ]);
});

/// Лёгкое DTO напоминания для UI (без Drift-типов в виджетах).
class ReminderEntityLite {
  const ReminderEntityLite({
    required this.id,
    required this.title,
    required this.remindAt,
    this.expectedAmount,
    required this.priority,
  });
  final String id;
  final String title;
  final DateTime remindAt;
  final int? expectedAmount;
  final String priority;
}

/// Завершение напоминания чекбоксом из панели/статистики дня.
final completeDayReminderProvider =
    Provider<Future<void> Function(String)>((ref) {
  return (id) => ref
      .watch(remindersRepositoryProvider)
      .markCompleted(id, DateTime.now().toUtc());
});
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/categories/domain/entities/category.dart';
import 'package:budget_assistant/features/categories/presentation/providers/category_providers.dart';
import '../../../reminders/domain/entities/reminder.dart';
import '../../../reminders/presentation/providers/reminders_repository_providers.dart';
import '../../data/datasources/calendar_dao.dart';
import '../../domain/entities/holiday.dart';
import 'holidays_repository_providers.dart';

DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

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
  DateTime build() => _startOfDay(DateTime.now());
  void set(DateTime day) => state = _startOfDay(day);
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

/// Агрегат дня: суммы по категориям, напоминания, праздники.
class DayAggregate {
  const DayAggregate({
    this.categoryTotals = const {},
    this.reminderCount = 0,
    this.holidays = const [],
  });

  final Map<String, int> categoryTotals;
  final int reminderCount;
  final List<Holiday> holidays;

  int get expenseTotal =>
      categoryTotals.values.fold(0, (a, b) => a + b);

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

final selectedDayRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  final day = ref.watch(selectedDayProvider);
  final start = DateTime.utc(day.year, day.month, day.day);
  final end = start.add(const Duration(days: 1));
  return ref.watch(remindersRepositoryProvider).watchByDay(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: start,
        endUtc: end,
      );
});

final categoriesMapCalendarProvider = Provider<Map<String, Category>>((ref) {
  final list =
      ref.watch(categoriesListProvider(ref.watch(currentUserIdProvider)))
          .value ??
      const [];
  return {for (final c in list) c.id: c};
});
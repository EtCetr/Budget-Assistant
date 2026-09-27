import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../../recurring_payments/domain/entities/recurring_transaction.dart';
import '../../../recurring_payments/presentation/providers/recurring_repository_providers.dart';
import '../../domain/entities/forecast_cache_entry.dart';
import '../../domain/usecases/recalculate_forecast_cache_usecase.dart';
import 'calendar_screen_providers.dart';
import 'forecast_cache_repository_providers.dart';

final Logger _forecastLogger = Logger();

final recalculateForecastUseCaseProvider =
    Provider<RecalculateForecastCacheUseCase>((ref) {
  return RecalculateForecastCacheUseCase(
    repository: ref.watch(forecastCacheRepositoryProvider),
    logger: _forecastLogger,
  );
});

/// Активные регулярные платежи (события прогноза каждого месяца).
final activeRecurringCalendarProvider =
    StreamProvider<List<RecurringTransaction>>((ref) {
  return ref.watch(recurringTransactionsRepositoryProvider).watchByStatus(
        userId: ref.watch(currentUserIdProvider),
        status: RecurringStatus.active,
      );
});

/// Напоминания месяца -> события прогноза (ТЗ 6.3.7).
final monthRemindersEventsProvider =
    StreamProvider.family<List<ForecastEventDto>, String>((ref, monthKey) {
  final range = calendarMonthUtcRange(monthKey);
  return ref
      .watch(calendarDaoProvider)
      .watchMonthReminders(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: range.$1,
        endUtc: range.$2,
      )
      .map((rows) => [
            for (final r in rows)
              if (r.expectedAmount != null)
                ForecastEventDto(
                  dateUtc: r.remindAt,
                  amountKopecks: r.expectedAmount!.abs(),
                  categoryId: r.linkedCategoryId,
                  isExpense: true,
                ),
          ]);
});

/// Все события прогноза месяца: напоминания + регулярки.
final forecastEventsProvider =
    Provider.family<List<ForecastEventDto>, String>((ref, monthKey) {
  final y = int.parse(monthKey.substring(0, 4));
  final m = int.parse(monthKey.substring(5, 7));
  final reminders =
      ref.watch(monthRemindersEventsProvider(monthKey)).value ?? const [];
  final recurring =
      ref.watch(activeRecurringCalendarProvider).value ?? const [];
  final events = <ForecastEventDto>[...reminders];
  for (final r in recurring) {
    final day = r.averageDayOfMonth.clamp(1, 28);
    events.add(
      ForecastEventDto(
        dateUtc: DateTime(y, m, day, 12, 0).toUtc(),
        amountKopecks: r.averageAmount.abs(),
        categoryId: r.categoryId,
        isExpense: true,
      ),
    );
  }
  events.sort((a, b) => a.dateUtc.compareTo(b.dateUtc));
  return events;
});

/// Кэш прогноза месяца (ТОМ 2 §20.1).
final forecastCacheProvider =
    FutureProvider.family<List<ForecastCacheEntry>, String>((ref, monthKey) {
  return ref.watch(forecastCacheRepositoryProvider).getForMonth(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        monthYear: monthKey,
      );
});

final forecastLastUpdatedProvider =
    FutureProvider.family<DateTime?, String>((ref, monthKey) {
  return ref.watch(forecastCacheRepositoryProvider).getLastUpdated(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        monthYear: monthKey,
      );
});

/// Прогноз баланса на дату: текущий баланс всех счетов +
/// накопленные события месяца до даты включительно (ТЗ 6.3.7).
final predictedBalanceProvider =
    FutureProvider.family<int, String>((ref, dateIso) async {
  final date = DateTime.tryParse(dateIso);
  if (date == null) return 0;
  final userId = ref.watch(currentUserIdProvider);
  final accounts = await ref.watch(accountsListProvider(userId).future);
  int balance = 0;
  for (final a in accounts) {
    balance += a.currentBalance;
  }
  final monthKey =
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';
  final events = ref.watch(forecastEventsProvider(monthKey));
  final endUtc = DateTime(date.year, date.month, date.day, 23, 59, 59).toUtc();
  for (final e in events) {
    if (!e.dateUtc.isAfter(endUtc)) {
      balance += e.isExpense ? -e.amountKopecks : e.amountKopecks;
    }
  }
  return balance;
});
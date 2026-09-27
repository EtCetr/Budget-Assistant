import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/usecases/get_free_day_streak_usecase.dart';
import 'calendar_screen_providers.dart';

final Logger _dayStatsLogger = Logger();

final getFreeDayStreakUseCaseProvider =
    Provider<GetFreeDayStreakUseCase>((ref) {
  return GetFreeDayStreakUseCase(
    dao: ref.watch(calendarDaoProvider),
    logger: _dayStatsLogger,
  );
});

final freeDayStreakProvider = FutureProvider<int>((ref) {
  return ref.watch(getFreeDayStreakUseCaseProvider)(
    userId: ref.watch(currentUserIdProvider),
    spaceId: ref.watch(currentSpaceIdProvider),
    fromDay: DateTime.now(),
  );
});

/// Транзакции выбранного дня (ключ — ISO-дата локального дня).
final dayTransactionsProvider =
    StreamProvider.family<List<TransactionDb>, String>((ref, dateIso) {
  final day = DateTime.tryParse(dateIso);
  if (day == null) return Stream.value(const <TransactionDb>[]);
  final start = DateTime(day.year, day.month, day.day);
  final end = start.add(const Duration(days: 1));
  return ref.watch(calendarDaoProvider).watchDayTransactions(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: start.toUtc(),
        endUtc: end.toUtc(),
      );
});

/// Итоги дня: доход/расход в копейках (ABS по типу).
final dayTotalsProvider =
    Provider.family<({int income, int expense}), String>((ref, dateIso) {
  final rows = ref.watch(dayTransactionsProvider(dateIso)).value ?? const [];
  int income = 0;
  int expense = 0;
  for (final t in rows) {
    if (t.type == TransactionType.income) {
      income += t.amount.abs();
    } else if (t.type == TransactionType.expense) {
      expense += t.amount.abs();
    }
  }
  return (income: income, expense: expense);
});
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

/// Транзакции выбранного дня (включая секретные — рендер-заглушка).
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

/// P&L-сводка дня (ТОМ 4 §1: без переводов, копилок, изъятий, ignored).
final daySummaryProvider =
    FutureProvider.family<({int income, int expense}), String>((
  ref,
  dateIso,
) async {
  final day = DateTime.tryParse(dateIso);
  if (day == null) return (income: 0, expense: 0);
  final start = DateTime(day.year, day.month, day.day);
  final end = start.add(const Duration(days: 1));
  final row = await ref.watch(calendarDaoProvider).getDayFlow(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: start.toUtc(),
        endUtc: end.toUtc(),
      );
  return (income: row?.income ?? 0, expense: row?.expense ?? 0);
});

/// Разбивка расходов дня по категориям (stacked-bar, ТЗ 6.3.6.6).
final dayCategoryBreakdownProvider =
    StreamProvider.family<List<({String? categoryId, int total})>, String>((
  ref,
  dateIso,
) {
  final day = DateTime.tryParse(dateIso);
  if (day == null) return Stream.value(const []);
  final start = DateTime(day.year, day.month, day.day);
  final end = start.add(const Duration(days: 1));
  return ref
      .watch(calendarDaoProvider)
      .watchDayCategoryTotals(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        startUtc: start.toUtc(),
        endUtc: end.toUtc(),
      )
      .map((rows) => [
            for (final r in rows) (categoryId: r.categoryId, total: r.total),
          ]);
});

/// Фильтр P&L для списка операций дня (summary считает SQL, список —
/// Dart-фильтр тех же правил, чтобы не дублировать запрос).
List<TransactionDb> applyPnlFilter(List<TransactionDb> rows) {
  return rows
      .where((t) =>
          t.type != TransactionType.transfer &&
          t.savingsGoalId == null &&
          !t.isWithdrawal &&
          t.auditStatus != AuditStatus.ignored)
      .toList();
}
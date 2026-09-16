import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/create_transaction_providers.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/usecases/build_accumulation_chart_usecase.dart';
import '../../domain/usecases/calculate_savings_analytics_usecase.dart';
import 'savings_goals_providers.dart';
import 'savings_goals_screen_providers.dart';

/// Период аналитики (ТЗ 6.3.18.3), дефолт — Год.
enum AnalyticsPeriod { month, quarter, year, allTime }

class AnalyticsPeriodNotifier extends Notifier<AnalyticsPeriod> {
  @override
  AnalyticsPeriod build() => AnalyticsPeriod.year;

  void set(AnalyticsPeriod period) => state = period;
}

final analyticsPeriodProvider =
    NotifierProvider<AnalyticsPeriodNotifier, AnalyticsPeriod>(
  AnalyticsPeriodNotifier.new,
);

class AnalyticsPeriodRange {
  const AnalyticsPeriodRange({
    required this.start,
    required this.end,
    required this.prevStart,
    required this.prevEnd,
  });

  final DateTime start;
  final DateTime end;
  final DateTime prevStart;
  final DateTime prevEnd;

  int get totalDays => end.difference(start).inDays + 1;
}

final analyticsPeriodRangeProvider = Provider<AnalyticsPeriodRange>((ref) {
  final period = ref.watch(analyticsPeriodProvider);
  final now = DateTime.now();
  final DateTime start;
  switch (period) {
    case AnalyticsPeriod.month:
      start = DateTime(now.year, now.month, 1);
    case AnalyticsPeriod.quarter:
      start = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1);
    case AnalyticsPeriod.year:
      start = DateTime(now.year, 1, 1);
    case AnalyticsPeriod.allTime:
      start = DateTime(2000, 1, 1);
  }
  final DateTime prevStart;
  final DateTime prevEnd;
  if (period == AnalyticsPeriod.allTime) {
    prevStart = start;
    prevEnd = start.subtract(const Duration(days: 1));
  } else {
    final days = now.difference(start).inDays + 1;
    prevEnd = start.subtract(const Duration(days: 1));
    prevStart = prevEnd.subtract(Duration(days: days - 1));
  }
  return AnalyticsPeriodRange(
    start: start,
    end: now,
    prevStart: prevStart,
    prevEnd: prevEnd,
  );
});

/// Все цели (активные + архив) для аналитики.
final analyticsAllGoalsProvider = FutureProvider<List<SavingsGoal>>((ref) async {
  final active = await ref.watch(allActiveSavingsGoalsProvider.future);
  final archived = await ref.watch(allArchivedSavingsGoalsProvider.future);
  return [...active, ...archived];
});

/// Счета пользователя: валюта суммы транзакции резолвится через счёт.
final analyticsAccountsProvider = FutureProvider<List<Account>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  return ref.watch(accountsListProvider(userId).future);
});

/// Все транзакции целей (пополнения + изъятия) за всё время.
final analyticsSavingsTxnsProvider =
    FutureProvider<List<Transaction>>((ref) async {
  final goals = await ref.watch(analyticsAllGoalsProvider.future);
  final repository = ref.watch(transactionsRepositoryProvider);
  final out = <Transaction>[];
  for (final goal in goals) {
    out.addAll(await repository.getTransactionsByGoalId(goal.id));
  }
  return out;
});

final savingsAnalyticsSummaryProvider =
    FutureProvider<AnalyticsSummary>((ref) async {
  final goals = await ref.watch(analyticsAllGoalsProvider.future);
  final txns = await ref.watch(analyticsSavingsTxnsProvider.future);
  final accounts = await ref.watch(analyticsAccountsProvider.future);
  final baseCurrency = await ref.watch(savingsBaseCurrencyProvider.future);
  final range = ref.watch(analyticsPeriodRangeProvider);
  return ref.watch(calculateSavingsAnalyticsUseCaseProvider)(
    goals: goals,
    savingsTransactions: txns,
    accounts: accounts,
    baseCurrency: baseCurrency,
    periodStart: range.start,
    periodEnd: range.end,
    prevPeriodStart: range.prevStart,
    prevPeriodEnd: range.prevEnd,
  );
});

final accumulationChartProvider =
    FutureProvider<AccumulationChartData>((ref) async {
  final goals = await ref.watch(analyticsAllGoalsProvider.future);
  final txns = await ref.watch(analyticsSavingsTxnsProvider.future);
  final accounts = await ref.watch(analyticsAccountsProvider.future);
  final baseCurrency = await ref.watch(savingsBaseCurrencyProvider.future);
  final range = ref.watch(analyticsPeriodRangeProvider);
  return ref.watch(buildAccumulationChartUseCaseProvider)(
    goals: goals,
    savingsTransactions: txns,
    accounts: accounts,
    baseCurrency: baseCurrency,
    periodStart: range.start,
    periodEnd: range.end,
    now: DateTime.now(),
  );
});
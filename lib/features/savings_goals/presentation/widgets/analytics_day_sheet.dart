import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/savings_analytics_providers.dart';
import '../savings_goals_strings.dart';

/// Day-details (ТЗ 6.3.18.5): список пополнений за выбранный день графика.
/// Валюта суммы резолвится через счёт транзакции (accountId -> currency),
/// фолбэк — валюта цели: у Transaction нет собственного поля currency.
Future<void> showAnalyticsDaySheet(BuildContext context, DateTime day) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (_) => AnalyticsDaySheet(day: day),
  );
}

class AnalyticsDaySheet extends ConsumerWidget {
  const AnalyticsDaySheet({required this.day, super.key});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(analyticsSavingsTxnsProvider);
    final goalsAsync = ref.watch(analyticsAllGoalsProvider);
    final accountsAsync = ref.watch(analyticsAccountsProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);
    return SafeArea(
      child: txAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const Padding(
          padding: EdgeInsets.all(24),
          child: Text(SavingsGoalsStrings.loadingError),
        ),
        data: (txns) {
          final goals = goalsAsync.value ?? const <SavingsGoal>[];
          final accounts = accountsAsync.value ?? const <Account>[];
          final goalById = {for (final g in goals) g.id: g};
          final curByAccount = {for (final a in accounts) a.id: a.currency};
          final dayTxns = txns
              .where((t) =>
                  !t.isWithdrawal &&
                  t.date.toLocal().year == day.year &&
                  t.date.toLocal().month == day.month &&
                  t.date.toLocal().day == day.day)
              .toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  DateFormat('dd MMMM yyyy', 'ru').format(day),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (dayTxns.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(SavingsGoalsStrings.daySheetEmpty),
                )
              else
                ...dayTxns.map(
                  (t) => ListTile(
                    dense: true,
                    title: Text(
                      goalById[t.savingsGoalId]?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      '+${formatter.formatAmount(
                        t.amount,
                        curByAccount[t.accountId] ??
                            goalById[t.savingsGoalId]?.currency ??
                            '',
                        mode,
                      )}',
                      style: const TextStyle(color: AppColors.colorIncome),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}
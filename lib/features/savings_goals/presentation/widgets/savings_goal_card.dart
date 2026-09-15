import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/pending_sync_indicator.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../savings_goals_strings.dart';
import 'contribute_to_goal_sheet.dart';
import 'savings_goal_long_press_menu.dart';
import 'withdraw_from_goal_sheet.dart';

/// Карточка активной цели накопления (ТЗ 6.3.16.6).
class SavingsGoalCard extends ConsumerWidget {
  const SavingsGoalCard({super.key, required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);

    final userId = ref.watch(currentUserIdProvider);
    final accounts = ref.watch(accountsListProvider(userId)).value;
    final account = findAccountById(accounts, goal.linkedAccountId);

    final name = formatter.formatName(goal.name, mode);
    final currentText =
        formatter.formatAmount(goal.currentAmount, goal.currency, mode);
    final targetText =
        formatter.formatAmount(goal.targetAmount, goal.currency, mode);
    final percentText = formatter.formatPercent(goal.progressPercent, mode);

    final daysLeft = goal.deadline == null ? null : daysUntil(goal.deadline!);
    final overdue =
        goal.deadline != null && daysLeft! < 0 && !goal.isReached;

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        showSavingsGoalLongPressMenu(context, goal);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  goal.isVirtual ? '💭' : '🏦',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: AppSpacing.spacing8),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (goal.syncStatus == SyncStatus.pending)
                  const PendingSyncIndicator(),
              ],
            ),
            if (account != null) ...[
              const SizedBox(height: AppSpacing.spacing4),
              Text(
                formatter.formatName(accountLabel(account), mode),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              '$currentText / $targetText${percentText.isEmpty ? '' : ' · $percentText'}',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (goal.deadline != null) ...[
              const SizedBox(height: AppSpacing.spacing4),
              Text(
                deadlineText(goal.deadline!, daysLeft!, overdue),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: overdue
                      ? AppColors.colorExpense
                      : (daysLeft <= 7
                          ? AppColors.colorWarning
                          : AppColors.textSecondary),
                  fontWeight:
                      overdue ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.spacing12),
            ClipRRect(
              borderRadius: AppRadius.radiusFull,
              child: Container(
                height: 8,
                color: AppColors.borderDivider,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor:
                        (goal.progressPercent / 100).clamp(0.0, 1.0),
                    child: Container(
                      color: overdue
                          ? AppColors.colorExpense
                          : AppColors.colorIncome,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => ContributeToGoalSheet(goal: goal),
                      );
                    },
                    child:
                        const Text(SavingsGoalsStrings.actionContribute),
                  ),
                ),
                if (goal.currentAmount > 0) ...[
                  const SizedBox(width: AppSpacing.spacing8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) =>
                              WithdrawFromGoalSheet(goal: goal),
                        );
                      },
                      child: const Text(SavingsGoalsStrings.actionWithdraw),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Поиск счёта по id в списке (без логики в SQL — список уже в провайдере).
Account? findAccountById(List<Account>? accounts, String? accountId) {
  if (accounts == null || accountId == null) return null;
  for (final account in accounts) {
    if (account.id == accountId) return account;
  }
  return null;
}

/// Подпись счёта: «Т-Банк Black *1234».
String accountLabel(Account account) {
  final buffer = StringBuffer(account.bankName);
  if (account.customName.isNotEmpty) {
    buffer.write(' ${account.customName}');
  }
  final mask = account.cardNumberMask;
  if (mask != null && mask.isNotEmpty) {
    buffer.write(' $mask');
  }
  return buffer.toString();
}

/// Дней до дедлайна (отрицательное значение — просрочено).
int daysUntil(DateTime deadlineUtc) {
  final local = deadlineUtc.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final deadlineDay = DateTime(local.year, local.month, local.day);
  return deadlineDay.difference(today).inDays;
}

/// Текст строки дедлайна.
String deadlineText(DateTime deadlineUtc, int daysLeft, bool overdue) {
  if (overdue) {
    final absDays = daysLeft.abs();
    return '${SavingsGoalsStrings.overduePrefix} $absDays '
        '${SavingsGoalsStrings.daysLabel(absDays)}';
  }
  final dateText =
      DateFormat.MMMMd('ru').format(deadlineUtc.toLocal());
  return '${SavingsGoalsStrings.deadlinePrefix} $dateText '
      '($daysLeft ${SavingsGoalsStrings.daysLabel(daysLeft)})';
}
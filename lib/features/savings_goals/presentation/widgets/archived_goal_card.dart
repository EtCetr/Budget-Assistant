import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/pending_sync_indicator.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../savings_goals_strings.dart';
import 'goal_history_sheet.dart';
import 'restore_goal_dialog.dart';
import 'savings_goal_card.dart';

/// Карточка архивной цели (ТЗ 6.3.47.5).
/// Микро-коммит 12.6: добавлена кнопка «📜 История» (BottomSheet истории).
class ArchivedGoalCard extends ConsumerWidget {
  const ArchivedGoalCard({super.key, required this.goal});

  final SavingsGoal goal;

  bool get _isCompleted => goal.status == SavingsGoalStatus.completed;

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
    final date = (goal.completedAt ?? goal.updatedAt).toLocal();
    final dateText = DateFormat('d MMMM yyyy', 'ru').format(date);
    final statusPrefix = _isCompleted
        ? SavingsGoalsStrings.completedPrefix
        : SavingsGoalsStrings.cancelledPrefix;
    return Opacity(
      opacity: _isCompleted ? 1.0 : 0.7,
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
                  _isCompleted ? '🎉' : '❌',
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
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              '$statusPrefix $dateText',
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showGoalHistorySheet(context, goal);
                    },
                    icon: const Icon(Icons.history, size: 18),
                    label: const Text(SavingsGoalsStrings.actionHistory),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showDialog(
                        context: context,
                        builder: (_) => RestoreGoalDialog(goal: goal),
                      );
                    },
                    icon: const Icon(Icons.restore, size: 18),
                    label: const Text(SavingsGoalsStrings.actionRestore),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
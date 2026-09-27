import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/pending_sync_indicator.dart';
import 'package:budget_assistant/core/widgets/priority_indicator.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminders_screen_providers.dart';
import '../reminders_strings.dart';
import 'assignee_badge.dart';
import 'reminder_area_badge.dart';

/// Карточка напоминания (ТЗ 6.3.10.5): приоритет, название, сумма,
/// дата, assignee, recurring-иконка, бейджи просрочки/области/snooze.
class ReminderCard extends ConsumerWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
    this.onLongPress,
  });

  final Reminder reminder;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency = ref.watch(remindersBaseCurrencyProvider).value ?? 'RUB';
    final now = ref.watch(remindersNowUtcProvider);
    final overdue = reminder.isOverdueAt(now);
    final completed = reminder.isCompleted;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(AppRadius.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PriorityIndicator(priority: reminder.priority),
            const SizedBox(width: AppSpacing.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reminder.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                      ),
                      if (reminder.linkedRecurringId != null)
                        const Icon(Icons.repeat,
                            size: 16, color: AppColors.colorTransfer),
                      if (reminder.syncStatus == SyncStatus.pending)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: PendingSyncIndicator(),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacing4),
                  Text(
                    DateFormat('d MMMM yyyy, HH:mm', 'ru')
                        .format(reminder.remindAt.toLocal()),
                    style: TextStyle(
                      color: overdue && !completed
                          ? AppColors.colorExpense
                          : AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacing8),
                  Wrap(
                    spacing: AppSpacing.spacing8,
                    runSpacing: AppSpacing.spacing4,
                    children: [
                      if (reminder.expectedAmount != null)
                        Text(
                          formatter.formatAmount(
                              reminder.expectedAmount!, currency, mode),
                          style: const TextStyle(
                              color: AppColors.colorExpense, fontSize: 14),
                        ),
                      if (overdue && !completed)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                AppColors.colorExpense.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            RemindersStrings.badgeOverdue,
                            style: TextStyle(
                                color: AppColors.colorExpense, fontSize: 12),
                          ),
                        ),
                      if (reminder.snoozeCount > 0)
                        Text(
                          '⏰ x${reminder.snoozeCount}',
                          style: const TextStyle(
                              color: AppColors.colorWarning, fontSize: 12),
                        ),
                      AssigneeBadge(assigneeId: reminder.assigneeId),
                      ReminderAreaBadge(isFamily: reminder.isFamily),
                    ],
                  ),
                ],
              ),
            ),
            if (completed)
              const Icon(Icons.check_circle, color: AppColors.colorIncome),
          ],
        ),
      ),
    );
  }
}
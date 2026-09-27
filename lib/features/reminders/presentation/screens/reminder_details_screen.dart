import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/priority_indicator.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminder_details_providers.dart';
import '../providers/reminders_providers.dart';
import '../providers/reminders_screen_providers.dart';
import '../reminders_strings.dart';
import '../widgets/assignee_badge.dart';
import '../widgets/reminder_area_badge.dart';
import '../widgets/snooze_bottom_sheet.dart';

/// Экран деталей напоминания (ТЗ 6.3.11).
class ReminderDetailsScreen extends ConsumerWidget {
  const ReminderDetailsScreen({super.key, required this.reminderId});

  final String reminderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(reminderByIdProvider(reminderId));
    return async.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text(RemindersStrings.detailsTitle)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            SkeletonShimmer(height: 120),
            SizedBox(height: 12),
            SkeletonShimmer(height: 160),
          ],
        ),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text(RemindersStrings.detailsTitle)),
        body: Center(
          child: OfflineErrorCard(
            message: RemindersStrings.loadingError,
            retryLabel: RemindersStrings.retry,
            onRetry: () => ref.invalidate(reminderByIdProvider(reminderId)),
          ),
        ),
      ),
      data: (reminder) {
        if (reminder == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(RemindersStrings.detailsTitle)),
            body: EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: RemindersStrings.notFoundTitle,
              subtitle: RemindersStrings.notFoundSubtitle,
              primaryAction: EmptyStateAction(
                label: RemindersStrings.notFoundAction,
                onPressed: () => context.go('/reminders'),
              ),
            ),
          );
        }
        return _DetailsScaffold(reminder: reminder);
      },
    );
  }
}

class _DetailsScaffold extends ConsumerWidget {
  const _DetailsScaffold({required this.reminder});

  final Reminder reminder;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    MotionTokens.light();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text(RemindersStrings.deleteConfirmTitle),
        content: const Text(RemindersStrings.deleteConfirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(false),
            child: const Text(RemindersStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(d).pop(true),
            child: const Text(RemindersStrings.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(deleteReminderUseCaseProvider)(reminder.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency = ref.watch(remindersBaseCurrencyProvider).value ?? 'RUB';
    final canEditAsync = ref.watch(canEditReminderProvider(reminder));
    final dayContextAsync =
        ref.watch(dayContextProvider(reminder.remindAt.toIso8601String()));
    final nextOccurrences = ref.watch(getNextOccurrencesUseCaseProvider)(
      startUtc: reminder.remindAt,
      rrule: reminder.recurrenceRule,
      afterUtc: DateTime.now().toUtc(),
      count: 3,
    );
    final snoozeEntries =
        ref.watch(formatSnoozeHistoryUseCaseProvider)(reminder.snoozeHistory);
    final recurringId = reminder.linkedRecurringId;
    final recurringAsync = recurringId == null
        ? null
        : ref.watch(linkedRecurringProvider(recurringId));
    final categoryId = reminder.linkedCategoryId;
    final categoryNameAsync = categoryId == null
        ? null
        : ref.watch(linkedCategoryNameProvider(categoryId));
    final accountId = reminder.linkedAccountId;
    final accountNameAsync = accountId == null
        ? null
        : ref.watch(linkedAccountNameProvider(accountId));
    return Scaffold(
      appBar: AppBar(
        title: const Text(RemindersStrings.detailsTitle),
        actions: [
          if (canEditAsync.value ?? false)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                MotionTokens.light();
                context.push('/reminders/create?id=${reminder.id}');
              },
            ),
          if (canEditAsync.value ?? false)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.colorExpense),
              onPressed: () => _delete(context, ref),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacing24),
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
                    PriorityIndicator(priority: reminder.priority, size: 32),
                    const SizedBox(width: AppSpacing.spacing12),
                    Expanded(
                      child: Text(
                        reminder.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spacing8),
                Wrap(
                  spacing: AppSpacing.spacing8,
                  children: [
                    AssigneeBadge(assigneeId: reminder.assigneeId),
                    ReminderAreaBadge(isFamily: reminder.isFamily),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spacing16),
          _sectionTitle(context, '📅 ${RemindersStrings.sectionWhen}'),
          _card(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, d MMMM yyyy, HH:mm', 'ru')
                      .format(reminder.remindAt.toLocal()),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (reminder.recurrenceRule != null) ...[
                  const SizedBox(height: AppSpacing.spacing8),
                  Text(
                    '${RemindersStrings.repeatsPrefix}'
                    '${ref.watch(formatRRuleUseCaseProvider)(reminder.recurrenceRule)}',
                    style: const TextStyle(color: AppColors.colorTransfer),
                  ),
                ],
                if (nextOccurrences.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.spacing8),
                  Text(RemindersStrings.nextPayments,
                      style: Theme.of(context).textTheme.labelLarge),
                  for (final occ in nextOccurrences)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4),
                      child: Text(
                        '• ${DateFormat('d MMMM, HH:mm', 'ru').format(occ.toLocal())}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (reminder.expectedAmount != null) ...[
            const SizedBox(height: AppSpacing.spacing16),
            _sectionTitle(context, '💰 ${RemindersStrings.sectionAmount}'),
            _card(
              context,
              Text(
                formatter.formatAmount(reminder.expectedAmount!, currency, mode),
                style: const TextStyle(
                  color: AppColors.colorExpense,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          if (categoryNameAsync != null) ...[
            const SizedBox(height: AppSpacing.spacing16),
            _sectionTitle(context, '🏷 ${RemindersStrings.sectionCategory}'),
            _card(
              context,
              Text(categoryNameAsync.value ?? '…',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
          if (accountNameAsync != null) ...[
            const SizedBox(height: AppSpacing.spacing16),
            _sectionTitle(context, '💳 ${RemindersStrings.sectionAccount}'),
            _card(
              context,
              Text(
                formatter.formatName(accountNameAsync.value, mode),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.spacing16),
          _sectionTitle(context, '📅 ${RemindersStrings.sectionCalendar}'),
          _card(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMMM — EEEE', 'ru')
                      .format(reminder.remindAt.toLocal()),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                dayContextAsync.whenOrNull(
                      data: (ctx) => ctx.holiday == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: AppSpacing.spacing8),
                              child: Text(
                                '${ctx.holiday!.iconEmoji ?? '🎉'} '
                                '${ctx.holiday!.name}',
                                style: const TextStyle(
                                    color: AppColors.colorWarning),
                              ),
                            ),
                    ) ??
                    const SizedBox.shrink(),
                const SizedBox(height: AppSpacing.spacing8),
                // Навигация в календарь появится в микро-коммите 14.4.
                OutlinedButton(
                  onPressed: () => MotionTokens.light(),
                  child: const Text(RemindersStrings.openInCalendar),
                ),
              ],
            ),
          ),
          if (recurringAsync != null) ...[
            const SizedBox(height: AppSpacing.spacing16),
            _sectionTitle(context, '🔁 ${RemindersStrings.sectionRecurring}'),
            _card(
              context,
              Text(
                formatter.formatName(recurringAsync.value?.merchantName, mode),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
          if (snoozeEntries.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.spacing16),
            _sectionTitle(
              context,
              '⏰ ${RemindersStrings.sectionSnooze} (${snoozeEntries.length})',
            ),
            _card(
              context,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < snoozeEntries.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${i + 1}. ${ref.watch(formatSnoozeHistoryUseCaseProvider).formatEntry(snoozeEntries[i])}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.spacing24),
          Wrap(
            spacing: AppSpacing.spacing8,
            runSpacing: AppSpacing.spacing8,
            children: [
              if (!reminder.isCompleted)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorIncome,
                  ),
                  onPressed: () async {
                    MotionTokens.medium();
                    await ref
                        .read(completeReminderUseCaseProvider)(reminder.id);
                    if (context.mounted) context.pop();
                  },
                  child: const Text(RemindersStrings.actionComplete),
                ),
              OutlinedButton(
                onPressed: () {
                  MotionTokens.light();
                  showSnoozeBottomSheet(context, ref, reminder);
                },
                child: const Text(RemindersStrings.actionSnooze),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorFAB,
                ),
                onPressed: () {
                  MotionTokens.light();
                  context.push(
                    '/transactions/create?reminder_id=${reminder.id}',
                  );
                },
                child: const Text(RemindersStrings.actionCreateTransaction),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _card(BuildContext context, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
      ),
      child: child,
    );
  }
}
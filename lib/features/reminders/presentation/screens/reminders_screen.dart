import 'package:flutter/material.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/repositories/reminders_repository.dart';
import '../providers/reminders_providers.dart';
import '../providers/reminders_screen_providers.dart';
import '../reminders_strings.dart';
import '../widgets/reminder_card.dart';
import '../widgets/reminder_long_press_menu.dart';
import '../widgets/reminders_fab_menu.dart';
import '../widgets/reminders_filter_row.dart';
import '../widgets/reminders_tab_selector.dart';

/// Экран «Напоминания» (ТЗ 6.3.10): табы, фильтры, swipe+undo,
/// long-press меню, FAB-меню, bootstrap планировщика при открытии,
/// обработка тапов/экшенов пушей.
class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        await ref.read(remindersBootstrapProvider.future);
        final userId = ref.read(currentUserIdProvider);
        await ref.read(scheduleRemindersUseCaseProvider)(userId);
      } catch (_) {
        // Планировщик не критичен для открытия экрана.
      }
    });
  }

  void _showPrivacySheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('visible'),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.visible);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                title: const Text('partial'),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.partial);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                title: const Text('hidden'),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.hidden);
                  Navigator.of(sheetContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(remindersTabProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    // Тап по пушу / экшен в открытом app (ТЗ 6.3.11.10).
    ref.listen(reminderNotificationIntentProvider, (_, next) {
      final intent = next.value;
      if (intent == null) return;
      if (intent.actionId == 'DONE') {
        ref.read(completeReminderUseCaseProvider)(intent.reminderId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(RemindersStrings.snackbarDone)),
        );
      } else {
        context.push('/reminders/${intent.reminderId}');
      }
    });
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/reminders'),
      appBar: AppBar(
        title: const Text(RemindersStrings.screenTitle),
        actions: [
          GestureDetector(
            onLongPress: _showPrivacySheet,
            child: IconButton(
              icon: Icon(
                privacyMode == BalanceVisibilityMode.hidden
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                MotionTokens.light();
                ref.read(privacyModeProvider.notifier).toggle();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showRemindersFabMenu(context),
        backgroundColor: AppColors.colorFAB,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const RemindersTabSelector(),
          Expanded(
            child: tab == RemindersTab.upcoming
                ? const _UpcomingBody()
                : const _HistoryBody(),
          ),
        ],
      ),
    );
  }
}

class _UpcomingBody extends ConsumerWidget {
  const _UpcomingBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(upcomingRemindersProvider);
    final totalAsync = ref.watch(upcomingCountProvider);
    final filter = ref.watch(remindersFilterProvider);
    return Column(
      children: [
        const RemindersFilterRow(),
        Expanded(
          child: async.when(
            loading: () => ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                SkeletonShimmer(height: 80),
                SizedBox(height: 12),
                SkeletonShimmer(height: 80),
                SizedBox(height: 12),
                SkeletonShimmer(height: 80),
              ],
            ),
            error: (e, _) => Center(
              child: OfflineErrorCard(
                message: RemindersStrings.loadingError,
                retryLabel: RemindersStrings.retry,
                onRetry: () => ref.invalidate(upcomingRemindersProvider),
              ),
            ),
            data: (reminders) {
              final total = totalAsync.value ?? 0;
              if (reminders.isEmpty && total == 0) {
                return EmptyStateWidget(
                  icon: Icons.notifications_none,
                  title: RemindersStrings.emptyAllTitle,
                  subtitle: RemindersStrings.emptyAllSubtitle,
                  primaryAction: EmptyStateAction(
                    label: RemindersStrings.emptyAllAction,
                    onPressed: () =>
                        context.push('/reminders/create?type=custom'),
                  ),
                  secondaryAction: EmptyStateAction(
                    label: RemindersStrings.emptyAllSecondary,
                    isPrimary: false,
                    onPressed: () => context
                        .push('/reminders/create?type=from_recurring'),
                  ),
                );
              }
              if (reminders.isEmpty) {
                if (filter == RemindersUpcomingFilter.all) {
                  return EmptyStateWidget(
                    icon: Icons.task_alt,
                    title: RemindersStrings.emptyDoneTitle,
                    subtitle: RemindersStrings.emptyDoneSubtitle,
                    primaryAction: EmptyStateAction(
                      label: RemindersStrings.emptyDoneAction,
                      onPressed: () =>
                          context.push('/reminders/create?type=custom'),
                    ),
                  );
                }
                return const EmptyStateWidget(
                  icon: Icons.filter_alt_off_outlined,
                  title: RemindersStrings.emptyAllTitle,
                  subtitle: RemindersStrings.emptyAllSubtitle,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reminders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Dismissible(
                    key: ValueKey('swipe_${reminder.id}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      decoration: BoxDecoration(
                        color: AppColors.colorIncome,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                    onDismissed: (_) async {
                      MotionTokens.medium();
                      final messenger = ScaffoldMessenger.of(context);
                      await ref
                          .read(completeReminderUseCaseProvider)(reminder.id);
                      messenger.showSnackBar(
                        SnackBar(
                          content: const Text(RemindersStrings.snackbarDone),
                          action: SnackBarAction(
                            label: RemindersStrings.snackbarUndo,
                            onPressed: () {
                              MotionTokens.medium();
                              ref.read(undoCompleteReminderUseCaseProvider)(
                                  reminder.id);
                            },
                          ),
                        ),
                      );
                    },
                    child: ReminderCard(
                      reminder: reminder,
                      onTap: () {
                        MotionTokens.light();
                        context.push('/reminders/${reminder.id}');
                      },
                      onLongPress: () =>
                          showReminderLongPressMenu(context, ref, reminder),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HistoryBody extends ConsumerWidget {
  const _HistoryBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(historyRemindersProvider);
    return async.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonShimmer(height: 80),
          SizedBox(height: 12),
          SkeletonShimmer(height: 80),
        ],
      ),
      error: (e, _) => Center(
        child: OfflineErrorCard(
          message: RemindersStrings.loadingError,
          retryLabel: RemindersStrings.retry,
          onRetry: () => ref.invalidate(historyRemindersProvider),
        ),
      ),
      data: (reminders) {
        if (reminders.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.history,
            title: RemindersStrings.emptyHistoryTitle,
            subtitle: RemindersStrings.emptyHistorySubtitle,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reminders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => ReminderCard(
            reminder: reminders[index],
            onTap: () {
              MotionTokens.light();
              context.push('/reminders/${reminders[index].id}');
            },
          ),
        );
      },
    );
  }
}
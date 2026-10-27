import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart' as db;
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import '../../domain/models/notification_type.dart';
import '../providers/notifications_providers.dart';
import '../widgets/notification_card.dart';

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(notificationsFilterProvider);
    final async = ref.watch(notificationsStreamProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        title: const Text('Уведомления'),
        actions: [
          IconButton(
            tooltip: 'Пометить все прочитанными',
            icon: const Icon(Icons.done_all),
            onPressed: () => _markAllRead(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _filterRow(ref, filter),
          const Divider(height: 1),
          Expanded(
            child: async.when(
              loading: () => ListView(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                children: List.generate(
                  5,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
                    child: SkeletonShimmer.card(height: 80),
                  ),
                ),
              ),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spacing24),
                  child: Text('Ошибка загрузки: $e',
                      style: const TextStyle(color: AppColors.colorExpense)),
                ),
              ),
              data: (list) {
                final filtered = _apply(list, filter);
                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                    icon: list.isEmpty
                        ? Icons.notifications_none
                        : Icons.filter_list_off,
                    title: list.isEmpty
                        ? 'Нет уведомлений'
                        : 'Нет уведомлений по фильтру',
                    subtitle: list.isEmpty
                        ? 'Здесь появятся пуши о лимитах, долгах, целях и событиях семьи'
                        : 'Попробуйте изменить фильтр',
                    primaryAction: EmptyStateAction(
                      label: list.isEmpty ? 'Обновить' : 'Сбросить фильтр',
                      isPrimary: list.isEmpty,
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        if (list.isEmpty) {
                          ref.invalidate(notificationsStreamProvider);
                        } else {
                          ref.read(notificationsFilterProvider.notifier).set(
                              const NotificationsFilter());
                        }
                      },
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.spacing16),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) =>
                      NotificationCard(notification: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterRow(WidgetRef ref, NotificationsFilter filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing16,
        vertical: AppSpacing.spacing8,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('Все'),
              selected: !filter.showOnlyUnread && filter.typeFilter == null,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                ref.read(notificationsFilterProvider.notifier).set(
                    const NotificationsFilter());
              },
            ),
            const SizedBox(width: AppSpacing.spacing8),
            FilterChip(
              label: const Text('Непрочитанные'),
              selected: filter.showOnlyUnread,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                ref.read(notificationsFilterProvider.notifier).set(
                    const NotificationsFilter(showOnlyUnread: true));
              },
            ),
            const SizedBox(width: AppSpacing.spacing16),
            for (final t in const [
              NotificationType.limitGlobalPercent,
              NotificationType.debtCreated,
              NotificationType.reminderDue,
              NotificationType.goalMilestone,
            ])
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.spacing8),
                child: FilterChip(
                  label: Text(t.label),
                  selected: filter.typeFilter == t,
                  onSelected: (_) {
                    HapticFeedback.selectionClick();
                    ref.read(notificationsFilterProvider.notifier).set(
                        NotificationsFilter(typeFilter: t));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<db.Notification> _apply(
    List<db.Notification> list,
    NotificationsFilter filter,
  ) {
    var result = list;
    if (filter.showOnlyUnread) {
      result = result.where((n) => !n.isRead).toList();
    }
    final t = filter.typeFilter;
    if (t != null) {
      result = result.where((n) => n.type == t.dbValue).toList();
    }
    return result;
  }

  Future<void> _markAllRead(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    HapticFeedback.mediumImpact();
    final list = await ref.read(notificationsStreamProvider.future);
    final useCase = ref.read(handleNotificationActionUseCaseProvider);
    for (final n in list) {
      if (!n.isRead) {
        await useCase.markAsRead(n.id);
      }
    }
    messenger.showSnackBar(
      const SnackBar(content: Text('✅ Все уведомления прочитаны')),
    );
  }
}

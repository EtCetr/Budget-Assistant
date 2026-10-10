import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/providers/database_providers.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/admin/presentation/providers/audit_log_providers.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/audit_entry_card.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/audit_entry_details_sheet.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/audit_log_export_sheet.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/audit_log_filter_row.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/audit_log_period_selector.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/audit_stats_summary.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

/// Журнал аудита пространства (ТЗ 6.3.35): период, сводка, фильтры (SQL),
/// список с группировкой по дням, CSV-экспорт с PIN-гейтом.
class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(adminScopeProvider);
    if (scope == null) {
      return const Scaffold(body: Center(child: Text('Нет активного пространства')));
    }
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    final period = ref.watch(auditPeriodProvider);
    final filter = ref.watch(auditFilterProvider);
    final stats = ref.watch(auditStatsProvider);
    final grouped = ref.watch(auditGroupedProvider);
    final total = ref.watch(auditFilteredProvider).value?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        title: const Text('Журнал аудита'),
        actions: [
          IconButton(
            tooltip: hidden ? 'Экспорт недоступен в скрытом режиме' : 'Экспорт',
            icon: const Icon(Icons.download_outlined),
            onPressed: hidden ? null : () => _exportFlow(context, ref, scope),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        children: [
          const AuditLogPeriodSelector(),
          const SizedBox(height: AppSpacing.spacing12),
          AuditStatsSummary(stats: stats, periodLabel: period.label),
          const SizedBox(height: AppSpacing.spacing12),
          AuditLogFilterRow(
            selected: filter,
            totalCount: total,
            hidden: hidden,
            onChanged: (f) => ref.read(auditFilterProvider.notifier).set(f),
          ),
          const SizedBox(height: AppSpacing.spacing12),
          grouped.when(
            loading: () => Column(
              children: List.generate(
                5,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
                  child: SkeletonShimmer.card(),
                ),
              ),
            ),
            error: (e, _) => OfflineErrorCard(
              message: 'Не удалось загрузить журнал: $e',
              onRetry: () => ref.invalidate(auditGroupedProvider),
            ),
            data: (groups) => _list(context, ref, groups, period, filter),
          ),
        ],
      ),
    );
  }

  Widget _list(
    BuildContext context,
    WidgetRef ref,
    List<AuditDayGroup> groups,
    AuditLogPeriod period,
    AuditLogFilter filter,
  ) {
    if (groups.isEmpty) {
      if (filter != AuditLogFilter.all) {
        return EmptyStateWidget(
          icon: Icons.filter_alt_off_outlined,
          title: 'Нет записей по этому фильтру',
          subtitle: 'Попробуйте изменить фильтр',
          primaryAction: EmptyStateAction(
            label: 'Сбросить фильтры',
            isPrimary: false,
            onPressed: () =>
                ref.read(auditFilterProvider.notifier).set(AuditLogFilter.all),
          ),
        );
      }
      if (period == AuditLogPeriod.all) {
        return EmptyStateWidget(
          icon: Icons.history_toggle_off,
          title: 'Журнал аудита пуст',
          subtitle: 'Здесь будут отображаться все критические действия в '
              'пространстве: приглашения, удаления, смены ролей',
          primaryAction: EmptyStateAction(
            label: '➕ Пригласить первого участника',
            onPressed: () => context.push('/admin/members'),
          ),
        );
      }
      return EmptyStateWidget(
        icon: Icons.event_busy_outlined,
        title: 'За этот период нет действий',
        subtitle: 'В пространстве не было критических действий. '
            'Попробуйте выбрать другой период',
        primaryAction: EmptyStateAction(
          label: 'Выбрать другой период',
          onPressed: () =>
              ref.read(auditPeriodProvider.notifier).set(AuditLogPeriod.all),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final g in groups) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
            child: Text(
              _dayTitle(g.day),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final item in g.items)
            AuditEntryCard(
              item: item,
              onTap: () {
                HapticFeedback.lightImpact();
                showAuditEntryDetailsSheet(context, item);
              },
            ),
        ],
      ],
    );
  }

  String _dayTitle(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateStr = DateFormat('d MMMM yyyy', 'ru').format(day);
    if (day == today) return '📅 Сегодня, $dateStr';
    if (day == yesterday) return '📅 Вчера, $dateStr';
    final weekday = DateFormat('EEEE', 'ru').format(day);
    final cap = weekday[0].toUpperCase() + weekday.substring(1);
    return '📅 $cap, $dateStr';
  }

  /// Флоу экспорта (6.3.35.7): PIN-гейт при включённом PIN → формат → файл →
  /// диалог «Сохранить / Поделиться».
  Future<void> _exportFlow(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
  ) async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final settings =
          await ref.read(appSettingsDaoProvider).getForUser(scope.userId);
      if (!context.mounted) return;
      if (settings.enablePinCode) {
        final ok = await context.push<bool>('/security/pin-entry?mode=verify');
        if (!context.mounted) return;
        if (ok != true) return;
      }
      if (!context.mounted) return;
      final choice = await showAuditExportSheet(context);
      if (choice != 'csv') return;
      final useCase = ref.read(exportAuditLogUseCaseProvider);
      final since = ref.read(auditPeriodProvider).since;
      final path = await useCase.call(spaceId: scope.spaceId, since: since);
      if (!context.mounted) return;
      final dest = await showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          title: const Text('Экспорт готов',
              style: TextStyle(color: AppColors.textPrimary)),
          content: const Text('Куда сохранить журнал аудита?',
              style: TextStyle(color: AppColors.textSecondary)),
          actions: [
            FilledButton.icon(
              icon: const Icon(Icons.save_outlined),
              label: const Text('Сохранить'),
              onPressed: () => Navigator.of(d).pop('save'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Поделиться'),
              onPressed: () => Navigator.of(d).pop('share'),
            ),
            TextButton(
              onPressed: () => Navigator.of(d).pop(),
              child: const Text('Отмена'),
            ),
          ],
        ),
      );
      if (dest == 'save') {
        final uri = await useCase.saveToDownloads(path);
        messenger.showSnackBar(SnackBar(content: Text('✅ Сохранено: $uri')));
      } else if (dest == 'share') {
        await useCase.share(path);
        messenger.showSnackBar(
          const SnackBar(content: Text('✅ Журнал экспортирован')),
        );
      }
      if (dest != null) HapticFeedback.mediumImpact();
    } catch (e, st) {
      AppLogger.e('Audit export flow failed', e, st);
      HapticFeedback.vibrate();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('❌ Не удалось экспортировать журнал. Попробуйте снова'),
        ),
      );
    }
  }
}
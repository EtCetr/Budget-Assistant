import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/providers/security_providers.dart' as sec;
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_providers.dart';

/// Хаб администратора (ТОМ 6, §6.3.32).
/// AppBar: [переключатель пространств] [участники] [журнал]. Нижних плашек нет.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  String _money(int kopecks, PrivacyFormatter pf, BalanceVisibilityMode mode) =>
      pf.formatAmount(kopecks, 'RUB', mode);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(adminScopeProvider);
    if (scope == null) {
      return const Scaffold(body: Center(child: Text('Выберите пространство')));
    }
    final access = ref.watch(adminAccessProvider(scope));
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        title: const Text('Администрирование'),
        actions: [
          _spaceSwitcher(context, ref, scope),
          IconButton(
            tooltip: 'Управление участниками',
            icon: const Icon(Icons.group),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/admin/members');
            },
          ),
          IconButton(
            tooltip: 'Журнал действий',
            icon: const Icon(Icons.history),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/admin/audit-log');
            },
          ),
        ],
      ),
      body: access.when(
        loading: () => ListView(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            children: List.generate(
                4,
                (_) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
                    child: SkeletonShimmer.card()))),
        error: (e, _) => Center(
            child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                child: Text('Ошибка доступа: $e',
                    style: const TextStyle(color: AppColors.textPrimary)))),
        data: (isAdmin) {
          if (isAdmin) {
            WidgetsBinding.instance.addPostFrameCallback((_) => ref
                .read(updateLastActiveAtUseCaseProvider)
                .call(scope.userId, scope.spaceId));
            return _body(context, ref, scope);
          }
          return const Center(
            child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacing16),
                child: Text('Раздел доступен только администраторам пространства',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textPrimary)),
          ));
        },
      ),
    );
  }

  Widget _spaceSwitcher(BuildContext context, WidgetRef ref, AdminScope scope) {
    final spaces = ref.watch(userSpacesProvider).value ?? const [];
    if (spaces.length < 2) {
      return const SizedBox.shrink();
    }
    return PopupMenuButton<String>(
      tooltip: 'Пространство',
      icon: const Icon(Icons.swap_horiz),
      onSelected: (id) {
        ref.read(currentSpaceIdProvider.notifier).setSpaceId(id);
        ref.read(sec.currentSpaceIdProvider.notifier).set(id);
        ref.invalidate(adminAccessProvider(scope));
      },
      itemBuilder: (_) => [
        for (final s in spaces)
          PopupMenuItem<String>(
            value: s.id,
            child: Text(s.id == scope.spaceId ? '• ${s.name}' : s.name),
          ),
      ],
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, AdminScope scope) {
    final pf = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);
    final info = ref.watch(spaceInfoProvider(scope.spaceId));
    final activity = ref.watch(activityStatsProvider(scope.spaceId));
    final alerts = ref.watch(criticalAlertsProvider(scope.spaceId));
    final stats = ref.watch(memberStatsProvider(scope.spaceId));
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(adminAccessProvider(scope)),
      child: ListView(padding: const EdgeInsets.all(AppSpacing.spacing16), children: [
        _infoCard(context, ref, info, scope, pf, mode),
        const SizedBox(height: AppSpacing.spacing16),
        stats.when(
          loading: () => SkeletonShimmer.card(),
          error: (e, _) => Text('Ошибка: $e',
              style: const TextStyle(color: AppColors.textPrimary)),
          data: (st) => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              mainAxisSpacing: AppSpacing.spacing12,
              crossAxisSpacing: AppSpacing.spacing12,
              children: [
                _gridCard(context, 'Участники', '${st.total}', 'админов: ${st.admins}',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.push('/admin/members');
                    }),
                _gridCard(context, 'Приостановлены', '${st.suspended}',
                    'неактивны 30д: ${st.inactive30d}'),
                _gridCard(context, 'Инвайты', '${st.pendingInvites}', 'ожидают принятия'),
                alerts.when(
                  loading: () => SkeletonShimmer.card(),
                  error: (e, _) => _gridCard(context, 'Алерты', '—', '$e'),
                  data: (a) => _gridCard(context, 'Алерты', '${a.length}',
                      a.isEmpty ? 'всё в порядке' : 'требуют внимания',
                      accent: a.isNotEmpty),
                ),
              ]),
        ),
        const SizedBox(height: AppSpacing.spacing16),
        activity.when(
          loading: () => SkeletonShimmer.card(),
          error: (e, _) => Text('Ошибка: $e',
              style: const TextStyle(color: AppColors.textPrimary)),
          data: (a) => Container(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
              border: Border.all(color: AppColors.borderDivider),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Активность',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.spacing12),
              Text('Операций за 7 дней: ${a.tx7d}',
                  style: const TextStyle(color: AppColors.textSecondary)),
              Text('Операций за 30 дней: ${a.tx30d}',
                  style: const TextStyle(color: AppColors.textSecondary)),
              Text('Последняя: ${a.lastTxAt == null ? '—' : a.lastTxAt!.toLocal().toString().split('.').first}',
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.spacing12),
              Text('Расходы месяца: ${_money(a.monthExpenseKopecks, pf, mode)}',
                  style: const TextStyle(color: AppColors.textPrimary)),
              Text('Доходы месяца: ${_money(a.monthIncomeKopecks, pf, mode)}',
                  style: const TextStyle(color: AppColors.textPrimary)),
            ]),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing16),
        alerts.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => const SizedBox.shrink(),
          data: (a) => a.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(AppSpacing.spacing16),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
                  ),
                  child: const Text('Критических алертов нет',
                      style: TextStyle(color: AppColors.textSecondary)))
              : Column(children: [
                  const Text('Критические уведомления',
                      style: TextStyle(
                          color: AppColors.colorExpense,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: AppSpacing.spacing8),
                  ...a.map((al) => Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
                        padding: const EdgeInsets.all(AppSpacing.spacing12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
                          border: Border.all(color: AppColors.colorExpense),
                        ),
                        child: Row(children: [
                          Icon(
                              switch (al.type) {
                                CriticalAlertType.soloAdmin =>
                                  Icons.admin_panel_settings_outlined,
                                CriticalAlertType.inactiveMembers => Icons.snooze,
                                CriticalAlertType.exMemberDebt => Icons.warning_amber,
                              },
                              color: AppColors.colorExpense),
                          const SizedBox(width: AppSpacing.spacing12),
                          Expanded(
                              child: Text(al.message,
                                  style: const TextStyle(color: AppColors.textPrimary))),
                          TextButton(
                              child: const Text('Открыть'),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                context.push('/admin/members');
                              }),
                        ]),
                      )),
                ]),
        ),
      ]),
    );
  }

  Widget _infoCard(BuildContext context, WidgetRef ref, AsyncValue<SpaceInfo?> info,
      AdminScope scope, PrivacyFormatter pf, BalanceVisibilityMode mode) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: info.when(
        loading: () => SkeletonShimmer.card(),
        error: (e, _) => Text('Ошибка: $e',
            style: const TextStyle(color: AppColors.textPrimary)),
        data: (s) => s == null
            ? const Text('Пространство не найдено',
                style: TextStyle(color: AppColors.textPrimary))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.family_restroom, color: AppColors.colorFAB, size: 32),
                  const SizedBox(width: AppSpacing.spacing12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(pf.formatSpaceName(s.name, mode),
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const Text('Администратор',
                            style: TextStyle(
                                color: AppColors.colorWarning, fontSize: 12)),
                      ])),
                ]),
                const SizedBox(height: AppSpacing.spacing12),
                Text('Участников: ${s.membersCount}',
                    style: const TextStyle(color: AppColors.textSecondary)),
                Text('Создано: ${s.createdAt.toLocal().toString().split('.').first}',
                    style: const TextStyle(color: AppColors.textSecondary)),
                Text('ID: ${s.id.length > 8 ? s.id.substring(0, 8) : s.id}…',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                if (s.membersCount == 1) ...[
                  const Divider(height: 24),
                  TextButton.icon(
                    onPressed: () => _confirmDissolve(context, ref, scope, pf.formatSpaceName(s.name, mode)),
                    icon: const Icon(Icons.delete_forever, color: AppColors.colorExpense),
                    label: const Text('Удалить группу',
                        style: TextStyle(color: AppColors.colorExpense)),
                  ),
                ],
              ]),
      ),
    );
  }

  Future<void> _confirmDissolve(BuildContext context, WidgetRef ref,
      AdminScope scope, String spaceName) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('Удалить группу?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
            'Группа «$spaceName» будет расформирована (в ней только вы). '
            'История операций сохранится локально и будет помечена к синхронизации.',
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Отмена')),
          FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.colorExpense),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Удалить')),
        ],
      ),
    );
    if (ok != true) {
      return;
    }
    try {
      await ref.read(dissolveSpaceUseCaseProvider).call(
          spaceId: scope.spaceId, actorId: scope.userId);
      ref.read(currentSpaceIdProvider.notifier).setSpaceId(null);
      ref.read(sec.currentSpaceIdProvider.notifier).set(null);
      ref.invalidate(userSpacesProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Группа расформирована')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }

  Widget _gridCard(BuildContext context, String title, String value, String subtitle,
      {VoidCallback? onTap, bool accent = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing12),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                Text(value,
                    style: TextStyle(
                        color: accent ? AppColors.colorExpense : AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
              ]),
        ),
      ),
    );
  }
}
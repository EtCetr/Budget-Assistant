import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/admin/presentation/providers/members_activity_providers.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/activity_chart.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/activity_chart_day_details_sheet.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/member_activity_card.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/members_activity_period_selector.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/overall_stats_card.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/top_active_members_section.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

/// Статистика активности участников (ТЗ 6.3.34): сводка, стек-бар,
/// топ-3, список участников с пингом неактивных.
class MembersActivityScreen extends ConsumerWidget {
  const MembersActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(adminScopeProvider);
    if (scope == null) {
      return const Scaffold(
        body: Center(child: Text('Нет активного пространства')),
      );
    }
    final access = ref.watch(adminAccessProvider(scope));
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(title: const Text('Статистика активности')),
      body: access.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Ошибка доступа: $e',
              style: const TextStyle(color: AppColors.textPrimary)),
        ),
        data: (isAdmin) => isAdmin
            ? _content(context, ref, scope)
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.spacing16),
                  child: Text(
                    'Раздел доступен только администраторам пространства',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, AdminScope scope) {
    final period = ref.watch(activityPeriodProvider);
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    final pf = ref.watch(privacyFormatterProvider);
    final stats = ref.watch(overallActivityStatsProvider);
    final chart = ref.watch(activityChartProvider);
    final top = ref.watch(topActiveMembersProvider);
    final counts = ref.watch(memberPeriodCountsProvider);
    final membersAsync = ref.watch(membersStreamProvider(scope.spaceId));
    return membersAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        children: List.generate(
          4,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
            child: SkeletonShimmer.card(),
          ),
        ),
      ),
      error: (e, _) => OfflineErrorCard(
        message: 'Не удалось загрузить статистику: $e',
        onRetry: () => ref.invalidate(membersStreamProvider(scope.spaceId)),
      ),
      data: (members) {
        if (members.length <= 1) {
          return EmptyStateWidget(
            icon: Icons.person_outline,
            title: 'В пространстве пока только вы',
            subtitle:
                'Пригласите членов семьи, чтобы видеть статистику активности',
            primaryAction: EmptyStateAction(
              label: '➕ Пригласить первого участника',
              onPressed: () => context.push('/admin/members'),
            ),
          );
        }
        final membersById = {for (final m in members) m.userId: m};
        final now = DateTime.now().toUtc();
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            const MembersActivityPeriodSelector(),
            const SizedBox(height: AppSpacing.spacing12),
            OverallStatsCard(stats: stats, periodLabel: period.labelAcc),
            const SizedBox(height: AppSpacing.spacing12),
            if (stats.totalTransactions == 0)
              EmptyStateWidget(
                icon: Icons.bar_chart,
                title: 'За этот период нет активности',
                subtitle: 'Участники пространства не создавали транзакции. '
                    'Попробуйте выбрать другой период',
                primaryAction: EmptyStateAction(
                  label: 'Выбрать другой период',
                  onPressed: () => ref
                      .read(activityPeriodProvider.notifier)
                      .set(ActivityPeriod.year),
                ),
                secondaryAction: EmptyStateAction(
                  label: 'Напомнить всем неактивным',
                  isPrimary: false,
                  onPressed: () => _pingAllInactive(context, ref, scope, members),
                ),
              )
            else ...[
              ActivityChart(
                data: chart,
                membersById: membersById,
                onDayTap: (d) {
                  HapticFeedback.lightImpact();
                  showActivityDayDetailsSheet(
                    context,
                    day: d,
                    membersById: membersById,
                    hidden: hidden,
                    pf: pf,
                    mode: mode,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacing12),
              TopActiveMembersSection(top: top, periodLabel: period.labelAcc),
              const SizedBox(height: AppSpacing.spacing12),
            ],
            Text(
              '👥 Все участники (${members.length})',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            for (final m in members)
              MemberActivityCard(
                member: m,
                count: counts[m.userId] ?? 0,
                periodDays: period.days,
                periodLabel: period.labelAcc,
                onPing: _needsPing(m, now)
                    ? () => _ping(context, ref, scope, m)
                    : null,
              ),
          ],
        );
      },
    );
  }

  bool _needsPing(MemberInfo m, DateTime now) {
    if (m.status != MemberStatus.active) {
      return false;
    }
    final last = m.lastActiveAt;
    if (last == null) {
      return true;
    }
    return now.difference(last).inDays >= 14;
  }

  Future<void> _ping(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
    MemberInfo m,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final pf = ref.read(privacyFormatterProvider);
    final mode = ref.read(privacyModeProvider);
    final name = pf.formatName(m.displayName, mode);
    HapticFeedback.mediumImpact();
    try {
      await ref.read(sendReminderUseCaseProvider).call(
            spaceId: scope.spaceId,
            actorId: scope.userId,
            target: m,
          );
      messenger.showSnackBar(
        SnackBar(content: Text('✅ Напоминание отправлено: $name')),
      );
    } catch (e, st) {
      AppLogger.e('Ping failed', e, st);
      HapticFeedback.vibrate();
      messenger.showSnackBar(
        const SnackBar(content: Text('❌ Не удалось отправить напоминание')),
      );
    }
  }

  Future<void> _pingAllInactive(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
    List<MemberInfo> members,
  ) async {
    final now = DateTime.now().toUtc();
    final inactive = members.where((m) => _needsPing(m, now)).toList();
    if (inactive.isEmpty) {
      return;
    }
    HapticFeedback.heavyImpact();
    var ok = 0;
    for (final m in inactive) {
      try {
        await ref.read(sendReminderUseCaseProvider).call(
              spaceId: scope.spaceId,
              actorId: scope.userId,
              target: m,
            );
        ok++;
      } catch (e, st) {
        AppLogger.e('PingAll failed for ${m.userId}', e, st);
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Напоминаний отправлено: $ok')),
      );
    }
  }
}
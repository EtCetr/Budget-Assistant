import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/dialogs/invite_sheet.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/dialogs/transfer_admin_dialog.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/member_card.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/member_filter_row.dart';

/// Управление участниками пространства (ТОМ 6, §6.3.33).
class MembersManagementScreen extends ConsumerStatefulWidget {
  const MembersManagementScreen({super.key});

  @override
  ConsumerState<MembersManagementScreen> createState() =>
      _MembersManagementScreenState();
}

class _MembersManagementScreenState
    extends ConsumerState<MembersManagementScreen> {
  MemberFilter _filter = MemberFilter.all;
  String? _query;

  @override
  Widget build(BuildContext context) {
    final scope = ref.watch(adminScopeProvider);
    if (scope == null) {
      return const Scaffold(
        body: Center(child: Text('Нет активного пространства')),
      );
    }
    final membersAsync = ref.watch(membersStreamProvider(scope.spaceId));
    final statsAsync = ref.watch(memberStatsProvider(scope.spaceId));

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(title: const Text('Участники')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _openInvite(scope.spaceId);
        },
        backgroundColor: AppColors.colorFAB,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Пригласить',
            style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(membersStreamProvider(scope.spaceId));
          ref.invalidate(memberStatsProvider(scope.spaceId));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            statsAsync.when(
              loading: () => SkeletonShimmer.card(),
              error: (e, _) => Text('Ошибка: $e',
                  style: const TextStyle(color: AppColors.textPrimary)),
              data: (st) => Container(
                padding: const EdgeInsets.all(AppSpacing.spacing12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
                  border: Border.all(color: AppColors.borderDivider),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('${st.total}', 'всего'),
                    _stat('${st.admins}', 'админов'),
                    _stat('${st.suspended}', 'блок'),
                    _stat('${st.inactive30d}', 'неактив'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            MemberFilterRow(
              selected: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск по имени',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
                ),
                filled: true,
                fillColor: AppColors.surfaceCard,
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            membersAsync.when(
              loading: () => Column(
                children: List.generate(
                  4,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SkeletonShimmer.card(),
                  ),
                ),
              ),
              error: (e, _) => Text('Ошибка: $e',
                  style: const TextStyle(color: AppColors.textPrimary)),
              data: (members) {
                final filtered = _applyFilter(members);
                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Icon(Icons.group_off,
                            size: 64, color: AppColors.textSecondary),
                        SizedBox(height: 12),
                        Text('Участники не найдены',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 16)),
                      ],
                    ),
                  );
                }
                return Column(
                  children: filtered
                      .map((m) => MemberCard(
                            member: m,
                            isSelf: m.userId == scope.userId,
                            onMenuTap: () => _showMenu(m, scope),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      );

  List<MemberInfo> _applyFilter(List<MemberInfo> members) {
    Iterable<MemberInfo> result = switch (_filter) {
      MemberFilter.all => members.where((m) => m.status != MemberStatus.left),
      MemberFilter.active =>
          members.where((m) => m.status == MemberStatus.active),
      MemberFilter.suspended =>
          members.where((m) => m.status == MemberStatus.suspended),
      MemberFilter.admins =>
          members.where((m) => m.role == MemberRole.admin),
    };
    if (_query != null && _query!.isNotEmpty) {
      result = result.where((m) => m.displayName.toLowerCase().contains(_query!));
    }
    return result.toList();
  }

  void _openInvite(String spaceId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InviteSheet(spaceId: spaceId),
    );
  }

  Future<void> _showMenu(MemberInfo m, AdminScope scope) async {
    final isAdmin = m.role == MemberRole.admin;
    final isSelf = m.userId == scope.userId;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(m.displayName,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.spacing12),
              if (!isSelf) ...[
                ListTile(
                  leading: const Icon(Icons.swap_horiz),
                  title: Text(
                      isAdmin ? 'Понизить до участника' : 'Повысить до админа',
                      style: const TextStyle(color: AppColors.textPrimary)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _changeRole(m, scope);
                  },
                ),
                if (!isAdmin && m.status == MemberStatus.active)
                  ListTile(
                    leading: const Icon(Icons.pause_circle_outline,
                        color: AppColors.colorExpense),
                    title: const Text('Приостановить',
                        style: TextStyle(color: AppColors.textPrimary)),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _suspend(m, scope);
                    },
                  ),
                if (m.status == MemberStatus.suspended)
                  ListTile(
                    leading: const Icon(Icons.play_circle_outline,
                        color: Color(0xFF2E7D32)),
                    title: const Text('Возобновить',
                        style: TextStyle(color: AppColors.textPrimary)),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _resume(m, scope);
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.notifications_active),
                  title: const Text('Отправить напоминание',
                      style: TextStyle(color: AppColors.textPrimary)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _sendReminder(m, scope);
                  },
                ),
                if (isSelf && isAdmin)
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings,
                        color: AppColors.colorWarning),
                    title: const Text('Передать роль админа',
                        style: TextStyle(color: AppColors.textPrimary)),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _pickTransferTarget(scope);
                    },
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_remove,
                      color: AppColors.colorExpense),
                  title: const Text('Удалить из пространства',
                      style: TextStyle(color: AppColors.colorExpense)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _remove(m, scope);
                  },
                ),
              ] else
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Действия с вашей учётной записью недоступны',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeRole(MemberInfo m, AdminScope scope) async {
    final newRole = m.role == MemberRole.admin ? MemberRole.member : MemberRole.admin;
    final ok = await _confirm('Изменить роль ${m.displayName} на «${newRole.label}»?');
    if (!ok) {
      return;
    }
    try {
      await ref.read(changeMemberRoleUseCaseProvider).call(
          spaceId: scope.spaceId, actorId: scope.userId, target: m, newRole: newRole);
      _snack('Роль изменена');
      ref.invalidate(membersStreamProvider(scope.spaceId));
    } catch (e, st) {
      AppLogger.e('changeRole UI failed', e, st);
      _snack('Ошибка: $e', error: true);
    }
  }

  Future<void> _suspend(MemberInfo m, AdminScope scope) async {
    final ok = await _confirm('Приостановить участника ${m.displayName}?');
    if (!ok) {
      return;
    }
    try {
      await ref.read(suspendMemberUseCaseProvider).call(
          spaceId: scope.spaceId, actorId: scope.userId, target: m);
      _snack('Участник приостановлен');
      ref.invalidate(membersStreamProvider(scope.spaceId));
    } catch (e, st) {
      AppLogger.e('suspend UI failed', e, st);
      _snack('Ошибка: $e', error: true);
    }
  }

  Future<void> _resume(MemberInfo m, AdminScope scope) async {
    try {
      await ref.read(resumeMemberUseCaseProvider).call(
          spaceId: scope.spaceId, actorId: scope.userId, target: m);
      _snack('Участник возобновлён');
      ref.invalidate(membersStreamProvider(scope.spaceId));
    } catch (e, st) {
      AppLogger.e('resume UI failed', e, st);
      _snack('Ошибка: $e', error: true);
    }
  }

  Future<void> _sendReminder(MemberInfo m, AdminScope scope) async {
    try {
      await ref.read(sendReminderUseCaseProvider).call(
          spaceId: scope.spaceId, actorId: scope.userId, target: m);
      _snack('Напоминание создано (доставится при синхронизации)');
    } catch (e, st) {
      AppLogger.e('sendReminder UI failed', e, st);
      _snack('Ошибка: $e', error: true);
    }
  }

  Future<void> _remove(MemberInfo m, AdminScope scope) async {
    final ok = await _confirm(
        'Удалить ${m.displayName}? Открытые долги станут «долгами вышедшего».');
    if (!ok) {
      return;
    }
    try {
      await ref.read(removeMemberUseCaseProvider).call(
          spaceId: scope.spaceId, actorId: scope.userId, target: m);
      _snack('Участник удалён');
      ref.invalidate(membersStreamProvider(scope.spaceId));
    } catch (e, st) {
      AppLogger.e('remove UI failed', e, st);
      _snack('Ошибка: $e', error: true);
    }
  }

  Future<void> _pickTransferTarget(AdminScope scope) async {
    final members = await ref.read(membersStreamProvider(scope.spaceId).future);
    final candidates = members
        .where((m) =>
            m.userId != scope.userId &&
            m.status == MemberStatus.active &&
            m.role != MemberRole.admin)
        .toList();
    if (candidates.isEmpty) {
      _snack('Нет подходящих кандидатов (нужен активный участник без роли админа)',
          error: true);
      return;
    }
    if (!mounted) {
      return;
    }
    final self = members.firstWhere((m) => m.userId == scope.userId);
    final target = await showModalBottomSheet<MemberInfo>(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          shrinkWrap: true,
          children: [
            const Text('Кому передать роль админа?',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.spacing12),
            ...candidates.map((c) => ListTile(
                  title: Text(c.displayName,
                      style: const TextStyle(color: AppColors.textPrimary)),
                  subtitle: Text(c.role.label,
                      style: const TextStyle(color: AppColors.textSecondary)),
                  onTap: () => Navigator.of(ctx).pop(c),
                )),
          ],
        ),
      ),
    );
    if (target == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => TransferAdminDialog(target: target),
    );
    if (confirmed != true) {
      return;
    }
    try {
      await ref.read(transferAdminRoleUseCaseProvider).call(
          spaceId: scope.spaceId, actorId: scope.userId, from: self, to: target);
      _snack('Роль админа передана. Обновите экран.');
      ref.invalidate(membersStreamProvider(scope.spaceId));
      ref.invalidate(adminAccessProvider(scope));
    } catch (e, st) {
      AppLogger.e('transferAdmin UI failed', e, st);
      _snack('Ошибка: $e', error: true);
    }
  }

  Future<bool> _confirm(String text) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('Подтверждение',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(text, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Отмена')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Подтвердить')),
        ],
      ),
    );
    return res == true;
  }

  void _snack(String text, {bool error = false}) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: error ? AppColors.colorExpense : AppColors.colorFAB,
    ));
  }
}

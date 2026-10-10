import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'family_colors.dart';

/// Карточка участника с детальной статистикой (ТЗ 6.3.34.7).
/// Кнопка «напомнить» — только для неактивных 14+ дней.
class MemberActivityCard extends ConsumerWidget {
  const MemberActivityCard({
    super.key,
    required this.member,
    required this.count,
    required this.periodDays,
    required this.periodLabel,
    this.onPing,
  });
  final MemberInfo member;
  final int count;
  final int periodDays;
  final String periodLabel;
  final VoidCallback? onPing;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    final pf = ref.watch(privacyFormatterProvider);
    final now = DateTime.now().toUtc();
    const statusUseCase = GetActivityStatusUseCase();
    final status = statusUseCase.call(member, now);
    final left = status == ActivityStatus.left;
    final (String icon, Color color, String text) = switch (status) {
      ActivityStatus.online => ('🟢', AppColors.colorIncome, 'Онлайн'),
      ActivityStatus.recent => (
          '🟢',
          AppColors.colorIncome,
          statusUseCase.lastSyncLabel(member, now),
        ),
      ActivityStatus.old => (
          '🟡',
          AppColors.colorWarning,
          statusUseCase.lastSyncLabel(member, now),
        ),
      ActivityStatus.inactive => (
          '🔴',
          AppColors.colorExpense,
          member.lastActiveAt == null
              ? 'Неактивен (нет синхронизаций)'
              : 'Неактивен ${now.difference(member.lastActiveAt!).inDays} дней',
        ),
      ActivityStatus.left => ('⬜', Colors.grey, 'Покинул группу'),
    };
    final days = periodDays < 1 ? 1 : periodDays;
    final perDay = count / days;
    return Opacity(
      opacity: left ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: (hidden || left || member.status == MemberStatus.suspended)
                      ? Colors.grey
                      : familyColorFor(member.userId),
                  child: Text(
                    hidden ? '••' : _initials(member.displayName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              pf.formatName(member.displayName, mode),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: member.role == MemberRole.admin
                                  ? AppColors.colorWarning
                                      .withValues(alpha: 0.12)
                                  : AppColors.textSecondary
                                      .withValues(alpha: 0.12),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              member.role.label,
                              style: TextStyle(
                                color: member.role == MemberRole.admin
                                    ? AppColors.colorWarning
                                    : AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              text,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: color, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        left
                            ? '📊 $count транзакций за $periodLabel'
                            : '📊 $count транзакций за $periodLabel · ${perDay.toStringAsFixed(1)} в день',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (onPing != null && !left) ...[
              const SizedBox(height: AppSpacing.spacing8),
              OutlinedButton.icon(
                onPressed: onPing,
                icon: const Icon(Icons.notifications_active, size: 16),
                label: const Text('Отправить напоминание'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'family_colors.dart';

/// Топ-3 активных участников (ТЗ 6.3.34.6): медали 🥇🥈, процент от общей.
class TopActiveMembersSection extends ConsumerWidget {
  const TopActiveMembersSection({
    super.key,
    required this.top,
    required this.periodLabel,
  });
  final List<TopMember> top;
  final String periodLabel;
  static const List<String> _medals = ['🥇', '🥈', ''];

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
    if (top.isEmpty) {
      return const SizedBox.shrink();
    }
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    final pf = ref.watch(privacyFormatterProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🏆 Самые активные за $periodLabel',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        for (var i = 0; i < top.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
            padding: const EdgeInsets.all(AppSpacing.spacing12),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
              border: Border.all(color: AppColors.borderDivider),
            ),
            child: Row(
              children: [
                Text(_medals[i], style: const TextStyle(fontSize: 20)),
                const SizedBox(width: AppSpacing.spacing8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      hidden ? Colors.grey : familyColorFor(top[i].userId),
                  child: Text(
                    hidden ? '••' : _initials(top[i].displayName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
                              pf.formatName(top[i].displayName, mode),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: top[i].role == MemberRole.admin
                                  ? AppColors.colorWarning
                                      .withValues(alpha: 0.12)
                                  : AppColors.textSecondary
                                      .withValues(alpha: 0.12),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              top[i].role.label,
                              style: TextStyle(
                                color: top[i].role == MemberRole.admin
                                    ? AppColors.colorWarning
                                    : AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${top[i].count} транзакций · ${top[i].percent}% от общей активности',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
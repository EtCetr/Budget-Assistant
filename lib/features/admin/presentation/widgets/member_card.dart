import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';

/// Карточка участника (ТОМ 6 §6.3.33). Цвет аватара детерминирован userId.
class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.member, required this.onMenuTap, this.isSelf = false});
  final MemberInfo member;
  final VoidCallback onMenuTap;
  final bool isSelf;

  static const List<Color> _avatarPalette = [
    Color(0xFF5E35B1), Color(0xFF1E88E5), Color(0xFF00ACC1), Color(0xFF43A047),
    Color(0xFFC0CA33), Color(0xFFFB8C00), Color(0xFFD81B60), Color(0xFF8E24AA),
    Color(0xFF3949AB), Color(0xFF039BE5), Color(0xFF00897B), Color(0xFFE53935),
  ];

  Color _avatarColor(String id) => _avatarPalette[id.hashCode.abs() % _avatarPalette.length];

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  bool get _isInactive {
    if (member.lastActiveAt == null) return true;
    return DateTime.now().toUtc().difference(member.lastActiveAt!) > const Duration(days: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: () { HapticFeedback.mediumImpact(); onMenuTap(); },
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing12),
            child: Row(children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: member.status == MemberStatus.suspended
                    ? Colors.grey
                    : _avatarColor(member.userId),
                child: Text(_initials(member.displayName),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: AppSpacing.spacing12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(child: Text(member.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textPrimary,
                          fontSize: 16, fontWeight: FontWeight.w600))),
                  if (isSelf) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.colorFAB.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Вы', style: TextStyle(
                          color: AppColors.colorFAB, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  _chip(member.role.label,
                      member.role == MemberRole.admin
                          ? AppColors.colorWarning
                          : AppColors.textSecondary),
                  const SizedBox(width: 6),
                  _statusChip(),
                  if (_isInactive && member.status == MemberStatus.active) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.warning_amber, size: 14, color: AppColors.colorExpense),
                    const Text(' >30д', style: TextStyle(color: AppColors.colorExpense, fontSize: 11)),
                  ],
                ]),
              ])),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                onPressed: () { HapticFeedback.lightImpact(); onMenuTap(); },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      );

  Widget _statusChip() {
    final (label, color) = switch (member.status) {
      MemberStatus.active => ('активен', const Color(0xFF2E7D32)),
      MemberStatus.suspended => ('приостановлен', AppColors.colorExpense),
      MemberStatus.left => ('вышел', Colors.grey),
    };
    return _chip(label, color);
  }
}
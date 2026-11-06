// lib/features/settings/presentation/widgets/space_card.dart
// Этап 21 (ТЗ 6.3.51.2 / 6.3.39.5): карточка пространства (активное / архив).
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/member_color_palette.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/spaces/domain/entities/space_membership_info.dart';

class SpaceCard extends StatelessWidget {
  const SpaceCard({
    super.key,
    required this.info,
    required this.mode,
    required this.formatter,
    this.onOpenSettings,
    this.onLeave,
    this.onOpenArchive,
  });

  final SpaceMembershipInfo info;
  final BalanceVisibilityMode mode;
  final PrivacyFormatter formatter;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onLeave;
  final VoidCallback? onOpenArchive;

  Color get _iconColor =>
      parseMemberColorHex(info.iconColor) ?? AppColors.surfaceElevated;

  @override
  Widget build(BuildContext context) {
    final dissolved = info.isDissolved;
    final df = DateFormat('dd.MM.yyyy');
    final meta = dissolved
        ? (info.dissolvedAt == null
            ? 'Расформировано'
            : 'Расформировано ${df.format(info.dissolvedAt!.toLocal())}')
        : '${info.memberCount} участников · Присоединился ${df.format(info.joinedAt.toLocal())}';
    return Opacity(
      opacity: dissolved ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      dissolved ? AppColors.surfaceElevated : _iconColor,
                  child: Text(
                    dissolved ? '🗑' : (info.iconEmoji ?? '🏠'),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    formatter.formatSpaceName(info.spaceName, mode),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _roleBadge(dissolved),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              meta,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (!dissolved && onOpenSettings != null)
                  OutlinedButton.icon(
                    onPressed: onOpenSettings,
                    icon: const Icon(Icons.settings_outlined, size: 18),
                    label: const Text('Настройки'),
                  ),
                if (!dissolved && onLeave != null)
                  OutlinedButton.icon(
                    onPressed: onLeave,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.colorWarning,
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Выйти'),
                  ),
                if (dissolved)
                  (onOpenArchive == null
                      ? Tooltip(
                          message: 'Появится в под-шаге 21.6',
                          child: OutlinedButton.icon(
                            onPressed: null,
                            icon: const Icon(
                              Icons.bar_chart_outlined,
                              size: 18,
                            ),
                            label: const Text('Посмотреть архив'),
                          ),
                        )
                      : OutlinedButton.icon(
                          onPressed: onOpenArchive,
                          icon: const Icon(
                            Icons.bar_chart_outlined,
                            size: 18,
                          ),
                          label: const Text('Посмотреть архив'),
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleBadge(bool dissolved) {
    final Color bg;
    final Color fg;
    final String label;
    if (dissolved) {
      bg = AppColors.surfaceElevated;
      fg = AppColors.textSecondary;
      label = '🗑 Архив';
    } else if (info.isAdmin) {
      bg = AppColors.colorWarning.withValues(alpha: 0.2);
      fg = AppColors.colorWarning;
      label = '👑 Админ';
    } else {
      bg = AppColors.colorTransfer.withValues(alpha: 0.2);
      fg = AppColors.colorTransfer;
      label = '👤 Участник';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
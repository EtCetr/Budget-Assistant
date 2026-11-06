// lib/features/settings/presentation/widgets/settings_navigation_item.dart
// Этап 21 (ТЗ 6.3.38): пункт с навигацией/действием (shared-виджет).
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

class SettingsNavigationItem extends StatelessWidget {
  const SettingsNavigationItem({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.badge,
    this.badgeColor = AppColors.colorWarning,
    this.enabled = true,
    this.tooltip,
    this.iconColor = AppColors.textPrimary,
    this.showArrow = true,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final String? badge;
  final Color badgeColor;
  final bool enabled;
  final String? tooltip;
  final Color iconColor;
  final bool showArrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final row = InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: enabled
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
    final dimmed = Opacity(opacity: enabled ? 1 : 0.5, child: row);
    if (tooltip == null) return dimmed;
    return Tooltip(message: tooltip!, child: dimmed);
  }
}
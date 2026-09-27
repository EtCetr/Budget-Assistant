import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../reminders_strings.dart';

/// Бейдж области: «Личное» / «Семейное» (метаданные приватности,
/// видимы во всех режимах).
class ReminderAreaBadge extends StatelessWidget {
  const ReminderAreaBadge({super.key, required this.isFamily});

  final bool isFamily;

  @override
  Widget build(BuildContext context) {
    final color = isFamily ? const Color(0xFF14B8A6) : AppColors.colorTransfer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isFamily
            ? RemindersStrings.badgeFamily
            : RemindersStrings.badgePersonal,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
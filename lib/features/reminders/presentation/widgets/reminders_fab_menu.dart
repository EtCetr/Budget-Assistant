import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../reminders_strings.dart';

/// FAB-меню создания (ТЗ 6.3.10.8): кастомное / из регулярного платежа.
Future<void> showRemindersFabMenu(BuildContext context) async {
  // Хаптик без await: context используется синхронно (lint).
  MotionTokens.heavy();
  await showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications_outlined,
                  color: AppColors.colorFAB),
              title: const Text(RemindersStrings.fabCustom),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push('/reminders/create?type=custom');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.repeat, color: AppColors.colorTransfer),
              title: const Text(RemindersStrings.fabFromRecurring),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push('/reminders/create?type=from_recurring');
              },
            ),
          ],
        ),
      );
    },
  );
}
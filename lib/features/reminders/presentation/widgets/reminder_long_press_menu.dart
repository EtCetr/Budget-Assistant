import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminders_providers.dart';
import '../providers/reminder_details_providers.dart';
import '../reminders_strings.dart';
import 'snooze_bottom_sheet.dart';

/// Long-press меню карточки (ТЗ 6.3.10.7): открыть / редактировать /
/// отложить / удалить (+ переход к регулярке).
Future<void> showReminderLongPressMenu(
  BuildContext context,
  WidgetRef ref,
  Reminder reminder,
) async {
  // ScaffoldMessenger берём ДО любых await (lint use_build_context_synchronously).
  final messenger = ScaffoldMessenger.of(context);
  MotionTokens.medium();
  final canEdit = await ref.read(canEditReminderProvider(reminder).future);
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text(RemindersStrings.menuOpen),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push('/reminders/${reminder.id}');
              },
            ),
            if (canEdit)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text(RemindersStrings.menuEdit),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.push('/reminders/create?id=${reminder.id}');
                },
              ),
            ListTile(
              leading: const Icon(Icons.snooze),
              title: const Text(RemindersStrings.menuSnooze),
              onTap: () {
                Navigator.of(sheetContext).pop();
                showSnoozeBottomSheet(context, ref, reminder);
              },
            ),
            if (reminder.linkedRecurringId != null)
              ListTile(
                leading: const Icon(Icons.repeat),
                title: const Text(RemindersStrings.menuGoRecurring),
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
            if (canEdit)
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: AppColors.colorExpense),
                title: const Text(RemindersStrings.menuDelete),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text(RemindersStrings.deleteConfirmTitle),
                      content: const Text(RemindersStrings.deleteConfirmText),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: const Text(RemindersStrings.cancel),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          child: const Text(RemindersStrings.delete),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true) return;
                  await ref.read(deleteReminderUseCaseProvider)(reminder.id);
                  messenger.showSnackBar(
                    const SnackBar(
                        content: Text(RemindersStrings.snackbarDeleted)),
                  );
                },
              ),
          ],
        ),
      );
    },
  );
}
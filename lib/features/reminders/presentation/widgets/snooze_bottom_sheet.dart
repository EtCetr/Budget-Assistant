import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminders_providers.dart';
import '../reminders_strings.dart';

/// BottomSheet «Отложить»: DatePicker + TimePicker (ТЗ 6.3.11.7).
Future<void> showSnoozeBottomSheet(
  BuildContext context,
  WidgetRef ref,
  Reminder reminder,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final initial = reminder.remindAt.toLocal().add(const Duration(days: 1));
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime.now().subtract(const Duration(days: 1)),
    lastDate: DateTime.now().add(const Duration(days: 3650)),
  );
  if (date == null || !context.mounted) return;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return;
  await MotionTokens.medium();
  final local =
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
  await ref.read(snoozeReminderUseCaseProvider)(
    reminderId: reminder.id,
    newRemindAtUtc: local.toUtc(),
  );
  if (reminder.snoozeCount + 1 >= 3) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text(RemindersStrings.snoozeWarning),
        backgroundColor: AppColors.colorWarning,
      ),
    );
  }
}
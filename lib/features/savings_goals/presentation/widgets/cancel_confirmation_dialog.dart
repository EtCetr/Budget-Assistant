import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../savings_goals_strings.dart';

/// Диалог подтверждения отмены создания/редактирования (ТЗ 6.3.17.8).
///
/// Возвращает true, если пользователь решил отменить.
Future<bool> showCancelConfirmationDialog(
  BuildContext context, {
  required bool isEdit,
}) async {
  HapticFeedback.mediumImpact();
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        isEdit
            ? SavingsGoalsStrings.cancelEditTitle
            : SavingsGoalsStrings.cancelCreateTitle,
      ),
      content: const Text(SavingsGoalsStrings.cancelSubtitle),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(SavingsGoalsStrings.continueEditing),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(SavingsGoalsStrings.discardAction),
        ),
      ],
    ),
  );
  return result ?? false;
}
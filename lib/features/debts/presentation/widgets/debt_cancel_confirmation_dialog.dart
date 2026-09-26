import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../debts_strings.dart';

/// Confirm-диалог отмены создания/редактирования долга (6.3.14.2).
Future<bool> showDebtCancelConfirmationDialog(
  BuildContext context, {
  required bool isEdit,
}) async {
  HapticFeedback.mediumImpact();
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        isEdit
            ? DebtsStrings.cancelEditTitle
            : DebtsStrings.cancelCreateTitle,
      ),
      content: const Text(DebtsStrings.cancelSubtitle),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(DebtsStrings.continueEditing),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(DebtsStrings.discardAction),
        ),
      ],
    ),
  );
  return result ?? false;
}
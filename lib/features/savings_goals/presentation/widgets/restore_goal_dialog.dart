import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/savings_goals_providers.dart';
import '../savings_goals_strings.dart';

/// Диалог подтверждения восстановления цели из архива (ТЗ 6.3.47.7).
class RestoreGoalDialog extends ConsumerWidget {
  const RestoreGoalDialog({super.key, required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text(SavingsGoalsStrings.restoreTitle),
      content: const Text(SavingsGoalsStrings.restoreText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(SavingsGoalsStrings.cancel),
        ),
        FilledButton(
          onPressed: () => _restore(ref, context),
          child: const Text(SavingsGoalsStrings.actionRestore),
        ),
      ],
    );
  }

  Future<void> _restore(WidgetRef ref, BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(restoreSavingsGoalUseCaseProvider)(goal.id);
      messenger.showSnackBar(const SnackBar(
        content: Text(SavingsGoalsStrings.restoreSuccess),
      ));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
        content: Text(SavingsGoalsStrings.operationFailed),
      ));
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
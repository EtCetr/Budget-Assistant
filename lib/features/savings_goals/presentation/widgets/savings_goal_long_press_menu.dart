import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/usecases/archive_savings_goal_usecase.dart';
import '../providers/savings_goals_providers.dart';
import '../savings_goals_strings.dart';
import 'contribute_to_goal_sheet.dart';
import 'withdraw_from_goal_sheet.dart';

Future<void> showSavingsGoalLongPressMenu(
  BuildContext context,
  SavingsGoal goal,
) {
  return showModalBottomSheet(
    context: context,
    builder: (sheetContext) => _SavingsGoalLongPressMenu(
      goal: goal,
      rootContext: context,
      sheetContext: sheetContext,
    ),
  );
}

class _SavingsGoalLongPressMenu extends ConsumerWidget {
  const _SavingsGoalLongPressMenu({
    required this.goal,
    required this.rootContext,
    required this.sheetContext,
  });
  final SavingsGoal goal;
  final BuildContext rootContext;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text(SavingsGoalsStrings.actionEdit),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(sheetContext).pop();
              rootContext.push('/savings-goals/create?id=${goal.id}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text(SavingsGoalsStrings.actionContribute),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(sheetContext).pop();
              showModalBottomSheet(
                context: rootContext,
                isScrollControlled: true,
                builder: (_) => ContributeToGoalSheet(goal: goal),
              );
            },
          ),
          if (goal.currentAmount > 0)
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text(SavingsGoalsStrings.actionWithdraw),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(sheetContext).pop();
                showModalBottomSheet(
                  context: rootContext,
                  isScrollControlled: true,
                  builder: (_) => WithdrawFromGoalSheet(goal: goal),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text(SavingsGoalsStrings.actionArchive),
            onTap: () {
              HapticFeedback.lightImpact();
              // Читаем UseCase ДО закрытия меню: после pop ref меню мёртв.
              final useCase = ref.read(archiveSavingsGoalUseCaseProvider);
              Navigator.of(sheetContext).pop();
              _confirmArchive(rootContext, useCase, goal);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _confirmArchive(
  BuildContext rootContext,
  ArchiveSavingsGoalUseCase useCase,
  SavingsGoal goal,
) async {
  final confirmed = await showDialog<bool>(
    context: rootContext,
    builder: (dialogContext) => AlertDialog(
      title: const Text(SavingsGoalsStrings.archiveTitle),
      content: const Text(SavingsGoalsStrings.archiveText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(SavingsGoalsStrings.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(SavingsGoalsStrings.actionArchive),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  if (!rootContext.mounted) return;
  final messenger = ScaffoldMessenger.of(rootContext);
  try {
    await useCase(goal.id);
    messenger.showSnackBar(const SnackBar(
      content: Text(SavingsGoalsStrings.archiveSuccess),
    ));
  } catch (_) {
    messenger.showSnackBar(const SnackBar(
      content: Text(SavingsGoalsStrings.operationFailed),
    ));
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/savings_goals_providers.dart';
import '../savings_goals_strings.dart';

/// Диалог достижения цели с конфетти (ТЗ 6.3.16.6).
///
/// В hidden режиме не показывается (проверка на экране).
class GoalAchievedDialog extends ConsumerWidget {
  const GoalAchievedDialog({super.key, required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/confetti.json',
            height: 140,
            repeat: false,
          ),
          const SizedBox(height: AppSpacing.spacing12),
          Text(
            SavingsGoalsStrings.achievedTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.spacing8),
          Text(
            formatter.formatName(goal.name, mode),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            '${formatter.formatAmount(goal.currentAmount, goal.currency, mode)}'
            ' / '
            '${formatter.formatAmount(goal.targetAmount, goal.currency, mode)}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(SavingsGoalsStrings.continueSaving),
        ),
        FilledButton(
          onPressed: () => _complete(ref, context),
          child: const Text(SavingsGoalsStrings.markCompleted),
        ),
      ],
    );
  }

  Future<void> _complete(WidgetRef ref, BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(completeSavingsGoalUseCaseProvider)(goal.id);
      messenger.showSnackBar(const SnackBar(
        content: Text(SavingsGoalsStrings.completeSuccess),
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
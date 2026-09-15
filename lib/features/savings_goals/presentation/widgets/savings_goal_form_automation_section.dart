import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/create_savings_goal_providers.dart';
import '../savings_goals_strings.dart';

/// Секция «Автоматизация» (ТЗ 6.3.17.5).
///
/// Регулярное пополнение отключено до Этапа 14 (нет таблицы
/// recurring_transactions) — решение владельца.
class SavingsGoalFormAutomationSection extends ConsumerWidget {
  const SavingsGoalFormAutomationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createSavingsGoalFormProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SavingsGoalsStrings.formSectionAutomation,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        CheckboxListTile(
          value: form.autoReminderEnabled,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            ref
                .read(createSavingsGoalFormProvider.notifier)
                .setAutoReminder(value ?? false);
          },
          title: const Text(SavingsGoalsStrings.autoReminderTitle),
          subtitle: const Text(SavingsGoalsStrings.autoReminderHint),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const CheckboxListTile(
          value: false,
          onChanged: null,
          title: Text(SavingsGoalsStrings.recurringTitle),
          subtitle: Text(SavingsGoalsStrings.recurringDisabled),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
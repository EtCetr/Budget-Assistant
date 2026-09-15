import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/create_savings_goal_providers.dart';
import '../savings_goals_strings.dart';
import 'account_selector_dropdown.dart';

/// Секция «Тип цели»: виртуальная / привязанная к счёту (ТЗ 6.3.17.4).
class SavingsGoalFormTypeSection extends ConsumerWidget {
  const SavingsGoalFormTypeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createSavingsGoalFormProvider);
    final theme = Theme.of(context);
    final isLinked = form.goalType == SavingsGoalType.linked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SavingsGoalsStrings.formSectionType,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          children: [
            Expanded(
              child: SavingsFormChoiceButton(
                label: SavingsGoalsStrings.typeVirtual,
                isActive: !isLinked,
                activeColor: AppColors.colorTransfer,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(createSavingsGoalFormProvider.notifier)
                      .setGoalType(SavingsGoalType.virtual);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Expanded(
              child: SavingsFormChoiceButton(
                label: SavingsGoalsStrings.typeLinked,
                isActive: isLinked,
                activeColor: AppColors.colorIncome,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(createSavingsGoalFormProvider.notifier)
                      .setGoalType(SavingsGoalType.linked);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing12),
        if (isLinked)
          const AccountSelectorDropdown()
        else
          Text(
            SavingsGoalsStrings.typeVirtualHint,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
      ],
    );
  }
}

/// Общая кнопка сегментированного выбора для секций формы.
class SavingsFormChoiceButton extends StatelessWidget {
  const SavingsFormChoiceButton({
    super.key,
    required this.label,
    required this.isActive,
    this.activeColor = AppColors.colorTransfer,
    this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing12,
          vertical: AppSpacing.spacing12,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
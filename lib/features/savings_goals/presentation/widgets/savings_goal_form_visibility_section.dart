import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/create_savings_goal_providers.dart';
import '../savings_goals_strings.dart';
import 'savings_goal_form_type_section.dart';

/// Секция «Область видимости»: личная / семейная (ТЗ 6.3.17.6).
///
/// «Вся семья» недоступна, если у пользователя нет активного пространства.
class SavingsGoalFormVisibilitySection extends ConsumerWidget {
  const SavingsGoalFormVisibilitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createSavingsGoalFormProvider);
    final canUseFamily = ref.watch(canUseFamilyVisibilityProvider);
    final theme = Theme.of(context);
    final isFamily = form.visibility == SavingsGoalVisibility.family;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SavingsGoalsStrings.formSectionVisibility,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          children: [
            Expanded(
              child: SavingsFormChoiceButton(
                label: SavingsGoalsStrings.visibilityPersonal,
                isActive: !isFamily,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(createSavingsGoalFormProvider.notifier)
                      .setVisibility(SavingsGoalVisibility.personal);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Expanded(
              child: Opacity(
                opacity: canUseFamily ? 1.0 : 0.5,
                child: SavingsFormChoiceButton(
                  label: SavingsGoalsStrings.visibilityFamily,
                  isActive: isFamily,
                  onTap: canUseFamily
                      ? () {
                          HapticFeedback.selectionClick();
                          ref
                              .read(createSavingsGoalFormProvider.notifier)
                              .setVisibility(SavingsGoalVisibility.family);
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          canUseFamily
              ? SavingsGoalsStrings.visibilityHint
              : SavingsGoalsStrings.familyUnavailable,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
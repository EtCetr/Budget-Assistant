import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/create_savings_goal_providers.dart';
import '../providers/savings_goals_providers.dart';
import '../savings_goals_strings.dart';

/// Live-предпросмотр плана накопления (ТЗ 6.3.17.3).
///
/// Расчёт целочисленный (копейки), поэтому дебаунс не нужен.
/// Сумма маскируется через PrivacyFormatter в partial/hidden.
class SavingsPlanPreview extends ConsumerWidget {
  const SavingsPlanPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createSavingsGoalFormProvider);
    final amount = MoneyInputParser.parseKopecks(form.amountText);
    if (amount == null || amount <= 0) {
      return const SizedBox.shrink();
    }
    final plan = ref.watch(calculateSavingsPlanUseCaseProvider)(
      targetAmountKopecks: amount,
      deadline: form.deadline,
    );
    if (plan.monthlyAmountKopecks <= 0) {
      return const SizedBox.shrink();
    }
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final monthly =
        formatter.formatAmount(plan.monthlyAmountKopecks, form.currency, mode);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      child: Text(
        '${SavingsGoalsStrings.planMonthlyPrefix} $monthly '
        '${SavingsGoalsStrings.planMonthlySuffix}, '
        '${form.deadline == null ? SavingsGoalsStrings.planTenYears : SavingsGoalsStrings.planByDeadline}',
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
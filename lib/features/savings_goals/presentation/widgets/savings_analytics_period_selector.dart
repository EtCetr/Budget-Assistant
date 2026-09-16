import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../providers/savings_analytics_providers.dart';
import '../savings_goals_strings.dart';
import 'savings_goal_form_type_section.dart';

/// Четырёхсегментный переключатель периода (ТЗ 6.3.18.3).
class SavingsAnalyticsPeriodSelector extends ConsumerWidget {
  const SavingsAnalyticsPeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(analyticsPeriodProvider);
    Widget segment(AnalyticsPeriod value, String label) {
      return Expanded(
        child: SavingsFormChoiceButton(
          label: label,
          isActive: period == value,
          activeColor: AppColors.colorIncome,
          onTap: () {
            HapticFeedback.selectionClick();
            ref.read(analyticsPeriodProvider.notifier).set(value);
          },
        ),
      );
    }

    return Row(
      children: [
        segment(AnalyticsPeriod.month, SavingsGoalsStrings.periodMonth),
        const SizedBox(width: AppSpacing.spacing8),
        segment(AnalyticsPeriod.quarter, SavingsGoalsStrings.periodQuarter),
        const SizedBox(width: AppSpacing.spacing8),
        segment(AnalyticsPeriod.year, SavingsGoalsStrings.periodYear),
        const SizedBox(width: AppSpacing.spacing8),
        segment(AnalyticsPeriod.allTime, SavingsGoalsStrings.periodAllTime),
      ],
    );
  }
}
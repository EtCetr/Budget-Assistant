import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/repositories/reminders_repository.dart';
import '../providers/reminders_screen_providers.dart';
import '../reminders_strings.dart';

/// Горизонтальные чипы фильтров (WHERE в SQL, ТЗ 6.3.10.4).
/// В hidden все чипы серые.
class RemindersFilterRow extends ConsumerWidget {
  const RemindersFilterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(remindersFilterProvider);
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    const items = <(RemindersUpcomingFilter, String, Color)>[
      (RemindersUpcomingFilter.all, RemindersStrings.filterAll,
          AppColors.textSecondary),
      (RemindersUpcomingFilter.mine, RemindersStrings.filterMine,
          AppColors.colorTransfer),
      (RemindersUpcomingFilter.assignedToMe,
          RemindersStrings.filterAssigned, AppColors.colorIncome),
      (RemindersUpcomingFilter.overdue, RemindersStrings.filterOverdue,
          AppColors.colorExpense),
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppSpacing.spacing8),
        itemBuilder: (context, index) {
          final (filter, label, color) = items[index];
          final selected = active == filter;
          final chipColor = hidden ? AppColors.textSecondary : color;
          return FilterChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) {
              MotionTokens.selection();
              ref.read(remindersFilterProvider.notifier).set(filter);
            },
            selectedColor: chipColor.withValues(alpha: 0.25),
            side: BorderSide(
              color: selected ? chipColor : AppColors.borderDivider,
            ),
            labelStyle: TextStyle(
              color: selected ? chipColor : AppColors.textSecondary,
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/repositories/savings_goals_repository.dart';
import '../providers/savings_goals_screen_providers.dart';
import '../savings_goals_strings.dart';

class SavingsFilterOption<T> {
  const SavingsFilterOption({
    required this.value,
    required this.label,
    this.activeColor,
  });
  final T value;
  final String label;
  final Color? activeColor;
}

class SavingsFilterChipRow<T> extends StatelessWidget {
  const SavingsFilterChipRow({
    super.key,
    required this.selected,
    required this.options,
    required this.onSelected,
  });
  final T selected;
  final List<SavingsFilterOption<T>> options;
  final ValueChanged<T> onSelected;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.spacing8),
        itemBuilder: (context, index) {
          final option = options[index];
          final isActive = option.value == selected;
          final background = isActive && option.activeColor != null
              ? option.activeColor!
              : AppColors.surfaceElevated;
          final foreground = isActive && option.activeColor != null
              ? Colors.white
              : AppColors.textSecondary;
          return InkWell(
            borderRadius: AppRadius.radiusFull,
            onTap: () => onSelected(option.value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing12),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: background, borderRadius: AppRadius.radiusFull),
              child: Text(option.label,
                  style: TextStyle(color: foreground, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
            ),
          );
        },
      ),
    );
  }
}

/// Фильтры активных целей: ОДИН горизонтальный скроллируемый ряд.
/// Тип (Все/Виртуальные/Привязанные) взаимно исключающий; «С дедлайном» —
/// независимый тумблер, комбинируется с типом (решение владельца).
class SavingsGoalsFilterRow extends ConsumerWidget {
  const SavingsGoalsFilterRow({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(savingsGoalsFilterProvider);
    final withDeadline = ref.watch(savingsGoalsWithDeadlineProvider);
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    Color? color(Color v) => hidden ? null : v;

    Widget chip({
      required String label,
      required bool active,
      Color? activeColor,
      required VoidCallback onTap,
    }) {
      final background = active && activeColor != null
          ? activeColor
          : AppColors.surfaceElevated;
      final foreground = active && activeColor != null
          ? Colors.white
          : AppColors.textSecondary;
      return InkWell(
        borderRadius: AppRadius.radiusFull,
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing12),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: background, borderRadius: AppRadius.radiusFull),
          child: Text(label,
              style: TextStyle(color: foreground, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
        ),
      );
    }

    void setType(SavingsGoalsFilter f) {
      HapticFeedback.selectionClick();
      final notifier = ref.read(savingsGoalsFilterProvider.notifier);
      if (f == selected && f != SavingsGoalsFilter.all) {
        notifier.set(SavingsGoalsFilter.all);
      } else {
        notifier.set(f);
      }
    }

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
        children: [
          chip(
            label: SavingsGoalsStrings.filterAll,
            active: selected == SavingsGoalsFilter.all,
            activeColor: AppColors.textSecondary,
            onTap: () => setType(SavingsGoalsFilter.all),
          ),
          const SizedBox(width: AppSpacing.spacing8),
          chip(
            label: SavingsGoalsStrings.filterVirtual,
            active: selected == SavingsGoalsFilter.virtual,
            activeColor: color(AppColors.colorTransfer),
            onTap: () => setType(SavingsGoalsFilter.virtual),
          ),
          const SizedBox(width: AppSpacing.spacing8),
          chip(
            label: SavingsGoalsStrings.filterLinked,
            active: selected == SavingsGoalsFilter.linked,
            activeColor: color(AppColors.colorIncome),
            onTap: () => setType(SavingsGoalsFilter.linked),
          ),
          const SizedBox(width: AppSpacing.spacing8),
          chip(
            label: SavingsGoalsStrings.filterWithDeadline,
            active: withDeadline,
            activeColor: color(AppColors.colorWarning),
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(savingsGoalsWithDeadlineProvider.notifier).toggle();
            },
          ),
        ],
      ),
    );
  }
}

class SavingsArchiveFilterRow extends ConsumerWidget {
  const SavingsArchiveFilterRow({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(savingsArchiveFilterProvider);
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    Color? color(Color v) => hidden ? null : v;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.spacing8, bottom: AppSpacing.spacing4),
      child: SavingsFilterChipRow<SavingsArchiveFilter>(
        selected: selected,
        onSelected: (filter) {
          HapticFeedback.selectionClick();
          final notifier = ref.read(savingsArchiveFilterProvider.notifier);
          if (filter == selected && filter != SavingsArchiveFilter.all) {
            notifier.set(SavingsArchiveFilter.all);
          } else {
            notifier.set(filter);
          }
        },
        options: [
          const SavingsFilterOption(value: SavingsArchiveFilter.all, label: SavingsGoalsStrings.filterAll, activeColor: AppColors.textSecondary),
          SavingsFilterOption(value: SavingsArchiveFilter.completed, label: SavingsGoalsStrings.filterCompleted, activeColor: color(AppColors.colorIncome)),
          SavingsFilterOption(value: SavingsArchiveFilter.cancelled, label: SavingsGoalsStrings.filterCancelled, activeColor: color(AppColors.colorExpense)),
        ],
      ),
    );
  }
}
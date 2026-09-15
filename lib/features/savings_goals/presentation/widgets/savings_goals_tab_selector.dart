import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../providers/savings_goals_screen_providers.dart';
import '../savings_goals_strings.dart';

/// Двухсегментный переключатель «Активные / Архив» со счётчиками
/// (ТЗ 6.3.16.3).
class SavingsGoalsTabSelector extends ConsumerWidget {
  const SavingsGoalsTabSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(savingsGoalsTabProvider);
    final activeCount =
        ref.watch(allActiveSavingsGoalsProvider).value?.length ?? 0;
    final archiveCount =
        ref.watch(allArchivedSavingsGoalsProvider).value?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing12,
        AppSpacing.spacing16,
        AppSpacing.spacing4,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabSegment(
              label: '${SavingsGoalsStrings.tabActive} ($activeCount)',
              isActive: tab == SavingsGoalsTab.active,
              activeColor: AppColors.colorIncome,
              onTap: () => _select(ref, SavingsGoalsTab.active),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing8),
          Expanded(
            child: _TabSegment(
              label: '${SavingsGoalsStrings.tabArchive} ($archiveCount)',
              isActive: tab == SavingsGoalsTab.archive,
              activeColor: AppColors.textSecondary,
              onTap: () => _select(ref, SavingsGoalsTab.archive),
            ),
          ),
        ],
      ),
    );
  }

  void _select(WidgetRef ref, SavingsGoalsTab tab) {
    HapticFeedback.selectionClick();
    ref.read(savingsGoalsTabProvider.notifier).set(tab);
  }
}

class _TabSegment extends StatelessWidget {
  const _TabSegment({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
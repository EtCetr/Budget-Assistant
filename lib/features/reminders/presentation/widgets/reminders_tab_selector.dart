import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../providers/reminders_screen_providers.dart';
import '../reminders_strings.dart';

/// Сегментный переключатель «Предстоящие (N) / История» (ТЗ 6.3.10.3).
class RemindersTabSelector extends ConsumerWidget {
  const RemindersTabSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(remindersTabProvider);
    final count = ref.watch(upcomingCountProvider).value ?? 0;
    Widget segment(RemindersTab value, String label) {
      final active = tab == value;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            MotionTokens.selection();
            ref.read(remindersTabProvider.notifier).set(value);
          },
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.spacing4),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? AppColors.colorIncome : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
      ),
      child: Row(
        children: [
          segment(
            RemindersTab.upcoming,
            '${RemindersStrings.tabUpcoming} ($count)',
          ),
          segment(RemindersTab.history, RemindersStrings.tabHistory),
        ],
      ),
    );
  }
}
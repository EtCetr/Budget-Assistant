import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../debts_strings.dart';
import '../providers/debts_screen_providers.dart';

/// Горизонтальный ряд фильтрующих чипов (6.3.13.5).
/// В hidden-режиме все чипы серые (Privacy Matrix).
class DebtsFilterRow extends ConsumerWidget {
  const DebtsFilterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(debtsScreenFilterProvider);
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    Color? color(Color v) => hidden ? null : v;

    Widget chip({
      required String label,
      required DebtsScreenFilter value,
      Color? activeColor,
    }) {
      final isActive = selected == value;
      final background = isActive && activeColor != null
          ? activeColor
          : AppColors.surfaceElevated;
      final foreground = isActive && activeColor != null
          ? Colors.white
          : AppColors.textSecondary;
      return InkWell(
        borderRadius: AppRadius.radiusFull,
        onTap: () {
          HapticFeedback.selectionClick();
          ref.read(debtsScreenFilterProvider.notifier).set(value);
        },
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppRadius.radiusFull,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
        children: [
          chip(
            label: DebtsStrings.filterAll,
            value: DebtsScreenFilter.all,
            activeColor: color(AppColors.textSecondary),
          ),
          const SizedBox(width: AppSpacing.spacing8),
          chip(
            label: DebtsStrings.filterActive,
            value: DebtsScreenFilter.active,
            activeColor: color(AppColors.colorIncome),
          ),
          const SizedBox(width: AppSpacing.spacing8),
          chip(
            label: DebtsStrings.filterOverdue,
            value: DebtsScreenFilter.overdue,
            activeColor: color(AppColors.colorExpense),
          ),
          const SizedBox(width: AppSpacing.spacing8),
          chip(
            label: DebtsStrings.filterResolved,
            value: DebtsScreenFilter.resolved,
            activeColor: color(AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
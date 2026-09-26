import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../domain/entities/debt.dart';
import '../debts_strings.dart';

/// Бейдж типа долга: Payable / Receivable / Resolved (6.3.13.6).
class DebtTypeBadge extends StatelessWidget {
  const DebtTypeBadge({super.key, required this.debt});

  final Debt debt;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    final String icon;
    if (!debt.isActive) {
      color = AppColors.textSecondary;
      label = DebtsStrings.badgeResolved;
      icon = '✓';
    } else if (debt.directionFor(_directionUserId()) == DebtDirection.payable) {
      color = AppColors.colorExpense;
      label = DebtsStrings.badgePayable;
      icon = '💳';
    } else {
      color = AppColors.colorIncome;
      label = DebtsStrings.badgeReceivable;
      icon = '💰';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$icon $label',
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Направление определяется по NULL-стороне (D13-2): если должник
  /// NULL — долг внешний и направлен «мне должны» относительно кредитора;
  /// для бейджа достаточно знака направления относительно владельца записи.
  String _directionUserId() => debt.debtorId ?? debt.creditorId ?? '';
}
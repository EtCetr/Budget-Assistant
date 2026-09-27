import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Индикатор приоритета напоминания (ТЗ 6.3.10.5): красный/жёлтый/зелёный.
class PriorityIndicator extends StatelessWidget {
  const PriorityIndicator({super.key, required this.priority, this.size = 24});

  final String priority;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      'high' => AppColors.colorExpense,
      'low' => AppColors.colorIncome,
      _ => AppColors.colorWarning,
    };
    return Icon(Icons.circle, size: size, color: color);
  }
}
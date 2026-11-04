import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';

/// Крупный моноширинный номер карты группами по 4 (ТЗ 6.3.21.6):
/// fallback для сканера и для типа manual.
class CardNumberDisplay extends StatelessWidget {
  const CardNumberDisplay({
    super.key,
    required this.number,
    this.color,
    this.fontSize = 40,
  });

  final String number;
  final Color? color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing24,
        vertical: AppSpacing.spacing24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Text(
        number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: fontSize,
          letterSpacing: 4,
          fontWeight: FontWeight.w700,
          color: color ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
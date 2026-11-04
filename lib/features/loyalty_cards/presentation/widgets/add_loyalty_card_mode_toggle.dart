import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../loyalty_cards_strings.dart';

/// Переключатель режимов: сканер / ручной ввод (ТЗ 6.3.20.4).
class AddLoyaltyCardModeToggle extends StatelessWidget {
  const AddLoyaltyCardModeToggle({
    super.key,
    required this.isScanMode,
    required this.onChanged,
  });

  final bool isScanMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _segment(
          label: LoyaltyCardsStrings.modeScan,
          icon: Icons.qr_code_scanner,
          active: isScanMode,
          onTap: () {
            MotionTokens.selection();
            onChanged(true);
          },
        ),
        const SizedBox(width: AppSpacing.spacing8),
        _segment(
          label: LoyaltyCardsStrings.modeManual,
          icon: Icons.edit_outlined,
          active: !isScanMode,
          onTap: () {
            MotionTokens.selection();
            onChanged(false);
          },
        ),
      ],
    );
  }

  Widget _segment({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: AppRadius.radiusFull,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing12,
            vertical: AppSpacing.spacing8,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.colorFAB : AppColors.surfaceCard,
            borderRadius: AppRadius.radiusFull,
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: active ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: AppSpacing.spacing8),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
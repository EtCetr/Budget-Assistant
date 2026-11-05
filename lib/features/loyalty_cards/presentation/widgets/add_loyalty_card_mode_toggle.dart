import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../loyalty_cards_strings.dart';

/// Переключатель режимов (ТЗ 6.3.20.4): галерея / сканер / ручной ввод.
/// Галерея — первая: большинство карт хранится скриншотами (решение владельца).
class AddLoyaltyCardModeToggle extends StatelessWidget {
  const AddLoyaltyCardModeToggle({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  /// 'gallery' | 'scan' | 'manual'
  final String mode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _segment('gallery', LoyaltyCardsStrings.modeGallery,
            Icons.photo_library_outlined, mode, onChanged),
        _segment('scan', LoyaltyCardsStrings.modeScan,
            Icons.qr_code_scanner, mode, onChanged),
        _segment('manual', LoyaltyCardsStrings.modeManual,
            Icons.edit_outlined, mode, onChanged),
      ],
    );
  }

  Widget _segment(
    String value,
    String label,
    IconData icon,
    String current,
    ValueChanged<String> onChanged,
  ) {
    final active = current == value;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.spacing8),
        child: InkWell(
          borderRadius: AppRadius.radiusFull,
          onTap: () {
            MotionTokens.selection();
            onChanged(value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing8,
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
                    size: 16,
                    color: active ? Colors.white : AppColors.textSecondary),
                const SizedBox(width: AppSpacing.spacing4),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: active ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
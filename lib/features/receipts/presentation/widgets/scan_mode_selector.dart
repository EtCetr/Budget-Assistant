import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion_tokens.dart';
import '../labels/receipts_strings.dart';

class ScanModeSelector extends StatelessWidget {
  const ScanModeSelector({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final String mode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _button('qr', Icons.qr_code_scanner, ReceiptsStrings.modeQr, AppColors.colorFAB),
          const SizedBox(width: 8),
          _button('ocr', Icons.edit_note, ReceiptsStrings.modeOcr, AppColors.colorTransfer),
          const SizedBox(width: 8),
          _button('gallery', Icons.photo_library_outlined, ReceiptsStrings.modeGallery, AppColors.colorIncome),
        ],
      ),
    );
  }

  Widget _button(String value, IconData icon, String label, Color activeColor) {
    final active = mode == value;
    return Expanded(
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: active ? activeColor : AppColors.surfaceCard,
          foregroundColor: active ? Colors.white : AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {
          MotionTokens.selection();
          onChanged(value);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
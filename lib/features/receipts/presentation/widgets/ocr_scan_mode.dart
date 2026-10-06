import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion_tokens.dart';
import '../labels/receipts_strings.dart';

/// OCR-режим (отклонение Q1-A): фото делает СИСТЕМНАЯ камера,
/// приложение получает готовый файл и распознаёт текст.
class OcrScanMode extends StatelessWidget {
  const OcrScanMode({super.key, required this.onPhoto});

  final ValueChanged<String> onPhoto;

  Future<void> _pick() async {
    MotionTokens.light();
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (file != null) onPhoto(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            const Text(
              ReceiptsStrings.ocrHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _pick,
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text(ReceiptsStrings.ocrButton),
            ),
          ],
        ),
      ),
    );
  }
}
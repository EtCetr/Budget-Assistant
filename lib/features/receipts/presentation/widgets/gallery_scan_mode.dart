import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion_tokens.dart';
import '../../../../features/privacy/domain/models/balance_visibility_mode.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../labels/receipts_strings.dart';

/// Галерея (отклонение Q2-A: без crop/rotate). Тип содержимого: QR или текст.
/// Privacy: partial -> blur 10, hidden -> placeholder.
class GalleryScanMode extends ConsumerWidget {
  const GalleryScanMode({
    super.key,
    required this.imagePath,
    required this.contentType,
    required this.onPicked,
    required this.onTypeChanged,
    required this.onQrRaw,
    required this.onOcrPhoto,
    required this.onFailed,
  });

  final String? imagePath;
  final String contentType;
  final ValueChanged<String> onPicked;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onQrRaw;
  final ValueChanged<String> onOcrPhoto;
  final ValueChanged<String> onFailed;

  Future<void> _pick() async {
    MotionTokens.light();
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) onPicked(file.path);
  }

  Future<void> _recognize() async {
    final path = imagePath;
    if (path == null) return;
    MotionTokens.light();
    if (contentType == 'text') {
      onOcrPhoto(path);
      return;
    }
    final controller = MobileScannerController();
    try {
      final capture = await controller.analyzeImage(path);
      final raw = capture?.barcodes.firstOrNull?.rawValue;
      if (raw != null) {
        onQrRaw(raw);
      } else {
        onFailed(ReceiptsStrings.qrParseFailed);
      }
    } catch (_) {
      onFailed(ReceiptsStrings.qrParseFailed);
    } finally {
      await controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath == null)
            FilledButton.icon(
              onPressed: _pick,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text(ReceiptsStrings.galleryPick),
            )
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: mode == BalanceVisibilityMode.hidden
                  ? Container(
                      height: 240,
                      color: AppColors.surfaceCard,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image_outlined,
                              size: 48, color: AppColors.textSecondary),
                          SizedBox(height: 8),
                          Text(ReceiptsStrings.galleryHidden,
                              style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 240,
                      child: mode == BalanceVisibilityMode.partial
                          ? ImageFiltered(
                              imageFilter:
                                  ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Image.file(File(imagePath!)),
                            )
                          : Image.file(File(imagePath!)),
                    ),
            ),
            const SizedBox(height: 12),
            Text(ReceiptsStrings.galleryTypeLabel,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'qr', label: Text(ReceiptsStrings.galleryTypeQr)),
                ButtonSegment(
                    value: 'text',
                    label: Text(ReceiptsStrings.galleryTypeText)),
              ],
              selected: {contentType},
              onSelectionChanged: (v) {
                MotionTokens.selection();
                onTypeChanged(v.first);
              },
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _recognize,
              child: const Text(ReceiptsStrings.galleryRecognize),
            ),
          ],
        ],
      ),
    );
  }
}
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/privacy/domain/models/balance_visibility_mode.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../labels/receipts_strings.dart';

/// Превью фото чека: pinch-zoom, privacy blur/hidden (ТЗ 6.3.23.2).
class ReceiptImagePreview extends ConsumerWidget {
  const ReceiptImagePreview({super.key, required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = imagePath;
    if (path == null) return const SizedBox.shrink();
    if (path.startsWith('http')) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text(ReceiptsStrings.imageCloud)),
          ),
        ),
      );
    }
    final mode = ref.watch(privacyModeProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: mode == BalanceVisibilityMode.hidden
            ? Container(
                height: 200,
                color: AppColors.surfaceCard,
                alignment: Alignment.center,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined,
                        size: 48, color: AppColors.textSecondary),
                    SizedBox(height: 8),
                    Text(ReceiptsStrings.imageHidden,
                        style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              )
            : SizedBox(
                height: 280,
                child: InteractiveViewer(
                  maxScale: 3.0,
                  child: mode == BalanceVisibilityMode.partial
                      ? ImageFiltered(
                          imageFilter:
                              ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Image.file(File(path), fit: BoxFit.contain),
                        )
                      : Image.file(File(path), fit: BoxFit.contain),
                ),
              ),
      ),
    );
  }
}
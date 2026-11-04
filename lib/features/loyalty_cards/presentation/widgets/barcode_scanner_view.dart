import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide BarcodeType;
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';

/// Камера-сканер штрих-кодов (mobile_scanner, прецедент Этапа 16).
/// При распознавании отдаёт сырое значение + тип наверх.
/// Имя BarcodeType у mobile_scanner своё — скрываем его импортом (hide).
class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key, required this.onDetected});

  final void Function(String raw, BarcodeType type) onDetected;

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _locked = false;
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  BarcodeType _mapFormat(BarcodeFormat format) => switch (format) {
        BarcodeFormat.ean13 => BarcodeType.ean13,
        BarcodeFormat.code128 => BarcodeType.code128,
        BarcodeFormat.qrCode => BarcodeType.qr,
        BarcodeFormat.pdf417 => BarcodeType.pdf417,
        _ => BarcodeType.manual,
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                if (_locked || capture.barcodes.isEmpty) return;
                final barcode = capture.barcodes.first;
                final raw = barcode.rawValue;
                if (raw == null || raw.isEmpty) return;
                _locked = true;
                MotionTokens.medium();
                widget.onDetected(raw, _mapFormat(barcode.format));
              },
              errorBuilder: (context, error) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spacing16),
                  child: Text(
                    error.errorCode == MobileScannerErrorCode.permissionDenied
                        ? LoyaltyCardsStrings.cameraDenied
                        : LoyaltyCardsStrings.cameraUnavailable,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.spacing8,
              bottom: AppSpacing.spacing8,
              child: IconButton(
                onPressed: () async {
                  MotionTokens.light();
                  await _controller.toggleTorch();
                  if (mounted) setState(() => _torchOn = !_torchOn);
                },
                icon: Icon(
                  _torchOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.spacing8,
              child: Center(
                child: Text(
                  LoyaltyCardsStrings.scanHint,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
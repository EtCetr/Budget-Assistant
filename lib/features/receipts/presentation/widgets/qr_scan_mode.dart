import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_colors.dart';
import '../labels/receipts_strings.dart';

/// In-app live-сканер QR (mobile_scanner). После первого успеха останавливается.
class QrScanMode extends StatefulWidget {
  const QrScanMode({super.key, required this.onScanned});

  final ValueChanged<String> onScanned;

  @override
  State<QrScanMode> createState() => _QrScanModeState();
}

class _QrScanModeState extends State<QrScanMode> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                final raw = capture.barcodes.firstOrNull?.rawValue;
                if (raw == null || _handled) return;
                _handled = true;
                _controller.stop();
                widget.onScanned(raw);
              },
            ),
            Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorFAB, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  ReceiptsStrings.qrHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.cameraswitch, color: Colors.white),
                onPressed: () => _controller.switchCamera(),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.flash_on, color: Colors.white),
                onPressed: () => _controller.toggleTorch(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
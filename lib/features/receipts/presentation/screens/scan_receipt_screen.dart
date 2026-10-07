import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/security_providers.dart';
import '../../../../core/theme/motion_tokens.dart';
import '../../../../features/auth/presentation/providers/current_user_provider.dart';
import '../labels/receipts_strings.dart';
import '../providers/scan_receipt_providers.dart';
import '../widgets/gallery_scan_mode.dart';
import '../widgets/ocr_scan_mode.dart';
import '../widgets/qr_scan_mode.dart';
import '../widgets/scan_mode_selector.dart';

/// Этап 16.3 (ТЗ 6.3.22): хаб сканирования чека (QR / OCR / галерея).
class ScanReceiptScreen extends ConsumerStatefulWidget {
  const ScanReceiptScreen({super.key, this.transactionId});

  final String? transactionId;

  @override
  ConsumerState<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends ConsumerState<ScanReceiptScreen> {
  bool _processing = false;

  /// Пустой query-параметр считаем отсутствующим (защита от 'съеденного' id).
  String? get _txId =>
      (widget.transactionId == null || widget.transactionId!.isEmpty)
          ? null
          : widget.transactionId;

  String _previewRoute(String receiptId) {
    final t = _txId;
    return t == null
        ? '/receipts/$receiptId/preview'
        : '/receipts/$receiptId/preview?transaction_id=$t';
  }

  Future<void> _run(Future<String?> Function() action) async {
    setState(() => _processing = true);
    try {
      String? id;
      try {
        id = await action();
      } catch (_) {
        if (!mounted) return;
        MotionTokens.error();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(ReceiptsStrings.saveFailed)),
        );
        return;
      }
      if (!mounted) return;
      if (id == null) {
        MotionTokens.error();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(ReceiptsStrings.qrParseFailed)),
        );
        return;
      }
      MotionTokens.medium();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ReceiptsStrings.scanSuccess)),
      );
      await context.push(_previewRoute(id));
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _onQrRaw(String raw) => _run(() => ref
      .read(scanReceiptQrUseCaseProvider)
      .call(
        raw: raw,
        userId: ref.read(currentUserIdProvider),
        spaceId: ref.read(currentSpaceIdProvider),
        transactionId: _txId,
      ));

  Future<void> _onOcrPhoto(String path) => _run(() => ref
      .read(scanReceiptOcrUseCaseProvider)
      .call(
        sourcePath: path,
        userId: ref.read(currentUserIdProvider),
        spaceId: ref.read(currentSpaceIdProvider),
        transactionId: _txId,
      ));

  void _showHelp() {
    MotionTokens.light();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ReceiptsStrings.helpTitle,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('1. QR: ${ReceiptsStrings.helpQr}'),
                SizedBox(height: 8),
                Text('2. OCR: ${ReceiptsStrings.helpOcr}'),
                SizedBox(height: 8),
                Text('3. Галерея: ${ReceiptsStrings.helpGallery}'),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(scanModeProvider);
    final galleryImage = ref.watch(galleryImageProvider);
    final galleryType = ref.watch(galleryContentTypeProvider);
    if (_txId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(ReceiptsStrings.scanTitle)),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              ReceiptsStrings.scanNoTransaction,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(ReceiptsStrings.scanTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              ScanModeSelector(
                mode: mode,
                onChanged: (m) =>
                    ref.read(scanModeProvider.notifier).set(m),
              ),
              if (mode == 'qr') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: QrScanMode(onScanned: _onQrRaw),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ReceiptsStrings.qrTip,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () =>
                      ref.read(scanModeProvider.notifier).set('ocr'),
                  icon: const Icon(Icons.edit_note),
                  label: const Text(ReceiptsStrings.noQrFallback),
                ),
              ],
              if (mode == 'ocr') OcrScanMode(onPhoto: _onOcrPhoto),
              if (mode == 'gallery')
                GalleryScanMode(
                  imagePath: galleryImage?.path,
                  contentType: galleryType,
                  onPicked: (p) => ref
                      .read(galleryImageProvider.notifier)
                      .set(XFile(p)),
                  onTypeChanged: (t) => ref
                      .read(galleryContentTypeProvider.notifier)
                      .set(t),
                  onQrRaw: _onQrRaw,
                  onOcrPhoto: _onOcrPhoto,
                  onFailed: (msg) {
                    MotionTokens.error();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  },
                ),
            ],
          ),
          if (_processing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      ReceiptsStrings.processing,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
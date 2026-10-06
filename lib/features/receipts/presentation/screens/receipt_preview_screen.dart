import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../labels/receipts_strings.dart';

/// ВРЕМЕННАЯ заглушка: полный ReceiptPreviewScreen реализуется в под-шаге 16.4.
class ReceiptPreviewScreen extends ConsumerWidget {
  const ReceiptPreviewScreen({
    super.key,
    required this.receiptId,
    this.transactionId,
  });

  final String receiptId;
  final String? transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(ReceiptsStrings.previewTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '${ReceiptsStrings.previewPlaceholder}\n\nID: $receiptId',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
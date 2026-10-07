import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../labels/receipts_strings.dart';

/// ВРЕМЕННАЯ заглушка: полный SplitReceiptScreen реализуется в 16.5.
class SplitReceiptScreen extends ConsumerWidget {
  const SplitReceiptScreen({super.key, required this.receiptId});

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(ReceiptsStrings.splitTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '${ReceiptsStrings.splitPlaceholder}\n\nID: $receiptId',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/receipt.dart';
import '../labels/receipts_strings.dart';
import '../utils/receipt_money_utils.dart';

/// Карточка метаданных чека: магазин/дата/сумма с инлайн-редактированием.
class ReceiptMetadataCard extends ConsumerWidget {
  const ReceiptMetadataCard({
    super.key,
    required this.receipt,
    required this.onStoreChanged,
    required this.onDateChanged,
    required this.onTotalChanged,
  });

  final Receipt receipt;
  final ValueChanged<String> onStoreChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onTotalChanged;

  Future<void> _editStore(BuildContext context) async {
    final controller = TextEditingController(text: receipt.storeName);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(ReceiptsStrings.metadataStore),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(ReceiptsStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text(ReceiptsStrings.metadataStore),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      onStoreChanged(result.trim());
    }
  }

  Future<void> _editDate(BuildContext context) async {
    final local = receipt.receiptDate.toLocal();
    final picked = await showDatePicker(
      context: context,
      initialDate: local,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      onDateChanged(DateTime.utc(
        picked.year,
        picked.month,
        picked.day,
        local.hour,
        local.minute,
      ));
    }
  }

  Future<void> _editTotal(BuildContext context) async {
    final controller =
        TextEditingController(text: ReceiptMoneyUtils.formatKop(receipt.totalAmount));
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(ReceiptsStrings.metadataTotal),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(ReceiptsStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text(ReceiptsStrings.metadataTotal),
          ),
        ],
      ),
    );
    if (result != null) {
      final kop = ReceiptMoneyUtils.parseKop(result);
      if (kop != null && kop > 0) onTotalChanged(kop);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.store_outlined),
                title: const Text(ReceiptsStrings.metadataStore),
                subtitle: Text(formatter.formatMerchant(receipt.storeName, mode)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () => _editStore(context),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text(ReceiptsStrings.metadataDate),
                subtitle:
                    Text(ReceiptMoneyUtils.formatDateUtc(receipt.receiptDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () => _editDate(context),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.payments_outlined),
                title: const Text(ReceiptsStrings.metadataTotal),
                subtitle: Text(
                  formatter.formatAmount(receipt.totalAmount, receipt.currency, mode),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () => _editTotal(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
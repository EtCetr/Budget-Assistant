import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/dtos/receipt_category_lookup.dart';
import '../../domain/entities/receipt_item.dart';
import '../labels/receipts_strings.dart';
import '../utils/receipt_money_utils.dart';
import 'receipt_item_row.dart';

/// Секция позиций: список, добавление, сводка суммы (ТЗ 6.3.23.6).
class ReceiptItemsSection extends StatelessWidget {
  const ReceiptItemsSection({
    super.key,
    required this.items,
    required this.categories,
    required this.totalKop,
    required this.onChanged,
    required this.onDelete,
    required this.onAdd,
  });

  final List<ReceiptItem> items;
  final List<ReceiptCategoryLookup> categories;
  final int totalKop;
  final void Function(ReceiptItem) onChanged;
  final void Function(String) onDelete;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final activeSum = items
        .where((i) => !i.isExcluded)
        .fold<int>(0, (acc, i) => acc + i.totalPrice);
    final sumOk = activeSum == totalKop;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            ReceiptsStrings.itemsTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...items.map((i) => ReceiptItemRow(
                item: i,
                categories: categories,
                onChanged: onChanged,
                onDelete: () => onDelete(i.id),
              )),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text(ReceiptsStrings.itemAdd),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: sumOk
                  ? AppColors.colorIncome.withValues(alpha: 0.12)
                  : AppColors.colorExpense.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  sumOk ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                  color: sumOk ? AppColors.colorIncome : AppColors.colorExpense,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${sumOk ? ReceiptsStrings.summaryOk : ReceiptsStrings.summaryMismatch}: '
                    '${ReceiptMoneyUtils.formatKop(activeSum)} / '
                    '${ReceiptMoneyUtils.formatKop(totalKop)}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
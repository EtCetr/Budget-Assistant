import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/dtos/receipt_category_lookup.dart';
import '../../domain/entities/receipt_item.dart';
import '../labels/receipts_strings.dart';
import '../utils/receipt_money_utils.dart';

/// Карточка позиции чека: имя, кол-во, цена, категория, исключение.
class ReceiptItemRow extends StatelessWidget {
  const ReceiptItemRow({
    super.key,
    required this.item,
    required this.categories,
    required this.onChanged,
    required this.onDelete,
  });

  final ReceiptItem item;
  final List<ReceiptCategoryLookup> categories;
  final ValueChanged<ReceiptItem> onChanged;
  final VoidCallback onDelete;

  String? _categoryName() {
    final id = item.categoryId;
    if (id == null) return null;
    for (final c in categories) {
      if (c.id == id) return c.iconEmoji == null ? c.name : '${c.iconEmoji} ${c.name}';
    }
    return null;
  }

  Future<void> _pickCategory(BuildContext context) async {
    final picked = await showDialog<ReceiptCategoryLookup>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(ReceiptsStrings.itemCategory),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: categories
                .map((c) => ListTile(
                      dense: true,
                      title: Text(
                          c.iconEmoji == null ? c.name : '${c.iconEmoji} ${c.name}'),
                      onTap: () => Navigator.of(ctx).pop(c),
                    ))
                .toList(),
          ),
        ),
      ),
    );
    if (picked != null) {
      onChanged(item.copyWith(categoryId: picked.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: item.isExcluded
          ? AppColors.surfaceCard.withValues(alpha: 0.5)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('name-${item.id}'),
                    initialValue: item.originalName,
                    decoration:
                        const InputDecoration(labelText: ReceiptsStrings.itemName),
                    onChanged: (v) =>
                        onChanged(item.copyWith(originalName: v)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 70,
                  child: TextFormField(
                    key: ValueKey('qty-${item.id}'),
                    initialValue: ReceiptMoneyUtils.formatQty(item.quantity),
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: ReceiptsStrings.itemQty),
                    onChanged: (v) {
                      final q = ReceiptMoneyUtils.parseQty(v);
                      if (q != null && q > 0) {
                        onChanged(item.copyWith(
                          quantity: q,
                          totalPrice: (item.unitPrice * q).round(),
                        ));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('price-${item.id}'),
                    initialValue: ReceiptMoneyUtils.formatKop(item.unitPrice),
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: ReceiptsStrings.itemPrice),
                    onChanged: (v) {
                      final kop = ReceiptMoneyUtils.parseKop(v);
                      if (kop != null) {
                        onChanged(item.copyWith(
                          unitPrice: kop,
                          totalPrice: (kop * item.quantity).round(),
                        ));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(ReceiptMoneyUtils.formatKop(item.totalPrice)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickCategory(context),
                    child: Text(
                      _categoryName() ?? ReceiptsStrings.itemCategory,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(ReceiptsStrings.itemExclude),
                Checkbox(
                  value: item.isExcluded,
                  onChanged: (v) =>
                      onChanged(item.copyWith(isExcluded: v ?? false)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
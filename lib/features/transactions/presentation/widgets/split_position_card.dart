import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/transactions_log_providers.dart';
import '../../domain/entities/split_position_draft.dart';
import '../providers/split_transaction_form_providers.dart';
import '../split_strings.dart';
import 'category_selector_sheet.dart';

/// Карточка позиции разделения (6.3.15.5): название, сумма, категория,
/// комментарий, удаление, drag-handle.
class SplitPositionCard extends ConsumerStatefulWidget {
  const SplitPositionCard({
    super.key,
    required this.position,
    required this.index,
  });

  final SplitPositionDraft position;
  final int index;

  @override
  ConsumerState<SplitPositionCard> createState() => _SplitPositionCardState();
}

class _SplitPositionCardState extends ConsumerState<SplitPositionCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.position.name);
    _amountController = TextEditingController(
      text: widget.position.amount == 0
          ? ''
          : MoneyTextInputFormatter.kopecksToInputText(widget.position.amount),
    );
    _descriptionController =
        TextEditingController(text: widget.position.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    HapticFeedback.lightImpact();
    final categoryId = await showCategorySelectorSheet(context);
    if (categoryId != null) {
      HapticFeedback.selectionClick();
      ref
          .read(splitTransactionFormProvider.notifier)
          .updatePosition(widget.position.id, categoryId: categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = widget.position;
    // Riverpod 3: valueOrNull удалён — используем .value (null вне data).
    final categories = ref.watch(transactionCategoryLookupProvider).value;
    final theme = Theme.of(context);
    final categoryName = categories
            ?.where((c) => c.id == position.categoryId)
            .map((c) => c.name)
            .firstOrNull ??
        SplitStrings.positionCategoryPick;
    return Card(
      color: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        side: const BorderSide(color: AppColors.borderDivider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    readOnly: position.fromOcr,
                    decoration: const InputDecoration(
                      labelText: SplitStrings.positionNameHint,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => ref
                        .read(splitTransactionFormProvider.notifier)
                        .updatePosition(position.id, name: value),
                  ),
                ),
                IconButton(
                  tooltip: SplitStrings.deletePosition,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    ref
                        .read(splitTransactionFormProvider.notifier)
                        .removePosition(position.id);
                  },
                ),
                ReorderableDragStartListener(
                  index: widget.index,
                  child: const Icon(Icons.drag_handle),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [MoneyTextInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: SplitStrings.positionAmountLabel,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => ref
                        .read(splitTransactionFormProvider.notifier)
                        .updatePosition(
                          position.id,
                          amount: MoneyInputParser.parseKopecks(value) ?? 0,
                        ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing8),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.spacing4),
                    onTap: position.fromOcr ? null : _pickCategory,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: position.categoryId == null
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: SplitStrings.positionDescriptionHint,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => ref
                  .read(splitTransactionFormProvider.notifier)
                  .updatePosition(position.id, description: value),
            ),
          ],
        ),
      ),
    );
  }
}
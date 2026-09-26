import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/constants/currency_codes.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/transactions_log_providers.dart';
import '../debts_strings.dart';
import '../providers/create_debt_providers.dart';

/// Секция «Детали»: сумма, валюта, категория, описание, срок (6.3.14.5).
class DebtFormDetailsSection extends ConsumerWidget {
  const DebtFormDetailsSection({
    super.key,
    required this.amountController,
    required this.descriptionController,
  });

  final TextEditingController amountController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createDebtFormProvider);
    final categoriesAsync = ref.watch(transactionCategoryLookupProvider);
    final theme = Theme.of(context);
    final locked = form.fieldsLocked;
    final now = DateTime.now();
    final dueInPast = form.dueDate != null &&
        DateTime(
          form.dueDate!.year,
          form.dueDate!.month,
          form.dueDate!.day,
        ).isBefore(DateTime(now.year, now.month, now.day));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DebtsStrings.formSectionDetails,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        // ВАЖНО: DropdownButtonFormField не может быть в Row без ширины.
        // Валюта получает фиксированные 110px, сумма — остаток через Expanded.
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [MoneyTextInputFormatter()],
                decoration: const InputDecoration(
                  labelText: DebtsStrings.amountLabel,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => ref
                    .read(createDebtFormProvider.notifier)
                    .setAmountText(value),
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            SizedBox(
              width: 110,
              child: DropdownButtonFormField<String>(
                initialValue: form.currency,
                decoration: const InputDecoration(
                  labelText: DebtsStrings.currencyLabel,
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final code in kCurrencyCodes)
                    DropdownMenuItem<String>(value: code, child: Text(code)),
                ],
                onChanged: locked
                    ? null
                    : (value) {
                        if (value == null) return;
                        HapticFeedback.selectionClick();
                        ref.read(createDebtFormProvider.notifier).setCurrency(value);
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing12),
        categoriesAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (categories) => DropdownButtonFormField<String>(
            initialValue: form.categoryId,
            decoration: const InputDecoration(
              labelText: DebtsStrings.categoryLabel,
              border: OutlineInputBorder(),
            ),
            items: [
              for (final c in categories)
                DropdownMenuItem<String>(value: c.id, child: Text(c.name)),
            ],
            onChanged: locked
                ? null
                : (value) {
                    HapticFeedback.selectionClick();
                    ref.read(createDebtFormProvider.notifier).setCategoryId(value);
                  },
          ),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        TextField(
          controller: descriptionController,
          maxLines: 2,
          maxLength: 200,
          readOnly: locked,
          decoration: const InputDecoration(
            labelText: DebtsStrings.descriptionLabel,
            hintText: DebtsStrings.descriptionHint,
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => ref
              .read(createDebtFormProvider.notifier)
              .setDescription(value),
        ),
        const SizedBox(height: AppSpacing.spacing4),
        InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.spacing4),
          onTap: locked ? null : () => _pickDueDate(context, ref, form.dueDate),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: DebtsStrings.dueDateLabel,
              border: const OutlineInputBorder(),
              suffixIcon: form.dueDate == null
                  ? const Icon(Icons.calendar_today)
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: locked
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              ref
                                  .read(createDebtFormProvider.notifier)
                                  .setDueDate(null);
                            },
                    ),
            ),
            child: Text(
              form.dueDate == null
                  ? DebtsStrings.dueDateChoose
                  : DateFormat('d MMMM yyyy', 'ru').format(form.dueDate!),
            ),
          ),
        ),
        if (dueInPast)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.spacing4),
            child: Text(
              DebtsStrings.dueDatePastWarning,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.colorWarning),
            ),
          ),
      ],
    );
  }

  Future<void> _pickDueDate(
    BuildContext context,
    WidgetRef ref,
    DateTime? current,
  ) async {
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now.add(const Duration(days: 30)),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      HapticFeedback.selectionClick();
      ref.read(createDebtFormProvider.notifier).setDueDate(picked);
    }
  }
}
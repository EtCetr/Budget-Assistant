import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/constants/currency_codes.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../providers/create_savings_goal_providers.dart';
import '../savings_goals_strings.dart';
import 'emoji_selector_sheet.dart';

/// Секция «Основная информация»: название + эмодзи, сумма + валюта,
/// дедлайн (ТЗ 6.3.17.3).
class SavingsGoalFormBasicSection extends ConsumerWidget {
  const SavingsGoalFormBasicSection({
    super.key,
    required this.nameController,
    required this.amountController,
  });

  final TextEditingController nameController;
  final TextEditingController amountController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createSavingsGoalFormProvider);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SavingsGoalsStrings.formSectionBasic,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                showEmojiSelectorSheet(
                  context,
                  selected: form.emoji,
                  onSelected: (emoji) {
                    HapticFeedback.selectionClick();
                    ref
                        .read(createSavingsGoalFormProvider.notifier)
                        .setEmoji(emoji);
                  },
                );
              },
              child: Text(
                form.emoji.isEmpty ? '＋' : form.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Expanded(
              child: TextField(
                controller: nameController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: SavingsGoalsStrings.nameLabel,
                  hintText: SavingsGoalsStrings.nameHint,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => ref
                    .read(createSavingsGoalFormProvider.notifier)
                    .setName(value),
              ),
            ),
          ],
        ),
        Text(
          SavingsGoalsStrings.emojiTooltip,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: SavingsGoalsStrings.amountFormLabel,
                  hintText: SavingsGoalsStrings.amountHint,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => ref
                    .read(createSavingsGoalFormProvider.notifier)
                    .setAmountText(value),
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            DropdownButton<String>(
              value: form.currency,
              items: [
                for (final code in kCurrencyCodes)
                  DropdownMenuItem(value: code, child: Text(code)),
              ],
              onChanged: form.currencyLocked
                  ? null
                  : (value) {
                      if (value == null) return;
                      HapticFeedback.selectionClick();
                      ref
                          .read(createSavingsGoalFormProvider.notifier)
                          .setCurrency(value);
                    },
            ),
          ],
        ),
        if (form.currencyLocked) ...[
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            SavingsGoalsStrings.currencyInherited,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
        const SizedBox(height: AppSpacing.spacing12),
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
          onTap: () => _pickDeadline(context, ref, form),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: SavingsGoalsStrings.deadlineLabel,
              border: const OutlineInputBorder(),
              suffixIcon: form.deadline == null
                  ? const Icon(Icons.calendar_today)
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        ref
                            .read(createSavingsGoalFormProvider.notifier)
                            .setDeadline(null);
                      },
                    ),
            ),
            child: Text(
              form.deadline == null
                  ? SavingsGoalsStrings.deadlineChoose
                  : DateFormat('d MMMM yyyy', 'ru')
                      .format(form.deadline!.toLocal()),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          SavingsGoalsStrings.deadlineHint,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
        if (_showPastWarning(form)) ...[
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            SavingsGoalsStrings.deadlinePastWarning,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.colorWarning),
          ),
        ],
      ],
    );
  }

  bool _showPastWarning(CreateSavingsGoalFormState form) {
    if (form.goalId == null || form.deadline == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = form.deadline!;
    final deadlineDay = DateTime(d.year, d.month, d.day);
    return deadlineDay.isBefore(today);
  }

  Future<void> _pickDeadline(
    BuildContext context,
    WidgetRef ref,
    CreateSavingsGoalFormState form,
  ) async {
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: form.deadline ?? now.add(const Duration(days: 30)),
      firstDate: form.goalId == null
          ? now.add(const Duration(days: 1))
          : DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      HapticFeedback.selectionClick();
      ref.read(createSavingsGoalFormProvider.notifier).setDeadline(picked);
    }
  }
}
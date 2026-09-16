import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

import '../../domain/entities/savings_goal.dart';
import '../providers/create_savings_goal_providers.dart';
import '../savings_goals_strings.dart';
import 'account_selector_dropdown.dart';

/// Секция «Тип цели»: виртуальная / привязанная к счёту (ТЗ 6.3.17.4).
///
/// Чекбокс «Зачислить текущий баланс счёта в цель» показывается СРАЗУ
/// при выборе «Привязать к счёту» в режиме создания (требование владельца):
/// условие не зависит от того, выбран ли уже счёт.
///
/// Микро-коммит 12.5.1 (Вариант Б): под чекбоксом — поле суммы зачисления
/// и кнопка «Весь баланс». Пустое поле = 100% баланса счёта.
class SavingsGoalFormTypeSection extends ConsumerWidget {
  const SavingsGoalFormTypeSection({
    super.key,
    required this.seedAmountController,
  });

  final TextEditingController seedAmountController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createSavingsGoalFormProvider);
    final theme = Theme.of(context);
    final isLinked = form.goalType == SavingsGoalType.linked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SavingsGoalsStrings.formSectionType,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          children: [
            Expanded(
              child: SavingsFormChoiceButton(
                label: SavingsGoalsStrings.typeVirtual,
                isActive: !isLinked,
                activeColor: AppColors.colorTransfer,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(createSavingsGoalFormProvider.notifier)
                      .setGoalType(SavingsGoalType.virtual);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Expanded(
              child: SavingsFormChoiceButton(
                label: SavingsGoalsStrings.typeLinked,
                isActive: isLinked,
                activeColor: AppColors.colorIncome,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(createSavingsGoalFormProvider.notifier)
                      .setGoalType(SavingsGoalType.linked);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing12),
        if (isLinked)
          const AccountSelectorDropdown()
        else
          Text(
            SavingsGoalsStrings.typeVirtualHint,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        if (isLinked && form.goalId == null) ...[
          CheckboxListTile(
            value: form.seedBalanceOnCreate,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              ref.read(createSavingsGoalFormProvider.notifier).setSeedBalance(
                    value ?? false,
                    balanceKopecks: _selectedAccountBalance(ref, form),
                  );
            },
            title: const Text(SavingsGoalsStrings.seedBalanceTitle),
            subtitle: const Text(SavingsGoalsStrings.seedBalanceHint),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          if (form.seedBalanceOnCreate)
            _SeedAmountField(
              controller: seedAmountController,
              balanceKopecks: _selectedAccountBalance(ref, form),
            ),
        ],
      ],
    );
  }

  /// Баланс выбранного счёта (null, если счёт не выбран).
  /// Виджет читает список счетов напрямую: циклическая зависимость
  /// запрещена только нотификатору формы.
  int? _selectedAccountBalance(
      WidgetRef ref, CreateSavingsGoalFormState form) {
    final accountId = form.linkedAccountId;
    if (accountId == null) return null;
    for (final account in ref.watch(linkedGoalAccountsProvider)) {
      if (account.id == accountId) return account.currentBalance;
    }
    return null;
  }
}

/// Поле суммы зачисления + кнопка «Весь баланс» (12.5.1, Вариант Б).
///
/// Пустое поле = зачислить 100% баланса счёта.
/// Баланс в подсказке маскируется через PrivacyFormatter.
class _SeedAmountField extends ConsumerWidget {
  const _SeedAmountField({
    required this.controller,
    required this.balanceKopecks,
  });

  final TextEditingController controller;
  final int? balanceKopecks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formatter = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);
    final form = ref.watch(createSavingsGoalFormProvider);
    final balance = balanceKopecks;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [MoneyTextInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: SavingsGoalsStrings.seedAmountLabel,
                    hintText: SavingsGoalsStrings.seedAmountHint,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) => ref
                      .read(createSavingsGoalFormProvider.notifier)
                      .setSeedAmountText(value),
                ),
              ),
              const SizedBox(width: AppSpacing.spacing8),
              OutlinedButton(
                onPressed: balance == null
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        final text = kopecksToFormText(balance);
                        controller.text = text;
                        ref
                            .read(createSavingsGoalFormProvider.notifier)
                            .setSeedAmountText(text);
                      },
                child: const Text(SavingsGoalsStrings.seedAmountFull),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            balance == null
                ? SavingsGoalsStrings.seedSelectAccountHint
                : '${SavingsGoalsStrings.seedAvailablePrefix} '
                    '${formatter.formatAmount(balance, form.currency, mode)}',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Общая кнопка сегментированного выбора для секций формы.
class SavingsFormChoiceButton extends StatelessWidget {
  const SavingsFormChoiceButton({
    super.key,
    required this.label,
    required this.isActive,
    this.activeColor = AppColors.colorTransfer,
    this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing12,
          vertical: AppSpacing.spacing12,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../debts_strings.dart';
import '../providers/create_debt_providers.dart';

/// Общая кнопка сегментированного выбора для формы долга.
class DebtFormChoiceButton extends StatelessWidget {
  const DebtFormChoiceButton({
    super.key,
    required this.label,
    required this.isActive,
    this.activeColor = AppColors.colorTransfer,
    this.enabled = true,
    this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
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
      ),
    );
  }
}

/// Секция «Тип долга»: Payable / Receivable (6.3.14.3).
class DebtFormTypeSection extends ConsumerWidget {
  const DebtFormTypeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createDebtFormProvider);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DebtsStrings.formSectionType,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          children: [
            Expanded(
              child: DebtFormChoiceButton(
                label: DebtsStrings.typePayable,
                isActive: form.debtType == 'payable',
                activeColor: AppColors.colorExpense,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(createDebtFormProvider.notifier).setDebtType('payable');
                },
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Expanded(
              child: DebtFormChoiceButton(
                label: DebtsStrings.typeReceivable,
                isActive: form.debtType == 'receivable',
                activeColor: AppColors.colorIncome,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(createDebtFormProvider.notifier)
                      .setDebtType('receivable');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
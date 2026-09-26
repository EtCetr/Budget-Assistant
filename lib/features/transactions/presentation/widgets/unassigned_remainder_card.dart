import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/split_transaction_form_providers.dart';
import '../split_strings.dart';

/// Карточка нераспределённого остатка (6.3.15.6): красный, пока != 0.
class UnassignedRemainderCard extends ConsumerWidget {
  const UnassignedRemainderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainder = ref.watch(splitRemainderKopecksProvider);
    final state = ref.watch(splitTransactionFormProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    final isZero = remainder == 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: (isZero ? AppColors.colorIncome : AppColors.colorExpense)
            .withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            isZero ? Icons.check_circle : Icons.warning_amber,
            color: isZero ? AppColors.colorIncome : AppColors.colorExpense,
          ),
          const SizedBox(width: AppSpacing.spacing8),
          Expanded(
            child: Text(
              isZero
                  ? SplitStrings.remainderZero
                  : SplitStrings.remainderTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isZero ? AppColors.colorIncome : AppColors.colorExpense,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!isZero)
            Text(
              formatter.formatAmount(
                remainder,
                state.source?.originalCurrency ?? 'RUB',
                mode,
              ),
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.colorExpense,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}
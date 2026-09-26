import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/split_transaction_form_providers.dart';
import '../split_strings.dart';

/// Сводка под списком позиций: количество и сумма (6.3.15.7).
class SplitBottomSummary extends ConsumerWidget {
  const SplitBottomSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(splitTransactionFormProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    var total = 0;
    for (final p in state.positions) {
      total += p.amount;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing8,
        AppSpacing.spacing16,
        AppSpacing.spacing8,
      ),
      child: Row(
        children: [
          Text(
            '${SplitStrings.summaryPositions}: ${state.positions.length}',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            '${SplitStrings.summaryTotal}: '
            '${formatter.formatAmount(total, state.source?.originalCurrency ?? 'RUB', mode)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
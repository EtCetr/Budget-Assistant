import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../debts_strings.dart';
import '../providers/create_debt_providers.dart';
import '../providers/debts_providers.dart';

/// Live-превью долга (6.3.14.4/6.3.14.9): «Вы должны Ивану 3 400 ₽ …».
class DebtLivePreview extends ConsumerWidget {
  const DebtLivePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createDebtFormProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    final amount = MoneyInputParser.parseKopecks(form.amountText);
    if (amount == null || amount <= 0) return const SizedBox.shrink();

    String name;
    if (form.counterpartyType == 'external') {
      final declined = ref.watch(declineNameUseCaseProvider)(form.externalName);
      name = declined.dative;
    } else {
      final members = ref.watch(familyMembersProvider).value ?? const [];
      final firstId = form.selectedMemberIds.isEmpty
          ? null
          : form.selectedMemberIds.first;
      final member = members.where((m) => m.userId == firstId).toList();
      name = member.isEmpty ? '' : member.first.displayName;
    }
    if (name.trim().isEmpty) return const SizedBox.shrink();

    final amountText = formatter.formatAmount(amount, form.currency, mode);
    final nameText = formatter.formatName(name, mode);
    final description = formatter.formatName(form.description, mode);
    final prefix = form.debtType == 'payable'
        ? DebtsStrings.previewPayable
        : DebtsStrings.previewReceivable;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      child: Text(
        '$prefix $nameText $amountText'
        '${description.isEmpty ? '' : ' · $description'}',
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: AppColors.colorTransfer),
      ),
    );
  }
}
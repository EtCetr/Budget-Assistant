import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

import '../../domain/entities/savings_goal.dart';
import '../providers/create_savings_goal_providers.dart';
import '../savings_goals_strings.dart';
import 'account_picker_sheet.dart';

class AccountSelectorDropdown extends ConsumerWidget {
  const AccountSelectorDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createSavingsGoalFormProvider);
    final accounts = ref.watch(linkedGoalAccountsProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);

    if (accounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(SavingsGoalsStrings.noAccountsTitle,
                style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              form.visibility == SavingsGoalVisibility.family
                  ? SavingsGoalsStrings.familyNoSharedAccounts
                  : SavingsGoalsStrings.noAccountsSubtitle,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Wrap(
              spacing: AppSpacing.spacing8,
              runSpacing: AppSpacing.spacing8,
              children: [
                OutlinedButton(
                  onPressed: () => context.push('/accounts'),
                  child: const Text(SavingsGoalsStrings.addAccountAction),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(createSavingsGoalFormProvider.notifier)
                      .setGoalType(SavingsGoalType.virtual),
                  child: const Text(SavingsGoalsStrings.makeVirtualAction),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final selectedList = accounts.where((a) => a.id == form.linkedAccountId).toList();
    final selected = selectedList.isEmpty ? null : selectedList.first;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      onTap: () async {
        final id = await showAccountPickerSheet(
          context,
          accounts: accounts,
          selectedId: form.linkedAccountId,
          title: SavingsGoalsStrings.accountSelectLabel,
        );
        if (id != null) {
          final picked = accounts.where((a) => a.id == id).toList();
          ref.read(createSavingsGoalFormProvider.notifier).setLinkedAccount(
                id,
                currency: picked.isEmpty ? null : picked.first.currency,
                // 12.5.1: баланс нужен для предзаполнения суммы зачисления.
                balanceKopecks:
                    picked.isEmpty ? null : picked.first.currentBalance,
              );
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: SavingsGoalsStrings.accountSelectLabel,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          selected == null
              ? SavingsGoalsStrings.accountHint
              : '${_label(selected)} · '
                  '${formatter.formatAmount(selected.currentBalance, selected.currency, mode)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String _label(Account account) {
    final buffer = StringBuffer(account.bankName);
    if (account.customName.isNotEmpty) buffer.write(' ${account.customName}');
    final mask = account.cardNumberMask;
    if (mask != null && mask.isNotEmpty) buffer.write(' $mask');
    return buffer.toString();
  }
}
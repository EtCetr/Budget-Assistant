import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/savings_goals_providers.dart';
import '../savings_goals_strings.dart';
import 'savings_goal_card.dart';

class WithdrawFromGoalSheet extends ConsumerStatefulWidget {
  const WithdrawFromGoalSheet({super.key, required this.goal});
  final SavingsGoal goal;
  @override
  ConsumerState<WithdrawFromGoalSheet> createState() =>
      _WithdrawFromGoalSheetState();
}

class _WithdrawFromGoalSheetState extends ConsumerState<WithdrawFromGoalSheet> {
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  String? _selectedAccountId;
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final userId = ref.watch(currentUserIdProvider);
    final accounts = _filteredAccounts(
      ref.watch(accountsListProvider(userId)).value,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(SavingsGoalsStrings.withdrawTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.spacing4),
            Text(formatter.formatName(widget.goal.name, mode),
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              '${SavingsGoalsStrings.withdrawAvailable} ${formatter.formatAmount(widget.goal.currentAmount, widget.goal.currency, mode)}',
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.colorIncome),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [MoneyTextInputFormatter()],
              decoration: const InputDecoration(
                labelText: SavingsGoalsStrings.amountLabel,
                hintText: SavingsGoalsStrings.amountHint,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: SavingsGoalsStrings.accountLabel,
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAccountId,
                  isExpanded: true,
                  hint: const Text(SavingsGoalsStrings.accountHint),
                  items: [
                    for (final account in accounts)
                      DropdownMenuItem(
                        value: account.id,
                        child: Text(
                          '${accountLabel(account)} · ${formatter.formatAmount(account.currentBalance, account.currency, mode)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedAccountId = value);
                  },
                ),
              ),
            ),
            if (accounts.isEmpty) ...[
              const SizedBox(height: AppSpacing.spacing8),
              Text(SavingsGoalsStrings.noAccountsForCurrency,
                  style: theme.textTheme.labelMedium?.copyWith(color: AppColors.colorWarning)),
            ],
            const SizedBox(height: AppSpacing.spacing12),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: SavingsGoalsStrings.commentLabel,
                hintText: SavingsGoalsStrings.commentHint,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text(SavingsGoalsStrings.submitWithdraw),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Account> _filteredAccounts(List<Account>? accounts) {
    if (accounts == null) return const [];
    return accounts
        .where((a) => !a.isArchived && !a.isSystem && a.currency == widget.goal.currency)
        .toList();
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);
    final amount = MoneyInputParser.parseKopecks(_amountController.text);
    if (amount == null || amount <= 0) {
      messenger.showSnackBar(const SnackBar(content: Text(SavingsGoalsStrings.validationAmount)));
      return;
    }
    if (amount > widget.goal.currentAmount) {
      messenger.showSnackBar(const SnackBar(content: Text(SavingsGoalsStrings.validationTooMuch)));
      return;
    }
    final accounts = _filteredAccounts(
      ref.read(accountsListProvider(ref.read(currentUserIdProvider))).value,
    );
    var accountId = _selectedAccountId;
    if (accountId == null && accounts.length == 1) accountId = accounts.single.id;
    if (accountId == null) {
      messenger.showSnackBar(const SnackBar(content: Text(SavingsGoalsStrings.validationAccount)));
      return;
    }
    setState(() => _saving = true);
    try {
      final comment = _commentController.text.trim();
      final result = await ref.read(withdrawFromSavingsGoalUseCaseProvider)(
        goal: widget.goal,
        accountId: accountId,
        amountKopecks: amount,
        comment: comment.isEmpty ? null : comment,
        userId: ref.read(currentUserIdProvider),
      );
      if (!mounted) return;
      switch (result) {
        case Success<Transaction>():
          HapticFeedback.mediumImpact();
          messenger.showSnackBar(const SnackBar(content: Text(SavingsGoalsStrings.withdrawSuccess)));
          Navigator.of(context).pop();
        case Error<Transaction>(:final failure):
          setState(() => _saving = false);
          messenger.showSnackBar(SnackBar(content: Text(failure.message)));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(const SnackBar(content: Text(SavingsGoalsStrings.operationFailed)));
    }
  }
}
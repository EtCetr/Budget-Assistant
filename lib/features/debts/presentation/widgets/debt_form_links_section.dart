import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/formatting/money_formatter.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../debts_strings.dart';
import '../providers/create_debt_providers.dart';

/// Секция «Связи»: транзакция + авто-закрытие (6.3.14.6).
/// Скрывается при открытии из транзакции/split (связь уже установлена).
class DebtFormLinksSection extends ConsumerWidget {
  const DebtFormLinksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createDebtFormProvider);
    final theme = Theme.of(context);
    if (form.fieldsLocked) return const SizedBox.shrink();
    final recentAsync = ref.watch(recentTransactionsForLinkProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DebtsStrings.formSectionLinks,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        recentAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (transactions) => DropdownButtonFormField<String>(
            initialValue: form.linkedTransactionId,
            decoration: const InputDecoration(
              labelText: DebtsStrings.linkTransactionLabel,
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text(DebtsStrings.linkNone),
              ),
              for (final t in transactions)
                DropdownMenuItem(
                  value: t.id,
                  child: Text(
                    '${DateFormat('dd.MM.yyyy').format(t.date.toLocal())} · '
                    '${t.merchantName ?? t.categoryName} · '
                    '${MoneyFormatter.formatKopecks(t.amountKopecks, t.currencyCode)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (value) {
              HapticFeedback.selectionClick();
              ref
                  .read(createDebtFormProvider.notifier)
                  .setLinkedTransaction(value);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        CheckboxListTile(
          value: form.autoResolve,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            ref
                .read(createDebtFormProvider.notifier)
                .setAutoResolve(value ?? true);
          },
          title: const Text(DebtsStrings.autoResolveLabel),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
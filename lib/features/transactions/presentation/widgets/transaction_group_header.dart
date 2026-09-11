import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/privacy_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/transaction_day_group.dart';
import '../labels/transactions_log_labels.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';

class TransactionGroupHeader extends ConsumerWidget {
  const TransactionGroupHeader({super.key, required this.group});

  final TransactionDayGroupUi group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyMode = ref.watch(privacyModeProvider);
    final formatter = PrivacyFormatter();

    final spent = formatter.amount(
      kopecks: group.summary.spentKopecks,
      currencyCode: 'RUB',
      mode: privacyMode,
    );

    final income = formatter.amount(
      kopecks: group.summary.incomeKopecks,
      currencyCode: 'RUB',
      mode: privacyMode,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '${TransactionsLogLabels.spent}: $spent · ${TransactionsLogLabels.income}: $income · ${group.summary.operationsCount} ${TransactionsLogLabels.operations}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
}

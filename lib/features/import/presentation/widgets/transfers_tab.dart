import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_candidate.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/post_import_review_notifier.dart';

class TransfersTab extends ConsumerWidget {
  const TransfersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postImportReviewProvider);
    final notifier = ref.read(postImportReviewProvider.notifier);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final fmt = DateFormat('dd.MM');
    if (state.transfers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
            child: Text('Переводы не найдены',
                style: TextStyle(color: AppColors.textSecondary))),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...state.transfers.map((tr) {
          final scenarioLabel = tr.scenario == TransferScenario.sbp
              ? 'СБП (±5 минут)'
              : 'Межбанк (±3 дня)';
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.colorTransfer.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Перевод между счетами',
                    style: TextStyle(
                        color: AppColors.colorTransfer,
                        fontWeight: FontWeight.w700)),
                Text(scenarioLabel,
                    style: const TextStyle(color: AppColors.colorTransfer)),
                const SizedBox(height: 8),
                Text(
                    'Расход: ${fmt.format(tr.expenseRow.date)} '
                    '${formatter.formatMerchant(tr.expenseRow.merchantName, mode)} '
                    '${formatter.formatAmount(-tr.amountKopecks, 'RUB', mode)}',
                    style: const TextStyle(color: AppColors.colorExpense)),
                Text(
                    'Доход: ${fmt.format(tr.incomeRow.date)} '
                    '${formatter.formatMerchant(tr.incomeRow.merchantName, mode)} '
                    '${formatter.formatAmount(tr.amountKopecks, 'RUB', mode)}',
                    style: const TextStyle(color: AppColors.colorIncome)),
                Text('Разница: ${tr.timeDifference.inHours} ч',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                RadioGroup<TransferAction>(
                  groupValue: tr.selectedAction,
                  onChanged: (v) {
                    if (v != null) notifier.setTransferAction(tr.id, v);
                  },
                  child: const Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: RadioListTile<TransferAction>(
                            title: Text('Объединить в перевод'),
                            value: TransferAction.merge,
                            dense: true),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: RadioListTile<TransferAction>(
                            title: Text('Оставить как есть'),
                            value: TransferAction.keep,
                            dense: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorTransfer),
          onPressed: notifier.mergeAllTransfers,
          child: Text('Объединить все переводы (${state.transfers.length})'),
        ),
      ],
    );
  }
}
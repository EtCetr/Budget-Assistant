import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/post_import_review_notifier.dart';

/// Таб «Переводы»: все строки, помеченные как перевод между своими счетами.
/// Строка создастся с type='transfer' (не попадает в P&L).
/// «Не перевод» возвращает строку в таб «Категории»; галка слева исключает из импорта.
class TransfersTab extends ConsumerWidget {
  const TransfersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postImportReviewProvider);
    final notifier = ref.read(postImportReviewProvider.notifier);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final fmt = DateFormat('dd.MM');
    final transfers = state.rows.where((r) => r.isTransfer).toList();
    if (transfers.isEmpty) {
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
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Эти операции будут импортированы как переводы между своими счетами '
            '(не попадают в P&L). «Не перевод» — вернуть в обычные операции; '
            'галка слева — не импортировать строку.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
        ...transfers.map((row) {
          final selected = state.selectedRows.contains(row.rowIndex);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.colorTransfer.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: selected,
                  onChanged: (v) =>
                      notifier.toggleRow(row.rowIndex, v ?? false),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatter.formatMerchant(row.merchantName, mode),
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            formatter.formatAmount(row.amountKopecks, 'RUB', mode),
                            style: TextStyle(
                              color: row.amountKopecks < 0
                                  ? AppColors.colorExpense
                                  : AppColors.colorIncome,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text('${fmt.format(row.date)} · перевод',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => notifier.toggleTransfer(row.rowIndex),
                          child: const Text('Не перевод'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
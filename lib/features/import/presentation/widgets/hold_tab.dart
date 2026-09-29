import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/import/domain/entities/hold_confirmation_candidate.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/post_import_review_notifier.dart';

class HoldTab extends ConsumerWidget {
  const HoldTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postImportReviewProvider);
    final notifier = ref.read(postImportReviewProvider.notifier);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final fmt = DateFormat('dd.MM');
    if (state.holds.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
            child: Text('Hold-операций нет',
                style: TextStyle(color: AppColors.textSecondary))),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...state.holds.map((hold) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.colorWarning.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Операция в обработке банком',
                    style: TextStyle(
                        color: AppColors.colorWarning,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                    '${fmt.format(hold.importedRow.date)} '
                    '${formatter.formatMerchant(hold.importedRow.merchantName, mode)} '
                    '${formatter.formatAmount(hold.importedRow.amountKopecks, 'RUB', mode)}',
                    style: const TextStyle(color: AppColors.textPrimary)),
                const Text('Банк ещё не подтвердил операцию (1-3 дня)',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                RadioGroup<HoldAction>(
                  groupValue: hold.selectedAction,
                  onChanged: (v) {
                    if (v != null) notifier.setHoldAction(hold.id, v);
                  },
                  child: const Column(
                    children: [
                      RadioListTile<HoldAction>(
                          title: Text('Обновить статус'),
                          value: HoldAction.confirm,
                          dense: true),
                      RadioListTile<HoldAction>(
                          title: Text('Пропустить'),
                          value: HoldAction.skip,
                          dense: true),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
              'Hold-операции автоматически подтвердятся при следующем импорте выписки',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
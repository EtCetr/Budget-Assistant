import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/import/domain/entities/duplicate_candidate.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/post_import_review_notifier.dart';
import 'package:intl/intl.dart';

class DuplicatesTab extends ConsumerWidget {
  const DuplicatesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postImportReviewProvider);
    final notifier = ref.read(postImportReviewProvider.notifier);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final fmt = DateFormat('dd.MM');
    if (state.duplicates.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
            child: Text('Дубликаты не найдены',
                style: TextStyle(color: AppColors.textSecondary))),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...state.duplicates.map((dup) {
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
                const Text('Возможный дубликат',
                    style: TextStyle(
                        color: AppColors.colorWarning,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                    'Импорт: ${fmt.format(dup.importedRow.date)} '
                    '${formatter.formatMerchant(dup.importedRow.merchantName, mode)} '
                    '${formatter.formatAmount(dup.importedRow.amountKopecks, 'RUB', mode)}',
                    style: const TextStyle(color: AppColors.textPrimary)),
                Text(
                    'Уже есть: ${fmt.format(dup.existingDate)} '
                    '${formatter.formatMerchant(dup.existingMerchantName, mode)} '
                    '${formatter.formatAmount(dup.existingAmountKopecks, 'RUB', mode)}',
                    style: const TextStyle(color: AppColors.colorIncome)),
                Text('Совпадение: ${(dup.matchScore * 100).round()}%',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                RadioGroup<DuplicateAction>(
                  groupValue: dup.selectedAction,
                  onChanged: (v) {
                    if (v != null) notifier.setDuplicateAction(dup.id, v);
                  },
                  child: const Column(
                    children: [
                      RadioListTile<DuplicateAction>(
                          title: Text('Пропустить импорт'),
                          value: DuplicateAction.skip,
                          dense: true),
                      RadioListTile<DuplicateAction>(
                          title: Text('Заменить существующую'),
                          value: DuplicateAction.replace,
                          dense: true),
                      RadioListTile<DuplicateAction>(
                          title: Text('Импортировать обе'),
                          value: DuplicateAction.both,
                          dense: true),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorWarning),
          onPressed: notifier.skipAllDuplicates,
          child: Text('Пропустить все дубликаты (${state.duplicates.length})'),
        ),
      ],
    );
  }
}
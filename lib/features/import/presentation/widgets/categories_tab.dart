import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/post_import_review_notifier.dart';
import '../providers/post_import_review_providers.dart';

class CategoriesTab extends ConsumerWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(postImportReviewProvider.notifier);
    final groups = notifier.dayGroups();
    final categoriesAsync = ref.watch(reviewCategoriesProvider);
    final state = ref.watch(postImportReviewProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(
          child: Text('Не удалось загрузить категории',
              style: TextStyle(color: AppColors.textSecondary))),
      data: (categories) {
        if (groups.isEmpty) {
          return const Center(
              child: Text('Нет транзакций',
                  style: TextStyle(color: AppColors.textSecondary)));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (state.suggestionsLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Применяем AI-правила...',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorFAB),
              onPressed: notifier.applyAllSuggestions,
              child: Text(
                  'Применить AI-категории ко всем (${notifier.uncategorizedCount})'),
            ),
            const SizedBox(height: 12),
            for (final group in groups) ...[
              _dayHeader(group, notifier, state.selectedRows),
              ...group.value.map((row) => _row(row, categories, notifier,
                  state.selectedRows, ref)),
            ],
          ],
        );
      },
    );
  }

  Widget _dayHeader(MapEntry<DateTime, List<ParsedRow>> group,
      dynamic notifier, Set<int> selected) {
    final allSelected =
        group.value.every((r) => selected.contains(r.rowIndex));
    final fmt = DateFormat('d MMMM yyyy', 'ru');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(fmt.format(group.key),
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700)),
          ),
          Checkbox(
            value: allSelected,
            onChanged: (v) => notifier.setDaySelected(
                group.value.map((r) => r.rowIndex).toList(), v ?? false),
          ),
        ],
      ),
    );
  }

  Widget _row(
    ParsedRow row,
    dynamic categories,
    dynamic notifier,
    Set<int> selected,
    WidgetRef ref,
  ) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final suggestion = ref
        .watch(postImportReviewProvider)
        .suggestions[row.rowIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: selected.contains(row.rowIndex),
            onChanged: (v) => notifier.toggleRow(row.rowIndex, v ?? false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        formatter.formatMerchant(row.merchantName, mode),
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: row.assignedCategoryId,
                          hint: const Text('Выбрать категорию',
                              style: TextStyle(fontSize: 13)),
                          items: [
                            for (final c in categories)
                              DropdownMenuItem(
                                value: c.id as String,
                                child: Text(
                                    '${c.iconEmoji ?? ''} ${c.name}',
                                    style: const TextStyle(fontSize: 13)),
                              ),
                          ],
                          onChanged: (v) =>
                              notifier.setCategory(row.rowIndex, v),
                        ),
                      ),
                    ),
                    if (row.assignedCategoryId == null &&
                        suggestion != null)
                      InkWell(
                        onTap: () => notifier.applySuggestion(row.rowIndex),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                              'AI: ${(suggestion.confidence * 100).round()}%',
                              style: const TextStyle(
                                  color: AppColors.colorIncome,
                                  fontSize: 12)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
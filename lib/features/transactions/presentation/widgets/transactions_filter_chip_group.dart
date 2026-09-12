import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/money_input_parser.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/lookup_item.dart';
import '../../domain/entities/transactions_filter_state.dart';
import '../labels/transactions_log_labels.dart';
import '../providers/transactions_log_providers.dart';

class TransactionsFilterChipGroup extends ConsumerWidget {
  const TransactionsFilterChipGroup({super.key, required this.filter});

  final TransactionsFilterState filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (filter.hasActiveFilters) ...[
            FilterChip(
              label: const Text(TransactionsLogLabels.reset),
              selected: false,
              onSelected: (_) {
                HapticFeedback.mediumImpact();
                ref.read(transactionsFilterProvider.notifier).reset();
              },
            ),
            const SizedBox(width: 8),
          ],
          FilterChip(
            label: Text(_typeLabel(filter.type)),
            selected: filter.type != TransactionTypeFilter.all,
            onSelected: (_) => _showTypeSheet(context, ref),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(
              filter.categoryIds.isEmpty
                  ? TransactionsLogLabels.categories
                  : '${TransactionsLogLabels.categories}: ${filter.categoryIds.length}',
            ),
            selected: filter.categoryIds.isNotEmpty,
            onSelected: (_) => _showCategoriesSheet(context, ref),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(
              filter.accountIds.isEmpty
                  ? TransactionsLogLabels.accounts
                  : '${TransactionsLogLabels.accounts}: ${filter.accountIds.length}',
            ),
            selected: filter.accountIds.isNotEmpty,
            onSelected: (_) => _showAccountsSheet(context, ref),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(_periodLabel(filter.period)),
            selected: filter.period != TransactionsPeriodPreset.all,
            onSelected: (_) => _showPeriodSheet(context, ref),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text(TransactionsLogLabels.amount),
            selected:
                filter.amountFromKopecks != null ||
                filter.amountToKopecks != null,
            onSelected: (_) => _showAmountSheet(context, ref),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text(TransactionsLogLabels.withReceipts),
            selected: filter.onlyWithReceipt,
            selectedColor: AppColors.colorWarning.withValues(alpha: .25),
            onSelected: (_) {
              HapticFeedback.selectionClick();
              ref
                  .read(transactionsFilterProvider.notifier)
                  .toggleOnlyWithReceipt();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text(TransactionsLogLabels.onlySplit),
            selected: filter.onlySplit,
            selectedColor: const Color(0xFF14B8A6).withValues(alpha: .25),
            onSelected: (_) {
              HapticFeedback.selectionClick();
              ref.read(transactionsFilterProvider.notifier).toggleOnlySplit();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text(TransactionsLogLabels.onlyDebts),
            selected: filter.onlyDebts,
            selectedColor: AppColors.colorExpense.withValues(alpha: .2),
            onSelected: (_) {
              HapticFeedback.selectionClick();
              ref.read(transactionsFilterProvider.notifier).toggleOnlyDebts();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text(TransactionsLogLabels.excludeOwn),
            selected: filter.excludeOwn,
            selectedColor: AppColors.colorTransfer.withValues(alpha: .25),
            onSelected: (_) {
              HapticFeedback.selectionClick();
              ref.read(transactionsFilterProvider.notifier).toggleExcludeOwn();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text(TransactionsLogLabels.excludeLargeExpenses),
            selected: filter.excludeLargeExpenses,
            selectedColor: const Color(0xFF8B5CF6).withValues(alpha: .25),
            onSelected: (_) {
              HapticFeedback.selectionClick();
              ref
                  .read(transactionsFilterProvider.notifier)
                  .toggleExcludeLargeExpenses();
            },
          ),
        ],
      ),
    );
  }
}

String _typeLabel(TransactionTypeFilter type) {
  switch (type) {
    case TransactionTypeFilter.all:
      return TransactionsLogLabels.typeAll;
    case TransactionTypeFilter.expense:
      return TransactionsLogLabels.typeExpense;
    case TransactionTypeFilter.income:
      return TransactionsLogLabels.typeIncome;
    case TransactionTypeFilter.transfer:
      return TransactionsLogLabels.typeTransfer;
  }
}

String _periodLabel(TransactionsPeriodPreset period) {
  switch (period) {
    case TransactionsPeriodPreset.all:
      return TransactionsLogLabels.periodAll;
    case TransactionsPeriodPreset.today:
      return TransactionsLogLabels.periodToday;
    case TransactionsPeriodPreset.week:
      return TransactionsLogLabels.periodWeek;
    case TransactionsPeriodPreset.month:
      return TransactionsLogLabels.periodMonth;
    case TransactionsPeriodPreset.year:
      return TransactionsLogLabels.periodYear;
    case TransactionsPeriodPreset.custom:
      return TransactionsLogLabels.periodCustom;
  }
}

Future<void> _showTypeSheet(BuildContext context, WidgetRef ref) async {
  final current = ref.read(transactionsFilterProvider).type;
  await showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: TransactionTypeFilter.values.map((type) {
            return ListTile(
              selected: current == type,
              title: Text(_typeLabel(type)),
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(transactionsFilterProvider.notifier).setType(type);
                Navigator.of(sheetContext).pop();
              },
            );
          }).toList(),
        ),
      );
    },
  );
}

Future<void> _showCategoriesSheet(BuildContext context, WidgetRef ref) async {
  // Перечитываем категории, чтобы новые записи были видны без рестарта.
  ref.invalidate(transactionCategoryLookupProvider);
  final lookupAsync = ref.read(transactionCategoryLookupProvider);
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return lookupAsync.when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const SizedBox(
          height: 200,
          child: Center(child: Icon(Icons.error_outline)),
        ),
        data: (items) => _MultiSelectSheet(
          items: items,
          initialSelected: ref.read(transactionsFilterProvider).categoryIds,
          onApply: (ids) {
            ref.read(transactionsFilterProvider.notifier).setCategoryIds(ids);
          },
        ),
      );
    },
  );
}

Future<void> _showAccountsSheet(BuildContext context, WidgetRef ref) async {
  // Перечитываем счета, чтобы новые записи были видны без рестарта.
  ref.invalidate(transactionAccountLookupProvider);
  final lookupAsync = ref.read(transactionAccountLookupProvider);
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return lookupAsync.when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const SizedBox(
          height: 200,
          child: Center(child: Icon(Icons.error_outline)),
        ),
        data: (items) => _MultiSelectSheet(
          items: items,
          initialSelected: ref.read(transactionsFilterProvider).accountIds,
          onApply: (ids) {
            ref.read(transactionsFilterProvider.notifier).setAccountIds(ids);
          },
        ),
      );
    },
  );
}

Future<void> _showPeriodSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _periodTile(
              sheetContext,
              ref,
              TransactionsPeriodPreset.all,
              TransactionsLogLabels.periodAll,
            ),
            _periodTile(
              sheetContext,
              ref,
              TransactionsPeriodPreset.today,
              TransactionsLogLabels.periodToday,
            ),
            _periodTile(
              sheetContext,
              ref,
              TransactionsPeriodPreset.week,
              TransactionsLogLabels.periodWeek,
            ),
            _periodTile(
              sheetContext,
              ref,
              TransactionsPeriodPreset.month,
              TransactionsLogLabels.periodMonth,
            ),
            _periodTile(
              sheetContext,
              ref,
              TransactionsPeriodPreset.year,
              TransactionsLogLabels.periodYear,
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text(TransactionsLogLabels.periodCustom),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (range == null) return;
                HapticFeedback.selectionClick();
                ref
                    .read(transactionsFilterProvider.notifier)
                    .setCustomPeriod(range.start, range.end);
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _periodTile(
  BuildContext context,
  WidgetRef ref,
  TransactionsPeriodPreset preset,
  String label,
) {
  final current = ref.read(transactionsFilterProvider).period;
  return ListTile(
    selected: current == preset,
    title: Text(label),
    onTap: () {
      HapticFeedback.selectionClick();
      ref.read(transactionsFilterProvider.notifier).setPeriod(preset);
      Navigator.of(context).pop();
    },
  );
}

Future<void> _showAmountSheet(BuildContext context, WidgetRef ref) async {
  // Читаем текущий фильтр, чтобы предзаполнить поля суммы.
  final currentFilter = ref.read(transactionsFilterProvider);
  final fromController = TextEditingController(
    text: currentFilter.amountFromKopecks == null
        ? ''
        : _formatAmountForInput(currentFilter.amountFromKopecks!),
  );
  final toController = TextEditingController(
    text: currentFilter.amountToKopecks == null
        ? ''
        : _formatAmountForInput(currentFilter.amountToKopecks!),
  );
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fromController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: TransactionsLogLabels.from,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: toController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: TransactionsLogLabels.to,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: const Text(TransactionsLogLabels.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final from = fromController.text.trim().isEmpty
                          ? null
                          : MoneyInputParser.parseKopecks(fromController.text);
                      final to = toController.text.trim().isEmpty
                          ? null
                          : MoneyInputParser.parseKopecks(toController.text);
                      HapticFeedback.selectionClick();
                      ref
                          .read(transactionsFilterProvider.notifier)
                          .setAmountRange(from, to);
                      Navigator.of(sheetContext).pop();
                    },
                    child: const Text(TransactionsLogLabels.apply),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

/// Форматирует копейки в строку для поля ввода (без double).
/// Пример: 25050 -> "250,50"; 25000 -> "250".
String _formatAmountForInput(int kopecks) {
  final abs = kopecks.abs();
  final rubles = abs ~/ 100;
  final kop = abs % 100;
  if (kop == 0) {
    return '$rubles';
  }
  return '$rubles,${kop.toString().padLeft(2, '0')}';
}

class _MultiSelectSheet extends StatefulWidget {
  const _MultiSelectSheet({
    required this.items,
    required this.initialSelected,
    required this.onApply,
  });

  final List<LookupItem> items;
  final List<String> initialSelected;
  final ValueChanged<List<String>> onApply;

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView(
              children: widget.items.map((item) {
                final selected = _selected.contains(item.id);
                return CheckboxListTile(
                  value: selected,
                  title: Text(item.name),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selected.add(item.id);
                      } else {
                        _selected.remove(item.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(TransactionsLogLabels.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      widget.onApply(_selected.toList());
                      Navigator.of(context).pop();
                    },
                    child: const Text(TransactionsLogLabels.apply),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

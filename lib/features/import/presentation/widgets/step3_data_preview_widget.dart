import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../providers/import_onboarding_notifier.dart';

class Step3DataPreviewWidget extends ConsumerWidget {
  const Step3DataPreviewWidget({super.key});

  static const List<String> _dateFormats = [
    'dd.MM.yyyy HH:mm:ss',
    'dd.MM.yyyy',
    'dd/MM/yyyy',
    'yyyy-MM-dd',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importOnboardingProvider);
    final notifier = ref.read(importOnboardingProvider.notifier);
    final mapping = state.mapping;
    final table = notifier.previewTable();

    if (mapping == null) {
      return const Center(child: Text('Файл не загружен',
          style: TextStyle(color: AppColors.textSecondary)));
    }

    final colCount = table.columnLabels.length;

    Widget columnPicker(String title, int value, ValueChanged<int> onChanged) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(title,
                  style: const TextStyle(color: AppColors.textPrimary)),
            ),
            Expanded(
              child: DropdownButton<int>(
                isExpanded: true,
                value: value.clamp(0, colCount == 0 ? 0 : colCount - 1),
                items: List.generate(colCount, (i) {
                  return DropdownMenuItem(
                    value: i,
                    child: Text(
                        '${table.columnLabels[i]}: ${_sample(table, i)}'),
                  );
                }),
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Распознано транзакций: ${state.parsedFile?.parseResult.rows.length ?? 0}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 36,
            dataRowMinHeight: 32,
            dataRowMaxHeight: 40,
            columns: table.columnLabels
                .map((l) => DataColumn(
                    label: Text(l,
                        style: const TextStyle(
                            color: AppColors.textSecondary))))
                .toList(),
            rows: table.rows
                .map((r) => DataRow(
                      cells: List.generate(
                        colCount,
                        (i) => DataCell(Text(
                              i < r.length ? r[i] : '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: i == mapping.dateColumnIndex ||
                                        i == mapping.amountColumnIndex ||
                                        i == mapping.merchantColumnIndex
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            )),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        columnPicker('Дата', mapping.dateColumnIndex,
            (v) => notifier.updateMapping(mapping.copyWith(dateColumnIndex: v))),
        columnPicker('Сумма', mapping.amountColumnIndex,
            (v) => notifier.updateMapping(mapping.copyWith(amountColumnIndex: v))),
        columnPicker('Мерчант', mapping.merchantColumnIndex,
            (v) => notifier.updateMapping(mapping.copyWith(merchantColumnIndex: v))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: mapping.dateFormat,
          decoration: const InputDecoration(labelText: 'Формат даты'),
          items: _dateFormats
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: (v) {
            if (v != null) {
              notifier.updateMapping(mapping.copyWith(dateFormat: v));
            }
          },
        ),
        SwitchListTile(
          title: const Text('Расход — отрицательное число'),
          value: mapping.expenseIsNegative,
          onChanged: (v) =>
              notifier.updateMapping(mapping.copyWith(expenseIsNegative: v)),
        ),
      ],
    );
  }

  String _sample(dynamic table, int i) {
    final rows = (table.rows as List<List<String>>);
    if (rows.isEmpty) return '';
    final first = rows.first;
    return i < first.length ? first[i] : '';
  }
}
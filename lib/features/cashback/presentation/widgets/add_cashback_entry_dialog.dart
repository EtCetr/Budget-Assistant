import 'package:flutter/material.dart';
import 'package:budget_assistant/features/categories/domain/entities/category.dart';

/// Результат диалога добавления категории кэшбэка.
class AddCashbackEntryResult {
  const AddCashbackEntryResult({
    required this.categoryId,
    required this.categoryName,
    required this.percentBps,
    required this.lifetimeType,
  });

  final String categoryId;
  final String categoryName;
  final int percentBps;
  final String lifetimeType;
}

class AddCashbackEntryDialog extends StatefulWidget {
  const AddCashbackEntryDialog({super.key, required this.categories});

  final List<Category> categories;

  static Future<AddCashbackEntryResult?> show(
      BuildContext context, List<Category> categories) {
    return showDialog<AddCashbackEntryResult>(
      context: context,
      builder: (_) => AddCashbackEntryDialog(categories: categories),
    );
  }

  @override
  State<AddCashbackEntryDialog> createState() => _AddCashbackEntryDialogState();
}

class _AddCashbackEntryDialogState extends State<AddCashbackEntryDialog> {
  String? _categoryId;
  String _lifetimeType = 'monthly';
  String? _categoryError;
  String? _percentError;
  final _percentController = TextEditingController();

  @override
  void dispose() {
    _percentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_categoryId == null) {
      setState(() => _categoryError = 'Выберите категорию');
      return;
    }
    final percent =
        double.tryParse(_percentController.text.replaceAll(',', '.'));
    if (percent == null || percent <= 0 || percent > 100) {
      setState(() => _percentError = 'Введите процент от 0 до 100');
      return;
    }
    final category = widget.categories.firstWhere((c) => c.id == _categoryId);
    final bps = (percent * 100).round();
    Navigator.of(context).pop(AddCashbackEntryResult(
      categoryId: category.id,
      categoryName: category.name,
      percentBps: bps,
      lifetimeType: _lifetimeType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Категория кэшбэка'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Категория',
                errorText: _categoryError,
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _categoryId,
                hint: const Text('Выберите категорию'),
                items: widget.categories
                    .map((c) =>
                        DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (v) => setState(() {
                  _categoryId = v;
                  _categoryError = null;
                }),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _percentController,
              decoration: InputDecoration(
                labelText: 'Процент кэшбэка',
                hintText: 'напр. 5',
                errorText: _percentError,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() => _percentError = null),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'monthly', label: Text('Месяц')),
                ButtonSegment(value: 'weekly', label: Text('Неделя')),
              ],
              selected: {_lifetimeType},
              onSelectionChanged: (s) =>
                  setState(() => _lifetimeType = s.first),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Добавить')),
      ],
    );
  }
}
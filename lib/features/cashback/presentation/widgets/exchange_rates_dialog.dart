import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cashback_providers.dart';
import '../../domain/entities/exchange_rate_entry.dart';

/// Диалог управления курсами валют (список + ручное добавление).
class ExchangeRatesDialog extends ConsumerWidget {
  const ExchangeRatesDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const ExchangeRatesDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratesAsync = ref.watch(exchangeRatesRecentProvider);
    return AlertDialog(
      title: const Text('Курсы валют'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: ratesAsync.when(
                data: (rates) => rates.isEmpty
                    ? const Center(child: Text('Курсы не добавлены'))
                    : ListView.builder(
                        itemCount: rates.length,
                        itemBuilder: (context, i) => _RateTile(rate: rates[i]),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Ошибка: $e')),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _AddRateDialog.show(context),
              icon: const Icon(Icons.add),
              label: const Text('Добавить курс'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}

class _RateTile extends StatelessWidget {
  const _RateTile({required this.rate});

  final ExchangeRateEntry rate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text('${rate.fromCurrency} → ${rate.toCurrency}'),
      subtitle: Text(DateFormat.yMd('ru').format(rate.date)),
      trailing: Text('${rate.rate}'),
    );
  }
}

class _AddRateDialog extends ConsumerStatefulWidget {
  const _AddRateDialog();

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const _AddRateDialog());
  }

  @override
  ConsumerState<_AddRateDialog> createState() => _AddRateDialogState();
}

class _AddRateDialogState extends ConsumerState<_AddRateDialog> {
  final _fromController = TextEditingController(text: 'USD');
  final _toController = TextEditingController(text: 'RUB');
  final _rateController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final rate = double.tryParse(_rateController.text.replaceAll(',', '.'));
    if (rate == null || rate <= 0) {
      setState(() => _error = 'Введите корректный курс');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repo = ref.read(exchangeRateRepositoryProvider);
      await repo.upsertRate(
        fromCurrency: _fromController.text.trim().toUpperCase(),
        toCurrency: _toController.text.trim().toUpperCase(),
        dateUtc: _date.toUtc(),
        rate: rate,
        source: 'manual',
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = 'Не удалось сохранить курс');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новый курс'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(labelText: 'Из валюты (напр. USD)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(labelText: 'В валюту (напр. RUB)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rateController,
              decoration:
                  const InputDecoration(labelText: 'Курс', hintText: 'напр. 92.5'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Дата'),
                child: Text(DateFormat.yMd('ru').format(_date)),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
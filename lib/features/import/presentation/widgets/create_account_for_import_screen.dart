import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/constants/currency_codes.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account_types.dart';
import 'package:budget_assistant/features/accounts/presentation/widgets/account_type_ui.dart';

/// Полноэкранный формат создания счёта из мастера импорта:
/// тот же набор полей, что в модуле счетов (название, баланс, валюта, тип).
class CreateAccountForImportScreen extends StatefulWidget {
  const CreateAccountForImportScreen({super.key});

  @override
  State<CreateAccountForImportScreen> createState() =>
      _CreateAccountForImportScreenState();
}

class _CreateAccountForImportScreenState
    extends State<CreateAccountForImportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String _currency = 'RUB';
  String _accountType = AccountTypes.debit;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final balanceText =
        _balanceController.text.replaceAll(' ', '').replaceAll(',', '.');
    final balance = double.tryParse(balanceText) ?? 0;
    Navigator.of(context).pop<Map<String, Object?>>({
      'name': _nameController.text.trim(),
      'accountType': _accountType,
      'currency': _currency,
      'balanceKopecks': (balance * 100).round(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новый счёт')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Название счёта *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Укажите название' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Начальный баланс',
                hintText: '0.00',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\s.,]')),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _currency,
              decoration: const InputDecoration(labelText: 'Валюта'),
              items: [
                for (final code in kCurrencyCodes)
                  DropdownMenuItem(value: code, child: Text(code)),
              ],
              onChanged: (v) => setState(() => _currency = v ?? 'RUB'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _accountType,
              decoration: const InputDecoration(labelText: 'Тип счёта'),
              items: [
                for (final type in AccountTypes.all)
                  DropdownMenuItem(
                    value: type,
                    child: Text(accountTypeMeta(type).label),
                  ),
              ],
              onChanged: (v) =>
                  setState(() => _accountType = v ?? AccountTypes.debit),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: const Text('Создать и вернуться к импорту'),
            ),
          ],
        ),
      ),
    );
  }
}
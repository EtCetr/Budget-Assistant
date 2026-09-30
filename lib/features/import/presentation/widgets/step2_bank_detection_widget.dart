import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../providers/import_onboarding_notifier.dart';
import '../providers/import_wizard_providers.dart';

/// Formatter для разделения разрядов при вводе баланса.
/// 2000000 → 2 000 000, 2000000.50 → 2 000 000.50
class ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    
    var text = newValue.text.replaceAll(' ', '');
    text = text.replaceAll(RegExp(r'[^\d.,]'), '');
    text = text.replaceAll(',', '.');
    
    var dotIndex = text.indexOf('.');
    if (dotIndex != -1) {
      var beforeDot = text.substring(0, dotIndex);
      var afterDot = text.substring(dotIndex + 1);
      afterDot = afterDot.replaceAll('.', '');
      text = '$beforeDot.$afterDot';
    }
    
    var parts = text.split('.');
    var integerPart = parts[0];
    var decimalPart = parts.length > 1 ? parts[1] : '';
    
    var buffer = StringBuffer();
    for (var i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(integerPart[i]);
    }
    
    var formatted = buffer.toString();
    if (decimalPart.isNotEmpty) {
      formatted += '.$decimalPart';
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class Step2BankDetectionWidget extends ConsumerStatefulWidget {
  const Step2BankDetectionWidget({super.key});

  @override
  ConsumerState<Step2BankDetectionWidget> createState() =>
      _Step2BankDetectionWidgetState();
}

class _Step2BankDetectionWidgetState
    extends ConsumerState<Step2BankDetectionWidget> {
  final _customBankController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountBalanceController = TextEditingController();

  @override
  void dispose() {
    _customBankController.dispose();
    _accountNameController.dispose();
    _accountBalanceController.dispose();
    super.dispose();
  }

  void _showCreateBankDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Добавить новый банк'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _customBankController,
              decoration: const InputDecoration(labelText: 'Название банка'),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              final name = _customBankController.text.trim();
              if (name.isNotEmpty) {
                ref.read(importOnboardingProvider.notifier).createNewBank(
                  bankName: name,
                  bankCode: name.toLowerCase().replaceAll(' ', '_'),
                  formats: const ['csv', 'xlsx', 'pdf'],
                );
                Navigator.pop(ctx);
                _customBankController.clear();
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showCreateAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Новый счёт'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _accountNameController,
              decoration: const InputDecoration(labelText: 'Название счёта'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _accountBalanceController,
              decoration: const InputDecoration(
                labelText: 'Начальный баланс (₽)',
                hintText: '0.00',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                ThousandsSeparatorFormatter(),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              final name = _accountNameController.text.trim();
              final balanceText = _accountBalanceController.text
                  .replaceAll(' ', '')
                  .replaceAll(',', '.');
              final balanceRubles = double.tryParse(balanceText) ?? 0;
              final balanceKopecks = (balanceRubles * 100).round();
              
              if (name.isNotEmpty) {
                ref.read(importOnboardingProvider.notifier).createNewAccount(
                  accountName: name,
                  accountType: 'checking',
                  currency: 'RUB',
                  initialBalance: balanceKopecks,
                );
                Navigator.pop(ctx);
                _accountNameController.clear();
                _accountBalanceController.clear();
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importOnboardingProvider);
    final notifier = ref.read(importOnboardingProvider.notifier);
    final allBanksAsync = ref.watch(parserConfigsListProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Определение банка',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Мы попытались определить банк по содержимому файла',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),

        if (state.detectedBanks.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderDivider),
            ),
            child: const Row(
              children: [
                Icon(Icons.search_off, color: AppColors.textSecondary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Не удалось определить банк автоматически',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          )
        else
          ...state.detectedBanks.map((detected) {
            final isSelected =
                state.selectedConfig?.bankCode == detected.bankCode;
            return GestureDetector(
              onTap: () => notifier.selectDetectedBank(detected.bankCode),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.colorFAB
                        : AppColors.borderDivider,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detected.bankName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Уверенность: ${(detected.confidence * 100).round()}%',
                            style: const TextStyle(
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    RadioGroup<String>(
                      groupValue: state.selectedConfig?.bankCode,
                      onChanged: (v) {
                        if (v != null) notifier.selectDetectedBank(v);
                      },
                      child: Radio<String>(value: detected.bankCode),
                    ),
                  ],
                ),
              ),
            );
          }),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        const Text(
          'Все банки',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        allBanksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Text('Не удалось загрузить список банков'),
          data: (banks) {
            if (banks.isEmpty) {
              return const Text('Нет доступных банков');
            }
            return Column(
              children: banks.map((bank) {
                final isSelected =
                    state.selectedConfig?.bankCode == bank.bankCode;
                return GestureDetector(
                  onTap: () => notifier.selectDetectedBank(bank.bankCode),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.colorFAB
                            : AppColors.borderDivider,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            bank.bankName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        RadioGroup<String>(
                          groupValue: state.selectedConfig?.bankCode,
                          onChanged: (v) {
                            if (v != null) notifier.selectDetectedBank(v);
                          },
                          child: Radio<String>(value: bank.bankCode),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),

        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _showCreateBankDialog,
          icon: const Icon(Icons.add),
          label: const Text('Добавить новый банк'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),

        // === Секция счетов ===
        if (state.selectedConfig != null || state.customBankName != null) ...[
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Выберите счёт',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (state.accountsForBank.isEmpty)
            const Text(
              'Нет счетов для этого банка',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            ...state.accountsForBank.map((account) {
              final isSelected = state.selectedAccountId == account.id;
              return GestureDetector(
                onTap: () => notifier.selectAccount(account.id),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.colorFAB
                          : AppColors.borderDivider,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.customName.isNotEmpty 
                                  ? account.customName 
                                  : account.bankName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Баланс: ${(account.currentBalance / 100).toStringAsFixed(2)} ₽',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RadioGroup<String>(
                        groupValue: state.selectedAccountId,
                        onChanged: (v) {
                          if (v != null) notifier.selectAccount(v);
                        },
                        child: Radio<String>(value: account.id),
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _showCreateAccountDialog,
            icon: const Icon(Icons.add),
            label: const Text('Добавить счёт'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ],
    );
  }
}
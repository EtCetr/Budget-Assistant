import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../providers/import_onboarding_notifier.dart';

class Step2BankDetectionWidget extends ConsumerStatefulWidget {
  const Step2BankDetectionWidget({super.key});

  @override
  ConsumerState<Step2BankDetectionWidget> createState() =>
      _Step2BankDetectionWidgetState();
}

class _Step2BankDetectionWidgetState
    extends ConsumerState<Step2BankDetectionWidget> {
  final _customBankController = TextEditingController();

  @override
  void dispose() {
    _customBankController.dispose();
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
            final isSelected = state.selectedConfig?.bankCode == detected.bankCode;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.colorFAB : AppColors.borderDivider,
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
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  RadioGroup<String>(
                    groupValue: state.selectedConfig?.bankCode,
                    onChanged: (v) {
                      if (v != null) notifier.selectDetectedBank(v);
                    },
                    child: Radio<String>(
                      value: detected.bankCode,
                    ),
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),

        const Text(
          'Выбрать вручную',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _showCreateBankDialog,
          icon: const Icon(Icons.add),
          label: const Text('Добавить новый банк'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../providers/import_onboarding_notifier.dart';

class Step4AccountSelectionWidget extends ConsumerWidget {
  const Step4AccountSelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importOnboardingProvider);
    final notifier = ref.read(importOnboardingProvider.notifier);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Импорт в:',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                'Банк: ${state.selectedConfig?.bankName ?? state.customBankName ?? "—"}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Счёт: ${state.selectedAccountId ?? "—"}',
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Опции импорта',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Проверять дубликаты'),
          value: state.options.detectDuplicates,
          onChanged: (v) => notifier.setOptions(
              state.options.copyWith(detectDuplicates: v)),
        ),
        SwitchListTile(
          title: const Text('Помечать переводы между своими счетами'),
          value: state.options.detectTransfers,
          onChanged: (v) => notifier.setOptions(
              state.options.copyWith(detectTransfers: v)),
        ),
        SwitchListTile(
          title: const Text('Проверять режим секретности'),
          value: state.options.checkSecrecy,
          onChanged: (v) =>
              notifier.setOptions(state.options.copyWith(checkSecrecy: v)),
        ),
        SwitchListTile(
          title: const Text('Автокатегоризация'),
          value: state.options.autoCategorize,
          onChanged: (v) =>
              notifier.setOptions(state.options.copyWith(autoCategorize: v)),
        ),
        SwitchListTile(
          title: const Text('Поиск регулярных платежей'),
          value: state.options.detectRecurring,
          onChanged: (v) =>
              notifier.setOptions(state.options.copyWith(detectRecurring: v)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow('Файл', state.parsedFile?.fileName ?? '—'),
              _summaryRow('Транзакций',
                  '${state.parsedFile?.parseResult.rows.length ?? 0}'),
            ],
          ),
        ),
      ],
    );
  }

  /// Фикс overflow: значение в Expanded с ellipsis (длинные имена файлов).
  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../providers/import_onboarding_notifier.dart';
import '../providers/import_wizard_providers.dart';

class Step4AccountSelectionWidget extends ConsumerWidget {
  const Step4AccountSelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importOnboardingProvider);
    final notifier = ref.read(importOnboardingProvider.notifier);
    final userId = ref.watch(currentUserIdProvider);
    final spaceId = ref.watch(currentSpaceIdProvider);
    final accountsAsync = ref.watch(
        importTargetAccountsProvider((userId, spaceId, state.scopeFamily)));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Личный')),
            ButtonSegment(value: true, label: Text('Семейный')),
          ],
          selected: {state.scopeFamily},
          onSelectionChanged: (s) => notifier.setScopeFamily(s.first),
        ),
        const SizedBox(height: 16),
        accountsAsync.when(
          loading: () => Column(children: [
            SkeletonShimmer.card(),
            const SizedBox(height: 12),
            SkeletonShimmer.card(),
          ]),
          error: (_, __) => const Text('Не удалось загрузить счета',
              style: TextStyle(color: AppColors.textSecondary)),
          data: (accounts) => RadioGroup<String>(
            groupValue: state.targetAccountId,
            onChanged: (v) {
              if (v != null) notifier.setTargetAccount(v);
            },
            child: Column(
              children: accounts
                  .map((a) => RadioListTile<String>(
                        title: Text(a.customName.isNotEmpty ? a.customName : a.bankName,
                            style: const TextStyle(
                                color: AppColors.textPrimary)),
                        subtitle: Text(a.cardNumberMask ?? '',
                            style: const TextStyle(
                                color: AppColors.textSecondary)),
                        value: a.id,
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Опции импорта',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        _option('Проверять дубликаты', state.options.detectDuplicates,
            (v) => notifier.setOptions(state.options.copyWith(detectDuplicates: v))),
        _option('Искать переводы между счетами', state.options.detectTransfers,
            (v) => notifier.setOptions(state.options.copyWith(detectTransfers: v))),
        _option('Проверять режим секретности', state.options.checkSecrecy,
            (v) => notifier.setOptions(state.options.copyWith(checkSecrecy: v))),
        _option('Автокатегоризация', state.options.autoCategorize,
            (v) => notifier.setOptions(state.options.copyWith(autoCategorize: v))),
        _option('Поиск регулярных платежей', state.options.detectRecurring,
            (v) => notifier.setOptions(state.options.copyWith(detectRecurring: v))),
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
              _summaryRow('Банк', state.selectedConfig?.bankName ?? '—'),
              _summaryRow('Файл', state.parsedFile?.fileName ?? '—'),
              _summaryRow(
                  'Транзакций', '${state.parsedFile?.parseResult.rows.length ?? 0}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _option(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
        title: Text(title), value: value, onChanged: onChanged);
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/import/domain/entities/parser_config.dart';
import '../providers/import_onboarding_notifier.dart';

class Step1BankSelectionWidget extends ConsumerWidget {
  const Step1BankSelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(importOnboardingProvider).searchQuery;
    final configsAsync = ref.watch(bankSearchProvider(query));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: ref.read(importOnboardingProvider.notifier).setSearch,
            decoration: const InputDecoration(
              hintText: 'Поиск банка',
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            ),
          ),
        ),
        Expanded(
          child: configsAsync.when(
            loading: () => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SkeletonShimmer.card(),
                const SizedBox(height: 12),
                SkeletonShimmer.card(),
                const SizedBox(height: 12),
                SkeletonShimmer.card(),
              ],
            ),
            error: (_, __) => const EmptyStateWidget(
              icon: Icons.cloud_off_outlined,
              title: 'Не удалось загрузить список банков',
              primaryAction: EmptyStateAction(
                label: 'Повторить',
                onPressed: _retry,
              ),
            ),
            data: (configs) {
              if (configs.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.search_off_outlined,
                  title: 'Банк не найден',
                  subtitle: 'Попробуйте другой запрос',
                );
              }
              final popular = configs.where((c) => c.isPopular).toList();
              final rest = configs.where((c) => !c.isPopular).toList();
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (popular.isNotEmpty) ...[
                    const Text('Популярные',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    ...popular.map((c) => _tile(context, ref, c)),
                  ],
                  if (rest.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Все банки',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    ...rest.map((c) => _tile(context, ref, c)),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  static void _retry() {}

  Widget _tile(BuildContext context, WidgetRef ref, ParserConfig config) {
    final selected =
        ref.watch(importOnboardingProvider).selectedConfig?.id == config.id;
    return ListTile(
      onTap: () =>
          ref.read(importOnboardingProvider.notifier).selectConfig(config),
      selected: selected,
      selectedTileColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: CircleAvatar(
        backgroundColor: AppColors.surfaceElevated,
        child: Text(config.bankName.characters.first.toUpperCase()),
      ),
      title: Text(config.bankName,
          style: const TextStyle(color: AppColors.textPrimary)),
      subtitle: Text(config.supportedFormats.join(' / ').toUpperCase(),
          style: const TextStyle(color: AppColors.textSecondary)),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.colorFAB)
          : null,
    );
  }
}
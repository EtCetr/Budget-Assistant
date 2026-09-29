import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/import/domain/entities/secrecy_candidate.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/import_secrets_providers.dart';
import '../providers/post_import_review_providers.dart';

class SecrecyCandidateCard extends ConsumerWidget {
  const SecrecyCandidateCard({super.key, required this.candidate});

  final SecrecyCandidate candidate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importSecretsProvider);
    final notifier = ref.read(importSecretsProvider.notifier);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final categoriesAsync = ref.watch(reviewCategoriesProvider);
    final selected = state.selectedIds.contains(candidate.id);
    final fmt = DateFormat('d MMMM', 'ru');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: selected
                ? AppColors.colorFAB.withValues(alpha: 0.5)
                : AppColors.borderDivider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: selected,
            onChanged: (_) => notifier.toggle(candidate.id),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        formatter.formatMerchant(
                            candidate.transaction.merchantName, mode),
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formatter.formatAmount(
                          candidate.transaction.amountKopecks, 'RUB', mode),
                      style: const TextStyle(
                          color: AppColors.colorExpense,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                    '🎁 ${candidate.relatedHolidayName}, '
                    '${fmt.format(candidate.relatedHolidayDate)}',
                    style: const TextStyle(color: AppColors.colorFAB)),
                Text(
                    'AI: подарок на ${(candidate.confidence * 100).round()}%',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                categoriesAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (categories) => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: state.categoryByCandidate[candidate.id],
                      hint: const Text('Категория',
                          style: TextStyle(fontSize: 13)),
                      items: [
                        for (final c in categories)
                          DropdownMenuItem(
                            value: c.id,
                            child: Text('${c.iconEmoji ?? ''} ${c.name}',
                                style: const TextStyle(fontSize: 13)),
                          ),
                      ],
                      onChanged: (v) => notifier.setCategory(candidate.id, v),
                    ),
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
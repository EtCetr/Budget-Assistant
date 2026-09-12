import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import '../../domain/entities/budget_limit.dart';
import '../providers/budget_providers.dart';
import 'budget_progress_indicator.dart';

class BudgetLimitCard extends ConsumerWidget {
  final BudgetLimit limit;
  final BalanceVisibilityMode privacyMode;
  final PrivacyFormatter formatter;
  final VoidCallback? onTap;

  const BudgetLimitCard({
    super.key,
    required this.limit,
    required this.privacyMode,
    required this.formatter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveLimitAsync = ref.watch(
      effectiveLimitForCategoryProvider(limit.categoryId),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: effectiveLimitAsync.when(
            data: (effective) {
              if (effective == null) {
                return _buildContent(
                  categoryName: 'Категория',
                  spent: 0,
                  limitAmount: limit.limitAmount,
                  percentUsed: 0,
                );
              }
              return _buildContent(
                categoryName: 'Категория',
                spent: effective.spent,
                limitAmount: effective.effectiveTotal,
                percentUsed: effective.percentUsed,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Ошибка: $e'),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required String categoryName,
    required int spent,
    required int limitAmount,
    required int percentUsed,
  }) {
    final spentText = formatter.formatAmount(spent, 'RUB', privacyMode);
    final limitText = formatter.formatAmount(limitAmount, 'RUB', privacyMode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BudgetProgressIndicator(
          percentUsed: percentUsed,
          privacyMode: privacyMode,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Потрачено: $spentText',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Лимит: $limitText',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
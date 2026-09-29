import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/post_import_review_notifier.dart';

/// Sticky-сводка выбранных транзакций (ТЗ 6.3.26).
class SelectedSummary extends ConsumerWidget {
  const SelectedSummary({super.key, required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(postImportReviewProvider.notifier);
    final summary = notifier.summary();
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    return Container(
      color: AppColors.surfaceCard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Выбрано: ${summary.count} из $totalCount',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700)),
            Text(
                formatter.formatAmount(summary.totalKopecks, 'RUB', mode),
                style: TextStyle(
                    color: summary.totalKopecks < 0
                        ? AppColors.colorExpense
                        : AppColors.colorIncome,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
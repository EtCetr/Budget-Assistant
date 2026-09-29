import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/import/presentation/providers/post_import_review_providers.dart';

/// Мета-баннер импорта (ТЗ 6.3.26.3).
class ImportSummaryBanner extends ConsumerWidget {
  const ImportSummaryBanner({
    super.key,
    required this.bankName,
    required this.fileName,
    required this.totalRows,
    required this.periodStart,
    required this.periodEnd,
    required this.targetAccountId,
  });

  final String bankName;
  final String fileName;
  final int totalRows;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String targetAccountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = DateFormat('dd.MM.yyyy');
    final accountAsync = ref.watch(reviewTargetAccountProvider(targetAccountId));
    final acc = accountAsync.asData?.value;
    final accountName = acc == null
        ? '...'
        : (acc.customName.isNotEmpty ? acc.customName : acc.bankName);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colorIncome.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Импортировано $totalRows транзакций из $bankName',
              style: const TextStyle(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
              'Период: ${fmt.format(periodStart)} - ${fmt.format(periodEnd)}',
              style: const TextStyle(color: AppColors.textSecondary)),
          Text('Файл: $fileName · Счёт: $accountName',
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
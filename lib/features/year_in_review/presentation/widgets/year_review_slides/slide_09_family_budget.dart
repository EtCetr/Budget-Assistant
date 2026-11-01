import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 9: Семейный бюджет (только для space_id != NULL).
/// Секретные траты — общей строкой без детализации (ТЗ 6.3.37.8).
class SlideFamilyBudget extends StatelessWidget {
  const SlideFamilyBudget({
    super.key,
    required this.data,
    required this.pf,
    required this.mode,
  });

  final YearInReviewData data;
  final PrivacyFormatter pf;
  final BalanceVisibilityMode mode;

  @override
  Widget build(BuildContext context) {
    return YearReviewSlideScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('👨‍👩‍👧', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.familyBudget,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            YearReviewStrings.familySpent,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            pf.formatAmount(
                data.familyTotalExpense, data.baseCurrency, mode),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.colorTransfer,
            ),
          ),
          const SizedBox(height: 16),
          // Процент не раскрывает абсолютную сумму — виден всегда.
          Text(
            YearReviewStrings.familyPercent(data.familyMyPercent),
            style: const TextStyle(color: AppColors.colorIncome, fontSize: 16),
          ),
          if (data.familySecretTotal > 0) ...[
            const SizedBox(height: 12),
            Text(
              YearReviewStrings.secretLine(pf.formatAmount(
                  data.familySecretTotal, data.baseCurrency, mode)),
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
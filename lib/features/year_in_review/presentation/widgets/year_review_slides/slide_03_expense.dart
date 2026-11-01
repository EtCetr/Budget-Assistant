import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 3: Общие расходы + самый щедрый месяц.
class SlideExpense extends StatelessWidget {
  const SlideExpense({
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
    final month = data.mostGenerousMonth;
    return YearReviewSlideScaffold(
      colors: const [Color(0xFF7F1D1D), AppColors.surfaceBackground],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💸', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.spent,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            pf.formatAmount(data.totalExpense, data.baseCurrency, mode),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.colorExpense,
            ),
          ),
          if (month != null) ...[
            const SizedBox(height: 16),
            Text(
              YearReviewStrings.mostGenerousMonth(
                  YearReviewStrings.monthName(month)),
              style: const TextStyle(
                  color: AppColors.colorWarning, fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 2: Общий доход + рост к прошлому году.
/// Маскировка сумм — через PrivacyFormatter (partial/hidden = •••).
class SlideIncome extends StatelessWidget {
  const SlideIncome({
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
    final growth = data.incomeGrowthPercent;
    final String comparison;
    if (growth == null || growth == 0) {
      comparison = YearReviewStrings.firstYear;
    } else if (growth > 0) {
      comparison = YearReviewStrings.moreThanLastYear(growth);
    } else {
      comparison = YearReviewStrings.lessThanLastYear(growth.abs());
    }

    return YearReviewSlideScaffold(
      colors: const [Color(0xFF14532D), AppColors.surfaceBackground],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💰', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.youEarned,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            pf.formatAmount(data.totalIncome, data.baseCurrency, mode),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.colorIncome,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            comparison,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
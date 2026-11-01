import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 7: Накопления (отложено в цели + закрытые цели).
class SlideSavings extends StatelessWidget {
  const SlideSavings({
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
    final allDone =
        data.goalsTotal > 0 && data.goalsCompleted >= data.goalsTotal;
    return YearReviewSlideScaffold(
      colors: const [Color(0xFF14532D), AppColors.surfaceBackground],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏦', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.savings,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            YearReviewStrings.savedLine,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            pf.formatAmount(data.totalSaved, data.baseCurrency, mode),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.colorIncome,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            allDone
                ? YearReviewStrings.allGoalsDone
                : YearReviewStrings.goalsClosed(
                    data.goalsCompleted, data.goalsTotal),
            style: const TextStyle(color: AppColors.colorIncome, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
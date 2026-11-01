import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 11: Savings Rate. Процент виден во всех режимах
/// (не раскрывает абсолютные суммы).
class SlideSavingsRate extends StatelessWidget {
  const SlideSavingsRate({super.key, required this.data});

  final YearInReviewData data;

  @override
  Widget build(BuildContext context) {
    final rate = data.savingsRate;
    final String comparison;
    if (rate < 0) {
      comparison = YearReviewStrings.negativeRate;
    } else if (rate > 12) {
      comparison = YearReviewStrings.aboveAverage;
    } else {
      comparison = YearReviewStrings.belowAverage;
    }

    return YearReviewSlideScaffold(
      colors: const [Color(0xFF14532D), AppColors.surfaceBackground],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.savingsRate,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            YearReviewStrings.savingsRateLine,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            '$rate%',
            style: const TextStyle(
              fontSize: 56,
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
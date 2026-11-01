import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// Упрощённый слайд для «мало данных» (< 10 транзакций, ТЗ 6.3.37.11а).
class SlideLittleData extends StatelessWidget {
  const SlideLittleData({super.key, required this.data});

  final YearInReviewData data;

  @override
  Widget build(BuildContext context) {
    final month = data.firstBudgetMonth;
    return YearReviewSlideScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            month == null
                ? YearReviewStrings.addMoreOps
                : YearReviewStrings.startedBudgeting(
                    YearReviewStrings.monthName(month)),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          if (month != null) ...[
            const SizedBox(height: 16),
            const Text(
              YearReviewStrings.addMoreOps,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}
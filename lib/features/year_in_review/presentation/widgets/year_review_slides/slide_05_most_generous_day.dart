import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 5: Самый щедрый день года.
class SlideGenerousDay extends StatelessWidget {
  const SlideGenerousDay({
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
    final day = DateTime.tryParse(data.mostGenerousDay ?? '');
    final dateStr = day == null
        ? data.mostGenerousDay ?? ''
        : DateFormat('d MMMM y', 'ru').format(day);

    return YearReviewSlideScaffold(
      colors: const [Color(0xFF7F1D1D), AppColors.surfaceBackground],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎄', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.yourRecord,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          // Дата — метаданные, видна во всех режимах.
          Text(
            dateStr,
            style: const TextStyle(
              color: AppColors.colorWarning,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            YearReviewStrings.spent,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            pf.formatAmount(
                data.mostGenerousDayAmount, data.baseCurrency, mode),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.colorExpense,
            ),
          ),
        ],
      ),
    );
  }
}
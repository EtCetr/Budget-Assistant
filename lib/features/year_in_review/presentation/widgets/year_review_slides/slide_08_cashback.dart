import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 8: Кэшбэк — сумма за год + топ-3 категории (решение владельца).
class SlideCashback extends StatelessWidget {
  const SlideCashback({
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
      colors: const [Color(0xFF14532D), AppColors.surfaceBackground],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💳', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.cashback,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            YearReviewStrings.cashbackEarned,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            pf.formatAmount(data.cashbackTotal, data.baseCurrency, mode),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.colorIncome,
            ),
          ),
          if (data.cashbackBestCategory != null) ...[
            const SizedBox(height: 16),
            Text(
              '${YearReviewStrings.bestCategory}: '
              '${pf.formatName(data.cashbackBestCategory, mode)}',
              style: const TextStyle(color: AppColors.colorIncome, fontSize: 16),
            ),
          ],
          if (data.cashbackTop.isNotEmpty) ...[
            const SizedBox(height: 24),
            for (final c in data.cashbackTop)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        pf.formatName(c.name, mode),
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      pf.formatAmount(c.amount, data.baseCurrency, mode),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
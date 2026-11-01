import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 6: Инвестиции (условный). Портфеля в продукте нет (Этап 15),
/// поэтому показываем нетто-переводы на инвест-счета за год.
class SlideInvestments extends StatelessWidget {
  const SlideInvestments({
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
      colors: const [Color(0xFF1E3A8A), AppColors.surfaceBackground],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📈', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.investments,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            YearReviewStrings.investedLine,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            pf.formatAmount(data.netInvested, data.baseCurrency, mode),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.colorIncome,
            ),
          ),
        ],
      ),
    );
  }
}
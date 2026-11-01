import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 12: Финал. Длительность не ограничена (автоплей останавливается).
class SlideFinale extends StatelessWidget {
  const SlideFinale({
    super.key,
    required this.year,
    required this.onShare,
    required this.onHome,
  });

  final int year;
  final VoidCallback onShare;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return YearReviewSlideScaffold(
      colors: const [Color(0xFF14532D), AppColors.surfaceBackground],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🚀', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.finaleTitle(year + 1),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: onShare,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorFAB,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            icon: const Icon(Icons.share),
            label: const Text(YearReviewStrings.shareResults),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Text(YearReviewStrings.goHome),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_providers.dart';
import '../../providers/year_in_review_providers.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 1: Приветствие + селектор пространства (ТЗ 6.3.37, п.7).
class SlideWelcome extends ConsumerWidget {
  const SlideWelcome({super.key, required this.year, required this.onNext});

  final int year;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(yearReviewSpaceProvider);
    final spaces = ref.watch(userSpacesProvider).value ?? const [];

    return YearReviewSlideScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          Text(
            YearReviewStrings.title(year),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          const Text(
            YearReviewStrings.subtitle,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          if (spaces.isNotEmpty) ...[
            const SizedBox(height: 32),
            DropdownButton<String?>(
              value: selected,
              dropdownColor: AppColors.surfaceCard,
              style: const TextStyle(color: AppColors.textPrimary),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text(YearReviewStrings.onlyMe),
                ),
                for (final s in spaces)
                  DropdownMenuItem<String?>(
                    value: s.id,
                    child: Text(s.name),
                  ),
              ],
              onChanged: (v) {
                MotionTokens.selection();
                ref.read(yearReviewSpaceProvider.notifier).select(v);
              },
            ),
          ],
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              MotionTokens.medium();
              onNext();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorFAB,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text(YearReviewStrings.start,
                style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
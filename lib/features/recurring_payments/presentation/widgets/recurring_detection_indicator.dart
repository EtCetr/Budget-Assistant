import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../providers/recurring_detection_providers.dart';
import '../recurring_detection_strings.dart';

/// Floating Indicator на календаре (ТЗ 6.3.5.7): виден, пока есть
/// кандидаты pending_confirmation; «Проверить» ведёт на экран детекции.
class RecurringDetectionIndicator extends ConsumerWidget {
  const RecurringDetectionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingCandidatesProvider).value ?? const [];
    if (pending.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.all(AppSpacing.spacing8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing12,
        vertical: AppSpacing.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.colorTransfer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: Border.all(color: AppColors.colorTransfer),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome,
              color: AppColors.colorTransfer, size: 20),
          const SizedBox(width: AppSpacing.spacing8),
          Expanded(
            child: Text(
              '${RecurringDetectionStrings.indicatorPrefix}'
              '${pending.length}',
              style: const TextStyle(
                color: AppColors.colorTransfer,
                fontSize: 13,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              MotionTokens.light();
              context.push('/recurring-payments-detection');
            },
            child: const Text(RecurringDetectionStrings.indicatorCheck),
          ),
        ],
      ),
    );
  }
}
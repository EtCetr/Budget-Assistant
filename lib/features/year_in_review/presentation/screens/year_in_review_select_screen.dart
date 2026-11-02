import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import '../../domain/models/yearly_aggregate.dart';
import '../providers/year_in_review_providers.dart';
import '../year_review_strings.dart';

/// Отдельный экран «Статистика по годам» (решение владельца, Этап 19):
/// выбор года -> сторис за этот год. Кэш за прошлые годы хранится в
/// yearly_aggregates и досчитывается при первом открытии.
class YearInReviewSelectScreen extends ConsumerWidget {
  const YearInReviewSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsAsync = ref.watch(availableYearsProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        foregroundColor: Colors.white,
        title: const Text(YearReviewStrings.selectTitle),
      ),
      body: yearsAsync.when(
        loading: () => const Center(
          child: SkeletonShimmer(width: 260, height: 320),
        ),
        error: (e, _) => Center(
          child: OfflineErrorCard(
            message: YearReviewStrings.loadingError,
            retryLabel: YearReviewStrings.retry,
            onRetry: () => ref.invalidate(availableYearsProvider),
          ),
        ),
        data: (years) {
          if (years.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.insights_outlined,
              title: YearReviewStrings.noDataTitle,
              subtitle: YearReviewStrings.noDataSubtitle,
              primaryAction: EmptyStateAction(
                label: YearReviewStrings.addFirstTx,
                onPressed: () => context.go('/transactions'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: years.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _YearCard(info: years[index]),
          );
        },
      ),
    );
  }
}

class _YearCard extends StatelessWidget {
  const _YearCard({required this.info});

  final YearInReviewYearInfo info;

  @override
  Widget build(BuildContext context) {
    final status =
        info.isCalculated ? YearReviewStrings.ready : YearReviewStrings.willCalculate;
    return Material(
      color: AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        onTap: () {
          MotionTokens.selection();
          context.push('/year-in-review/${info.year}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${info.year}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.colorIncome,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      YearReviewStrings.txCount(info.transactionCount),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (info.isViewed)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.check_circle,
                      color: AppColors.colorIncome, size: 20),
                ),
              const Icon(Icons.chevron_right,
                  color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
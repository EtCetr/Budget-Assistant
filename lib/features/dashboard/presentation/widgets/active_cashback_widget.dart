import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/offline_error_card.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../../../features/privacy/domain/models/balance_visibility_mode.dart';
import '../dashboard_strings.dart';
import '../providers/dashboard_providers.dart';

class ActiveCashbackWidget extends ConsumerWidget {
  const ActiveCashbackWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashbackAsync = ref.watch(dashboardActiveCashbackProvider);
    final formatter = ref.watch(privacyFormatterProvider);

    return cashbackAsync.when(
      loading: () => const SkeletonShimmer(height: 120),
      error: (error, _) => OfflineErrorCard(
        message: DashboardStrings.loadingError,
        retryLabel: DashboardStrings.retry,
        onRetry: () => ref.invalidate(dashboardActiveCashbackProvider),
      ),
      data: (items) {
        final now = DateTime.now();
        final monthName = DateFormat.MMMM('ru').format(now);

        if (items.isEmpty) {
          return EmptyStateWidget(
            animationAsset: 'assets/animations/empty_cards.json',
            title: 'Выберите категории на $monthName',
            subtitle: DashboardStrings.cashbackEmptySubtitle,
            primaryAction: EmptyStateAction(
              label: DashboardStrings.chooseCategories,
              onPressed: () => context.push('/cashback'),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DashboardStrings.cashbackTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.spacing12),
              SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.spacing8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final percent = formatter.formatPercentBps(
                      item.percentBps,
                      BalanceVisibilityMode.visible,
                    );
                    final expires = DateFormat('dd.MM').format(item.expiresAt);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.colorFAB.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.categoryName),
                          Text(
                            '$percent до $expires',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/offline_error_card.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../../features/auth/presentation/providers/current_user_provider.dart';
import '../../../../features/budget/presentation/providers/budget_providers.dart';
import '../../../../features/budget/presentation/widgets/budget_limit_card.dart';
import '../../../../features/categories/presentation/providers/category_providers.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../dashboard_strings.dart';

class LimitCardsWidget extends ConsumerWidget {
  const LimitCardsWidget({super.key});

  String _categoryName(dynamic categories, String categoryId) {
    if (categories == null) return 'Категория';
    for (final category in categories) {
      if (category.id == categoryId) return category.name;
    }
    return 'Категория';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limitsAsync = ref.watch(budgetLimitsForCurrentMonthProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    final userId = ref.watch(currentUserIdProvider);
    final categoriesAsync = ref.watch(categoriesListProvider(userId));

    return limitsAsync.when(
      loading: () => const SkeletonShimmer(height: 160),
      error: (error, _) => OfflineErrorCard(
        message: DashboardStrings.loadingError,
        retryLabel: DashboardStrings.retry,
        onRetry: () => ref.invalidate(budgetLimitsForCurrentMonthProvider),
      ),
      data: (limits) {
        if (limits.isEmpty) {
          return EmptyStateWidget(
            animationAsset: 'assets/animations/empty_chart.json',
            title: DashboardStrings.limitEmptyTitle,
            subtitle: DashboardStrings.limitEmptySubtitle,
            primaryAction: EmptyStateAction(
              label: 'Установить лимит',
              onPressed: () => context.push('/budget/create'),
            ),
          );
        }

        final categories = categoriesAsync.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DashboardStrings.limitsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.spacing8),
            for (final limit in limits)
              BudgetLimitCard(
                limit: limit,
                privacyMode: privacyMode,
                formatter: formatter,
                categoryName: _categoryName(categories, limit.categoryId),
              ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/offline_error_card.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../../core/providers/security_providers.dart';
import '../../../../features/accounts/presentation/providers/account_providers.dart';
import '../../../../features/auth/presentation/providers/current_user_provider.dart';
import '../../../../features/budget/presentation/providers/budget_providers.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../dashboard_strings.dart';

class BalanceSummaryWidget extends ConsumerStatefulWidget {
  const BalanceSummaryWidget({super.key});

  @override
  ConsumerState<BalanceSummaryWidget> createState() =>
      _BalanceSummaryWidgetState();
}

class _BalanceSummaryWidgetState extends ConsumerState<BalanceSummaryWidget> {
  bool _personal = true;

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserIdProvider);
    final accountsAsync = ref.watch(accountsListProvider(userId));
    final currentSpaceId = ref.watch(currentSpaceIdProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    final pnlAsync = ref.watch(monthlyPnlForCurrentMonthProvider);

    return accountsAsync.when(
      loading: () => const SkeletonShimmer(height: 180),
      error: (error, _) => OfflineErrorCard(
        message: DashboardStrings.loadingError,
        retryLabel: DashboardStrings.retry,
        onRetry: () => ref.invalidate(accountsListProvider(userId)),
      ),
      data: (accounts) {
        if (accounts.isEmpty) {
          return EmptyStateWidget(
            animationAsset: 'assets/animations/empty_wallet.json',
            title: 'Пока нет счетов',
            subtitle: 'Добавьте первый счёт, чтобы увидеть баланс',
            primaryAction: EmptyStateAction(
              label: DashboardStrings.addAccount,
              onPressed: () => context.push('/accounts'),
            ),
          );
        }

        int total = 0;

        for (final account in accounts) {
          if (_personal) {
            if (account.includeInPersonalBalance) {
              total += account.currentBalance;
            }
          } else {
            if (account.spaceId == currentSpaceId ||
                account.includeInFamilyBalance) {
              total += account.currentBalance;
            }
          }
        }

        final balanceText = formatter.formatAmount(
          total,
          'RUB',
          privacyMode,
        );

        final pnl = pnlAsync.value;

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
                DashboardStrings.balanceTitle,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.spacing8),
              Text(
                balanceText,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppSpacing.spacing16),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text(DashboardStrings.personal),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(DashboardStrings.family),
                  ),
                ],
                selected: {_personal},
                onSelectionChanged: (selection) {
                  setState(() => _personal = selection.first);
                },
              ),
              if (privacyMode != BalanceVisibilityMode.hidden && pnl != null) ...[
                const SizedBox(height: AppSpacing.spacing16),
                Text(
                  '+${formatter.formatAmount(pnl.totalIncome, 'RUB', privacyMode)} ${DashboardStrings.income} · '
                  '-${formatter.formatAmount(pnl.totalExpense, 'RUB', privacyMode)} ${DashboardStrings.expenses}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
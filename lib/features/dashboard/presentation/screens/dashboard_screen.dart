import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import '../../../../core/providers/security_providers.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/offline_error_card.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../../features/accounts/presentation/providers/account_providers.dart';
import '../../../../features/auth/presentation/providers/current_user_provider.dart';
import '../../../../features/budget/presentation/providers/budget_providers.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../../../features/spaces/presentation/providers/space_providers.dart';
import '../../domain/entities/dashboard_widget_type.dart';
import '../dashboard_strings.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/active_cashback_widget.dart';
import '../widgets/balance_summary_widget.dart';
import '../widgets/dashboard_empty_state.dart';
import '../widgets/dashboard_settings_sheet.dart';
import '../widgets/expense_flow_chart_widget.dart';
import '../widgets/limit_cards_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _openSettings(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const DashboardSettingsSheet(),
    );
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    final userId = ref.read(currentUserIdProvider);
    ref.invalidate(dashboardLayoutProvider);
    ref.invalidate(dashboardExpenseFlowProvider);
    ref.invalidate(dashboardActiveCashbackProvider);
    ref.invalidate(accountsListProvider(userId));
    ref.invalidate(monthlyPnlForCurrentMonthProvider);
    ref.invalidate(budgetLimitsForCurrentMonthProvider);
  }

  Widget _buildWidget(DashboardWidgetType type) {
    switch (type) {
      case DashboardWidgetType.balanceSummary:
        return const BalanceSummaryWidget();
      case DashboardWidgetType.expenseFlowChart:
        return const ExpenseFlowChartWidget();
      case DashboardWidgetType.activeCashbackCategories:
        return const ActiveCashbackWidget();
      case DashboardWidgetType.limitCards:
        return const LimitCardsWidget();
    }
  }

  void _showPrivacySheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(DashboardStrings.privacyVisible),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.visible);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                title: const Text(DashboardStrings.privacyPartial),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.partial);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                title: const Text(DashboardStrings.privacyHidden),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.hidden);
                  Navigator.of(sheetContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutAsync = ref.watch(dashboardLayoutProvider);
    final spacesAsync = ref.watch(userSpacesProvider);
    final currentSpaceId = ref.watch(currentSpaceIdProvider);
    final privacyMode = ref.watch(privacyModeProvider);

    final spaces = spacesAsync.value ?? const [];
    final currentSpace = spaces.where((s) => s.id == currentSpaceId).toList();
    final spaceTitle = currentSpace.isEmpty
        ? DashboardStrings.personalSpace
        : currentSpace.first.name;

    return Scaffold(
      appBar: AppBar(
        title: PopupMenuButton<String>(
          initialValue: currentSpaceId ?? '',
          tooltip: DashboardStrings.group,
          onSelected: (spaceId) {
            HapticFeedback.selectionClick();
            ref
                .read(currentSpaceIdProvider.notifier)
                .set(spaceId.isEmpty ? null : spaceId);
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: '',
                child: Text(DashboardStrings.personalSpace),
              ),
              for (final space in spaces)
                PopupMenuItem(value: space.id, child: Text(space.name)),
            ];
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(spaceTitle),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onLongPress: () => _showPrivacySheet(context, ref),
            child: IconButton(
              icon: Icon(
                privacyMode == BalanceVisibilityMode.hidden
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(privacyModeProvider.notifier).toggle();
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Budget Assistant',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text(DashboardStrings.navTransactions),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/transactions');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text(DashboardStrings.navAccounts),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/accounts');
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text(DashboardStrings.navCategories),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/categories');
                },
              ),
              ListTile(
                leading: const Icon(Icons.pie_chart),
                title: const Text(DashboardStrings.navBudget),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/budget');
                },
              ),
              ListTile(
                leading: const Icon(Icons.loyalty),
                title: const Text(DashboardStrings.navCashback),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/cashback');
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context, ref),
        child: layoutAsync.when(
          loading: () => ListView(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            children: const [
              SkeletonShimmer(height: 180),
              SizedBox(height: AppSpacing.spacing16),
              SkeletonShimmer(height: 220),
              SizedBox(height: AppSpacing.spacing16),
              SkeletonShimmer(height: 120),
            ],
          ),
          error: (error, _) => Center(
            child: OfflineErrorCard(
              message: DashboardStrings.loadingError,
              retryLabel: DashboardStrings.retry,
              onRetry: () => ref.invalidate(dashboardLayoutProvider),
            ),
          ),
          data: (layout) {
            final visible = layout.where((e) => e.isVisible).toList()
              ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
            if (visible.isEmpty) {
              return DashboardEmptyState(
                onConfigure: () => _openSettings(context),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              itemCount: visible.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.spacing16),
              itemBuilder: (context, index) {
                final item = visible[index];
                return GestureDetector(
                  onLongPress: () => _openSettings(context),
                  child: _buildWidget(item.type),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
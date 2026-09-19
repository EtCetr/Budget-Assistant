import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/savings_analytics_providers.dart';
import '../savings_goals_strings.dart';
import '../widgets/accumulation_chart.dart';
import '../widgets/savings_analytics_period_selector.dart';
import '../widgets/savings_analytics_summary_grid.dart';
import '../widgets/export_bottom_sheet.dart';

class SavingsAnalyticsScreen extends ConsumerStatefulWidget {
  const SavingsAnalyticsScreen({super.key});
  @override
  ConsumerState<SavingsAnalyticsScreen> createState() =>
      _SavingsAnalyticsScreenState();
}

class _SavingsAnalyticsScreenState extends ConsumerState<SavingsAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final privacyMode = ref.watch(privacyModeProvider);
    final goalsAsync = ref.watch(analyticsAllGoalsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(SavingsGoalsStrings.analyticsTitle),
        actions: [
          GestureDetector(
            onLongPress: _showPrivacySheet,
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
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: privacyMode == BalanceVisibilityMode.hidden
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    showExportBottomSheet(context);
                  },
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text(SavingsGoalsStrings.loadingError),
        ),
        data: (goals) {
          if (goals.isEmpty) {
            return EmptyStateWidget(
              animationAsset: 'assets/animations/empty_piggy.json',
              title: SavingsGoalsStrings.emptyAllTitle,
              subtitle: SavingsGoalsStrings.analyticsEmptySubtitle,
              primaryAction: EmptyStateAction(
                label: SavingsGoalsStrings.emptyAllAction,
                onPressed: () => context.push('/savings-goals/create'),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            children: [
              const SavingsAnalyticsPeriodSelector(),
              const SizedBox(height: AppSpacing.spacing12),
              const SavingsAnalyticsSummaryGrid(),
              const SizedBox(height: AppSpacing.spacing12),
              RepaintBoundary(
                key: ref.watch(chartRepaintBoundaryKeyProvider),
                child: const AccumulationChart(),
              ),
              const SizedBox(height: AppSpacing.spacing24),
            ],
          );
        },
      ),
    );
  }

  void _showPrivacySheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text(SavingsGoalsStrings.privacyVisible),
              onTap: () {
                ref
                    .read(privacyModeProvider.notifier)
                    .setMode(BalanceVisibilityMode.visible);
                Navigator.of(sheetContext).pop();
              },
            ),
            ListTile(
              title: const Text(SavingsGoalsStrings.privacyPartial),
              onTap: () {
                ref
                    .read(privacyModeProvider.notifier)
                    .setMode(BalanceVisibilityMode.partial);
                Navigator.of(sheetContext).pop();
              },
            ),
            ListTile(
              title: const Text(SavingsGoalsStrings.privacyHidden),
              onTap: () {
                ref
                    .read(privacyModeProvider.notifier)
                    .setMode(BalanceVisibilityMode.hidden);
                Navigator.of(sheetContext).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
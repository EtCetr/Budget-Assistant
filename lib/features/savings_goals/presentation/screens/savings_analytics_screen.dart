import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../savings_goals_strings.dart';
import '../widgets/accumulation_chart.dart';
import '../widgets/savings_analytics_period_selector.dart';
import '../widgets/savings_analytics_summary_grid.dart';

/// Экран аналитики копилок (ТЗ 6.3.18). Микро-коммит 12.7.1:
/// период, Summary Grid, график накопления с прогнозом.
/// Таблица целей, фильтры, валютный баннер и экспорт — следующие коммиты.
class SavingsAnalyticsScreen extends ConsumerWidget {
  const SavingsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyMode = ref.watch(privacyModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(SavingsGoalsStrings.analyticsTitle),
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
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        children: const [
          SavingsAnalyticsPeriodSelector(),
          SizedBox(height: AppSpacing.spacing12),
          SavingsAnalyticsSummaryGrid(),
          SizedBox(height: AppSpacing.spacing12),
          AccumulationChart(),
          SizedBox(height: AppSpacing.spacing24),
        ],
      ),
    );
  }

  void _showPrivacySheet(BuildContext context, WidgetRef ref) {
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
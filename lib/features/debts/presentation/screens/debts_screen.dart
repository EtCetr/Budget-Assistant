import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/debt.dart';
import '../debts_strings.dart';
import '../providers/debts_providers.dart';
import '../providers/debts_screen_providers.dart';
import '../widgets/debt_card.dart';
import '../widgets/debts_empty_state.dart';
import '../widgets/debts_filter_row.dart';
import '../widgets/debts_stats_summary.dart';
import '../widgets/debts_tab_selector.dart';
import '../widgets/ex_member_debt_actions_sheet.dart';

/// Экран долгов (ТЗ 6.3.13): табы, сводка, фильтры, секции карточек,
/// empty states, privacy toggle, FAB.
class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtsAsync = ref.watch(debtsStreamProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(DebtsStrings.screenTitle),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.colorFAB,
        onPressed: () {
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(DebtsStrings.fabPendingNote)),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const DebtsTabSelector(),
          const DebtsStatsSummary(),
          const DebtsFilterRow(),
          const SizedBox(height: AppSpacing.spacing8),
          Expanded(
            child: debtsAsync.when(
              loading: () => ListView(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                children: const [
                  SkeletonShimmer(height: 88),
                  SizedBox(height: AppSpacing.spacing12),
                  SkeletonShimmer(height: 88),
                  SizedBox(height: AppSpacing.spacing12),
                  SkeletonShimmer(height: 88),
                ],
              ),
              error: (error, _) => Center(
                child: OfflineErrorCard(
                  message: DebtsStrings.loadingError,
                  retryLabel: DebtsStrings.retry,
                  onRetry: () => ref.invalidate(debtsStreamProvider),
                ),
              ),
              data: (debts) => _buildBody(context, ref, debts),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, List<Debt> debts) {
    final sections = ref.watch(debtSectionsProvider);
    final groups = ref.watch(debtsGroupsProvider);
    final filter = ref.watch(debtsScreenFilterProvider);
    final tab = ref.watch(debtsTabProvider);

    if (debts.isEmpty) {
      return DebtsEmptyState.noDebts(
        onAdd: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(DebtsStrings.fabPendingNote)),
        ),
      );
    }
    if (sections.isEmpty) {
      final tabGroups = tab == DebtsTab.payable
          ? (active: groups.payableActive, closed: groups.payableClosed)
          : (active: groups.receivableActive, closed: groups.receivableClosed);
      if (filter == DebtsScreenFilter.all &&
          tabGroups.active.isEmpty &&
          tabGroups.closed.isNotEmpty) {
        return DebtsEmptyState.allResolved(
          onHistory: () => ref
              .read(debtsScreenFilterProvider.notifier)
              .set(DebtsScreenFilter.resolved),
        );
      }
      return DebtsEmptyState.filtered(
        onReset: () => ref
            .read(debtsScreenFilterProvider.notifier)
            .set(DebtsScreenFilter.all),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.spacing8,
                bottom: AppSpacing.spacing8,
              ),
              child: Text(
                section.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: section.title == DebtsStrings.sectionOverdue
                          ? AppColors.colorExpense
                          : AppColors.textPrimary,
                    ),
              ),
            ),
            for (final debt in section.debts)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
                child: GestureDetector(
                  onTap: debt.isExMemberDebt && debt.isActive
                      ? () => showExMemberDebtActionsSheet(
                            context: context,
                            debt: debt,
                          )
                      : null,
                  child: DebtCard(debt: debt),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showPrivacySheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        final current = ref.read(privacyModeProvider);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                selected: current == BalanceVisibilityMode.visible,
                leading: const Icon(Icons.visibility),
                title: const Text(DebtsStrings.privacyVisible),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.visible);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                selected: current == BalanceVisibilityMode.partial,
                leading: const Icon(Icons.visibility_outlined),
                title: const Text(DebtsStrings.privacyPartial),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.partial);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                selected: current == BalanceVisibilityMode.hidden,
                leading: const Icon(Icons.visibility_off),
                title: const Text(DebtsStrings.privacyHidden),
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
}
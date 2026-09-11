import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/pending_sync_indicator.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../privacy/domain/models/balance_visibility_mode.dart';
import '../../domain/entities/transactions_filter_state.dart';
import '../labels/transactions_log_labels.dart';
import '../providers/transactions_log_providers.dart';
import '../widgets/fab_create_menu.dart';
import '../widgets/transactions_empty_state.dart';
import '../widgets/transactions_filter_chip_group.dart';
import '../widgets/transactions_list.dart';
import '../widgets/transactions_segmented_control.dart';

class TransactionsLogScreen extends ConsumerWidget {
  const TransactionsLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logState = ref.watch(transactionsLogProvider);
    final filter = ref.watch(transactionsFilterProvider);
    final hasPendingAsync = ref.watch(hasPendingSyncProvider);
    final hasPending = hasPendingAsync.value ?? false;
    final privacyMode = ref.watch(privacyModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(TransactionsLogLabels.title),
        actions: [
          if (hasPending)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(child: PendingSyncIndicator()),
            ),
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchSheet(context, ref),
          ),
          GestureDetector(
            onTap: () => _togglePrivacyQuick(ref, privacyMode),
            onLongPress: () => _showPrivacySheet(context, ref),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                privacyMode == BalanceVisibilityMode.hidden
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TransactionsSegmentedControl(
            scope: filter.scope,
            onChanged: (scope) {
              HapticFeedback.selectionClick();
              ref.read(transactionsFilterProvider.notifier).setScope(scope);
            },
          ),
          TransactionsFilterChipGroup(filter: filter),
          Expanded(child: _buildBody(context, ref, logState, filter)),
        ],
      ),
      floatingActionButton: const FabCreateMenu(),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TransactionsLogState state,
    TransactionsFilterState filter,
  ) {
    return RefreshIndicator(
      color: AppColors.colorFAB,
      backgroundColor: AppColors.surfaceCard,
      onRefresh: () => _onRefresh(context, ref),
      child: state.groups.when(
        loading: () => const TransactionsLogSkeleton(),
        error: (error, stack) {
          return TransactionsEmptyState.error(
            onRetry: () => ref.invalidate(transactionsLogProvider),
          );
        },
        data: (groups) {
          if (groups.isEmpty) {
            if (filter.hasActiveFilters) {
              return TransactionsEmptyState.filtered(
                onReset: () {
                  HapticFeedback.mediumImpact();
                  ref.read(transactionsFilterProvider.notifier).reset();
                },
              );
            }

            return TransactionsEmptyState.noData(
              onAdd: () => showFabCreateMenu(context),
              onImport: () => context.push('/import/onboarding'),
            );
          }

          return TransactionsList(
            groups: groups,
            hasMore: state.hasMore,
            isLoadingMore: state.isLoadingMore,
            onLoadMore: () =>
                ref.read(transactionsLogProvider.notifier).loadMore(),
          );
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();

    try {
      final syncedCount = await ref.read(syncServiceProvider).forceSyncNow();

      ref.invalidate(transactionsLogProvider);
      ref.invalidate(hasPendingSyncProvider);

      if (!context.mounted) return;

      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${TransactionsLogLabels.syncSuccess}: $syncedCount'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TransactionsLogLabels.syncError)),
      );
    }
  }

  void _togglePrivacyQuick(WidgetRef ref, BalanceVisibilityMode current) {
    HapticFeedback.lightImpact();

    final next = current == BalanceVisibilityMode.visible
        ? BalanceVisibilityMode.partial
        : BalanceVisibilityMode.visible;

    ref.read(privacyModeProvider.notifier).setMode(next);
  }

  void _showSearchSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: ref.read(transactionsFilterProvider).search,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: TransactionsLogLabels.searchHint,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      child: const Text(TransactionsLogLabels.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        ref
                            .read(transactionsFilterProvider.notifier)
                            .setSearch(controller.text);
                        Navigator.of(sheetContext).pop();
                      },
                      child: const Text(TransactionsLogLabels.apply),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacySheet(BuildContext context, WidgetRef ref) {
    final current = ref.read(privacyModeProvider);

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                selected: current == BalanceVisibilityMode.visible,
                leading: const Icon(Icons.visibility),
                title: const Text(TransactionsLogLabels.visible),
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
                title: const Text(TransactionsLogLabels.partial),
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
                title: const Text(TransactionsLogLabels.hidden),
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

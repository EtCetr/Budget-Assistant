import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';
import '../providers/loyalty_cards_providers.dart';
import '../providers/loyalty_cards_usecase_providers.dart';
import '../widgets/loyalty_card_long_press_menu.dart';
import '../widgets/loyalty_card_tile.dart';
import '../widgets/loyalty_cards_empty_state.dart';
import '../widgets/loyalty_cards_filter_row.dart';
import '../widgets/loyalty_cards_scope_selector.dart';
import '../widgets/loyalty_cards_search_bar.dart';
import '../widgets/loyalty_cards_stats_summary.dart';

/// Хаб скидочных карт (ТЗ 6.3.19): scope, поиск, фильтры, сводка,
/// сетка 2 колонки с drag-and-drop, long-press меню, FAB.
class LoyaltyCardsScreen extends ConsumerStatefulWidget {
  const LoyaltyCardsScreen({super.key});

  @override
  ConsumerState<LoyaltyCardsScreen> createState() => _LoyaltyCardsScreenState();
}

class _LoyaltyCardsScreenState extends ConsumerState<LoyaltyCardsScreen> {
  final _searchController = TextEditingController();
  bool _searchOpen = false;
  bool _reorderMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleDrop(String draggedId, String targetId) {
    final list = ref.read(loyaltyCardsListProvider).value ?? const <LoyaltyCard>[];
    final ids = [for (final c in list) c.id];
    final from = ids.indexOf(draggedId);
    final to = ids.indexOf(targetId);
    if (from < 0 || to < 0 || from == to) return;
    ids.removeAt(from);
    ids.insert(to, draggedId);
    MotionTokens.selection();
    ref
        .read(updateLoyaltyCardSortOrderUseCaseProvider)
        .call(orderedCardIds: ids);
  }

  Future<void> _openCard(LoyaltyCard card) async {
    final mode = ref.read(privacyModeProvider);
    if (mode == BalanceVisibilityMode.hidden) {
      MotionTokens.error();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(LoyaltyCardsStrings.displayBlockedHidden)),
      );
      return;
    }
    MotionTokens.light();
    await context.push('/loyalty-cards/display/${card.id}');
  }

  Future<void> _openMenu(LoyaltyCard card) async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final userId = ref.read(currentUserIdProvider);
    MotionTokens.medium();
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => LoyaltyCardLongPressMenu(
        card: card,
        isCreator: card.userId == userId,
      ),
    );
    if (action == null || !mounted) return;
    switch (action) {
      case 'open':
        await _openCard(card);
      case 'edit':
        MotionTokens.light();
        await router.push('/loyalty-cards/add?id=${card.id}');
      case 'favorite':
        MotionTokens.light();
        final result =
            await ref.read(toggleLoyaltyCardFavoriteUseCaseProvider).call(card.id);
        if (result.isError && mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text(LoyaltyCardsStrings.actionFailed)),
          );
        }
      case 'shared':
        MotionTokens.light();
        final result = await ref
            .read(toggleLoyaltyCardSharedUseCaseProvider)
            .call(cardId: card.id, currentUserId: userId);
        if (result.isError && mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text(LoyaltyCardsStrings.actionFailed)),
          );
        }
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(LoyaltyCardsStrings.deleteConfirmTitle),
            content: const Text(LoyaltyCardsStrings.deleteConfirmText),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(LoyaltyCardsStrings.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(LoyaltyCardsStrings.deleteConfirmAction),
              ),
            ],
          ),
        );
        if (confirm != true || !mounted) return;
        final result = await ref
            .read(deleteLoyaltyCardUseCaseProvider)
            .call(cardId: card.id, currentUserId: userId);
        if (result.isError && mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text(LoyaltyCardsStrings.actionFailed)),
          );
        }
    }
  }

  Widget _cell(LoyaltyCard card) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final userId = ref.watch(currentUserIdProvider);
    final tile = LoyaltyCardTile(
      card: card,
      mode: mode,
      formatter: formatter,
      currentUserId: userId,
    );
    if (!_reorderMode) {
      return GestureDetector(
        onTap: () => _openCard(card),
        onLongPress: () => _openMenu(card),
        child: tile,
      );
    }
    // Современный API: DragTarget требует builder + ...WithDetails-колбэки.
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => details.data != card.id,
      onAcceptWithDetails: (details) => _handleDrop(details.data, card.id),
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<String>(
          data: card.id,
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 160,
              height: 150,
              child: tile,
            ),
          ),
          childWhenDragging: Opacity(opacity: 0.3, child: tile),
          child: tile,
        );
      },
    );
  }

  Widget _buildBody() {
    final listAsync = ref.watch(loyaltyCardsListProvider);
    final statsAsync = ref.watch(loyaltyCardsStatsProvider);
    final filter = ref.watch(loyaltyCardsFilterProvider);
    final scope = ref.watch(loyaltyCardsScopeProvider);
    final spaceId = ref.watch(currentSpaceIdProvider);
    final search = ref.watch(loyaltyCardsSearchProvider);
    return Column(
      children: [
        LoyaltyCardsStatsSummary(stats: statsAsync),
        if (_reorderMode)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadius.radiusFull,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.drag_indicator,
                    size: 16, color: AppColors.textSecondary),
                SizedBox(width: AppSpacing.spacing8),
                Text(
                  LoyaltyCardsStrings.reorderBanner,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        Expanded(
          child: listAsync.when(
            loading: () => GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.spacing12,
                crossAxisSpacing: AppSpacing.spacing12,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, i) => SkeletonShimmer.card(),
            ),
            error: (_, __) => LoyaltyCardsEmptyState(
              kind: 'error',
              onRetry: () => ref.invalidate(loyaltyCardsListProvider),
            ),
            data: (list) {
              if (list.isEmpty) {
                if (!filter.isEmpty || search.isNotEmpty) {
                  return LoyaltyCardsEmptyState(
                    kind: 'filter',
                    onResetFilters: () {
                      ref.read(loyaltyCardsFilterProvider.notifier).reset();
                      _searchController.clear();
                      ref.read(loyaltyCardsSearchProvider.notifier).clear();
                    },
                  );
                }
                if (scope == LoyaltyCardsScope.family && spaceId != null) {
                  return LoyaltyCardsEmptyState(
                    kind: 'family',
                    onAdd: () => context.push('/loyalty-cards/add'),
                  );
                }
                return LoyaltyCardsEmptyState(
                  kind: 'no_cards',
                  onAdd: () => context.push('/loyalty-cards/add'),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.spacing12,
                  crossAxisSpacing: AppSpacing.spacing12,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, i) => _cell(list[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(privacyModeProvider);
    final spaceId = ref.watch(currentSpaceIdProvider);
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/loyalty-cards'),
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text(LoyaltyCardsStrings.screenTitle),
        actions: [
          IconButton(
            icon: Icon(_searchOpen ? Icons.search_off : Icons.search),
            onPressed: () {
              MotionTokens.light();
              setState(() => _searchOpen = !_searchOpen);
              if (!_searchOpen) {
                _searchController.clear();
                ref.read(loyaltyCardsSearchProvider.notifier).clear();
              }
            },
          ),
          IconButton(
            icon: Icon(_reorderMode ? Icons.check : Icons.drag_indicator),
            tooltip: LoyaltyCardsStrings.reorderDone,
            onPressed: () {
              MotionTokens.light();
              setState(() => _reorderMode = !_reorderMode);
            },
          ),
          IconButton(
            icon: Icon(mode == BalanceVisibilityMode.visible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            onPressed: () {
              MotionTokens.light();
              ref.read(privacyModeProvider.notifier).toggle();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.spacing8),
          if (spaceId != null) ...[
            const LoyaltyCardsScopeSelector(),
            const SizedBox(height: AppSpacing.spacing8),
          ],
          if (_searchOpen) LoyaltyCardsSearchBar(controller: _searchController),
          const SizedBox(height: AppSpacing.spacing8),
          const LoyaltyCardsFilterRow(),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.colorFAB,
        onPressed: () {
          MotionTokens.heavy();
          context.push('/loyalty-cards/add');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          LoyaltyCardsStrings.addCard,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
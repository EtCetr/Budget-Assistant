import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_goals_repository.dart';
import '../providers/savings_goals_screen_providers.dart';
import '../savings_goals_strings.dart';
import '../widgets/archived_goal_card.dart';
import '../widgets/goal_achieved_dialog.dart';
import '../widgets/savings_goal_card.dart';
import '../widgets/savings_goals_filter_row.dart';
import '../widgets/savings_goals_stats_summary.dart';
import '../widgets/savings_goals_tab_selector.dart';

/// Экран «Цели накопления» (ТЗ 6.3.16).
class SavingsGoalsScreen extends ConsumerStatefulWidget {
  const SavingsGoalsScreen({
    super.key,
    this.initialTab = SavingsGoalsTab.active,
  });

  final SavingsGoalsTab initialTab;

  @override
  ConsumerState<SavingsGoalsScreen> createState() =>
      _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends ConsumerState<SavingsGoalsScreen> {
  final Set<String> _celebratedGoalIds = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(savingsGoalsTabProvider.notifier).set(widget.initialTab);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(savingsGoalsTabProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    ref.listen(activeSavingsGoalsProvider, (_, next) {
      _checkForAchievements(next.value ?? const []);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(SavingsGoalsStrings.screenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/savings-analytics');
            },
          ),
          GestureDetector(
            onLongPress: () => _showPrivacySheet(context),
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
        onPressed: () {
          HapticFeedback.heavyImpact();
          context.push('/savings-goals/create');
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SavingsGoalsTabSelector(),
          Expanded(
            child: tab == SavingsGoalsTab.active
                ? const _ActiveTabBody()
                : const _ArchiveTabBody(),
          ),
        ],
      ),
    );
  }

  void _checkForAchievements(List<SavingsGoal> goals) {
    final formatter = ref.read(privacyFormatterProvider);
    final mode = ref.read(privacyModeProvider);
    for (final goal in goals) {
      final reachedNow = goal.isReached &&
          goal.completedAt == null &&
          goal.status == SavingsGoalStatus.active;
      if (!reachedNow || _celebratedGoalIds.contains(goal.id)) continue;
      _celebratedGoalIds.add(goal.id);
      if (!formatter.shouldShowCelebration(mode)) continue;
      HapticFeedback.heavyImpact();
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => GoalAchievedDialog(goal: goal),
      );
    }
  }

  void _showPrivacySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
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
        );
      },
    );
  }
}

class _ActiveTabBody extends ConsumerWidget {
  const _ActiveTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(activeSavingsGoalsProvider);
    final allActive =
        ref.watch(allActiveSavingsGoalsProvider).value ?? const <SavingsGoal>[];
    final allArchived =
        ref.watch(allArchivedSavingsGoalsProvider).value ?? const <SavingsGoal>[];
    return goalsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        children: const [
          SkeletonShimmer(height: 180),
          SizedBox(height: AppSpacing.spacing12),
          SkeletonShimmer(height: 180),
        ],
      ),
      error: (error, _) => Center(
        child: OfflineErrorCard(
          message: SavingsGoalsStrings.loadingError,
          retryLabel: SavingsGoalsStrings.retry,
          onRetry: () => ref.invalidate(activeSavingsGoalsProvider),
        ),
      ),
      data: (goals) {
        if (allActive.isEmpty && allArchived.isEmpty) {
          return EmptyStateWidget(
            animationAsset: 'assets/animations/empty_piggy.json',
            title: SavingsGoalsStrings.emptyAllTitle,
            subtitle: SavingsGoalsStrings.emptyAllSubtitle,
            primaryAction: EmptyStateAction(
              label: SavingsGoalsStrings.emptyAllAction,
              onPressed: () => context.push('/savings-goals/create'),
            ),
          );
        }
        if (goals.isEmpty && allActive.isEmpty) {
          return EmptyStateWidget(
            animationAsset: 'assets/animations/empty_box.json',
            title: SavingsGoalsStrings.emptyActiveTitle,
            subtitle: SavingsGoalsStrings.emptyActiveSubtitle,
            primaryAction: EmptyStateAction(
              label: SavingsGoalsStrings.emptyActivePrimary,
              onPressed: () => context.push('/savings-goals/create'),
            ),
            secondaryAction: EmptyStateAction(
              label: SavingsGoalsStrings.emptyActiveSecondary,
              isPrimary: false,
              onPressed: () => ref
                  .read(savingsGoalsTabProvider.notifier)
                  .set(SavingsGoalsTab.archive),
            ),
          );
        }
        if (goals.isEmpty) {
          return Column(
            children: [
              const SavingsGoalsStatsSummary(),
              const SavingsGoalsFilterRow(),
              Expanded(
                child: _CompactFilterEmpty(
                  onReset: () => ref
                      .read(savingsGoalsFilterProvider.notifier)
                      .set(SavingsGoalsFilter.all),
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            const SavingsGoalsStatsSummary(),
            const SavingsGoalsFilterRow(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                itemCount: goals.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.spacing12),
                itemBuilder: (context, index) =>
                    SavingsGoalCard(goal: goals[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ArchiveTabBody extends ConsumerWidget {
  const _ArchiveTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(archivedSavingsGoalsProvider);
    final allArchived =
        ref.watch(allArchivedSavingsGoalsProvider).value ?? const <SavingsGoal>[];
    return goalsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        children: const [
          SkeletonShimmer(height: 160),
          SizedBox(height: AppSpacing.spacing12),
          SkeletonShimmer(height: 160),
        ],
      ),
      error: (error, _) => Center(
        child: OfflineErrorCard(
          message: SavingsGoalsStrings.loadingError,
          retryLabel: SavingsGoalsStrings.retry,
          onRetry: () => ref.invalidate(archivedSavingsGoalsProvider),
        ),
      ),
      data: (goals) {
        if (allArchived.isEmpty) {
          return EmptyStateWidget(
            animationAsset: 'assets/animations/empty_box.json',
            title: SavingsGoalsStrings.emptyArchiveTitle,
            subtitle: SavingsGoalsStrings.emptyArchiveSubtitle,
            primaryAction: EmptyStateAction(
              label: SavingsGoalsStrings.emptyArchiveAction,
              isPrimary: false,
              onPressed: () => ref
                  .read(savingsGoalsTabProvider.notifier)
                  .set(SavingsGoalsTab.active),
            ),
          );
        }
        if (goals.isEmpty) {
          return Column(
            children: [
              const SavingsArchiveStatsSummary(),
              const SavingsArchiveFilterRow(),
              Expanded(
                child: _CompactFilterEmpty(
                  onReset: () => ref
                      .read(savingsArchiveFilterProvider.notifier)
                      .set(SavingsArchiveFilter.all),
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            const SavingsArchiveStatsSummary(),
            const SavingsArchiveFilterRow(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                itemCount: goals.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.spacing12),
                itemBuilder: (context, index) =>
                    ArchivedGoalCard(goal: goals[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Компактное состояние «нет целей по фильтру»: фильтры остаются
/// кликабельными сверху (решение владельца вместо полноэкранного empty).
class _CompactFilterEmpty extends StatelessWidget {
  const _CompactFilterEmpty({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/search.json',
              width: 120,
              height: 120,
              repeat: false,
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Text(
              SavingsGoalsStrings.emptyFilterTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              SavingsGoalsStrings.emptyFilterSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            OutlinedButton(
              onPressed: onReset,
              child: const Text(SavingsGoalsStrings.filterReset),
            ),
          ],
        ),
      ),
    );
  }
}
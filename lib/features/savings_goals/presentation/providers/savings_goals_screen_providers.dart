import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_goals_repository.dart';
import '../../domain/usecases/calculate_archive_stats_usecase.dart';
import '../../domain/usecases/calculate_savings_goals_summary_usecase.dart';
import 'savings_goals_providers.dart';
import 'savings_goals_repository_providers.dart';

enum SavingsGoalsTab { active, archive }

class SavingsGoalsTabNotifier extends Notifier<SavingsGoalsTab> {
  @override
  SavingsGoalsTab build() => SavingsGoalsTab.active;
  void set(SavingsGoalsTab tab) => state = tab;
}

final savingsGoalsTabProvider =
    NotifierProvider<SavingsGoalsTabNotifier, SavingsGoalsTab>(
  SavingsGoalsTabNotifier.new,
);

class SavingsGoalsFilterNotifier extends Notifier<SavingsGoalsFilter> {
  @override
  SavingsGoalsFilter build() => SavingsGoalsFilter.all;
  void set(SavingsGoalsFilter filter) => state = filter;
}

final savingsGoalsFilterProvider =
    NotifierProvider<SavingsGoalsFilterNotifier, SavingsGoalsFilter>(
  SavingsGoalsFilterNotifier.new,
);

/// Независимый тумблер «только с дедлайном»: комбинируется с фильтром типа.
class SavingsGoalsWithDeadlineNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle() => state = !state;
  void set(bool value) => state = value;
}

final savingsGoalsWithDeadlineProvider =
    NotifierProvider<SavingsGoalsWithDeadlineNotifier, bool>(
  SavingsGoalsWithDeadlineNotifier.new,
);

class SavingsArchiveFilterNotifier extends Notifier<SavingsArchiveFilter> {
  @override
  SavingsArchiveFilter build() => SavingsArchiveFilter.all;
  void set(SavingsArchiveFilter filter) => state = filter;
}

final savingsArchiveFilterProvider =
    NotifierProvider<SavingsArchiveFilterNotifier, SavingsArchiveFilter>(
  SavingsArchiveFilterNotifier.new,
);

final savingsBaseCurrencyProvider = FutureProvider<String>((ref) async {
  final dao = ref.watch(appSettingsDaoProvider);
  final userId = ref.watch(currentUserIdProvider);
  final settings = await dao.getForUser(userId);
  return settings.baseCurrency;
});

final allActiveSavingsGoalsProvider =
    StreamProvider<List<SavingsGoal>>((ref) {
  final repo = ref.watch(savingsGoalsRepositoryProvider);
  return repo.watchActive(
    userId: ref.watch(currentUserIdProvider),
    spaceId: ref.watch(currentSpaceIdProvider),
    filter: SavingsGoalsFilter.all,
    withDeadline: false,
  );
});

final activeSavingsGoalsProvider = StreamProvider<List<SavingsGoal>>((ref) {
  final repo = ref.watch(savingsGoalsRepositoryProvider);
  return repo.watchActive(
    userId: ref.watch(currentUserIdProvider),
    spaceId: ref.watch(currentSpaceIdProvider),
    filter: ref.watch(savingsGoalsFilterProvider),
    withDeadline: ref.watch(savingsGoalsWithDeadlineProvider),
  );
});

final allArchivedSavingsGoalsProvider =
    StreamProvider<List<SavingsGoal>>((ref) {
  final repo = ref.watch(savingsGoalsRepositoryProvider);
  return repo.watchArchived(
    userId: ref.watch(currentUserIdProvider),
    spaceId: ref.watch(currentSpaceIdProvider),
    filter: SavingsArchiveFilter.all,
  );
});

final archivedSavingsGoalsProvider =
    StreamProvider<List<SavingsGoal>>((ref) {
  final repo = ref.watch(savingsGoalsRepositoryProvider);
  return repo.watchArchived(
    userId: ref.watch(currentUserIdProvider),
    spaceId: ref.watch(currentSpaceIdProvider),
    filter: ref.watch(savingsArchiveFilterProvider),
  );
});

final savingsGoalsSummaryProvider =
    FutureProvider<SavingsGoalsSummary?>((ref) async {
  final goals = ref.watch(allActiveSavingsGoalsProvider).value;
  final baseCurrency = ref.watch(savingsBaseCurrencyProvider).value;
  if (goals == null || baseCurrency == null) return null;
  return ref.watch(calculateSavingsGoalsSummaryUseCaseProvider)(
    baseCurrency: baseCurrency,
    goals: goals,
  );
});

final savingsArchiveStatsProvider = FutureProvider<ArchiveStats?>((ref) async {
  final goals = ref.watch(allArchivedSavingsGoalsProvider).value;
  final baseCurrency = ref.watch(savingsBaseCurrencyProvider).value;
  if (goals == null || baseCurrency == null) return null;
  return ref.watch(calculateArchiveStatsUseCaseProvider)(
    goals: goals,
    baseCurrency: baseCurrency,
  );
});
import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_goals_repository.dart';

part 'savings_goals_dao.g.dart';

@DriftAccessor(tables: [SavingsGoals, SavingsGoalDrafts])
class SavingsGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsGoalsDaoMixin {
  SavingsGoalsDao(super.db);

  Stream<List<SavingsGoalDb>> watchActive({
    required String userId,
    String? spaceId,
    required SavingsGoalsFilter filter,
    bool withDeadline = false,
  }) {
    return (select(savingsGoals)
          ..where((g) =>
              _scope(userId, spaceId, g) &
              g.status.equals(SavingsGoalStatus.active) &
              g.isArchived.equals(false) &
              _activeFilter(filter, g) &
              (withDeadline ? g.deadline.isNotNull() : const Constant(true)))
          ..orderBy([
            (g) => OrderingTerm.asc(g.deadline, nulls: NullsOrder.last),
            (g) => OrderingTerm.desc(g.createdAt),
          ]))
        .watch();
  }

  Stream<List<SavingsGoalDb>> watchArchived({
    required String userId,
    String? spaceId,
    required SavingsArchiveFilter filter,
  }) {
    return (select(savingsGoals)
          ..where((g) =>
              _scope(userId, spaceId, g) &
              (g.isArchived.equals(true) |
                  g.status.isIn(const [
                    SavingsGoalStatus.completed,
                    SavingsGoalStatus.cancelled,
                  ])) &
              _archiveFilter(filter, g))
          ..orderBy([(g) => OrderingTerm.desc(g.updatedAt)]))
        .watch();
  }

  Future<SavingsGoalDb?> getById(String goalId) {
    return (select(savingsGoals)..where((g) => g.id.equals(goalId)))
        .getSingleOrNull();
  }

  Future<void> insertGoal(SavingsGoal goal) {
    return into(savingsGoals).insert(_companion(goal));
  }

  Future<int> updateGoal(SavingsGoal goal) {
    return (update(savingsGoals)..where((g) => g.id.equals(goal.id)))
        .write(_companion(goal));
  }

  Future<int> updateProgress({
    required String goalId,
    required int newAmountKopecks,
    int? newDraftAmountKopecks,
  }) {
    return (update(savingsGoals)..where((g) => g.id.equals(goalId))).write(
      SavingsGoalsCompanion(
        currentAmount: Value(newAmountKopecks),
        draftAmount: newDraftAmountKopecks == null
            ? const Value.absent()
            : Value(newDraftAmountKopecks),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<int> markCompleted(String goalId) {
    final now = DateTime.now().toUtc();
    return (update(savingsGoals)..where((g) => g.id.equals(goalId))).write(
      SavingsGoalsCompanion(
        status: const Value(SavingsGoalStatus.completed),
        completedAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<int> archiveGoal(String goalId) {
    return (update(savingsGoals)..where((g) => g.id.equals(goalId))).write(
      SavingsGoalsCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<int> restoreGoal(String goalId) {
    return (update(savingsGoals)..where((g) => g.id.equals(goalId))).write(
      SavingsGoalsCompanion(
        isArchived: const Value(false),
        status: const Value(SavingsGoalStatus.active),
        completedAt: const Value<DateTime?>(null),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<SavingsGoalDraftDb?> getFreshDraft(String draftId, DateTime sinceUtc) {
    return (select(savingsGoalDrafts)
          ..where((d) =>
              d.id.equals(draftId) &
              d.updatedAt.isBiggerOrEqualValue(sinceUtc)))
        .getSingleOrNull();
  }

  Future<void> upsertDraft({
    required String id,
    required String userId,
    String? goalId,
    required String formDataJson,
    required DateTime updatedAt,
  }) {
    return into(savingsGoalDrafts).insertOnConflictUpdate(
      SavingsGoalDraftsCompanion(
        id: Value(id),
        userId: Value(userId),
        goalId: Value(goalId),
        formDataJson: Value(formDataJson),
        createdAt: Value(updatedAt),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<int> deleteDraft(String draftId) {
    return (delete(savingsGoalDrafts)..where((d) => d.id.equals(draftId))).go();
  }

  Future<int> cleanupOldDrafts(DateTime olderThanUtc) {
    return (delete(savingsGoalDrafts)
          ..where((d) => d.updatedAt.isSmallerThanValue(olderThanUtc)))
        .go();
  }

  Expression<bool> _scope(String userId, String? spaceId, SavingsGoals g) {
    if (spaceId == null) return g.userId.equals(userId);
    return g.userId.equals(userId) | g.spaceId.equals(spaceId);
  }

  Expression<bool> _activeFilter(SavingsGoalsFilter filter, SavingsGoals g) {
    switch (filter) {
      case SavingsGoalsFilter.all:
        return const Constant(true);
      case SavingsGoalsFilter.virtual:
        return g.linkedAccountId.isNull();
      case SavingsGoalsFilter.linked:
        return g.linkedAccountId.isNotNull();
    }
  }

  Expression<bool> _archiveFilter(SavingsArchiveFilter filter, SavingsGoals g) {
    switch (filter) {
      case SavingsArchiveFilter.all:
        return const Constant(true);
      case SavingsArchiveFilter.completed:
        return g.status.equals(SavingsGoalStatus.completed);
      case SavingsArchiveFilter.cancelled:
        return g.status.equals(SavingsGoalStatus.cancelled);
    }
  }

  SavingsGoalsCompanion _companion(SavingsGoal g) {
    return SavingsGoalsCompanion(
      id: Value(g.id),
      userId: Value(g.userId),
      spaceId: Value(g.spaceId),
      name: Value(g.name),
      targetAmount: Value(g.targetAmount),
      currentAmount: Value(g.currentAmount),
      deadline: Value(g.deadline),
      linkedAccountId: Value(g.linkedAccountId),
      currency: Value(g.currency),
      draftAmount: Value(g.draftAmount),
      autoReminderEnabled: Value(g.autoReminderEnabled),
      status: Value(g.status),
      isArchived: Value(g.isArchived),
      completedAt: Value(g.completedAt),
      createdAt: Value(g.createdAt),
      updatedAt: Value(g.updatedAt),
      syncStatus: Value(g.syncStatus),
    );
  }
}
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal.dart';
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal_form_draft.dart';
import 'package:budget_assistant/features/savings_goals/domain/repositories/savings_goals_repository.dart';

/// Этап 24: заглушка репозитория целей для доменных тестов.
/// Деньги — целые копейки, даты — UTC.
class FakeSavingsGoalsRepository implements SavingsGoalsRepository {
  final Map<String, SavingsGoal> goals = <String, SavingsGoal>{};
  SavingsGoalFormDraft? draft;

  /// Если задано — каждый метод бросает эту ошибку.
  Object? error;

  final List<String> calls = <String>[];
  final List<({String goalId, int amount, int? draftAmount})> progressUpdates =
      <({String goalId, int amount, int? draftAmount})>[];

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Stream<List<SavingsGoal>> watchActive({
    required String userId,
    String? spaceId,
    required SavingsGoalsFilter filter,
    bool withDeadline = false,
  }) async* {
    _enter('watchActive');
    yield goals.values
        .where((g) => g.userId == userId && !g.isArchived)
        .toList();
  }

  @override
  Stream<List<SavingsGoal>> watchArchived({
    required String userId,
    String? spaceId,
    required SavingsArchiveFilter filter,
  }) async* {
    _enter('watchArchived');
    yield goals.values
        .where((g) => g.userId == userId && g.isArchived)
        .toList();
  }

  @override
  Future<SavingsGoal?> getById(String goalId) async {
    _enter('getById');
    return goals[goalId];
  }

  @override
  Future<void> insert(SavingsGoal goal) async {
    _enter('insert');
    goals[goal.id] = goal;
  }

  @override
  Future<void> update(SavingsGoal goal) async {
    _enter('update');
    goals[goal.id] = goal;
  }

  @override
  Future<void> updateProgress({
    required String goalId,
    required int newAmountKopecks,
    int? draftAmountKopecks,
  }) async {
    _enter('updateProgress');
    progressUpdates.add((
      goalId: goalId,
      amount: newAmountKopecks,
      draftAmount: draftAmountKopecks,
    ));
    final g = goals[goalId];
    if (g != null) {
      goals[goalId] = g.copyWith(
        currentAmount: newAmountKopecks,
        draftAmount: draftAmountKopecks ?? g.draftAmount,
      );
    }
  }

  @override
  Future<void> markCompleted(String goalId) async {
    _enter('markCompleted');
    final g = goals[goalId];
    if (g != null) {
      goals[goalId] = g.copyWith(
        status: SavingsGoalStatus.completed,
        completedAt: DateTime.utc(2026, 7, 15),
      );
    }
  }

  @override
  Future<void> archive(String goalId) async {
    _enter('archive');
    final g = goals[goalId];
    if (g != null) goals[goalId] = g.copyWith(isArchived: true);
  }

  @override
  Future<void> restore(String goalId) async {
    _enter('restore');
    final g = goals[goalId];
    if (g != null) goals[goalId] = g.copyWith(isArchived: false);
  }

  @override
  Future<SavingsGoalFormDraft?> getFreshDraft(String userId) async {
    _enter('getFreshDraft');
    return draft;
  }

  @override
  Future<void> saveDraft(String userId, SavingsGoalFormDraft formDraft) async {
    _enter('saveDraft');
    draft = formDraft;
  }

  @override
  Future<void> deleteDraftByUser(String userId) async {
    _enter('deleteDraftByUser');
    draft = null;
  }
}

/// Фабрика цели для тестов (копейки, UTC).
SavingsGoal makeGoal({
  required String id,
  String name = 'Отпуск',
  int target = 10000000,
  int current = 0,
  String currency = 'RUB',
  String? linkedAccountId,
  String? spaceId,
  DateTime? deadline,
  String status = SavingsGoalStatus.active,
  bool isArchived = false,
  String userId = 'u1',
}) =>
    SavingsGoal(
      id: id,
      userId: userId,
      spaceId: spaceId,
      name: name,
      targetAmount: target,
      currentAmount: current,
      currency: currency,
      linkedAccountId: linkedAccountId,
      deadline: deadline,
      status: status,
      isArchived: isArchived,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
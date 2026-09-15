import '../entities/savings_goal.dart';
import '../entities/savings_goal_form_draft.dart';

/// Фильтры списка активных целей (ТЗ 6.3.16.5).
/// withDeadline вынесен в отдельный bool-параметр watchActive,
/// чтобы комбинироваться с типом (виртуальные/привязанные взаимно исключающие).
enum SavingsGoalsFilter { all, virtual, linked }

/// Фильтры архива (ТЗ 6.3.47.3).
enum SavingsArchiveFilter { all, completed, cancelled }

abstract interface class SavingsGoalsRepository {
  Stream<List<SavingsGoal>> watchActive({
    required String userId,
    String? spaceId,
    required SavingsGoalsFilter filter,
    bool withDeadline = false,
  });

  Stream<List<SavingsGoal>> watchArchived({
    required String userId,
    String? spaceId,
    required SavingsArchiveFilter filter,
  });

  Future<SavingsGoal?> getById(String goalId);
  Future<void> insert(SavingsGoal goal);
  Future<void> update(SavingsGoal goal);
  Future<void> updateProgress({
    required String goalId,
    required int newAmountKopecks,
    int? draftAmountKopecks,
  });
  Future<void> markCompleted(String goalId);
  Future<void> archive(String goalId);
  Future<void> restore(String goalId);
  Future<SavingsGoalFormDraft?> getFreshDraft(String userId);
  Future<void> saveDraft(String userId, SavingsGoalFormDraft draft);
  Future<void> deleteDraftByUser(String userId);
}
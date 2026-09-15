import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/entities/savings_goal_form_draft.dart';
import '../../domain/repositories/savings_goals_repository.dart';
import '../datasources/savings_goals_dao.dart';

class SavingsGoalsRepositoryImpl implements SavingsGoalsRepository {
  SavingsGoalsRepositoryImpl({required SavingsGoalsDao dao, required Logger logger})
      : _dao = dao,
        _logger = logger;

  final SavingsGoalsDao _dao;
  final Logger _logger;

  @override
  Stream<List<SavingsGoal>> watchActive({
    required String userId,
    String? spaceId,
    required SavingsGoalsFilter filter,
    bool withDeadline = false,
  }) {
    try {
      return _dao
          .watchActive(
            userId: userId,
            spaceId: spaceId,
            filter: filter,
            withDeadline: withDeadline,
          )
          .map((rows) => rows.map(_mapGoal).toList());
    } catch (e, st) {
      _logger.e('watchActive failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<SavingsGoal>> watchArchived({
    required String userId,
    String? spaceId,
    required SavingsArchiveFilter filter,
  }) {
    try {
      return _dao
          .watchArchived(userId: userId, spaceId: spaceId, filter: filter)
          .map((rows) => rows.map(_mapGoal).toList());
    } catch (e, st) {
      _logger.e('watchArchived failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<SavingsGoal?> getById(String goalId) async {
    try {
      final row = await _dao.getById(goalId);
      return row == null ? null : _mapGoal(row);
    } catch (e, st) {
      _logger.e('getById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> insert(SavingsGoal goal) async {
    try {
      await _dao.insertGoal(goal);
    } catch (e, st) {
      _logger.e('insert failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> update(SavingsGoal goal) async {
    try {
      await _dao.updateGoal(goal);
    } catch (e, st) {
      _logger.e('update failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> updateProgress({
    required String goalId,
    required int newAmountKopecks,
    int? draftAmountKopecks,
  }) async {
    try {
      await _dao.updateProgress(
        goalId: goalId,
        newAmountKopecks: newAmountKopecks,
        newDraftAmountKopecks: draftAmountKopecks,
      );
    } catch (e, st) {
      _logger.e('updateProgress failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> markCompleted(String goalId) async {
    try {
      await _dao.markCompleted(goalId);
    } catch (e, st) {
      _logger.e('markCompleted failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> archive(String goalId) async {
    try {
      await _dao.archiveGoal(goalId);
    } catch (e, st) {
      _logger.e('archive failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> restore(String goalId) async {
    try {
      await _dao.restoreGoal(goalId);
    } catch (e, st) {
      _logger.e('restore failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<SavingsGoalFormDraft?> getFreshDraft(String userId) async {
    try {
      final since = DateTime.now().toUtc().subtract(const Duration(hours: 24));
      final row = await _dao.getFreshDraft('savings_draft_$userId', since);
      if (row == null) return null;
      return SavingsGoalFormDraft.fromJson(
          jsonDecode(row.formDataJson) as Map<String, dynamic>);
    } on FormatException catch (e) {
      _logger.w('Corrupt draft ignored: $e');
      return null;
    } catch (e, st) {
      _logger.e('getFreshDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> saveDraft(String userId, SavingsGoalFormDraft draft) async {
    try {
      final now = DateTime.now().toUtc();
      await _dao.upsertDraft(
        id: 'savings_draft_$userId',
        userId: userId,
        goalId: draft.goalId,
        formDataJson: jsonEncode(draft.toJson()),
        updatedAt: now,
      );
      await _dao.cleanupOldDrafts(now.subtract(const Duration(days: 7)));
    } catch (e, st) {
      _logger.e('saveDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteDraftByUser(String userId) async {
    try {
      await _dao.deleteDraft('savings_draft_$userId');
    } catch (e, st) {
      _logger.e('deleteDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  SavingsGoal _mapGoal(SavingsGoalDb db) {
    return SavingsGoal(
      id: db.id,
      userId: db.userId,
      spaceId: db.spaceId,
      name: db.name,
      targetAmount: db.targetAmount,
      currentAmount: db.currentAmount,
      deadline: db.deadline,
      linkedAccountId: db.linkedAccountId,
      currency: db.currency,
      draftAmount: db.draftAmount,
      autoReminderEnabled: db.autoReminderEnabled,
      status: db.status,
      isArchived: db.isArchived,
      completedAt: db.completedAt,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: db.syncStatus,
    );
  }
}
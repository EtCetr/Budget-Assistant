import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/entities/reminder_form_draft.dart';
import '../../domain/repositories/reminders_repository.dart';
import '../datasources/reminders_dao.dart';

class RemindersRepositoryImpl implements RemindersRepository {
  RemindersRepositoryImpl({required RemindersDao dao, required Logger logger})
      : _dao = dao,
        _logger = logger;

  final RemindersDao _dao;
  final Logger _logger;

  @override
  Stream<List<Reminder>> watchUpcoming({
    required String userId,
    String? spaceId,
    required RemindersUpcomingFilter filter,
    String? myMembershipId,
    required DateTime nowUtc,
  }) {
    try {
      return _dao
          .watchUpcoming(
            userId: userId,
            spaceId: spaceId,
            filter: filter,
            myMembershipId: myMembershipId,
            nowUtc: nowUtc,
          )
          .map((rows) => rows.map(_map).toList());
    } catch (e, st) {
      _logger.e('watchUpcoming failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<Reminder>> watchHistory({
    required String userId,
    String? spaceId,
  }) {
    try {
      return _dao
          .watchHistory(userId: userId, spaceId: spaceId)
          .map((rows) => rows.map(_map).toList());
    } catch (e, st) {
      _logger.e('watchHistory failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<int> watchUpcomingCount({
    required String userId,
    String? spaceId,
    required DateTime nowUtc,
  }) {
    try {
      return _dao.watchUpcomingCount(
        userId: userId,
        spaceId: spaceId,
        nowUtc: nowUtc,
      );
    } catch (e, st) {
      _logger.e('watchUpcomingCount failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Reminder?> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      return row == null ? null : _map(row);
    } catch (e, st) {
      _logger.e('getById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<Reminder?> watchById(String id) {
    try {
      return _dao.watchById(id).map((row) => row == null ? null : _map(row));
    } catch (e, st) {
      _logger.e('watchById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<Reminder>> getActiveForScheduling(String userId) async {
    try {
      final rows = await _dao.getActiveForScheduling(userId);
      return rows.map(_map).toList();
    } catch (e, st) {
      _logger.e('getActiveForScheduling failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<Reminder>> watchByDay({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) {
    try {
      return _dao
          .watchByDay(
            userId: userId,
            spaceId: spaceId,
            startUtc: startUtc,
            endUtc: endUtc,
          )
          .map((rows) => rows.map(_map).toList());
    } catch (e, st) {
      _logger.e('watchByDay failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> insert(Reminder reminder) async {
    try {
      await _dao.insertReminder(reminder);
    } catch (e, st) {
      _logger.e('insert failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> update(Reminder reminder) async {
    try {
      await _dao.updateReminder(reminder);
    } catch (e, st) {
      _logger.e('update failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteById(String id) async {
    try {
      await _dao.deleteById(id);
    } catch (e, st) {
      _logger.e('deleteById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> markCompleted(String id, DateTime nowUtc) async {
    try {
      await _dao.markCompleted(id, nowUtc);
    } catch (e, st) {
      _logger.e('markCompleted failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> undoComplete(String id) async {
    try {
      await _dao.undoComplete(id);
    } catch (e, st) {
      _logger.e('undoComplete failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> applySnooze({
    required String id,
    required DateTime newRemindAtUtc,
    required int newSnoozeCount,
    required String snoozeHistoryJson,
  }) async {
    try {
      await _dao.applySnooze(
        id: id,
        newRemindAtUtc: newRemindAtUtc,
        newSnoozeCount: newSnoozeCount,
        snoozeHistoryJson: snoozeHistoryJson,
      );
    } catch (e, st) {
      _logger.e('applySnooze failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<ReminderFormDraft?> getFreshDraft(String userId) async {
    try {
      final since = DateTime.now().toUtc().subtract(const Duration(hours: 24));
      final row = await _dao.getFreshDraft('reminder_draft_$userId', since);
      if (row == null) return null;
      return ReminderFormDraft.fromJson(
        jsonDecode(row.formDataJson) as Map<String, dynamic>,
      );
    } on FormatException catch (e) {
      _logger.w('Corrupt reminder draft ignored: $e');
      return null;
    } catch (e, st) {
      _logger.e('getFreshDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> saveDraft(String userId, ReminderFormDraft draft) async {
    try {
      final now = DateTime.now().toUtc();
      await _dao.upsertDraft(
        id: 'reminder_draft_$userId',
        userId: userId,
        reminderId: draft.reminderId,
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
      await _dao.deleteDraft('reminder_draft_$userId');
    } catch (e, st) {
      _logger.e('deleteDraftByUser failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Reminder _map(ReminderDb db) {
    return Reminder(
      id: db.id,
      userId: db.userId,
      spaceId: db.spaceId,
      title: db.title,
      description: db.description,
      remindAt: db.remindAt,
      recurrenceRule: db.recurrenceRule,
      isCompleted: db.isCompleted,
      assigneeId: db.assigneeId,
      linkedRecurringId: db.linkedRecurringId,
      linkedCategoryId: db.linkedCategoryId,
      linkedAccountId: db.linkedAccountId,
      expectedAmount: db.expectedAmount,
      priority: db.priority,
      snoozeCount: db.snoozeCount,
      snoozeHistory: db.snoozeHistory,
      completedAt: db.completedAt,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: db.syncStatus,
    );
  }
}
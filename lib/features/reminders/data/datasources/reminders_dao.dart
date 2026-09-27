import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminders_repository.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [Reminders, ReminderDrafts])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(super.db);

  Stream<List<ReminderDb>> watchUpcoming({
    required String userId,
    String? spaceId,
    required RemindersUpcomingFilter filter,
    String? myMembershipId,
    required DateTime nowUtc,
  }) {
    return (select(reminders)
      ..where((r) =>
          _scope(userId, spaceId, r) &
          r.isCompleted.equals(false) &
          _upcomingFilter(filter, userId, myMembershipId, nowUtc, r))
      ..orderBy([(r) => OrderingTerm.asc(r.remindAt)]))
        .watch();
  }

  Stream<List<ReminderDb>> watchHistory({
    required String userId,
    String? spaceId,
  }) {
    return (select(reminders)
      ..where((r) => _scope(userId, spaceId, r) & r.isCompleted.equals(true))
      ..orderBy([
        (r) => OrderingTerm.desc(r.completedAt, nulls: NullsOrder.last),
        (r) => OrderingTerm.desc(r.updatedAt),
      ]))
        .watch();
  }

  Stream<int> watchUpcomingCount({
    required String userId,
    String? spaceId,
    required DateTime nowUtc,
  }) {
    final counter = countAll();
    return (selectOnly(reminders)
      ..addColumns([counter])
      ..where(_scope(userId, spaceId, reminders) &
          reminders.isCompleted.equals(false)))
        .watchSingle()
        .map((row) => row.read(counter) ?? 0);
  }

  Future<ReminderDb?> getById(String id) {
    return (select(reminders)..where((r) => r.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<ReminderDb?> watchById(String id) {
    return (select(reminders)..where((r) => r.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<List<ReminderDb>> getActiveForScheduling(String userId) {
    return (select(reminders)
      ..where((r) => r.userId.equals(userId) & r.isCompleted.equals(false)))
        .get();
  }

  Stream<List<ReminderDb>> watchByDay({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) {
    return (select(reminders)
      ..where((r) =>
          _scope(userId, spaceId, r) &
          r.remindAt.isBiggerOrEqualValue(startUtc) &
          r.remindAt.isSmallerThanValue(endUtc))
      ..orderBy([(r) => OrderingTerm.asc(r.remindAt)]))
        .watch();
  }

  Future<void> insertReminder(Reminder reminder) {
    return into(reminders).insert(_companion(reminder));
  }

  Future<int> updateReminder(Reminder reminder) {
    return (update(reminders)..where((r) => r.id.equals(reminder.id)))
        .write(_companion(reminder));
  }

  Future<int> deleteById(String id) {
    return (delete(reminders)..where((r) => r.id.equals(id))).go();
  }

  Future<int> markCompleted(String id, DateTime nowUtc) {
    return (update(reminders)..where((r) => r.id.equals(id))).write(
      RemindersCompanion(
        isCompleted: const Value(true),
        completedAt: Value(nowUtc),
        updatedAt: Value(nowUtc),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<int> undoComplete(String id) {
    return (update(reminders)..where((r) => r.id.equals(id))).write(
      RemindersCompanion(
        isCompleted: const Value(false),
        completedAt: const Value<DateTime?>(null),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<int> applySnooze({
    required String id,
    required DateTime newRemindAtUtc,
    required int newSnoozeCount,
    required String snoozeHistoryJson,
  }) {
    return (update(reminders)..where((r) => r.id.equals(id))).write(
      RemindersCompanion(
        remindAt: Value(newRemindAtUtc),
        snoozeCount: Value(newSnoozeCount),
        snoozeHistory: Value(snoozeHistoryJson),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<ReminderDraftDb?> getFreshDraft(String draftId, DateTime sinceUtc) {
    return (select(reminderDrafts)
      ..where((d) =>
          d.id.equals(draftId) & d.updatedAt.isBiggerOrEqualValue(sinceUtc)))
        .getSingleOrNull();
  }

  Future<void> upsertDraft({
    required String id,
    required String userId,
    String? reminderId,
    required String formDataJson,
    required DateTime updatedAt,
  }) {
    return into(reminderDrafts).insertOnConflictUpdate(
      ReminderDraftsCompanion(
        id: Value(id),
        userId: Value(userId),
        reminderId: Value(reminderId),
        formDataJson: Value(formDataJson),
        createdAt: Value(updatedAt),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<int> deleteDraft(String draftId) {
    return (delete(reminderDrafts)..where((d) => d.id.equals(draftId))).go();
  }

  Future<int> cleanupOldDrafts(DateTime olderThanUtc) {
    return (delete(reminderDrafts)
      ..where((d) => d.updatedAt.isSmallerThanValue(olderThanUtc)))
        .go();
  }

  Expression<bool> _scope(String userId, String? spaceId, Reminders r) {
    if (spaceId == null) return r.userId.equals(userId);
    return r.userId.equals(userId) | r.spaceId.equals(spaceId);
  }

  Expression<bool> _upcomingFilter(
    RemindersUpcomingFilter filter,
    String userId,
    String? myMembershipId,
    DateTime nowUtc,
    Reminders r,
  ) {
    switch (filter) {
      case RemindersUpcomingFilter.all:
        return const Constant(true);
      case RemindersUpcomingFilter.mine:
        return r.userId.equals(userId);
      case RemindersUpcomingFilter.assignedToMe:
        if (myMembershipId == null) return const Constant(false);
        return r.assigneeId.equals(myMembershipId);
      case RemindersUpcomingFilter.overdue:
        return r.remindAt.isSmallerThanValue(nowUtc);
    }
  }

  RemindersCompanion _companion(Reminder r) {
    return RemindersCompanion(
      id: Value(r.id),
      userId: Value(r.userId),
      spaceId: Value(r.spaceId),
      title: Value(r.title),
      description: Value(r.description),
      remindAt: Value(r.remindAt),
      recurrenceRule: Value(r.recurrenceRule),
      isCompleted: Value(r.isCompleted),
      assigneeId: Value(r.assigneeId),
      linkedRecurringId: Value(r.linkedRecurringId),
      linkedCategoryId: Value(r.linkedCategoryId),
      linkedAccountId: Value(r.linkedAccountId),
      expectedAmount: Value(r.expectedAmount),
      priority: Value(r.priority),
      snoozeCount: Value(r.snoozeCount),
      snoozeHistory: Value(r.snoozeHistory),
      completedAt: Value(r.completedAt),
      createdAt: Value(r.createdAt),
      updatedAt: Value(r.updatedAt),
      syncStatus: Value(r.syncStatus),
    );
  }
}
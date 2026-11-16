import 'package:budget_assistant/features/reminders/domain/entities/reminder.dart';
import 'package:budget_assistant/features/reminders/domain/entities/reminder_form_draft.dart';
import 'package:budget_assistant/features/reminders/domain/repositories/reminders_repository.dart';

/// Этап 24: заглушка репозитория напоминаний. Даты — UTC, суммы — копейки.
class FakeRemindersRepository implements RemindersRepository {
  final Map<String, Reminder> reminders = <String, Reminder>{};
  ReminderFormDraft? draft;

  Object? error;
  final List<String> calls = <String>[];
  final List<({String id, DateTime at})> completions =
      <({String id, DateTime at})>[];
  final List<String> undos = <String>[];
  final List<({String id, DateTime at, int count, String history})> snoozes =
      <({String id, DateTime at, int count, String history})>[];

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Stream<List<Reminder>> watchUpcoming({
    required String userId,
    String? spaceId,
    required RemindersUpcomingFilter filter,
    String? myMembershipId,
    required DateTime nowUtc,
  }) async* {
    _enter('watchUpcoming');
    yield reminders.values
        .where((r) => r.userId == userId && !r.isCompleted)
        .toList();
  }

  @override
  Stream<List<Reminder>> watchHistory({
    required String userId,
    String? spaceId,
  }) async* {
    _enter('watchHistory');
    yield reminders.values
        .where((r) => r.userId == userId && r.isCompleted)
        .toList();
  }

  @override
  Stream<int> watchUpcomingCount({
    required String userId,
    String? spaceId,
    required DateTime nowUtc,
  }) async* {
    _enter('watchUpcomingCount');
    yield reminders.values
        .where((r) => r.userId == userId && !r.isCompleted)
        .length;
  }

  @override
  Future<Reminder?> getById(String id) async {
    _enter('getById');
    return reminders[id];
  }

  @override
  Stream<Reminder?> watchById(String id) async* {
    _enter('watchById');
    yield reminders[id];
  }

  @override
  Future<List<Reminder>> getActiveForScheduling(String userId) async {
    _enter('getActiveForScheduling');
    return reminders.values
        .where((r) => r.userId == userId && !r.isCompleted)
        .toList();
  }

  @override
  Stream<List<Reminder>> watchByDay({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) async* {
    _enter('watchByDay');
    yield reminders.values
        .where((r) =>
            r.userId == userId &&
            !r.remindAt.isBefore(startUtc) &&
            r.remindAt.isBefore(endUtc))
        .toList();
  }

  @override
  Future<void> insert(Reminder reminder) async {
    _enter('insert');
    reminders[reminder.id] = reminder;
  }

  @override
  Future<void> update(Reminder reminder) async {
    _enter('update');
    reminders[reminder.id] = reminder;
  }

  @override
  Future<void> deleteById(String id) async {
    _enter('deleteById');
    reminders.remove(id);
  }

  @override
  Future<void> markCompleted(String id, DateTime nowUtc) async {
    _enter('markCompleted');
    completions.add((id: id, at: nowUtc));
    final r = reminders[id];
    if (r != null) {
      reminders[id] = r.copyWith(isCompleted: true, completedAt: nowUtc);
    }
  }

  @override
  Future<void> undoComplete(String id) async {
    _enter('undoComplete');
    undos.add(id);
    final r = reminders[id];
    if (r != null) {
      reminders[id] = r.copyWith(isCompleted: false, completedAt: null);
    }
  }

  @override
  Future<void> applySnooze({
    required String id,
    required DateTime newRemindAtUtc,
    required int newSnoozeCount,
    required String snoozeHistoryJson,
  }) async {
    _enter('applySnooze');
    snoozes.add((
      id: id,
      at: newRemindAtUtc,
      count: newSnoozeCount,
      history: snoozeHistoryJson,
    ));
    final r = reminders[id];
    if (r != null) {
      reminders[id] = r.copyWith(
        remindAt: newRemindAtUtc,
        snoozeCount: newSnoozeCount,
        snoozeHistory: snoozeHistoryJson,
      );
    }
  }

  @override
  Future<ReminderFormDraft?> getFreshDraft(String userId) async {
    _enter('getFreshDraft');
    return draft;
  }

  @override
  Future<void> saveDraft(String userId, ReminderFormDraft formDraft) async {
    _enter('saveDraft');
    draft = formDraft;
  }

  @override
  Future<void> deleteDraftByUser(String userId) async {
    _enter('deleteDraftByUser');
    draft = null;
  }
}

/// Фабрика напоминания для тестов.
Reminder makeReminder({
  required String id,
  String userId = 'u1',
  String? spaceId,
  String title = 'Оплатить интернет',
  DateTime? remindAt,
  String? recurrenceRule,
  bool isCompleted = false,
  int snoozeCount = 0,
  String? snoozeHistory,
  String? assigneeId,
  String? linkedRecurringId,
  int? expectedAmount,
  String priority = ReminderPriority.normal,
}) =>
    Reminder(
      id: id,
      userId: userId,
      spaceId: spaceId,
      title: title,
      remindAt: remindAt ?? DateTime.utc(2026, 7, 15, 10),
      recurrenceRule: recurrenceRule,
      isCompleted: isCompleted,
      snoozeCount: snoozeCount,
      snoozeHistory: snoozeHistory,
      assigneeId: assigneeId,
      linkedRecurringId: linkedRecurringId,
      expectedAmount: expectedAmount,
      priority: priority,
      createdAt: DateTime.utc(2026, 7, 1),
      updatedAt: DateTime.utc(2026, 7, 1),
    );

/// Фабрика черновика формы напоминания.
ReminderFormDraft makeReminderDraft({
  String? reminderId,
  String title = 'Оплатить интернет',
  String? description,
  DateTime? remindAt,
  String? recurrenceRule,
  int? expectedAmountKopecks,
  String priority = 'normal',
  String scope = 'personal',
  String? assigneeId,
  String? linkedCategoryId,
  String? linkedAccountId,
  String? linkedRecurringId,
}) =>
    ReminderFormDraft(
      reminderId: reminderId,
      title: title,
      description: description,
      remindAt: remindAt ?? DateTime.utc(2026, 7, 15, 10),
      recurrenceRule: recurrenceRule,
      expectedAmountKopecks: expectedAmountKopecks,
      priority: priority,
      scope: scope,
      assigneeId: assigneeId,
      linkedCategoryId: linkedCategoryId,
      linkedAccountId: linkedAccountId,
      linkedRecurringId: linkedRecurringId,
    );
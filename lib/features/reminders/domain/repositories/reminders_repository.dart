import '../entities/reminder.dart';
import '../entities/reminder_form_draft.dart';

/// Фильтры вкладки «Предстоящие» (ТЗ 6.3.10.4). Применяются WHERE в SQL.
enum RemindersUpcomingFilter { all, mine, assignedToMe, overdue }

abstract interface class RemindersRepository {
  Stream<List<Reminder>> watchUpcoming({
    required String userId,
    String? spaceId,
    required RemindersUpcomingFilter filter,
    String? myMembershipId,
    required DateTime nowUtc,
  });
  Stream<List<Reminder>> watchHistory({
    required String userId,
    String? spaceId,
  });
  Stream<int> watchUpcomingCount({
    required String userId,
    String? spaceId,
    required DateTime nowUtc,
  });
  Future<Reminder?> getById(String id);
  Stream<Reminder?> watchById(String id);
  /// Все незавершённые напоминания пользователя для планировщика пушей.
  Future<List<Reminder>> getActiveForScheduling(String userId);
  Stream<List<Reminder>> watchByDay({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  });
  Future<void> insert(Reminder reminder);
  Future<void> update(Reminder reminder);
  Future<void> deleteById(String id);
  Future<void> markCompleted(String id, DateTime nowUtc);
  Future<void> undoComplete(String id);
  Future<void> applySnooze({
    required String id,
    required DateTime newRemindAtUtc,
    required int newSnoozeCount,
    required String snoozeHistoryJson,
  });
  Future<ReminderFormDraft?> getFreshDraft(String userId);
  Future<void> saveDraft(String userId, ReminderFormDraft draft);
  Future<void> deleteDraftByUser(String userId);
}
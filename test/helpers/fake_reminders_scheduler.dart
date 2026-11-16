import 'package:budget_assistant/features/reminders/domain/entities/reminder.dart';
import 'package:budget_assistant/features/reminders/domain/ports/reminders_scheduler_port.dart';

/// Этап 24: заглушка планировщика пушей. Пишет все вызовы.
class FakeRemindersScheduler implements RemindersSchedulerPort {
  Object? error;
  bool permissionResult = true;
  int ensureReadyCalls = 0;

  final List<({String id, List<DateTime> occurrences})> scheduled =
      <({String id, List<DateTime> occurrences})>[];
  final List<String> cancelled = <String>[];

  void _check() {
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<void> ensureReady() async {
    ensureReadyCalls++;
    _check();
  }

  @override
  Future<bool> requestPermissions() async => permissionResult;

  @override
  Future<void> scheduleReminder(
    Reminder reminder,
    List<DateTime> occurrencesUtc,
  ) async {
    _check();
    scheduled.add((id: reminder.id, occurrences: occurrencesUtc));
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    cancelled.add(reminderId);
    _check();
  }
}
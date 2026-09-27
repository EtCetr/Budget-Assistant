import 'dart:convert';
import 'package:logger/logger.dart';
import '../ports/reminders_scheduler_port.dart';
import '../repositories/reminders_repository.dart';
import 'schedule_reminders_usecase.dart';

/// Отложить напоминание: новая дата + история откладываний
/// (локальное JSON-поле snooze_history, ТЗ 6.3.11.6) + перепланирование.
class SnoozeReminderUseCase {
  SnoozeReminderUseCase({
    required RemindersRepository repository,
    required ScheduleRemindersUseCase scheduler,
    required RemindersSchedulerPort port,
    required Logger logger,
  })  : _repository = repository,
        _scheduler = scheduler,
        _port = port,
        _logger = logger;

  final RemindersRepository _repository;
  final ScheduleRemindersUseCase _scheduler;
  final RemindersSchedulerPort _port;
  final Logger _logger;

  Future<void> call({
    required String reminderId,
    required DateTime newRemindAtUtc,
  }) async {
    try {
      final reminder = await _repository.getById(reminderId);
      if (reminder == null) {
        _logger.w('Snooze: reminder $reminderId not found');
        return;
      }
      final now = DateTime.now().toUtc();
      final history = <Map<String, dynamic>>[];
      final raw = reminder.snoozeHistory;
      if (raw != null && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            for (final e in decoded) {
              if (e is Map<String, dynamic>) history.add(e);
            }
          }
        } on FormatException {
          history.clear();
        }
      }
      history.add({
        'atUtc': now.toIso8601String(),
        'fromUtc': reminder.remindAt.toIso8601String(),
        'toUtc': newRemindAtUtc.toIso8601String(),
      });
      final historyJson = jsonEncode(history);
      await _repository.applySnooze(
        id: reminderId,
        newRemindAtUtc: newRemindAtUtc,
        newSnoozeCount: reminder.snoozeCount + 1,
        snoozeHistoryJson: historyJson,
      );
      final updated = reminder.copyWith(
        remindAt: newRemindAtUtc,
        snoozeCount: reminder.snoozeCount + 1,
        snoozeHistory: historyJson,
      );
      await _port.ensureReady();
      await _scheduler.scheduleSingle(updated, now);
    } catch (e, st) {
      _logger.e('SnoozeReminder failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/reminder.dart';
import '../ports/reminders_scheduler_port.dart';
import '../repositories/reminders_repository.dart';
import 'schedule_reminders_usecase.dart';

/// Обновление напоминания + перепланирование пушей.
class UpdateReminderUseCase {
  UpdateReminderUseCase({
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

  Future<void> call(Reminder updated) async {
    try {
      final now = DateTime.now().toUtc();
      final reminder = updated.copyWith(
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
      await _repository.update(reminder);
      await _port.ensureReady();
      await _scheduler.scheduleSingle(reminder, now);
    } catch (e, st) {
      _logger.e('UpdateReminder failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
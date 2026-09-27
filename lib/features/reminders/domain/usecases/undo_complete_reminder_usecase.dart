import 'package:logger/logger.dart';
import '../ports/reminders_scheduler_port.dart';
import '../repositories/reminders_repository.dart';
import 'schedule_reminders_usecase.dart';

/// Отмена завершения + перепланирование пушей.
class UndoCompleteReminderUseCase {
  UndoCompleteReminderUseCase({
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

  Future<void> call(String reminderId) async {
    try {
      await _repository.undoComplete(reminderId);
      final reminder = await _repository.getById(reminderId);
      if (reminder == null) return;
      await _port.ensureReady();
      await _scheduler.scheduleSingle(reminder, DateTime.now().toUtc());
    } catch (e, st) {
      _logger.e('UndoCompleteReminder failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
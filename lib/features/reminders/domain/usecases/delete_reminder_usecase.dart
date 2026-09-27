import 'package:logger/logger.dart';
import '../ports/reminders_scheduler_port.dart';
import '../repositories/reminders_repository.dart';

/// Удаление напоминания + отмена всех PendingIntent.
class DeleteReminderUseCase {
  DeleteReminderUseCase({
    required RemindersRepository repository,
    required RemindersSchedulerPort port,
    required Logger logger,
  })  : _repository = repository,
        _port = port,
        _logger = logger;

  final RemindersRepository _repository;
  final RemindersSchedulerPort _port;
  final Logger _logger;

  Future<void> call(String reminderId) async {
    try {
      await _repository.deleteById(reminderId);
      await _port.cancelReminder(reminderId);
    } catch (e, st) {
      _logger.e('DeleteReminder failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
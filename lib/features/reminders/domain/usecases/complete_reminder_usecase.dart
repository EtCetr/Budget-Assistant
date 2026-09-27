import 'package:logger/logger.dart';
import '../ports/reminders_scheduler_port.dart';
import '../repositories/reminders_repository.dart';

/// Завершение напоминания (чекбокс / кнопка «Выполнено» в пуше)
/// + отмена будущих PendingIntent этого напоминания.
class CompleteReminderUseCase {
  CompleteReminderUseCase({
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
      await _repository.markCompleted(reminderId, DateTime.now().toUtc());
      await _port.cancelReminder(reminderId);
    } catch (e, st) {
      _logger.e('CompleteReminder failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
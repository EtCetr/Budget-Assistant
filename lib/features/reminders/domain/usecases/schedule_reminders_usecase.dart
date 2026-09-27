import 'package:logger/logger.dart';
import '../entities/reminder.dart';
import '../ports/reminders_scheduler_port.dart';
import '../repositories/reminders_repository.dart';
import 'get_next_occurrences_usecase.dart';

/// Перепланирование всех активных напоминаний пользователя:
/// отмена старых PendingIntent + строго 3 ближайших срабатывания
/// на каждое (ТЗ 6.3.10.14.8a, ограничение Android).
class ScheduleRemindersUseCase {
  ScheduleRemindersUseCase({
    required RemindersRepository repository,
    required RemindersSchedulerPort scheduler,
    required GetNextOccurrencesUseCase nextOccurrences,
    required Logger logger,
  })  : _repository = repository,
        _scheduler = scheduler,
        _nextOccurrences = nextOccurrences,
        _logger = logger;

  final RemindersRepository _repository;
  final RemindersSchedulerPort _scheduler;
  final GetNextOccurrencesUseCase _nextOccurrences;
  final Logger _logger;

  Future<void> call(String userId) async {
    try {
      await _scheduler.ensureReady();
      final active = await _repository.getActiveForScheduling(userId);
      final now = DateTime.now().toUtc();
      for (final reminder in active) {
        try {
          await scheduleSingle(reminder, now);
        } catch (e, st) {
          // Одно плохое напоминание не ломает планирование остальных.
          _logger.e('Schedule failed for ${reminder.id}', error: e, stackTrace: st);
        }
      }
      _logger.i('Reminders scheduled: ${active.length} active');
    } catch (e, st) {
      _logger.e('ScheduleRemindersUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Планирует одно напоминание (используется CRUD-usecase'ами).
  Future<void> scheduleSingle(Reminder reminder, DateTime nowUtc) async {
    final occurrences = _nextOccurrences(
      startUtc: reminder.remindAt,
      rrule: reminder.recurrenceRule,
      afterUtc: nowUtc,
      count: 3,
    );
    if (occurrences.isEmpty) {
      await _scheduler.cancelReminder(reminder.id);
      return;
    }
    await _scheduler.scheduleReminder(reminder, occurrences);
  }
}
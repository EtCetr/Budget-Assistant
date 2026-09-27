import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../../reminders/domain/entities/reminder.dart';
import '../../../reminders/domain/repositories/reminders_repository.dart';
import '../entities/recurring_transaction.dart';

/// Интеграция с Фичей 10 (ТЗ 6.3.9.8): напоминание из регулярного
/// платежа. linked_recurring_id + RRULE FREQ=MONTHLY;BYMONTHDAY=day;
/// remind_at = ближайшая дата списания минус advanceDays, время из
/// timeOfDay ('HH:mm', дефолт 17:00).
class CreateReminderFromRecurringUseCase {
  CreateReminderFromRecurringUseCase({
    required RemindersRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final RemindersRepository _repository;
  final Logger _logger;
  static const Uuid _uuid = Uuid();

  Future<String> call({
    required RecurringTransaction recurring,
    required int advanceDays,
    String timeOfDay = '17:00',
  }) async {
    try {
      final day = recurring.averageDayOfMonth.clamp(1, 28);
      final now = DateTime.now().toLocal();
      var payment = DateTime(now.year, now.month, day, 12, 0);
      if (payment.isBefore(now)) {
        payment = DateTime(now.year, now.month + 1, day, 12, 0);
      }
      final remindDate = payment.subtract(Duration(days: advanceDays));
      final parts = timeOfDay.split(':');
      final hour = int.tryParse(parts.first) ?? 17;
      final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      final remindAt = DateTime(
        remindDate.year,
        remindDate.month,
        remindDate.day,
        hour,
        minute,
      ).toUtc();
      final nowUtc = DateTime.now().toUtc();
      final reminder = Reminder(
        id: _uuid.v4(),
        userId: recurring.userId,
        title: recurring.merchantName,
        remindAt: remindAt,
        recurrenceRule: 'FREQ=MONTHLY;BYMONTHDAY=$day',
        linkedRecurringId: recurring.id,
        linkedCategoryId: recurring.categoryId,
        expectedAmount: recurring.averageAmount,
        createdAt: nowUtc,
        updatedAt: nowUtc,
        syncStatus: SyncStatus.pending,
      );
      await _repository.insert(reminder);
      return reminder.id;
    } catch (e, st) {
      _logger.e('CreateReminderFromRecurring failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../../recurring_payments/domain/repositories/recurring_transactions_repository.dart';
import '../entities/reminder.dart';
import '../ports/reminders_scheduler_port.dart';
import '../repositories/reminders_repository.dart';
import 'schedule_reminders_usecase.dart';

/// Параметры создания напоминания (ТЗ 6.3.12).
class CreateReminderParams {
  const CreateReminderParams({
    required this.userId,
    this.spaceId,
    required this.title,
    this.description,
    required this.remindAtUtc,
    this.recurrenceRule,
    this.assigneeId,
    this.linkedRecurringId,
    this.linkedCategoryId,
    this.linkedAccountId,
    this.expectedAmount,
    this.priority = ReminderPriority.normal,
  });

  final String userId;
  final String? spaceId;
  final String title;
  final String? description;
  final DateTime remindAtUtc;
  final String? recurrenceRule;
  /// memberships.id исполнителя.
  final String? assigneeId;
  final String? linkedRecurringId;
  final String? linkedCategoryId;
  final String? linkedAccountId;
  final int? expectedAmount;
  final String priority;
}

/// Создание напоминания + планирование пушей + связь с регуляркой.
class CreateReminderUseCase {
  CreateReminderUseCase({
    required RemindersRepository repository,
    required RecurringTransactionsRepository recurringRepository,
    required ScheduleRemindersUseCase scheduler,
    required RemindersSchedulerPort port,
    required Logger logger,
  })  : _repository = repository,
        _recurringRepository = recurringRepository,
        _scheduler = scheduler,
        _port = port,
        _logger = logger;

  final RemindersRepository _repository;
  final RecurringTransactionsRepository _recurringRepository;
  final ScheduleRemindersUseCase _scheduler;
  final RemindersSchedulerPort _port;
  final Logger _logger;
  static const Uuid _uuid = Uuid();

  Future<String> call(CreateReminderParams p) async {
    try {
      final now = DateTime.now().toUtc();
      // Локальная переменная: гарантирует promotion String? -> String
      // внутри if и читается один раз.
      final linkedRecurringId = p.linkedRecurringId;
      final reminder = Reminder(
        id: _uuid.v4(),
        userId: p.userId,
        spaceId: p.spaceId,
        title: p.title,
        description: p.description,
        remindAt: p.remindAtUtc,
        recurrenceRule: p.recurrenceRule,
        assigneeId: p.assigneeId,
        linkedRecurringId: linkedRecurringId,
        linkedCategoryId: p.linkedCategoryId,
        linkedAccountId: p.linkedAccountId,
        expectedAmount: p.expectedAmount,
        priority: p.priority,
        createdAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
      await _repository.insert(reminder);
      if (linkedRecurringId != null) {
        await _recurringRepository.setLinkedReminder(
          recurringId: linkedRecurringId,
          reminderId: reminder.id,
        );
      }
      await _port.ensureReady();
      await _scheduler.scheduleSingle(reminder, now);
      return reminder.id;
    } catch (e, st) {
      _logger.e('CreateReminder failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
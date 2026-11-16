import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/recurring_payments/domain/repositories/recurring_transactions_repository.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/complete_reminder_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/create_reminder_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/delete_reminder_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/get_next_occurrences_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/schedule_reminders_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/snooze_reminder_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/undo_complete_reminder_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/update_reminder_usecase.dart';
import '../../../helpers/fake_reminders_repository.dart';
import '../../../helpers/fake_reminders_scheduler.dart';

class _MockRecurring extends Mock implements RecurringTransactionsRepository {}

/// Этап 24: жизненный цикл напоминания и планирование пушей.
/// Ключевое ограничение Android: не больше 3 срабатываний на напоминание.
/// Даты в тестах планирования — относительно «сейчас»: прошедшие
/// однократные напоминания планировщик отменяет, а не планирует.
void main() {
  late FakeRemindersRepository repo;
  late FakeRemindersScheduler port;
  late _MockRecurring recurring;
  late ScheduleRemindersUseCase scheduler;
  late CreateReminderUseCase create;
  late UpdateReminderUseCase update;
  late DeleteReminderUseCase delete;
  late CompleteReminderUseCase complete;
  late UndoCompleteReminderUseCase undo;
  late SnoozeReminderUseCase snooze;
  late Logger logger;

  setUp(() {
    logger = Logger(level: Level.off);
    repo = FakeRemindersRepository();
    port = FakeRemindersScheduler();
    recurring = _MockRecurring();
    scheduler = ScheduleRemindersUseCase(
      repository: repo,
      scheduler: port,
      nextOccurrences: GetNextOccurrencesUseCase(logger: logger),
      logger: logger,
    );
    create = CreateReminderUseCase(
      repository: repo,
      recurringRepository: recurring,
      scheduler: scheduler,
      port: port,
      logger: logger,
    );
    update = UpdateReminderUseCase(
      repository: repo,
      scheduler: scheduler,
      port: port,
      logger: logger,
    );
    delete = DeleteReminderUseCase(
      repository: repo,
      port: port,
      logger: logger,
    );
    complete = CompleteReminderUseCase(
      repository: repo,
      port: port,
      logger: logger,
    );
    undo = UndoCompleteReminderUseCase(
      repository: repo,
      scheduler: scheduler,
      port: port,
      logger: logger,
    );
    snooze = SnoozeReminderUseCase(
      repository: repo,
      scheduler: scheduler,
      port: port,
      logger: logger,
    );

    when(() => recurring.setLinkedReminder(
          recurringId: any(named: 'recurringId'),
          reminderId: any(named: 'reminderId'),
        )).thenAnswer((_) async {});
  });

  group('Создание', () {
    Future<String> run({String? linkedRecurringId}) => create(
          CreateReminderParams(
            userId: 'u1',
            title: 'Оплатить интернет',
            remindAtUtc: DateTime.now().toUtc().add(const Duration(days: 1)),
            linkedRecurringId: linkedRecurringId,
            expectedAmount: 90000,
          ),
        );

    test('создаётся с pending и UTC-датами', () async {
      final id = await run();

      final r = repo.reminders[id]!;
      expect(r.syncStatus, SyncStatus.pending);
      expect(r.createdAt.isUtc, isTrue);
      expect(r.updatedAt.isUtc, isTrue);
      expect(r.expectedAmount, 90000);
    });

    test('планировщик инициализируется и получает вхождения', () async {
      final id = await run();

      expect(port.ensureReadyCalls, greaterThan(0));
      expect(port.scheduled.single.id, id);
      expect(port.scheduled.single.occurrences, isNotEmpty);
    });

    test('связь с регулярным платежом проставляется', () async {
      final id = await run(linkedRecurringId: 'rec1');

      verify(() => recurring.setLinkedReminder(
            recurringId: 'rec1',
            reminderId: id,
          )).called(1);
      expect(repo.reminders[id]!.linkedRecurringId, 'rec1');
    });

    test('без связи репозиторий регулярок не трогается', () async {
      await run();

      verifyNever(() => recurring.setLinkedReminder(
            recurringId: any(named: 'recurringId'),
            reminderId: any(named: 'reminderId'),
          ));
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(run(), throwsA(isA<Exception>()));
    });
  });

  group('Планирование', () {
    test('ежедневное напоминание получает ровно 3 вхождения', () async {
      await repo.insert(makeReminder(
        id: 'r1',
        remindAt: DateTime.now().toUtc().add(const Duration(days: 1)),
        recurrenceRule: 'FREQ=DAILY',
      ));

      await scheduler('u1');

      expect(port.scheduled.single.occurrences.length, 3);
    });

    test('прошедшее однократное отменяется', () async {
      await repo.insert(makeReminder(
        id: 'r1',
        remindAt: DateTime.now().toUtc().subtract(const Duration(days: 1)),
      ));

      await scheduler('u1');

      expect(port.cancelled, ['r1']);
      expect(port.scheduled, isEmpty);
    });

    test('планируются все активные напоминания', () async {
      final future = DateTime.now().toUtc().add(const Duration(days: 1));
      await repo.insert(makeReminder(id: 'r1', remindAt: future));
      await repo.insert(makeReminder(id: 'r2', remindAt: future));
      await repo.insert(makeReminder(
        id: 'r3',
        remindAt: future,
        isCompleted: true,
      ));

      await scheduler('u1');

      expect(port.scheduled.map((s) => s.id).toSet(), {'r1', 'r2'});
    });

    test('ошибка планировщика пробрасывается', () async {
      port.error = Exception('plugin down');

      await expectLater(scheduler('u1'), throwsA(isA<Exception>()));
    });
  });

  group('Обновление и удаление', () {
    test('обновление ставит pending и перепланирует', () async {
      final r = makeReminder(
        id: 'r1',
        remindAt: DateTime.now().toUtc().add(const Duration(days: 2)),
      );
      await repo.insert(r);

      await update(r.copyWith(title: 'Новое название'));

      expect(repo.reminders['r1']!.title, 'Новое название');
      expect(repo.reminders['r1']!.syncStatus, SyncStatus.pending);
      expect(port.scheduled.single.id, 'r1');
    });

    test('удаление отменяет все срабатывания', () async {
      await repo.insert(makeReminder(id: 'r1'));

      await delete('r1');

      expect(repo.reminders, isEmpty);
      expect(port.cancelled, ['r1']);
    });

    test('ошибка удаления пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(delete('r1'), throwsA(isA<Exception>()));
    });
  });

  group('Завершение и отмена', () {
    test('завершение ставит флаг и отменяет пуши', () async {
      await repo.insert(makeReminder(id: 'r1'));

      await complete('r1');

      expect(repo.reminders['r1']!.isCompleted, isTrue);
      expect(repo.reminders['r1']!.completedAt, isNotNull);
      expect(port.cancelled, ['r1']);
    });

    test('отмена завершения перепланирует напоминание', () async {
      await repo.insert(makeReminder(
        id: 'r1',
        isCompleted: true,
        remindAt: DateTime.now().toUtc().add(const Duration(days: 1)),
      ));

      await undo('r1');

      expect(repo.undos, ['r1']);
      expect(repo.reminders['r1']!.isCompleted, isFalse);
      expect(port.scheduled.single.id, 'r1');
    });

    test('отмена завершения для отсутствующего напоминания', () async {
      await undo('missing');

      expect(port.scheduled, isEmpty);
    });

    test('ошибка завершения пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(complete('r1'), throwsA(isA<Exception>()));
    });
  });

  group('Откладывание', () {
    test('счётчик растёт, история пишется, пуши перепланируются', () async {
      final from = DateTime.now().toUtc().add(const Duration(days: 1));
      final to = DateTime.now().toUtc().add(const Duration(days: 3));
      await repo.insert(makeReminder(id: 'r1', remindAt: from));

      await snooze(reminderId: 'r1', newRemindAtUtc: to);

      final s = repo.snoozes.single;
      expect(s.count, 1);
      expect(s.at, to);
      final history = jsonDecode(s.history) as List;
      expect(history.length, 1);
      expect(port.scheduled.single.id, 'r1');
    });

    test('история дополняется, а не перезаписывается', () async {
      final old = jsonEncode([
        {
          'atUtc': '2026-07-10T00:00:00Z',
          'fromUtc': '2026-07-12T00:00:00Z',
          'toUtc': '2026-07-15T00:00:00Z',
        }
      ]);
      await repo.insert(makeReminder(id: 'r1', snoozeHistory: old));

      await snooze(
        reminderId: 'r1',
        newRemindAtUtc: DateTime.now().toUtc().add(const Duration(days: 5)),
      );

      expect((jsonDecode(repo.snoozes.single.history) as List).length, 2);
      expect(repo.snoozes.single.count, 1);
    });

    test('битая история начинается заново', () async {
      await repo.insert(makeReminder(id: 'r1', snoozeHistory: '{битый json'));

      await snooze(
        reminderId: 'r1',
        newRemindAtUtc: DateTime.now().toUtc().add(const Duration(days: 5)),
      );

      expect((jsonDecode(repo.snoozes.single.history) as List).length, 1);
    });

    test('отсутствующее напоминание не откладывается', () async {
      await snooze(
        reminderId: 'missing',
        newRemindAtUtc: DateTime.utc(2026, 7, 20),
      );

      expect(repo.snoozes, isEmpty);
      expect(port.scheduled, isEmpty);
    });
  });
}
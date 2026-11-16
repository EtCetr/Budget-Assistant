import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/recurring_payments/domain/entities/recurring_transaction.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/add_recurring_payment_usecase.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/calculate_confidence_usecase.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/create_reminder_from_recurring_usecase.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/detect_recurring_payments_usecase.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/group_recurring_candidates_usecase.dart';
import '../../../helpers/fake_recurring_repository.dart';
import '../../../helpers/fake_reminders_repository.dart';

/// Этап 24: правила детекции регулярных платежей (ТЗ 6.3.9).
void main() {
  late FakeRecurringRepository repo;
  late Logger logger;

  setUp(() {
    repo = FakeRecurringRepository();
    logger = Logger(level: Level.off);
  });

  group('Нормализация и бакеты', () {
    test('нормализация мерчанта: регистр и пунктуация', () {
      expect(
        normalizeMerchant('ООО «Яндекс.Такси»!'),
        'ооо яндекс такси',
      );
      expect(normalizeMerchant('   '), '');
    });

    test('бакет суммы: округление до сотен рублей', () {
      expect(amountBucket(1509999), 1510000);
      expect(amountBucket(9999), 10000);
      expect(amountBucket(-200000), 200000);
    });
  });

  group('CalculateConfidenceUseCase', () {
    test('6 и более вхождений — high, меньше — medium', () {
      final useCase = CalculateConfidenceUseCase();
      expect(useCase(6), RecurringConfidence.high);
      expect(useCase(5), RecurringConfidence.medium);
      expect(useCase(3), RecurringConfidence.medium);
    });
  });

  group('GroupRecurringCandidatesUseCase', () {
    test('группы по паттернам и сортировка по количеству', () {
      final useCase = GroupRecurringCandidatesUseCase();
      final groups = useCase([
        makeRecurring(id: 'n1', merchantNormalized: 'netflix com'),
        makeRecurring(id: 'n2', merchantNormalized: 'netflix com'),
        makeRecurring(id: 'm1', merchantNormalized: 'mts'),
        makeRecurring(id: 'x1', merchantNormalized: 'случайный магазин'),
      ]);

      expect(groups.first.key, 'subscriptions');
      expect(groups.first.emoji, '🎬');
      expect(groups.first.candidates.length, 2);
      expect(
        groups.map((g) => g.key).toSet(),
        {'subscriptions', 'utilities', 'other'},
      );
      expect(useCase.emojiFor('unknown'), '💳');
    });
  });

  group('AddRecurringPaymentUseCase', () {
    test('нового кандидата подтверждает вставкой со статусом active',
        () async {
      final useCase = AddRecurringPaymentUseCase(
        repository: repo,
        logger: logger,
      );

      final id = await useCase(makeRecurring(id: 'c1'));

      expect(id, 'c1');
      expect(repo.rows['c1']!.status, RecurringStatus.active);
    });

    test('существующий ключ обновляет статистику, без дубля', () async {
      repo.rows['e1'] = makeRecurring(id: 'e1');
      final useCase = AddRecurringPaymentUseCase(
        repository: repo,
        logger: logger,
      );

      final id = await useCase(
        makeRecurring(id: 'c1', occurrenceCount: 7),
      );

      expect(id, 'e1');
      expect(repo.rows.length, 1);
      expect(repo.statsUpdates.single.status, RecurringStatus.active);
      expect(repo.statsUpdates.single.count, 7);
    });
  });

  group('CreateReminderFromRecurringUseCase', () {
    late FakeRemindersRepository reminders;
    late CreateReminderFromRecurringUseCase useCase;

    setUp(() {
      reminders = FakeRemindersRepository();
      useCase = CreateReminderFromRecurringUseCase(
        repository: reminders,
        logger: logger,
      );
    });

    test('напоминание связано и получает месячный RRULE', () async {
      await useCase(
        recurring: makeRecurring(id: 'r1', averageDayOfMonth: 15),
        advanceDays: 3,
      );

      final reminder = reminders.reminders.values.single;
      expect(reminder.recurrenceRule, 'FREQ=MONTHLY;BYMONTHDAY=15');
      expect(reminder.linkedRecurringId, 'r1');
      expect(reminder.title, 'NETFLIX.COM');
      expect(reminder.expectedAmount, 99900);
    });

    test('день списания зажимается в 1..28', () async {
      await useCase(
        recurring: makeRecurring(id: 'r1', averageDayOfMonth: 31),
        advanceDays: 1,
      );

      expect(
        reminders.reminders.values.single.recurrenceRule,
        'FREQ=MONTHLY;BYMONTHDAY=28',
      );
    });

    test('время напоминания берётся из timeOfDay', () async {
      await useCase(
        recurring: makeRecurring(id: 'r1'),
        advanceDays: 1,
        timeOfDay: '09:30',
      );

      final local = reminders.reminders.values.single.remindAt.toLocal();
      expect(local.hour, 9);
      expect(local.minute, 30);
    });
  });
}
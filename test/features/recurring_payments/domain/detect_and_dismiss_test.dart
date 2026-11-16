import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/recurring_payments/data/datasources/recurring_detection_dao.dart';
import 'package:budget_assistant/features/recurring_payments/domain/entities/recurring_transaction.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/calculate_confidence_usecase.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/detect_recurring_payments_usecase.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/dismiss_all_candidates_usecase.dart';
import 'package:budget_assistant/features/recurring_payments/domain/usecases/restore_dismissed_candidates_usecase.dart';
import '../../../helpers/fake_recurring_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: автодетект регулярных платежей на реальной БД и защита от спама.
void main() {
  final skip = sqliteSkipReason();

  group('DetectRecurringPaymentsUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late FakeRecurringRepository repo;
    late DetectRecurringPaymentsUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      repo = FakeRecurringRepository();
      useCase = DetectRecurringPaymentsUseCase(
        dao: RecurringDetectionDao(db),
        repository: repo,
        confidence: CalculateConfidenceUseCase(),
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> monthly(String merchant, int amount, int months) async {
      final now = DateTime.now();
      for (var i = 0; i < months; i++) {
        final date = now.subtract(Duration(days: 30 * i));
        await db.into(db.transactions).insert(TransactionsCompanion.insert(
              id: '$merchant-$i',
              accountId: kAccountId,
              userId: kUserId,
              date: date,
              amount: amount,
              type: TransactionType.expense,
              merchantName: Value(merchant),
              createdAt: date,
              updatedAt: date,
            ));
      }
    }

    test('3 месяца одной суммы — кандидат medium', () async {
      await monthly('NETFLIX.COM', 99900, 3);

      final touched = await useCase(userId: kUserId);

      expect(touched, 1);
      final c = repo.rows.values.single;
      expect(c.status, RecurringStatus.pendingConfirmation);
      expect(c.confidence, RecurringConfidence.medium);
      expect(c.occurrenceCount, 3);
      expect(c.merchantNameNormalized, 'netflix com');
      expect(c.averageAmountBucket, 100000);
    });

    test('6 месяцев — уверенность high', () async {
      await monthly('NETFLIX.COM', 99900, 6);

      await useCase(userId: kUserId);

      expect(
        repo.rows.values.single.confidence,
        RecurringConfidence.high,
      );
    });

    test('меньше 3 месяцев — кандидатов нет', () async {
      await monthly('NETFLIX.COM', 99900, 2);

      expect(await useCase(userId: kUserId), 0);
      expect(repo.rows, isEmpty);
    });

    test('подтверждённый (active) не трогается повторным детектом', () async {
      repo.rows['a1'] = makeRecurring(
        id: 'a1',
        status: RecurringStatus.active,
      );
      await monthly('NETFLIX.COM', 99900, 4);

      final touched = await useCase(userId: kUserId);

      expect(touched, 0);
      expect(repo.rows['a1']!.status, RecurringStatus.active);
      expect(repo.statsUpdates, isEmpty);
    });

    test('разные мерчанты — отдельные кандидаты', () async {
      await monthly('NETFLIX.COM', 99900, 3);
      await monthly('MTS', 60000, 3);

      expect(await useCase(userId: kUserId), 2);
      expect(repo.rows.length, 2);
    });
  }, skip: skip);

  group('Dismiss / Restore (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late FakeRecurringRepository repo;
    late DismissAllCandidatesUseCase dismiss;
    late RestoreDismissedCandidatesUseCase restore;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.user(kUserId);
      // Прогрев строки app_settings (getForUser создаёт дефолт).
      await db.appSettingsDao.getForUser(kUserId);
      repo = FakeRecurringRepository();
      final logger = Logger(level: Level.off);
      dismiss = DismissAllCandidatesUseCase(
        repository: repo,
        settingsDao: db.appSettingsDao,
        logger: logger,
      );
      restore = RestoreDismissedCandidatesUseCase(
        repository: repo,
        settingsDao: db.appSettingsDao,
        logger: logger,
      );
    });

    tearDown(() async {
      await db.close();
    });

    void seedPending(int n) {
      for (var i = 0; i < n; i++) {
        repo.rows['p$i'] = makeRecurring(id: 'p$i');
      }
    }

    test('нет кандидатов — пустой результат', () async {
      final r = await dismiss(kUserId);

      expect(r.deleted, isEmpty);
      expect(r.newDismissCount, 0);
      expect(r.autoDetectDisabled, isFalse);
    });

    test('отклонение инкрементирует счётчик', () async {
      seedPending(2);

      final r = await dismiss(kUserId);

      expect(r.deleted.length, 2);
      expect(r.newDismissCount, 1);
      expect(r.autoDetectDisabled, isFalse);
      expect(repo.rows, isEmpty);
      final settings = await db.appSettingsDao.getForUser(kUserId);
      expect(settings.recurringDetectionDismissCount, 1);
    });

    test('третье отклонение выключает автодетект', () async {
      late DismissAllResult last;
      for (var round = 1; round <= 3; round++) {
        seedPending(1);
        last = await dismiss(kUserId);
        if (round < 3) {
          expect(last.autoDetectDisabled, isFalse);
        }
      }

      expect(last.autoDetectDisabled, isTrue);
      final settings = await db.appSettingsDao.getForUser(kUserId);
      expect(settings.recurringDetectionDismissCount, 3);
      expect(settings.autoDetectRecurring, isFalse);
    });

    test('undo восстанавливает кандидатов и откатывает счётчик', () async {
      seedPending(2);
      final r = await dismiss(kUserId);

      await restore(kUserId, r.deleted);

      expect(repo.rows.length, 2);
      final settings = await db.appSettingsDao.getForUser(kUserId);
      expect(settings.recurringDetectionDismissCount, 0);
    });
  }, skip: skip);
}
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/secrecy_candidate.dart';
import 'package:budget_assistant/features/import/domain/usecases/apply_secrecy_mode_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/check_secrecy_mode_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_gift_candidate_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: режим секретности подарков (ТЗ 6.3.27).
/// Период = [праздник - secrecyDaysBefore, праздник).
///
/// CheckSecrecyModeUseCase: настройка влияет на преднабор
/// (isSelectedByDefault = confidence >= 0.3), а не на сам расчёт.
/// Даты из Drift приходят в локальном поясе — сравниваем моменты времени.
///
/// DetectGiftCandidateUseCase: средний чек считается ТОЛЬКО по транзакциям
/// с merchant_name IS NOT NULL, поэтому история сидится прямым insert.
void main() {
  final skip = sqliteSkipReason();

  group('Режим секретности (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DetectGiftCandidateUseCase gift;
    late CheckSecrecyModeUseCase check;
    late ApplySecrecyModeUseCase apply;
    final holidayDate = DateTime.utc(2026, 7, 15);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      final logger = Logger(level: Level.off);
      gift = DetectGiftCandidateUseCase(logger: logger);
      check = CheckSecrecyModeUseCase(
        db: db,
        giftDetector: gift,
        logger: logger,
      );
      apply = ApplySecrecyModeUseCase(db: db, logger: logger);
      await db.appSettingsDao.getForUser(kUserId);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> enableSecrecy({bool on = true, int days = 3}) async {
      await db.appSettingsDao.updateForUser(
        kUserId,
        AppSettingsCompanion(
          enableSecrecyMode: Value(on),
          secrecyDaysBefore: Value(days),
        ),
      );
    }

    Future<void> holiday({
      required String id,
      String? spaceId,
      DateTime? date,
    }) async {
      final now = DateTime.now().toUtc();
      await db.into(db.holidays).insert(HolidaysCompanion(
            id: Value(id),
            userId: const Value(kUserId),
            spaceId: Value(spaceId),
            name: const Value('День рождения'),
            date: Value(date ?? holidayDate),
            isAnnuallyRecurring: const Value(false),
            isPreset: const Value(false),
            isEnabled: const Value(true),
            createdAt: Value(now),
            updatedAt: Value(now),
          ));
    }

    /// История трат с заполненным мерчантом — иначе детектор её не видит.
    Future<void> historyTx({required String id, required int amount}) async {
      final now = DateTime.now();
      await db.into(db.transactions).insert(TransactionsCompanion.insert(
            id: id,
            accountId: kAccountId,
            userId: kUserId,
            date: now,
            amount: amount,
            type: TransactionType.expense,
            merchantName: const Value('Магазин'),
            customCategoryId: const Value('c1'),
            createdAt: now,
            updatedAt: now,
          ));
    }

    ParsedRow row({
      int index = 0,
      int amount = -500000,
      String merchant = 'Магазин',
      DateTime? date,
      String? bankCategory,
    }) =>
        ParsedRow(
          rowIndex: index,
          date: date ?? DateTime.utc(2026, 7, 13, 12),
          amountKopecks: amount,
          merchantName: merchant,
          bankCategory: bankCategory,
        );

    group('CheckSecrecyModeUseCase', () {
      test('режим выключен — кандидатов нет', () async {
        await enableSecrecy(on: false);
        await holiday(id: 'h1');

        final result = await check(
          transactions: [row()],
          targetSpaceId: null,
          userId: kUserId,
        );

        expect(result, isEmpty);
      });

      test('низкая уверенность — кандидат не выбран по умолчанию', () async {
        await enableSecrecy();
        await holiday(id: 'h1');

        final result = await check(
          transactions: [row()],
          targetSpaceId: null,
          userId: kUserId,
        );

        expect(result, isNotEmpty);
        expect(result.every((c) => !c.isSelectedByDefault), isTrue);
      });

      test('покупка в периоде секретности становится кандидатом', () async {
        await enableSecrecy();
        await holiday(id: 'h1');

        final result = await check(
          transactions: [row()],
          targetSpaceId: null,
          userId: kUserId,
        );

        expect(result.length, 1);
        expect(result.single.relatedHolidayId, 'h1');
        expect(result.single.relatedHolidayName, 'День рождения');
      });

      test('покупка вне периода не кандидат', () async {
        await enableSecrecy();
        await holiday(id: 'h1');

        final result = await check(
          transactions: [row(date: DateTime.utc(2026, 7, 1))],
          targetSpaceId: null,
          userId: kUserId,
        );

        expect(result, isEmpty);
      });

      test('праздник чужого пространства не учитывается', () async {
        await enableSecrecy();
        await seed.space('s2');
        await holiday(id: 'h2', spaceId: 's2');

        final result = await check(
          transactions: [row()],
          targetSpaceId: kSpaceId,
          userId: kUserId,
        );

        expect(result, isEmpty);
      });

      test('личный праздник учитывается при любом скоупе', () async {
        await enableSecrecy();
        await holiday(id: 'h1');

        final result = await check(
          transactions: [row()],
          targetSpaceId: kSpaceId,
          userId: kUserId,
        );

        expect(result.length, 1);
      });
    });

    group('ApplySecrecyModeUseCase', () {
      Future<String> seedTx() async {
        await seed.tx(id: 't1', amountKopecks: 500000, categoryId: 'c1');
        return 't1';
      }

      test('транзакция скрывается до даты праздника с новой категорией',
          () async {
        final id = await seedTx();
        final candidate = SecrecyCandidate(
          id: 'c1',
          transaction: row(),
          relatedHolidayId: 'h1',
          relatedHolidayName: 'День рождения',
          relatedHolidayDate: holidayDate,
          confidence: 0.5,
          selectedCategoryId: 'c2',
        );

        final ok = await apply(
          selected: [candidate],
          transactionIdByRowIndex: {0: id},
        );

        expect(ok, isTrue);
        final t = await (db.select(db.transactions)
              ..where((x) => x.id.equals(id)))
            .getSingle();
        expect(t.isHiddenByCalendar, isTrue);
        expect(t.hiddenUntilDate!.isAtSameMomentAs(holidayDate), isTrue);
        expect(t.customCategoryId, 'c2');
        expect(t.syncStatus, SyncStatus.pending);
      });

      test('без id для строки ничего не меняется, но результат успешен',
          () async {
        final id = await seedTx();

        final ok = await apply(
          selected: [
            SecrecyCandidate(
              id: 'c1',
              transaction: row(index: 9),
              relatedHolidayId: 'h1',
              relatedHolidayName: 'День рождения',
              relatedHolidayDate: holidayDate,
              confidence: 0.5,
            ),
          ],
          transactionIdByRowIndex: {0: id},
        );

        expect(ok, isTrue);
        final t = await (db.select(db.transactions)
              ..where((x) => x.id.equals(id)))
            .getSingle();
        expect(t.isHiddenByCalendar, isFalse);
      });
    });

    group('DetectGiftCandidateUseCase', () {
      test('категория «Подарок» даёт 0.5', () async {
        final c = await gift(
          row: row(bankCategory: 'Подарок'),
          db: db,
        );

        expect(c, closeTo(0.5, 0.001));
      });

      test('категория «Gift» даёт 0.5', () async {
        final c = await gift(
          row: row(bankCategory: 'Gift'),
          db: db,
        );

        expect(c, closeTo(0.5, 0.001));
      });

      test('текущее поведение: «Подарки» во множественном числе не даёт веса '
          '(TODO(24.8))', () async {
        // Детектор ищет подстроку «подарок»; «подарки» её не содержит.
        final c = await gift(
          row: row(bankCategory: 'Подарки'),
          db: db,
        );

        expect(c, 0);
      });

      test('типичный мерчант подарков даёт 0.3', () async {
        final c = await gift(
          row: row(merchant: 'Золотое Яблоко'),
          db: db,
        );

        expect(c, closeTo(0.3, 0.001));
      });

      test('сумма выше двойного среднего чека добавляет 0.2', () async {
        for (var i = 0; i < 5; i++) {
          await historyTx(id: 'h$i', amount: 10000);
        }

        final c = await gift(
          row: row(merchant: 'Золотое Яблоко', amount: -100000),
          db: db,
        );

        // 0.3 (мерчант) + 0.2 (100000 > 2 * 10000)
        expect(c, closeTo(0.5, 0.001));
      });

      test('все три критерия дают максимум 1.0', () async {
        for (var i = 0; i < 5; i++) {
          await historyTx(id: 'h$i', amount: 10000);
        }

        final c = await gift(
          row: row(
            merchant: 'Золотое Яблоко',
            amount: -100000,
            bankCategory: 'Подарок',
          ),
          db: db,
        );

        expect(c, closeTo(1.0, 0.001));
      });

      test('обычная покупка без истории — 0', () async {
        final c = await gift(row: row(), db: db);

        expect(c, 0);
      });
    });
  }, skip: skip);
}
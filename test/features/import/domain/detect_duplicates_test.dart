import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_duplicates_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: детект дубликатов при импорте (ТЗ 6.3.26.5).
/// Сумма точная, дата ±допуск, мерчант — Левенштейн < 3.
/// Hold-операция (audit_status='pending') — НЕ дубль, а подтверждение.
void main() {
  final skip = sqliteSkipReason();

  group('DetectDuplicatesUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DetectDuplicatesUseCase useCase;
    final day = DateTime.utc(2026, 7, 15, 12);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      useCase = DetectDuplicatesUseCase(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> existing({
      required String id,
      required int amount,
      required String merchant,
      DateTime? date,
      String accountId = kAccountId,
      AuditStatus auditStatus = AuditStatus.verified,
    }) async {
      final d = date ?? day;
      await db.into(db.transactions).insert(TransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            userId: kUserId,
            date: d,
            amount: amount,
            type: TransactionType.expense,
            merchantName: Value(merchant),
            customCategoryId: const Value('c1'),
            auditStatus: Value(auditStatus),
            createdAt: d,
            updatedAt: d,
          ));
    }

    ParsedRow row({
      int amount = -15000,
      String merchant = 'Пятёрочка',
      DateTime? date,
    }) =>
        ParsedRow(
          rowIndex: 0,
          date: date ?? day,
          amountKopecks: amount,
          merchantName: merchant,
        );

    test('точное совпадение суммы, даты и мерчанта — дубль с оценкой 1.0',
        () async {
      await existing(id: 'e1', amount: 15000, merchant: 'Пятёрочка');

      final r = await useCase(
        importedRows: [row()],
        accountId: kAccountId,
        toleranceDays: 1,
      );

      expect(r.duplicates.length, 1);
      expect(r.holdConfirmations, isEmpty);
      expect(r.duplicates.single.existingTransactionId, 'e1');
      expect(r.duplicates.single.matchScore, closeTo(1.0, 0.001));
    });

    test('hold-операция попадает в подтверждения, а не в дубли', () async {
      await existing(
        id: 'h1',
        amount: 15000,
        merchant: 'Пятёрочка',
        auditStatus: AuditStatus.pending,
      );

      final r = await useCase(
        importedRows: [row()],
        accountId: kAccountId,
        toleranceDays: 1,
      );

      expect(r.duplicates, isEmpty);
      expect(r.holdConfirmations.length, 1);
      expect(r.holdConfirmations.single.existingTransactionId, 'h1');
    });

    test('другая сумма — совпадений нет', () async {
      await existing(id: 'e1', amount: 20000, merchant: 'Пятёрочка');

      final r = await useCase(
        importedRows: [row()],
        accountId: kAccountId,
        toleranceDays: 1,
      );

      expect(r.duplicates, isEmpty);
      expect(r.holdConfirmations, isEmpty);
    });

    test('дата вне допуска — совпадений нет', () async {
      await existing(
        id: 'e1',
        amount: 15000,
        merchant: 'Пятёрочка',
        date: day.subtract(const Duration(days: 5)),
      );

      final r = await useCase(
        importedRows: [row()],
        accountId: kAccountId,
        toleranceDays: 1,
      );

      expect(r.duplicates, isEmpty);
    });

    test('дата внутри допуска — дубль с меньшей оценкой', () async {
      await existing(
        id: 'e1',
        amount: 15000,
        merchant: 'Пятёрочка',
        date: day.subtract(const Duration(days: 1)),
      );

      final r = await useCase(
        importedRows: [row()],
        accountId: kAccountId,
        toleranceDays: 2,
      );

      expect(r.duplicates.length, 1);
      expect(r.duplicates.single.matchScore, lessThan(1.0));
    });

    test('мерчант отличается сильно — совпадений нет', () async {
      await existing(id: 'e1', amount: 15000, merchant: 'АЗС Лукойл');

      final r = await useCase(
        importedRows: [row()],
        accountId: kAccountId,
        toleranceDays: 1,
      );

      expect(r.duplicates, isEmpty);
    });

    test('мерчант отличается на один символ — дубль', () async {
      await existing(id: 'e1', amount: 15000, merchant: 'Пятёрочк');

      final r = await useCase(
        importedRows: [row()],
        accountId: kAccountId,
        toleranceDays: 1,
      );

      expect(r.duplicates.length, 1);
      expect(r.duplicates.single.matchScore, closeTo(0.85, 0.001));
    });

    test('операция другого счёта не считается дублем', () async {
      await seed.account(id: 'a2');
      await existing(
        id: 'e1',
        amount: 15000,
        merchant: 'Пятёрочка',
        accountId: 'a2',
      );

      final r = await useCase(
        importedRows: [row()],
        accountId: kAccountId,
        toleranceDays: 1,
      );

      expect(r.duplicates, isEmpty);
    });

    test('пустой импорт — пустой результат', () async {
      final r = await useCase(
        importedRows: const [],
        accountId: kAccountId,
        toleranceDays: 1,
      );

      expect(r.duplicates, isEmpty);
      expect(r.holdConfirmations, isEmpty);
    });
  }, skip: skip);
}
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_candidate.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_transfers_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: детект переводов между своими счетами (ТЗ 6.3.26.7).
/// Сценарий Б (СБП): маркер + окно в минутах.
/// Сценарий А (межбанк): окно в днях + доход на другом счёте в БД.
void main() {
  final skip = sqliteSkipReason();

  group('DetectTransfersUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DetectTransfersUseCase useCase;
    final day = DateTime.utc(2026, 7, 15, 12);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      useCase = DetectTransfersUseCase(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    ParsedRow row({
      required int index,
      required int amount,
      required String merchant,
      required DateTime date,
    }) =>
        ParsedRow(
          rowIndex: index,
          date: date,
          amountKopecks: amount,
          merchantName: merchant,
        );

    Future<void> incomeInDb({
      required String id,
      required String accountId,
      required int amount,
      required DateTime date,
    }) async {
      await db.into(db.transactions).insert(TransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            userId: kUserId,
            date: date,
            amount: amount,
            type: TransactionType.income,
            createdAt: date,
            updatedAt: date,
          ));
    }

    Future<List<TransferCandidate>> run(List<ParsedRow> rows) => useCase(
          importedRows: rows,
          sourceAccountId: kAccountId,
          interbankToleranceDays: 3,
          sbpToleranceMinutes: 5,
        );

    test('СБП в окне минут — перевод без поиска второго счёта', () async {
      final result = await run([
        row(index: 0, amount: -50000, merchant: 'СБП перевод', date: day),
        row(
          index: 1,
          amount: 50000,
          merchant: 'Поступление СБП',
          date: day.add(const Duration(minutes: 2)),
        ),
      ]);

      expect(result.length, 1);
      expect(result.single.scenario, TransferScenario.sbp);
      expect(result.single.amountKopecks, 50000);
      expect(result.single.targetAccountId, kAccountId);
    });

    test('СБП вне окна минут и без второго счёта — перевода нет', () async {
      final result = await run([
        row(index: 0, amount: -50000, merchant: 'СБП перевод', date: day),
        row(
          index: 1,
          amount: 50000,
          merchant: 'Поступление СБП',
          date: day.add(const Duration(minutes: 10)),
        ),
      ]);

      expect(result, isEmpty);
    });

    test('межбанк: доход на другом счёте в БД даёт перевод', () async {
      await seed.account(id: 'a2');
      final incomeDate = day.add(const Duration(days: 1));
      await incomeInDb(
        id: 'inc',
        accountId: 'a2',
        amount: 50000,
        date: incomeDate,
      );

      final result = await run([
        row(index: 0, amount: -50000, merchant: 'Перевод', date: day),
        row(index: 1, amount: 50000, merchant: 'Зачисление', date: incomeDate),
      ]);

      expect(result.length, 1);
      expect(result.single.scenario, TransferScenario.interbank);
      expect(result.single.targetAccountId, 'a2');
    });

    test('межбанк без второго счёта в БД — перевода нет', () async {
      final result = await run([
        row(index: 0, amount: -50000, merchant: 'Перевод', date: day),
        row(
          index: 1,
          amount: 50000,
          merchant: 'Зачисление',
          date: day.add(const Duration(days: 1)),
        ),
      ]);

      expect(result, isEmpty);
    });

    test('разные суммы — перевода нет', () async {
      final result = await run([
        row(index: 0, amount: -50000, merchant: 'СБП перевод', date: day),
        row(
          index: 1,
          amount: 40000,
          merchant: 'Поступление СБП',
          date: day.add(const Duration(minutes: 1)),
        ),
      ]);

      expect(result, isEmpty);
    });

    test('разница больше окна дней — перевода нет', () async {
      await seed.account(id: 'a2');
      final incomeDate = day.add(const Duration(days: 5));
      await incomeInDb(
        id: 'inc',
        accountId: 'a2',
        amount: 50000,
        date: incomeDate,
      );

      final result = await run([
        row(index: 0, amount: -50000, merchant: 'Перевод', date: day),
        row(index: 1, amount: 50000, merchant: 'Зачисление', date: incomeDate),
      ]);

      expect(result, isEmpty);
    });
  }, skip: skip);
}
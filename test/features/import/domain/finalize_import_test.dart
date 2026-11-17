import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/import/domain/entities/duplicate_candidate.dart';
import 'package:budget_assistant/features/import/domain/entities/hold_confirmation_candidate.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_candidate.dart';
import 'package:budget_assistant/features/import/domain/usecases/finalize_import_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: финализация импорта (ТЗ 6.3.26).
/// hold -> дубликаты (skip/replace/both) -> переводы -> создание -> баланс.
void main() {
  final skip = sqliteSkipReason();

  group('FinalizeImportUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late FinalizeImportUseCase useCase;
    final day = DateTime.utc(2026, 7, 15, 12);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      useCase = FinalizeImportUseCase(
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
      String merchant = 'Пятёрочка',
      bool isHold = false,
      bool isTransfer = false,
      String? categoryId,
      String? comment,
      String? bankTransactionId,
    }) =>
        ParsedRow(
          rowIndex: index,
          date: day,
          amountKopecks: amount,
          merchantName: merchant,
          isHold: isHold,
          isTransfer: isTransfer,
          assignedCategoryId: categoryId,
          comment: comment,
          bankTransactionId: bankTransactionId,
        );

    ImportResult result({
      required List<ParsedRow> rows,
      List<DuplicateCandidate> duplicates = const [],
      List<HoldConfirmationCandidate> holds = const [],
      List<TransferCandidate> transfers = const [],
    }) =>
        ImportResult(
          bankName: 'Т-Банк',
          bankCode: 'tbank',
          fileName: 'sample.csv',
          totalRows: rows.length,
          periodStart: day,
          periodEnd: day,
          targetAccountId: kAccountId,
          rows: rows,
          duplicates: duplicates,
          holdConfirmations: holds,
          transfers: transfers,
        );

    Future<void> existing({
      required String id,
      int amount = 15000,
      AuditStatus auditStatus = AuditStatus.verified,
    }) async {
      await db.into(db.transactions).insert(TransactionsCompanion.insert(
            id: id,
            accountId: kAccountId,
            userId: kUserId,
            date: day,
            amount: amount,
            type: TransactionType.expense,
            merchantName: const Value('Пятёрочка'),
            customCategoryId: const Value('c1'),
            auditStatus: Value(auditStatus),
            createdAt: day,
            updatedAt: day,
          ));
    }

    Future<TransactionDb> tx(String id) =>
        (db.select(db.transactions)..where((t) => t.id.equals(id))).getSingle();

    Future<int> balance() async {
      final a = await (db.select(db.accounts)
            ..where((t) => t.id.equals(kAccountId)))
          .getSingle();
      return a.currentBalance;
    }

    test('выбранные строки создаются, баланс меняется на дельту', () async {
      final rows = [
        row(index: 0, amount: -15000),
        row(index: 1, amount: 50000, merchant: 'Зарплата'),
      ];

      final outcome = await useCase(
        importResult: result(rows: rows),
        userId: kUserId,
        selectedRowIndices: {0, 1},
      );

      expect(outcome, isNotNull);
      expect(outcome!.created.length, 2);
      expect(outcome.balanceDeltaKopecks, 35000);
      expect(await balance(), 35000);

      final all = await db.select(db.transactions).get();
      expect(all.length, 2);
      expect(all.every((t) => t.syncStatus == SyncStatus.pending), isTrue);
    });

    test('невыбранные строки не создаются', () async {
      final rows = [
        row(index: 0, amount: -15000),
        row(index: 1, amount: -20000),
      ];

      final outcome = await useCase(
        importResult: result(rows: rows),
        userId: kUserId,
        selectedRowIndices: {0},
      );

      expect(outcome!.created.length, 1);
      expect(outcome.created.single.row.rowIndex, 0);
      expect(await balance(), -15000);
    });

    test('HOLD-строка создаётся со статусом pending', () async {
      final outcome = await useCase(
        importResult: result(rows: [row(index: 0, amount: -15000, isHold: true)]),
        userId: kUserId,
        selectedRowIndices: {0},
      );

      final created = await tx(outcome!.created.single.id);
      expect(created.auditStatus, AuditStatus.pending);
    });

    test('помеченная переводом строка создаётся как transfer', () async {
      final outcome = await useCase(
        importResult: result(
          rows: [row(index: 0, amount: -15000, isTransfer: true)],
        ),
        userId: kUserId,
        selectedRowIndices: {0},
      );

      final created = await tx(outcome!.created.single.id);
      expect(created.type, TransactionType.transfer);
      expect(created.amount, 15000);
    });

    test('дубль со skip не создаётся', () async {
      await existing(id: 'e1');
      final r = row(index: 0, amount: -15000);

      final outcome = await useCase(
        importResult: result(
          rows: [r],
          duplicates: [
            DuplicateCandidate(
              id: 'd1',
              importedRow: r,
              existingTransactionId: 'e1',
              existingDate: day,
              existingAmountKopecks: 15000,
              existingMerchantName: 'Пятёрочка',
              matchScore: 1,
            ),
          ],
        ),
        userId: kUserId,
        selectedRowIndices: {0},
      );

      expect(outcome!.created, isEmpty);
      expect(outcome.updatedExistingCount, 0);
      expect(await balance(), 0);
    });

    test('дубль с replace обновляет существующую и не создаёт новую',
        () async {
      await existing(id: 'e1');
      final r = row(
        index: 0,
        amount: -15000,
        categoryId: 'c2',
        comment: 'из выписки',
        bankTransactionId: 'bank-1',
      );

      final outcome = await useCase(
        importResult: result(
          rows: [r],
          duplicates: [
            DuplicateCandidate(
              id: 'd1',
              importedRow: r,
              existingTransactionId: 'e1',
              existingDate: day,
              existingAmountKopecks: 15000,
              existingMerchantName: 'Пятёрочка',
              matchScore: 1,
              selectedAction: DuplicateAction.replace,
            ),
          ],
        ),
        userId: kUserId,
        selectedRowIndices: {0},
      );

      expect(outcome!.created, isEmpty);
      expect(outcome.updatedExistingCount, 1);
      final updated = await tx('e1');
      expect(updated.customCategoryId, 'c2');
      expect(updated.comment, 'из выписки');
      expect(updated.bankTransactionId, 'bank-1');
      expect(updated.syncStatus, SyncStatus.pending);
    });

    test('дубль с both создаёт новую строку', () async {
      await existing(id: 'e1');
      final r = row(index: 0, amount: -15000);

      final outcome = await useCase(
        importResult: result(
          rows: [r],
          duplicates: [
            DuplicateCandidate(
              id: 'd1',
              importedRow: r,
              existingTransactionId: 'e1',
              existingDate: day,
              existingAmountKopecks: 15000,
              existingMerchantName: 'Пятёрочка',
              matchScore: 1,
              selectedAction: DuplicateAction.both,
            ),
          ],
        ),
        userId: kUserId,
        selectedRowIndices: {0},
      );

      expect(outcome!.created.length, 1);
      expect((await db.select(db.transactions).get()).length, 2);
    });

    test('подтверждение hold переводит операцию в verified', () async {
      await existing(id: 'h1', auditStatus: AuditStatus.pending);
      final r = row(index: 0, amount: -15000, bankTransactionId: 'bank-h');

      final outcome = await useCase(
        importResult: result(
          rows: [r],
          holds: [
            HoldConfirmationCandidate(
              id: 'hc1',
              importedRow: r,
              existingTransactionId: 'h1',
              existingDate: day,
              existingAmountKopecks: 15000,
              existingMerchantName: 'Пятёрочка',
            ),
          ],
        ),
        userId: kUserId,
        selectedRowIndices: const <int>{},
      );

      expect(outcome!.updatedExistingCount, 1);
      final confirmed = await tx('h1');
      expect(confirmed.auditStatus, AuditStatus.verified);
      expect(confirmed.bankTransactionId, 'bank-h');
    });

    test('перевод с merge создаёт transfer и исключает обе строки', () async {
      await seed.account(id: 'a2');
      final expense = row(index: 0, amount: -50000, merchant: 'Перевод');
      final income = row(index: 1, amount: 50000, merchant: 'Зачисление');

      final outcome = await useCase(
        importResult: result(
          rows: [expense, income],
          transfers: [
            TransferCandidate(
              id: 't1',
              scenario: TransferScenario.interbank,
              expenseRow: expense,
              incomeRow: income,
              amountKopecks: 50000,
              sourceAccountId: kAccountId,
              targetAccountId: 'a2',
              timeDifference: const Duration(days: 1),
            ),
          ],
        ),
        userId: kUserId,
        selectedRowIndices: {0, 1},
      );

      expect(outcome!.transfersCreatedCount, 1);
      expect(outcome.created, isEmpty);
      expect(outcome.balanceDeltaKopecks, -50000);
      final all = await db.select(db.transactions).get();
      expect(all.length, 1);
      expect(all.single.type, TransactionType.transfer);
      expect(all.single.linkedAccountId, 'a2');
    });

    test('пустой выбор ничего не создаёт и не меняет баланс', () async {
      final outcome = await useCase(
        importResult: result(rows: [row(index: 0, amount: -15000)]),
        userId: kUserId,
        selectedRowIndices: const <int>{},
      );

      expect(outcome!.created, isEmpty);
      expect(outcome.balanceDeltaKopecks, 0);
      expect(await balance(), 0);
    });
  }, skip: skip);
}
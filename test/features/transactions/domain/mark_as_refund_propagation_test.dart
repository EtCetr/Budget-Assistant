import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/transactions/data/repositories/drift_transactions_log_repository.dart';
import 'package:budget_assistant/features/transactions/domain/entities/transaction_ui_model.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/add_transaction_copies_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/mark_as_refund_usecase.dart';
import 'package:logger/logger.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: сторно propagates на копии группы (D23.8-1 / D23.8-2).
TransactionUiModel _ui(TransactionDb r) => TransactionUiModel(
      id: r.id,
      userId: r.userId,
      spaceId: r.spaceId,
      accountId: r.accountId,
      categoryId: r.customCategoryId,
      type: r.type,
      amountKopecks: r.amount,
      currencyCode: r.originalCurrency ?? 'RUB',
      date: r.date,
      merchantName: r.merchantName,
      comment: r.comment,
      receiptId: r.receiptId,
      isSplit: r.isSplit,
      auditStatus: r.auditStatus,
      syncStatus: r.syncStatus,
      categoryName: 'Продукты',
      categoryColorHex: '#9CA3AF',
      memberDisplayName: null,
      memberColorHex: null,
    );

void main() {
  final skip = sqliteSkipReason();

  group('Сторно на копии группы (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DriftTransactionsLogRepository logRepo;
    late AddTransactionCopiesUseCase addCopies;
    late MarkAsRefundUseCase markAsRefund;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      logRepo = DriftTransactionsLogRepository(db);
      addCopies = AddTransactionCopiesUseCase(
        db: db,
        logger: Logger(level: Level.off),
      );
      markAsRefund = MarkAsRefundUseCase(logRepo, db: db);
      await seed.tx(id: 'src', amountKopecks: 30000, categoryId: 'c1');
    });

    tearDown(() async {
      await db.close();
    });

    Future<List<TransactionDb>> incomes() =>
        (db.select(db.transactions)
              ..where((t) => t.type.equalsValue(TransactionType.income)))
            .get();

    test('компенсация создаётся для источника и для каждой копии', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );
      final source = await (db.select(db.transactions)
            ..where((t) => t.id.equals('src')))
          .getSingle();

      final result = await markAsRefund(_ui(source));

      expect(result, isA<Success<void>>());
      final created = await incomes();
      expect(created.length, 2);
      expect(created.every((r) => r.amount == 30000), isTrue);
      expect(created.every((r) => r.syncStatus == SyncStatus.pending), isTrue);
    });

    test('компенсации наследуют скоуп и категорию, связаны своей группой',
        () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );
      final source = await (db.select(db.transactions)
            ..where((t) => t.id.equals('src')))
          .getSingle();

      await markAsRefund(_ui(source));

      final created = await incomes();
      expect(created.map((r) => r.spaceId).toSet(), {null, 's1'});
      expect(created.every((r) => r.customCategoryId == 'c1'), isTrue);

      final gids = created.map((r) => r.copyGroupId).toSet();
      expect(gids.length, 1);
      expect(gids.single, isNotNull);
      expect(gids.single, isNot(source.copyGroupId));
    });

    test('одиночная операция: одна компенсация без группы', () async {
      final source = await (db.select(db.transactions)
            ..where((t) => t.id.equals('src')))
          .getSingle();

      final result = await markAsRefund(_ui(source));

      expect(result, isA<Success<void>>());
      final created = await incomes();
      expect(created.length, 1);
      expect(created.single.copyGroupId, isNull);
    });

    test('для дохода сторно запрещено', () async {
      await seed.tx(
        id: 'inc',
        amountKopecks: 5000,
        categoryId: 'i1',
        type: TransactionType.income,
      );
      final row = await (db.select(db.transactions)
            ..where((t) => t.id.equals('inc')))
          .getSingle();

      final result = await markAsRefund(_ui(row));

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure, isA<ValidationFailure>());
      expect((await incomes()).length, 1);
    });
  }, skip: skip);
}
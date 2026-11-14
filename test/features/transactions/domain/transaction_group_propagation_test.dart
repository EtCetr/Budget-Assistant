import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/add_transaction_copies_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/update_transaction_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

class _FakeClock implements ClockPort {
  const _FakeClock();

  @override
  Future<int> elapsedRealtimeMs() async => 1000;
}

/// Этап 24: правка и удаление применяются ко всем копиям группы.
void main() {
  final skip = sqliteSkipReason();

  group('Propagation правки и удаления (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late Logger logger;
    late TransactionsRepositoryImpl repo;
    late AddTransactionCopiesUseCase addCopies;
    late UpdateTransactionUseCase update;
    late DeleteTransactionUseCase delete;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      logger = Logger(level: Level.off);
      repo = TransactionsRepositoryImpl(db: db, logger: logger);
      addCopies = AddTransactionCopiesUseCase(db: db, logger: logger);
      update = UpdateTransactionUseCase(
        repository: repo,
        logger: logger,
        clock: const _FakeClock(),
        db: db,
      );
      delete = DeleteTransactionUseCase(
        repository: repo,
        logger: logger,
        db: db,
      );
      await seed.tx(id: 'src', amountKopecks: 30000, categoryId: 'c1');
    });

    tearDown(() async {
      await db.close();
    });

    TransactionDraft draft({
      int amount = 7777,
      List<TransactionSplitDraft>? splits,
    }) =>
        TransactionDraft(
          id: 'src',
          accountId: kAccountId,
          date: testDate(2026, 7, 20),
          amount: amount,
          type: TransactionType.expense,
          customCategoryId: 'c2',
          merchantName: 'Новый мерчант',
          comment: 'коммент',
          splits: splits,
        );

    Future<TransactionDb> copyRow() async =>
        (await db.select(db.transactions).get())
            .firstWhere((r) => r.spaceId == 's1');

    test('правка суммы и реквизитов доходит до копии', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      final result = await update(draft: draft(), userId: kUserId);
      expect(result, isA<Success<Transaction>>());

      final copy = await copyRow();
      expect(copy.amount, 7777);
      expect(copy.customCategoryId, 'c2');
      expect(copy.merchantName, 'Новый мерчант');
      expect(copy.comment, 'коммент');
      expect(copy.syncStatus, SyncStatus.pending);
      expect(
        copy.date.millisecondsSinceEpoch,
        testDate(2026, 7, 20).millisecondsSinceEpoch,
      );
    });

    test('правка со сплитами пересоздаёт сплиты копии', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      final result = await update(
        draft: draft(
          splits: const [
            TransactionSplitDraft(categoryId: 'c1', amount: 3000),
            TransactionSplitDraft(categoryId: 'c2', amount: 4777),
          ],
        ),
        userId: kUserId,
      );
      expect(result, isA<Success<Transaction>>());

      final copy = await copyRow();
      final splits = await (db.select(db.transactionSplits)
            ..where((s) => s.transactionId.equals(copy.id)))
          .get();

      expect(copy.isSplit, isTrue);
      expect(splits.length, 2);
      expect(
        {for (final s in splits) s.categoryId: s.amount},
        {'c1': 3000, 'c2': 4777},
      );
    });

    test('правка без сплитов очищает сплиты копии', () async {
      await seed.split(
        id: 'sp1',
        transactionId: 'src',
        categoryId: 'c1',
        amountKopecks: 30000,
      );
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      await update(draft: draft(amount: 5000), userId: kUserId);

      final copy = await copyRow();
      final splits = await (db.select(db.transactionSplits)
            ..where((s) => s.transactionId.equals(copy.id)))
          .get();

      expect(copy.isSplit, isFalse);
      expect(splits, isEmpty);
    });

    test('удаление убирает всю группу вместе со сплитами', () async {
      await seed.split(
        id: 'sp1',
        transactionId: 'src',
        categoryId: 'c1',
        amountKopecks: 30000,
      );
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      final result = await delete(id: 'src', userId: kUserId);

      expect(result, isA<Success<void>>());
      expect(await db.select(db.transactions).get(), isEmpty);
      expect(await db.select(db.transactionSplits).get(), isEmpty);
    });

    test('удаление чужой операции -> NotFound, группа цела', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      final result = await delete(id: 'src', userId: kOtherUserId);

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure, isA<NotFoundFailure>());
      expect((await db.select(db.transactions).get()).length, 2);
    });

    test('одиночная операция: правка не трогает соседние записи', () async {
      await seed.tx(id: 'other', amountKopecks: 1000, categoryId: 'c1');

      await update(draft: draft(), userId: kUserId);

      final other = await (db.select(db.transactions)
            ..where((t) => t.id.equals('other')))
          .getSingle();
      expect(other.amount, 1000);
      expect(other.customCategoryId, 'c1');
    });

    test('недоступная БД копий не отменяет правку (D23.6-5)', () async {
      final broken = openTestDb();
      await broken.close();
      final useCase = UpdateTransactionUseCase(
        repository: repo,
        logger: logger,
        clock: const _FakeClock(),
        db: broken,
      );

      final result = await useCase(draft: draft(), userId: kUserId);

      expect(result, isA<Success<Transaction>>());
      final src = await (db.select(db.transactions)
            ..where((t) => t.id.equals('src')))
          .getSingle();
      expect(src.amount, 7777);
    });

    test('недоступная БД копий не отменяет удаление (D23.6-5)', () async {
      final broken = openTestDb();
      await broken.close();
      final useCase = DeleteTransactionUseCase(
        repository: repo,
        logger: logger,
        db: broken,
      );

      final result = await useCase(id: 'src', userId: kUserId);

      expect(result, isA<Success<void>>());
      expect(await db.select(db.transactions).get(), isEmpty);
    });
  }, skip: skip);
}
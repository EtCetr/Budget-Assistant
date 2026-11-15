import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/cashback/data/repositories/cashback_repository_impl.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: Правило 3 (переводы) и фундаментальные фильтры P&L живут в SQL.
void main() {
  final skip = sqliteSkipReason();

  group('CashbackRepositoryImpl (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late CashbackRepositoryImpl repo;
    final start = DateTime.utc(2026, 7, 1);
    final end = DateTime.utc(2026, 8, 1);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      repo = CashbackRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> addAccount(
      String id, {
      bool isSystem = false,
      bool isArchived = false,
    }) async {
      final now = DateTime.now().toUtc();
      await db.into(db.accounts).insert(AccountsCompanion.insert(
            id: id,
            userId: kUserId,
            bankName: 'Банк',
            customName: 'Карта $id',
            accountType: 'debit',
            currency: 'RUB',
            currentBalance: 0,
            isSystem: Value(isSystem),
            isArchived: Value(isArchived),
            createdAt: now,
            updatedAt: now,
          ));
    }

    Future<List<String>> relevantIds() async {
      final rows = await repo.fetchRelevantTransactions(kAccountId, start, end);
      return rows.map((r) => r.id).toList();
    }

    test('переводы, ignored, копилки, изъятия и внe цикла исключены',
        () async {
      await seed.tx(id: 'ok', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(
        id: 'transfer',
        amountKopecks: 2000,
        categoryId: 'c1',
        type: TransactionType.transfer,
        linkedAccountId: kAccountId,
      );
      await seed.tx(
        id: 'ignored',
        amountKopecks: 3000,
        categoryId: 'c1',
        auditStatus: AuditStatus.ignored,
      );
      await seed.tx(
        id: 'goal',
        amountKopecks: 4000,
        categoryId: 'c1',
        savingsGoalId: 'g1',
      );
      await seed.tx(
        id: 'withdrawal',
        amountKopecks: 5000,
        categoryId: 'c1',
        isWithdrawal: true,
      );
      await seed.tx(
        id: 'outside',
        amountKopecks: 6000,
        categoryId: 'c1',
        date: DateTime.utc(2026, 6, 15),
      );

      expect(await relevantIds(), ['ok']);
    });

    test('доходы попадают в выборку (нужны для NET-суммы)', () async {
      await seed.tx(
        id: 'refund',
        amountKopecks: 3000,
        categoryId: 'c1',
        type: TransactionType.income,
      );

      final rows = await repo.fetchRelevantTransactions(kAccountId, start, end);

      expect(rows.single.type, TransactionType.income);
    });

    test('сплиты читаются по идентификаторам транзакций', () async {
      await seed.tx(
        id: 'spl',
        amountKopecks: 30000,
        categoryId: 'c1',
        isSplit: true,
      );
      await seed.split(
        id: 'sp1',
        transactionId: 'spl',
        categoryId: 'c1',
        amountKopecks: 10000,
      );
      await seed.split(
        id: 'sp2',
        transactionId: 'spl',
        categoryId: 'c2',
        amountKopecks: 20000,
      );

      final splits = await repo.fetchSplits(['spl']);

      expect(splits.length, 2);
      expect({for (final s in splits) s.categoryId: s.amount},
          {'c1': 10000, 'c2': 20000});
      expect(await repo.fetchSplits(const []), isEmpty);
    });

    test('мои счета: системные и архивные исключены', () async {
      await addAccount('normal');
      await addAccount('sys', isSystem: true);
      await addAccount('arch', isArchived: true);

      final accounts = await repo.getMyAccounts(kUserId);

      expect(accounts.map((a) => a.id), contains('normal'));
      expect(accounts.map((a) => a.id), isNot(contains('sys')));
      expect(accounts.map((a) => a.id), isNot(contains('arch')));
    });

    test('смена статуса возвращает запись в очередь синка', () async {
      final now = DateTime.now().toUtc();
      await db.into(db.cashbackMatrix).insert(CashbackMatrixCompanion.insert(
            id: 'e1',
            accountId: kAccountId,
            categoryId: const Value('c1'),
            categoryName: 'Продукты',
            percentBps: 500,
            expiresAt: DateTime.utc(2026, 8, 1),
            createdAt: now,
            updatedAt: now,
          ));

      await repo.updateEntryStatus('e1', 'approved');

      final row = await (db.select(db.cashbackMatrix)
            ..where((t) => t.id.equals('e1')))
          .getSingle();
      expect(row.status, 'approved');
      expect(row.syncStatus, SyncStatus.pending);
    });

    test('валюта счёта читается для конвертации', () async {
      expect(await repo.getAccountCurrency(kAccountId), 'RUB');
      expect(await repo.getAccountCurrency('missing'), isNull);
    });
  }, skip: skip);
}
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/debts/data/datasources/debts_dao.dart';
import 'package:budget_assistant/features/debts/data/repositories/debts_repository_impl.dart';
import 'package:budget_assistant/features/debts/domain/entities/debt.dart';
import '../../../helpers/fake_debts_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: DebtsRepositoryImpl на Drift in-memory.
/// Нужен полный сид: debts ссылается на users, categories и transactions.
void main() {
  final skip = sqliteSkipReason();

  group('DebtsRepositoryImpl (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DebtsRepositoryImpl repo;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await seed.user(kOtherUserId);
      repo = DebtsRepositoryImpl(
        dao: DebtsDao(db),
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> insertDebt(Debt d) async {
      await db.into(db.debts).insert(DebtsCompanion(
            id: Value(d.id),
            creditorId: Value(d.creditorId),
            debtorId: Value(d.debtorId),
            spaceId: Value(d.spaceId),
            categoryId: Value(d.categoryId),
            amount: Value(d.amount),
            currency: Value(d.currency),
            description: Value(d.description),
            counterpartyNameDative: Value(d.counterpartyNameDative),
            originalTransactionId: Value(d.originalTransactionId),
            splitId: Value(d.splitId),
            dueDate: Value(d.dueDate),
            resolvedAt: Value(d.resolvedAt),
            resolutionStatus: Value(d.resolutionStatus),
            isExMemberDebt: Value(d.isExMemberDebt),
            autoResolve: Value(d.autoResolve),
            createdBy: Value(d.createdBy),
            createdAt: Value(d.createdAt),
            updatedAt: Value(d.updatedAt),
            syncStatus: Value(d.syncStatus),
          ));
    }

    Future<DebtDb> row(String id) =>
        (db.select(db.debts)..where((t) => t.id.equals(id))).getSingle();

    test('watchForUser: долги где пользователь — должник или кредитор',
        () async {
      await insertDebt(makeDebt(
        id: 'd1',
        debtorId: kUserId,
        creditorId: kOtherUserId,
        createdBy: kUserId,
      ));
      await insertDebt(makeDebt(
        id: 'd2',
        debtorId: kOtherUserId,
        creditorId: kUserId,
        createdBy: kOtherUserId,
      ));
      await insertDebt(makeDebt(
        id: 'd3',
        debtorId: kOtherUserId,
        creditorId: kUserId,
        createdBy: kOtherUserId,
        spaceId: null,
      ));

      final debts = await repo.watchForUser(userId: kUserId).first;

      expect(debts.map((d) => d.id).toSet(), {'d1', 'd2', 'd3'});
    });

    test('getById возвращает долг с суммой в копейках', () async {
      await insertDebt(makeDebt(
        id: 'd1',
        debtorId: kUserId,
        creditorId: kOtherUserId,
        createdBy: kUserId,
        amount: 123456,
      ));

      final d = await repo.getById('d1');

      expect(d, isNotNull);
      expect(d!.amount, 123456);
    });

    test('resolve ставит статус и возвращает запись в очередь синка', () async {
      await insertDebt(makeDebt(
        id: 'd1',
        debtorId: kUserId,
        creditorId: kOtherUserId,
        createdBy: kUserId,
      ));

      await repo.resolve(debtId: 'd1', status: DebtResolutionStatus.forgiven);

      final r = await row('d1');
      expect(r.resolutionStatus, DebtResolutionStatus.forgiven);
      expect(r.syncStatus, SyncStatus.pending);
    });

    test('markExMember помечает только активные долги', () async {
      await insertDebt(makeDebt(
        id: 'd1',
        debtorId: kOtherUserId,
        creditorId: kUserId,
        createdBy: kUserId,
      ));
      await insertDebt(makeDebt(
        id: 'd2',
        debtorId: kOtherUserId,
        creditorId: kUserId,
        createdBy: kUserId,
        resolutionStatus: DebtResolutionStatus.resolved,
      ));

      final count = await repo.markExMember(memberUserId: kOtherUserId);

      expect(count, 1);
      expect((await row('d1')).isExMemberDebt, isTrue);
      expect((await row('d2')).isExMemberDebt, isFalse);
    });

    test('resolveAutoLinked закрывает только долги с auto_resolve', () async {
      // FK: debts.original_transaction_id -> transactions.id.
      await seed.tx(id: 'tx1', amountKopecks: 100000, categoryId: 'c1');

      await insertDebt(makeDebt(
        id: 'd1',
        debtorId: kUserId,
        creditorId: kOtherUserId,
        createdBy: kUserId,
        originalTransactionId: 'tx1',
      ));
      await insertDebt(makeDebt(
        id: 'd2',
        debtorId: kUserId,
        creditorId: kOtherUserId,
        createdBy: kUserId,
        originalTransactionId: 'tx1',
        autoResolve: false,
      ));

      final count = await repo.resolveAutoLinked(transactionId: 'tx1');

      expect(count, 1);
      expect((await row('d1')).resolutionStatus, DebtResolutionStatus.resolved);
      expect((await row('d2')).resolutionStatus, DebtResolutionStatus.active);
    });

    test('черновики: сохранение, чтение, удаление', () async {
      await repo.saveDraft(kUserId, makeDraft(debtId: 'd1'));

      final loaded = await repo.getFreshDraft(kUserId);
      expect(loaded, isNotNull);
      expect(loaded!.debtId, 'd1');

      await repo.deleteDraftByUser(kUserId);

      expect(await repo.getFreshDraft(kUserId), isNull);
    });

    test('getFreshDraft: черновик старше 24 часов не возвращается', () async {
      final old = DateTime.now().toUtc().subtract(const Duration(hours: 25));
      await db.into(db.debtDrafts).insert(DebtDraftsCompanion(
            id: const Value('debt_draft_u1'),
            userId: const Value(kUserId),
            debtId: const Value('d1'),
            formDataJson: const Value('{}'),
            createdAt: Value(old),
            updatedAt: Value(old),
          ));

      expect(await repo.getFreshDraft(kUserId), isNull);
    });
  }, skip: skip);
}
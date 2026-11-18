import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/receipts/data/repositories/receipts_repository_impl.dart';
import '../../../helpers/fake_receipts_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: ReceiptsRepositoryImpl на реальной БД (Drift in-memory).
/// Ключевое: привязка чека к hold-операции ЗАПРЕЩЕНА (ТЗ 6.3.23.5).
void main() {
  final skip = sqliteSkipReason();

  group('ReceiptsRepositoryImpl (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late ReceiptsRepositoryImpl repo;
    final day = DateTime.utc(2026, 7, 15, 12);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      repo = ReceiptsRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<ReceiptDb> receiptRow(String id) =>
        (db.select(db.receipts)..where((r) => r.id.equals(id))).getSingle();

    Future<int> itemsCount(String receiptId) async {
      final rows = await (db.select(db.receiptItems)
            ..where((i) => i.receiptId.equals(receiptId)))
          .get();
      return rows.length;
    }

    test('createReceipt сохраняет чек и позиции одной транзакцией', () async {
      await repo.createReceipt(
        makeReceipt(id: 'r1', receiptDate: day),
        [
          makeReceiptItem(id: 'i1', receiptId: 'r1'),
          makeReceiptItem(id: 'i2', receiptId: 'r1', originalName: 'Хлеб'),
        ],
      );

      final r = await repo.getReceiptById('r1');
      expect(r, isNotNull);
      expect(r!.totalAmount, 10000);
      expect(r.status, 'draft');
      expect(await itemsCount('r1'), 2);
    });

    test('getReceiptById: отсутствующий чек — null', () async {
      expect(await repo.getReceiptById('missing'), isNull);
    });

    test('getReceiptsByUser сортирует по дате чека убывающе', () async {
      await repo.createReceipt(
        makeReceipt(id: 'old', receiptDate: DateTime.utc(2026, 7, 1)),
        const [],
      );
      await repo.createReceipt(
        makeReceipt(id: 'new', receiptDate: DateTime.utc(2026, 7, 20)),
        const [],
      );

      final list = await repo.getReceiptsByUser(kUserId);

      expect(list.map((r) => r.id).toList(), ['new', 'old']);
    });

    test('getItemsByReceiptId возвращает позиции с копейками', () async {
      await repo.createReceipt(
        makeReceipt(id: 'r1'),
        [makeReceiptItem(id: 'i1', receiptId: 'r1', totalPrice: 7500)],
      );

      final items = await repo.getItemsByReceiptId('r1');

      expect(items.single.totalPrice, 7500);
      expect(items.single.isExcluded, isFalse);
    });

    test('updateReceipt заменяет позиции атомарно', () async {
      await repo.createReceipt(
        makeReceipt(id: 'r1'),
        [
          makeReceiptItem(id: 'i1', receiptId: 'r1'),
          makeReceiptItem(id: 'i2', receiptId: 'r1'),
        ],
      );

      await repo.updateReceipt(
        makeReceipt(id: 'r1', storeName: 'Лента', totalAmount: 5000),
        [makeReceiptItem(id: 'i3', receiptId: 'r1')],
      );

      expect((await receiptRow('r1')).storeName, 'Лента');
      expect(await itemsCount('r1'), 1);
      expect((await repo.getItemsByReceiptId('r1')).single.id, 'i3');
    });

    test('saveItems полностью заменяет набор позиций', () async {
      await repo.createReceipt(
        makeReceipt(id: 'r1'),
        [makeReceiptItem(id: 'i1', receiptId: 'r1')],
      );

      await repo.saveItems('r1', [
        makeReceiptItem(id: 'a', receiptId: 'r1'),
        makeReceiptItem(id: 'b', receiptId: 'r1'),
      ]);

      expect(await itemsCount('r1'), 2);
      expect(
        (await repo.getItemsByReceiptId('r1')).map((i) => i.id).toSet(),
        {'a', 'b'},
      );
    });

    test('saveReceipt обновляет только метаданные чека', () async {
      await repo.createReceipt(
        makeReceipt(id: 'r1'),
        [makeReceiptItem(id: 'i1', receiptId: 'r1')],
      );

      await repo.saveReceipt(
        makeReceipt(id: 'r1', status: 'confirmed', storeName: 'Магнит'),
      );

      final r = await receiptRow('r1');
      expect(r.status, 'confirmed');
      expect(r.storeName, 'Магнит');
      expect(await itemsCount('r1'), 1);
    });

    test('updateReceiptStatus меняет статус и updatedAt', () async {
      await repo.createReceipt(makeReceipt(id: 'r1'), const []);

      await repo.updateReceiptStatus('r1', 'matched');

      expect((await receiptRow('r1')).status, 'matched');
    });

    test('deleteReceipt каскадно удаляет позиции', () async {
      await repo.createReceipt(
        makeReceipt(id: 'r1'),
        [makeReceiptItem(id: 'i1', receiptId: 'r1')],
      );

      await repo.deleteReceipt('r1');

      expect(await db.select(db.receipts).get(), isEmpty);
      expect(await db.select(db.receiptItems).get(), isEmpty);
    });

    test('кандидаты матчинга: только расходы в окне ±48ч и ±5%', () async {
      await seed.tx(
        id: 'ok',
        amountKopecks: 10000,
        categoryId: 'c1',
        date: day,
      );
      await seed.tx(
        id: 'far',
        amountKopecks: 10000,
        categoryId: 'c1',
        date: day.add(const Duration(hours: 60)),
      );
      await seed.tx(
        id: 'pricey',
        amountKopecks: 20000,
        categoryId: 'c1',
        date: day,
      );

      final candidates = await repo.findMatchCandidates(
        totalKop: 10000,
        dateUtc: day,
      );

      expect(candidates.map((c) => c.id), ['ok']);
      expect(candidates.single.amountKop, 10000);
      expect(candidates.single.hasReceipt, isFalse);
    });

    test('доход не попадает в кандидаты матчинга', () async {
      await seed.tx(
        id: 'inc',
        amountKopecks: 10000,
        categoryId: 'i1',
        type: TransactionType.income,
        date: day,
      );

      expect(
        await repo.findMatchCandidates(totalKop: 10000, dateUtc: day),
        isEmpty,
      );
    });

    test('привязка ставит matched, receipt_id и pending обеим записям',
        () async {
      await seed.tx(id: 't1', amountKopecks: 10000, categoryId: 'c1');
      await repo.createReceipt(makeReceipt(id: 'r1'), const []);

      await repo.linkReceiptToTransaction(receiptId: 'r1', transactionId: 't1');

      final r = await receiptRow('r1');
      expect(r.status, 'matched');
      expect(r.transactionId, 't1');
      expect(r.syncStatus, 'pending');
      final t = await (db.select(db.transactions)
            ..where((x) => x.id.equals('t1')))
          .getSingle();
      expect(t.receiptId, 'r1');
      expect(t.syncStatus, SyncStatus.pending);
    });

    test('привязка к hold-операции запрещена', () async {
      await seed.tx(
        id: 'hold',
        amountKopecks: 10000,
        categoryId: 'c1',
        auditStatus: AuditStatus.pending,
      );
      await repo.createReceipt(makeReceipt(id: 'r1'), const []);

      await expectLater(
        repo.linkReceiptToTransaction(receiptId: 'r1', transactionId: 'hold'),
        throwsA(isA<StateError>()),
      );
      expect((await receiptRow('r1')).transactionId, isNull);
    });

    test('пустой и несуществующий id транзакции — StateError', () async {
      await repo.createReceipt(makeReceipt(id: 'r1'), const []);

      await expectLater(
        repo.linkReceiptToTransaction(receiptId: 'r1', transactionId: ''),
        throwsA(isA<StateError>()),
      );
      await expectLater(
        repo.linkReceiptToTransaction(receiptId: 'r1', transactionId: 'nope'),
        throwsA(isA<StateError>()),
      );
    });

    test('категории позиций: только расход, свои и общие', () async {
      final personal = await repo.getExpenseCategories(spaceId: null);
      final family = await repo.getExpenseCategories(spaceId: kSpaceId);

      expect(personal.map((c) => c.id), contains('c1'));
      expect(personal.map((c) => c.id), isNot(contains('i1')));
      expect(family.map((c) => c.id), contains('c1'));
    });
  }, skip: skip);
}
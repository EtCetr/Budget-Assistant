import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/receipts/data/repositories/receipts_repository_impl.dart';
import 'package:budget_assistant/features/transactions/domain/entities/split_position_draft.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: разделение чека и спам-защита предложений (ТЗ 6.3.48).
/// Черновик живёт 24 часа; применение атомарно ставит is_split и сплиты.
/// Три отказа подряд выключают автопредложение (порог ТЗ 6.3.48.8).
void main() {
  final skip = sqliteSkipReason();

  group('ReceiptsRepositoryImpl: split и спам (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late ReceiptsRepositoryImpl repo;

    const positions = [
      SplitPositionDraft(
        id: 'p1',
        name: 'Молоко',
        amount: 6000,
        categoryId: 'c1',
      ),
      SplitPositionDraft(
        id: 'p2',
        name: 'Хлеб',
        amount: 4000,
        categoryId: 'c2',
      ),
    ];

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await seed.tx(id: 't1', amountKopecks: 10000, categoryId: 'c1');
      repo = ReceiptsRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<TransactionDb> txRow() =>
        (db.select(db.transactions)..where((t) => t.id.equals('t1')))
            .getSingle();

    Future<List<TransactionSplitDb>> splitRows() =>
        (db.select(db.transactionSplits)
              ..where((s) => s.transactionId.equals('t1')))
            .get();

    group('Черновик разделения', () {
      test('сохранение и чтение сохраняют позиции', () async {
        await repo.saveSplitDraft('t1', positions);

        final loaded = await repo.getFreshSplitDraft('t1');

        expect(loaded, isNotNull);
        expect(loaded!.length, 2);
        expect(loaded.map((p) => p.id).toList(), ['p1', 'p2']);
        expect(loaded.first.amount, 6000);
        expect(loaded.first.categoryId, 'c1');
        expect(loaded.first.name, 'Молоко');
      });

      test('повторное сохранение заменяет черновик, а не плодит строки',
          () async {
        await repo.saveSplitDraft('t1', positions);
        await repo.saveSplitDraft('t1', [positions.first]);

        expect((await db.select(db.splitDrafts).get()).length, 1);
        expect((await repo.getFreshSplitDraft('t1'))!.length, 1);
      });

      test('черновика нет — null', () async {
        expect(await repo.getFreshSplitDraft('t1'), isNull);
      });

      test('черновик старше 24 часов не возвращается', () async {
        await repo.saveSplitDraft('t1', positions);
        final old = DateTime.now().toUtc().subtract(const Duration(hours: 25));
        await (db.update(db.splitDrafts)
              ..where((d) => d.transactionId.equals('t1')))
            .write(SplitDraftsCompanion(updatedAt: Value(old)));

        expect(await repo.getFreshSplitDraft('t1'), isNull);
      });

      test('битый JSON — null без исключения', () async {
        await repo.saveSplitDraft('t1', positions);
        await (db.update(db.splitDrafts)
              ..where((d) => d.transactionId.equals('t1')))
            .write(const SplitDraftsCompanion(
          positionsJson: Value('{не json'),
        ));

        expect(await repo.getFreshSplitDraft('t1'), isNull);
      });

      test('JSON не массив — null', () async {
        await repo.saveSplitDraft('t1', positions);
        await (db.update(db.splitDrafts)
              ..where((d) => d.transactionId.equals('t1')))
            .write(const SplitDraftsCompanion(
          positionsJson: Value('{"a":1}'),
        ));

        expect(await repo.getFreshSplitDraft('t1'), isNull);
      });
    });

    group('Применение разделения', () {
      test('is_split, сплиты и удаление черновика одной транзакцией',
          () async {
        await repo.saveSplitDraft('t1', positions);

        await repo.applyReceiptSplit(
          receiptId: 'r1',
          transactionId: 't1',
          actorUserId: kUserId,
          positions: positions,
        );

        final t = await txRow();
        expect(t.isSplit, isTrue);
        expect(t.syncStatus, SyncStatus.pending);

        final splits = await splitRows();
        expect(splits.length, 2);
        expect(splits.map((s) => s.amount).toList(), [6000, 4000]);
        expect(splits.every((s) => s.syncStatus == SyncStatus.pending), isTrue);
        expect(await db.select(db.splitDrafts).get(), isEmpty);
      });

      test('повторное применение заменяет сплиты без задвоения', () async {
        await repo.applyReceiptSplit(
          receiptId: 'r1',
          transactionId: 't1',
          actorUserId: kUserId,
          positions: positions,
        );
        await repo.applyReceiptSplit(
          receiptId: 'r1',
          transactionId: 't1',
          actorUserId: kUserId,
          positions: const [
            SplitPositionDraft(id: 'n1', amount: 7000, categoryId: 'c1'),
            SplitPositionDraft(id: 'n2', amount: 3000, categoryId: 'c2'),
          ],
        );

        final splits = await splitRows();
        expect(splits.length, 2);
        expect(splits.map((s) => s.id).toSet(), {'n1', 'n2'});
      });

      test('разделить может только владелец операции', () async {
        await expectLater(
          repo.applyReceiptSplit(
            receiptId: 'r1',
            transactionId: 't1',
            actorUserId: kOtherUserId,
            positions: positions,
          ),
          throwsA(isA<StateError>()),
        );
        expect((await txRow()).isSplit, isFalse);
        expect(await splitRows(), isEmpty);
      });

      test('несуществующая операция — StateError', () async {
        await expectLater(
          repo.applyReceiptSplit(
            receiptId: 'r1',
            transactionId: 'missing',
            actorUserId: kUserId,
            positions: positions,
          ),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('Спам-защита предложений', () {
      test('счётчики предложений стартуют с нуля', () async {
        final s = await repo.getReceiptOfferSettings(kUserId);

        expect(s.offerNamingCount, 0);
        expect(s.offerSplitCount, 0);
      });

      test('один отказ по именованию increments счётчик, оффер ещё включён',
          () async {
        await repo.recordNamingDecision(kUserId, accepted: false);

        final s = await repo.getReceiptOfferSettings(kUserId);
        expect(s.offerNamingCount, 1);
        expect(s.autoOfferNaming, isTrue);
      });

      test('три отказа по именованию выключают автопредложение', () async {
        for (var i = 0; i < 3; i++) {
          await repo.recordNamingDecision(kUserId, accepted: false);
        }

        final s = await repo.getReceiptOfferSettings(kUserId);
        expect(s.offerNamingCount, 3);
        expect(s.autoOfferNaming, isFalse);
      });

      test('принятие предложения сбрасывает счётчик именования', () async {
        await repo.recordNamingDecision(kUserId, accepted: false);
        await repo.recordNamingDecision(kUserId, accepted: false);
        await repo.recordNamingDecision(kUserId, accepted: true);

        final s = await repo.getReceiptOfferSettings(kUserId);
        expect(s.offerNamingCount, 0);
        expect(s.autoOfferNaming, isTrue);
      });

      test('три отказа по разделению выключают автопредложение', () async {
        for (var i = 0; i < 3; i++) {
          await repo.recordSplitDecision(kUserId, accepted: false);
        }

        final s = await repo.getReceiptOfferSettings(kUserId);
        expect(s.offerSplitCount, 3);
        expect(s.autoOfferSplit, isFalse);
      });

      test('принятие разделения сбрасывает счётчик', () async {
        await repo.recordSplitDecision(kUserId, accepted: false);
        await repo.recordSplitDecision(kUserId, accepted: true);

        final s = await repo.getReceiptOfferSettings(kUserId);
        expect(s.offerSplitCount, 0);
        expect(s.autoOfferSplit, isTrue);
      });

      test('счётчики именования и разделения независимы', () async {
        await repo.recordNamingDecision(kUserId, accepted: false);
        await repo.recordNamingDecision(kUserId, accepted: false);
        await repo.recordNamingDecision(kUserId, accepted: false);

        final s = await repo.getReceiptOfferSettings(kUserId);
        expect(s.autoOfferNaming, isFalse);
        expect(s.offerSplitCount, 0);
        expect(s.autoOfferSplit, isTrue);
      });
    });
  }, skip: skip);
}
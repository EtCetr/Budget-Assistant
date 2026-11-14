import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/add_transaction_copies_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/set_transaction_spaces_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: связанные копии операции (D23.6-2 / D23.6-3 / D23.6-4).
void main() {
  final skip = sqliteSkipReason();

  group('Группы копий операции (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late AddTransactionCopiesUseCase addCopies;
    late SetTransactionSpacesUseCase setSpaces;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await seed.space('s2');
      final logger = Logger(level: Level.off);
      addCopies = AddTransactionCopiesUseCase(db: db, logger: logger);
      setSpaces = SetTransactionSpacesUseCase(
        db: db,
        logger: logger,
        addCopies: addCopies,
      );
      await seed.tx(id: 'src', amountKopecks: 30000, categoryId: 'c1');
    });

    tearDown(() async {
      await db.close();
    });

    Future<List<TransactionDb>> allTx() => db.select(db.transactions).get();

    test('копии создаются в выбранных пространствах с общим copy_group_id',
        () async {
      final created = await addCopies(
        transactionId: 'src',
        spaceIds: ['s1', 's2'],
        userId: kUserId,
      );

      expect(created, 2);
      final rows = await allTx();
      expect(rows.length, 3);

      final src = rows.firstWhere((r) => r.id == 'src');
      expect(src.copyGroupId, isNotNull);

      final copies = rows.where((r) => r.id != 'src').toList();
      expect(copies.map((c) => c.spaceId).toSet(), {'s1', 's2'});
      for (final c in copies) {
        expect(c.copyGroupId, src.copyGroupId);
        expect(c.amount, 30000);
        expect(c.type, TransactionType.expense);
        expect(c.syncStatus, SyncStatus.pending);
        expect(c.date.millisecondsSinceEpoch, src.date.millisecondsSinceEpoch);
      }
    });

    test('повторное добавление того же пространства не плодит дубли', () async {
      final first = await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );
      final second = await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      expect(first, 1);
      expect(second, 0);
      expect((await allTx()).length, 2);
    });

    test('includePersonal создаёт личную копию семейной операции', () async {
      await seed.tx(
        id: 'fam',
        amountKopecks: 5000,
        categoryId: 'c1',
        spaceId: 's1',
      );

      final created = await addCopies(
        transactionId: 'fam',
        spaceIds: const [],
        userId: kUserId,
        includePersonal: true,
      );

      expect(created, 1);
      final rows = await allTx();
      final fam = rows.firstWhere((r) => r.id == 'fam');
      final personal = rows.firstWhere(
        (r) => r.id != 'fam' && r.copyGroupId == fam.copyGroupId,
      );
      expect(personal.spaceId, isNull);
      expect(personal.amount, 5000);
    });

    test('сплиты копируются вместе с операцией', () async {
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

      await addCopies(
        transactionId: 'spl',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      final copy = (await allTx()).firstWhere((r) => r.spaceId == 's1');
      final copySplits = await (db.select(db.transactionSplits)
            ..where((s) => s.transactionId.equals(copy.id)))
          .get();

      expect(copy.isSplit, isTrue);
      expect(copySplits.length, 2);
      expect(
        {for (final s in copySplits) s.categoryId: s.amount},
        {'c1': 10000, 'c2': 20000},
      );
      expect(copySplits.every((s) => s.id != 'sp1' && s.id != 'sp2'), isTrue);
    });

    test('пустой состав группы запрещён', () async {
      await expectLater(
        setSpaces(
          transactionId: 'src',
          personal: false,
          spaceIds: <String>{},
          userId: kUserId,
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect((await allTx()).length, 1);
    });

    test('через шит можно добавить пространство', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      await setSpaces(
        transactionId: 'src',
        personal: true,
        spaceIds: {'s1', 's2'},
        userId: kUserId,
      );

      final rows = await allTx();
      expect(rows.length, 3);
      expect(
        rows.where((r) => r.spaceId != null).map((r) => r.spaceId).toSet(),
        {'s1', 's2'},
      );
    });

    test('убранное пространство удаляется вместе со сплитами копии', () async {
      await seed.split(
        id: 'sp1',
        transactionId: 'src',
        categoryId: 'c1',
        amountKopecks: 30000,
      );
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1', 's2'],
        userId: kUserId,
      );

      await setSpaces(
        transactionId: 'src',
        personal: true,
        spaceIds: {'s1'},
        userId: kUserId,
      );

      final rows = await allTx();
      expect(rows.length, 2);
      expect(rows.any((r) => r.spaceId == 's2'), isFalse);

      final ids = rows.map((r) => r.id).toSet();
      final splits = await db.select(db.transactionSplits).get();
      expect(splits.every((s) => ids.contains(s.transactionId)), isTrue);
    });

    test('убрали личную копию: осталась одна — copy_group_id обнулён', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      await setSpaces(
        transactionId: 'src',
        personal: false,
        spaceIds: {'s1'},
        userId: kUserId,
      );

      final rows = await allTx();
      expect(rows.length, 1);
      expect(rows.single.spaceId, 's1');
      expect(rows.single.copyGroupId, isNull);
    });

    test('убрали семью: осталась личная — copy_group_id обнулён', () async {
      await addCopies(
        transactionId: 'src',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      await setSpaces(
        transactionId: 'src',
        personal: true,
        spaceIds: <String>{},
        userId: kUserId,
      );

      final rows = await allTx();
      expect(rows.length, 1);
      expect(rows.single.id, 'src');
      expect(rows.single.copyGroupId, isNull);
    });

    test('несуществующая операция: шит ничего не меняет', () async {
      await setSpaces(
        transactionId: 'missing',
        personal: true,
        spaceIds: {'s1'},
        userId: kUserId,
      );

      expect((await allTx()).length, 1);
    });

    test('несуществующая операция: копии не создаются', () async {
      final created = await addCopies(
        transactionId: 'missing',
        spaceIds: ['s1'],
        userId: kUserId,
      );

      expect(created, 0);
      expect((await allTx()).length, 1);
    });

    test('пустой список без includePersonal — no-op', () async {
      final created = await addCopies(
        transactionId: 'src',
        spaceIds: const [],
        userId: kUserId,
      );

      expect(created, 0);
      final rows = await allTx();
      expect(rows.length, 1);
      expect(rows.single.copyGroupId, isNull);
    });
  }, skip: skip);
}
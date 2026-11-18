import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/receipts/data/datasources/product_aliases_dao.dart';
import 'package:budget_assistant/features/receipts/data/repositories/product_aliases_repository_impl.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/hash_product_name_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/product_aliases_settings_usecases.dart';
import '../../../helpers/fake_product_aliases_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: настройки алиасов товаров (ТЗ 6.3.38.6).
/// Область «Я» = space_id IS NULL, «Семья» = текущее пространство (D20-6).
void main() {
  final skip = sqliteSkipReason();

  group('Настройки алиасов (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late ProductAliasesDao dao;
    late ProductAliasesRepositoryImpl repo;
    late String hash;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      dao = ProductAliasesDao(db);
      repo = ProductAliasesRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
      hash = HashProductNameUseCase()('Молоко');
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> addAlias({
      required String id,
      String? spaceId,
      int usageCount = 1,
      String name = 'молоко',
    }) =>
        repo.createAlias(makeAlias(
          id: id,
          hash: hash,
          spaceId: spaceId,
          usageCount: usageCount,
          normalizedName: name,
        ));

    test('область «Я» берёт только алиасы без пространства', () async {
      await addAlias(id: 'mine');
      await addAlias(id: 'family', spaceId: kSpaceId);

      final rows = await dao
          .watchByUserFiltered(userId: kUserId, mode: 'mine')
          .first;

      expect(rows.map((r) => r.id).toList(), ['mine']);
    });

    test('область «Семья» берёт алиасы текущего пространства', () async {
      await addAlias(id: 'mine');
      await addAlias(id: 'family', spaceId: kSpaceId);

      final rows = await dao
          .watchByUserFiltered(
            userId: kUserId,
            mode: 'family',
            spaceId: kSpaceId,
          )
          .first;

      expect(rows.map((r) => r.id).toList(), ['family']);
    });

    test('область «Семья» без активного пространства — пусто', () async {
      await addAlias(id: 'mine');
      await addAlias(id: 'family', spaceId: kSpaceId);

      final rows = await dao
          .watchByUserFiltered(userId: kUserId, mode: 'family')
          .first;

      expect(rows, isEmpty);
    });

    test('режим «все» берёт личные и семейные, сортировка по использованию',
        () async {
      await addAlias(id: 'low', usageCount: 1);
      await addAlias(id: 'high', spaceId: kSpaceId, usageCount: 9);

      final rows = await dao
          .watchByUserFiltered(userId: kUserId, mode: 'all')
          .first;

      expect(rows.map((r) => r.id).toList(), ['high', 'low']);
    });

    test('чужие алиасы не попадают в список', () async {
      await addAlias(id: 'mine');
      await seed.user(kOtherUserId);
      await repo.createAlias(makeAlias(
        id: 'other',
        hash: hash,
        userId: kOtherUserId,
      ));

      final rows = await dao
          .watchByUserFiltered(userId: kUserId, mode: 'all')
          .first;

      expect(rows.map((r) => r.id).toList(), ['mine']);
    });

    test('updateFields меняет имя и категорию, возвращает в очередь синка',
        () async {
      await addAlias(id: 'a1');

      await dao.updateFields('a1', 'молоко 3.2%', 'c2');

      final row = await dao.findByHash(hash: hash, currentSpaceId: '');
      expect(row!.normalizedName, 'молоко 3.2%');
      expect(row.categoryId, 'c2');
      expect(row.syncStatus, 'pending');
    });

    test('UseCase правки обновляет алиас', () async {
      await addAlias(id: 'a1');
      final useCase = UpdateProductAliasUseCase(db: db);

      await useCase(
        id: 'a1',
        normalizedName: '  сыр  ',
        categoryId: 'c2',
      );

      final row = await dao.findByHash(hash: hash, currentSpaceId: '');
      expect(row!.normalizedName, 'сыр');
      expect(row.categoryId, 'c2');
    });

    test('UseCase правки отклоняет пустое название', () async {
      await addAlias(id: 'a1');
      final useCase = UpdateProductAliasUseCase(db: db);

      await expectLater(
        useCase(id: 'a1', normalizedName: '   ', categoryId: 'c2'),
        throwsA(isA<StateError>()),
      );
      final row = await dao.findByHash(hash: hash, currentSpaceId: '');
      expect(row!.normalizedName, 'молоко');
    });

    test('UseCase удаления удаляет алиас', () async {
      await addAlias(id: 'a1');
      final useCase = DeleteProductAliasUseCase(db: db);

      await useCase('a1');

      expect(await dao.findByHash(hash: hash, currentSpaceId: ''), isNull);
    });
  }, skip: skip);
}
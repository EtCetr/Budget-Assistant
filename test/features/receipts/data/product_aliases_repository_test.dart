import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/receipts/data/repositories/product_aliases_repository_impl.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/hash_product_name_usecase.dart';
import '../../../helpers/fake_product_aliases_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: ProductAliasesRepositoryImpl на реальной БД.
/// findByHash: space_id = currentSpaceId ИЛИ space_id IS NULL (D20-6).
void main() {
  final skip = sqliteSkipReason();

  group('ProductAliasesRepositoryImpl (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late ProductAliasesRepositoryImpl repo;
    late String hash;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      repo = ProductAliasesRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
      hash = HashProductNameUseCase()('Молоко');
    });

    tearDown(() async {
      await db.close();
    });

    test('создание и поиск по хэшу', () async {
      await repo.createAlias(makeAlias(id: 'a1', hash: hash));

      final found = await repo.findByHash(hash: hash, currentSpaceId: '');

      expect(found, isNotNull);
      expect(found!.id, 'a1');
      expect(found.normalizedName, 'молоко');
      expect(found.usageCount, 1);
    });

    test('семейный алиас находится в своём пространстве', () async {
      await repo.createAlias(
        makeAlias(id: 'a1', hash: hash, spaceId: kSpaceId),
      );

      final found =
          await repo.findByHash(hash: hash, currentSpaceId: kSpaceId);

      expect(found?.id, 'a1');
    });

    test('глобальный алиас (NULL) находится в любом пространстве', () async {
      await repo.createAlias(makeAlias(id: 'a1', hash: hash));

      final found =
          await repo.findByHash(hash: hash, currentSpaceId: kSpaceId);

      expect(found?.id, 'a1');
    });

    test('алиас чужого пространства не находится', () async {
      await seed.space('s2');
      await repo.createAlias(makeAlias(id: 'a1', hash: hash, spaceId: 's2'));

      final found =
          await repo.findByHash(hash: hash, currentSpaceId: kSpaceId);

      expect(found, isNull);
    });

    test('incrementUsageCount увеличивает счётчик на 1', () async {
      await repo.createAlias(makeAlias(id: 'a1', hash: hash, usageCount: 4));

      await repo.incrementUsageCount('a1');

      final found = await repo.findByHash(hash: hash, currentSpaceId: '');
      expect(found!.usageCount, 5);
    });

    test('updateAlias меняет имя и категорию', () async {
      await repo.createAlias(makeAlias(id: 'a1', hash: hash));

      final existing = await repo.findByHash(hash: hash, currentSpaceId: '');
      await repo.updateAlias(
        existing!.copyWith(normalizedName: 'молоко 3.2%', categoryId: 'c2'),
      );

      final updated = await repo.findByHash(hash: hash, currentSpaceId: '');
      expect(updated!.normalizedName, 'молоко 3.2%');
      expect(updated.categoryId, 'c2');
    });

    test('deleteAlias удаляет запись', () async {
      await repo.createAlias(makeAlias(id: 'a1', hash: hash));

      await repo.deleteAlias('a1');

      expect(await repo.findByHash(hash: hash, currentSpaceId: ''), isNull);
    });
  }, skip: skip);
}
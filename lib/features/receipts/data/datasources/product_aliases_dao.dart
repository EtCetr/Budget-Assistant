import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'product_aliases_dao.g.dart';

@DriftAccessor(tables: [ProductAliases])
class ProductAliasesDao extends DatabaseAccessor<AppDatabase> with _$ProductAliasesDaoMixin {
  ProductAliasesDao(super.db);

  Future<void> insert(ProductAliasesCompanion alias) async {
    await into(productAliases).insert(alias);
  }

  Future<void> updateAlias(ProductAliasDb alias) async {
    await (update(productAliases)..where((a) => a.id.equals(alias.id))).write(alias.toCompanion(false));
  }

  Future<void> deleteById(String id) async {
    await (delete(productAliases)..where((a) => a.id.equals(id))).go();
  }

  Future<ProductAliasDb?> findByHash({
    required String hash,
    required String currentSpaceId,
  }) async {
    return await (select(productAliases)
      ..where((a) =>
          a.originalNameHash.equals(hash) &
          (a.spaceId.equals(currentSpaceId) | a.spaceId.isNull())))
        .getSingleOrNull();
  }

  Future<void> incrementUsageCount(String id) async {
    final alias = await (select(productAliases)..where((a) => a.id.equals(id))).getSingle();
    await updateAlias(alias.copyWith(usageCount: alias.usageCount + 1));
  }

  /// Этап 21 (6.3.38.6): список алиасов пользователя с фильтром области.
  Stream<List<ProductAliasDb>> watchByUserFiltered({
    required String userId,
    required String mode,
    String? spaceId,
  }) {
    final q = select(productAliases)
      ..where((a) => a.userId.equals(userId));
    if (mode == 'mine') {
      q.where((a) => a.spaceId.isNull());
    } else if (mode == 'family') {
      if (spaceId == null) {
        q.where((a) => a.id.equals(''));
      } else {
        q.where((a) => a.spaceId.equals(spaceId));
      }
    }
    q.orderBy([(a) => OrderingTerm.desc(a.usageCount)]);
    return q.watch();
  }

  Future<int> updateFields(
    String id,
    String normalizedName,
    String categoryId,
  ) {
    return (update(productAliases)..where((a) => a.id.equals(id))).write(
      ProductAliasesCompanion(
        normalizedName: Value(normalizedName),
        categoryId: Value(categoryId),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value('pending'),
      ),
    );
  }
}
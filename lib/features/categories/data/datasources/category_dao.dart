// lib/features/categories/data/datasources/category_dao.dart
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/category_model.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  // ✅ НОВЫЙ МЕТОД: Stream для автообновления UI
  Stream<List<CategoryModel>> watchCategoriesByUserId(String userId) {
    final query = select(categories)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.type, mode: OrderingMode.asc),
                 (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]);
    
    return query.watch().map((results) => results
        .map((row) => CategoryModel(
              id: row.id,
              spaceId: row.spaceId,
              userId: row.userId,
              parentId: row.parentId,
              name: row.name,
              type: row.type,
              iconEmoji: row.iconEmoji,
              colorHex: row.colorHex,
              isPinnedForCashback: row.isPinnedForCashback,
              isSystem: row.isSystem,
              sortOrder: row.sortOrder,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              syncStatus: row.syncStatus,
            ))
        .toList());
  }

  Future<List<CategoryModel>> getCategoriesByUserId(String userId) async {
    try {
      final query = select(categories)..where((t) => t.userId.equals(userId));
      final results = await query.get();

      return results
          .map(
            (row) => CategoryModel(
              id: row.id,
              spaceId: row.spaceId,
              userId: row.userId,
              parentId: row.parentId,
              name: row.name,
              type: row.type,
              iconEmoji: row.iconEmoji,
              colorHex: row.colorHex,
              isPinnedForCashback: row.isPinnedForCashback,
              isSystem: row.isSystem,
              sortOrder: row.sortOrder,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              syncStatus: row.syncStatus,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  Future<void> insertCategory(CategoryModel category) async {
    try {
      await into(categories).insert(
        CategoriesCompanion(
          id: Value(category.id),
          spaceId: Value(category.spaceId),
          userId: Value(category.userId),
          parentId: Value(category.parentId),
          name: Value(category.name),
          type: Value(category.type),
          iconEmoji: Value(category.iconEmoji),
          colorHex: Value(category.colorHex),
          isPinnedForCashback: Value(category.isPinnedForCashback),
          isSystem: Value(category.isSystem),
          sortOrder: Value(category.sortOrder),
          createdAt: Value(category.createdAt),
          updatedAt: Value(category.updatedAt),
          syncStatus: Value(category.syncStatus),
        ),
      );
    } catch (e) {
      throw Exception('Failed to insert category: $e');
    }
  }

  Future<List<CategoryModel>> getCategoriesByParentId(String? parentId) async {
    try {
      final query = select(categories);

      if (parentId == null) {
        query.where((t) => t.parentId.isNull());
      } else {
        query.where((t) => t.parentId.equals(parentId));
      }

      final results = await query.get();

      return results
          .map(
            (row) => CategoryModel(
              id: row.id,
              spaceId: row.spaceId,
              userId: row.userId,
              parentId: row.parentId,
              name: row.name,
              type: row.type,
              iconEmoji: row.iconEmoji,
              colorHex: row.colorHex,
              isPinnedForCashback: row.isPinnedForCashback,
              isSystem: row.isSystem,
              sortOrder: row.sortOrder,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              syncStatus: row.syncStatus,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get categories by parent: $e');
    }
  }

    /// Обновление категории: updatedAt + возврат в очередь sync
  Future<void> updateCategoryFields({
    required String categoryId,
    required String name,
    required String type,
    required String? parentId,
    required String? iconEmoji,
    required String? colorHex,
    required DateTime updatedAt,
  }) async {
    try {
      await (update(categories)..where((t) => t.id.equals(categoryId))).write(
        CategoriesCompanion(
          name: Value(name),
          type: Value(type),
          parentId: Value(parentId),
          iconEmoji: Value(iconEmoji),
          colorHex: Value(colorHex),
          updatedAt: Value(updatedAt),
          syncStatus: const Value('pending'),
        ),
      );
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  /// Удаление категории со сплайсом детей на её родителя (в транзакции)
  Future<void> deleteCategory(String categoryId) async {
    try {
      await transaction(() async {
        final row = await (select(categories)
              ..where((t) => t.id.equals(categoryId)))
            .getSingleOrNull();
        if (row == null) return;

        await (update(categories)..where((t) => t.parentId.equals(categoryId)))
            .write(CategoriesCompanion(parentId: Value(row.parentId)));

        await (delete(categories)..where((t) => t.id.equals(categoryId))).go();
      });
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}

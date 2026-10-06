import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/receipts/domain/entities/product_alias.dart';
import 'package:budget_assistant/features/receipts/domain/repositories/product_aliases_repository.dart';

class ProductAliasesRepositoryImpl implements ProductAliasesRepository {
  final AppDatabase _db;
  final Logger _logger;

  ProductAliasesRepositoryImpl({required AppDatabase db, required Logger logger})
      : _db = db,
        _logger = logger;

  @override
  Future<void> createAlias(ProductAlias alias) async {
    try {
      await _db.into(_db.productAliases).insert(_toCompanion(alias));
    } catch (e, stack) {
      _logger.e('Failed to create product alias', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> updateAlias(ProductAlias alias) async {
    try {
      await (_db.update(_db.productAliases)..where((a) => a.id.equals(alias.id)))
          .write(_toCompanion(alias));
    } catch (e, stack) {
      _logger.e('Failed to update product alias', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteAlias(String id) async {
    try {
      await (_db.delete(_db.productAliases)..where((a) => a.id.equals(id))).go();
    } catch (e, stack) {
      _logger.e('Failed to delete product alias', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<ProductAlias?> findByHash({required String hash, required String currentSpaceId}) async {
    try {
      final row = await (_db.select(_db.productAliases)
        ..where((a) =>
            a.originalNameHash.equals(hash) &
            (a.spaceId.equals(currentSpaceId) | a.spaceId.isNull())))
          .getSingleOrNull();
      return row == null ? null : _fromDb(row);
    } catch (e, stack) {
      _logger.e('Failed to find product alias', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> incrementUsageCount(String id) async {
    try {
      final alias = await (_db.select(_db.productAliases)..where((a) => a.id.equals(id))).getSingle();
      await updateAlias(_fromDb(alias).copyWith(usageCount: alias.usageCount + 1));
    } catch (e, stack) {
      _logger.e('Failed to increment usage count', error: e, stackTrace: stack);
      rethrow;
    }
  }

  ProductAliasesCompanion _toCompanion(ProductAlias a) {
    return ProductAliasesCompanion(
      id: Value(a.id),
      userId: Value(a.userId),
      spaceId: Value(a.spaceId),
      originalNameHash: Value(a.originalNameHash),
      normalizedName: Value(a.normalizedName),
      categoryId: Value(a.categoryId),
      usageCount: Value(a.usageCount),
      createdAt: Value(a.createdAt),
      updatedAt: Value(a.updatedAt),
      syncStatus: Value(a.syncStatus.name),
    );
  }

  ProductAlias _fromDb(ProductAliasDb db) {
    return ProductAlias(
      id: db.id,
      userId: db.userId,
      spaceId: db.spaceId,
      originalNameHash: db.originalNameHash,
      normalizedName: db.normalizedName,
      categoryId: db.categoryId,
      usageCount: db.usageCount,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: _parseSyncStatus(db.syncStatus),
    );
  }

  SyncStatus _parseSyncStatus(String status) {
    return SyncStatus.values.firstWhere(
      (s) => s.name == status,
      orElse: () => SyncStatus.pending,
    );
  }
}
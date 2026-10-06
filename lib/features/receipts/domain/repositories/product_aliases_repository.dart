import '../entities/product_alias.dart';

abstract class ProductAliasesRepository {
  Future<void> createAlias(ProductAlias alias);
  Future<void> updateAlias(ProductAlias alias);
  Future<void> deleteAlias(String id);
  Future<ProductAlias?> findByHash({required String hash, required String currentSpaceId});
  Future<void> incrementUsageCount(String id);
}
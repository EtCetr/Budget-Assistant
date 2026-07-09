// lib/features/categories/domain/repositories/category_repository.dart
import '../entities/category.dart';
import '../entities/category_rule.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategoriesByUserId(String userId);
  Future<void> insertCategory(Category category);
  Future<List<Category>> getCategoriesByParentId(String? parentId);
  Future<List<CategoryRule>> getRulesByBankAndSpace(
    String bankName,
    String? spaceId,
  );
  Future<void> insertRule(CategoryRule rule);
}

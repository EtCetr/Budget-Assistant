import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/categories/domain/entities/category.dart';
import 'package:budget_assistant/features/categories/domain/entities/category_rule.dart';
import 'package:budget_assistant/features/categories/domain/repositories/category_repository.dart';

/// Этап 24: заглушка репозитория категорий для доменных тестов.
/// Сигнатуры повторяют порт: parentId nullable, правила банка — позиционные.
class FakeCategoryRepository implements CategoryRepository {
  final Map<String, Category> categories = <String, Category>{};
  final List<CategoryRule> rules = <CategoryRule>[];

  /// Если задано — каждый метод бросает эту ошибку.
  Object? error;

  /// Готовые ошибки без throw — для проверки проброса Result.
  Failure? updateFailure;
  Failure? deleteFailure;

  final List<String> calls = <String>[];
  String? lastBankName;
  String? lastSpaceId;

  ({
    String categoryId,
    String name,
    String type,
    String? parentId,
    String? iconEmoji,
    String? colorHex,
  })? lastUpdate;

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<List<Category>> getCategoriesByUserId(String userId) async {
    _enter('getCategoriesByUserId');
    return categories.values.where((c) => c.userId == userId).toList();
  }

  @override
  Future<void> insertCategory(Category category) async {
    _enter('insertCategory');
    categories[category.id] = category;
  }

  @override
  Future<List<Category>> getCategoriesByParentId(String? parentId) async {
    _enter('getCategoriesByParentId');
    return categories.values.where((c) => c.parentId == parentId).toList();
  }

  @override
  Future<List<CategoryRule>> getRulesByBankAndSpace(
    String bankName,
    String? spaceId,
  ) async {
    _enter('getRulesByBankAndSpace');
    lastBankName = bankName;
    lastSpaceId = spaceId;
    return rules;
  }

  @override
  Future<void> insertRule(CategoryRule rule) async {
    _enter('insertRule');
    rules.add(rule);
  }

  @override
  Future<Result<void>> updateCategory({
    required String categoryId,
    required String name,
    required String type,
    String? parentId,
    String? iconEmoji,
    String? colorHex,
  }) async {
    _enter('updateCategory');
    lastUpdate = (
      categoryId: categoryId,
      name: name,
      type: type,
      parentId: parentId,
      iconEmoji: iconEmoji,
      colorHex: colorHex,
    );
    final f = updateFailure;
    if (f != null) return Result.failure(f);
    return Result.success(null);
  }

  @override
  Future<Result<void>> deleteCategory(String categoryId) async {
    _enter('deleteCategory');
    final f = deleteFailure;
    if (f != null) return Result.failure(f);
    categories.remove(categoryId);
    return Result.success(null);
  }
}

/// Фабрика категории для тестов (даты UTC).
Category makeCategory({
  required String id,
  String name = 'Продукты',
  String type = 'expense',
  String? parentId,
  String userId = 'u1',
}) =>
    Category(
      id: id,
      userId: userId,
      name: name,
      type: type,
      parentId: parentId,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

/// Фабрика правила автокатегоризации.
CategoryRule makeRule({
  required String id,
  String bankName = 'Т-Банк',
  String triggerString = 'перекрёсток',
  String targetCategoryId = 'c1',
  String? spaceId,
}) =>
    CategoryRule(
      id: id,
      userId: 'u1',
      spaceId: spaceId,
      bankName: bankName,
      triggerString: triggerString,
      targetCategoryId: targetCategoryId,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
// lib/features/categories/data/repositories/category_repository_impl.dart
import '../../domain/entities/category.dart';
import '../../domain/entities/category_rule.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_dao.dart';
import '../datasources/category_rule_dao.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDao _categoryDao;
  final CategoryRuleDao _ruleDao;
  final Logger _logger;

  CategoryRepositoryImpl({
    required CategoryDao categoryDao,
    required CategoryRuleDao ruleDao,
    required Logger logger,
  }) : _categoryDao = categoryDao,
       _ruleDao = ruleDao,
       _logger = logger;

  @override
  Future<List<Category>> getCategoriesByUserId(String userId) async {
    try {
      final models = await _categoryDao.getCategoriesByUserId(userId);
      return models.map((m) => Category.fromModel(m)).toList();
    } catch (e, stackTrace) {
      _logger.e(
        'CategoryRepository.getCategoriesByUserId',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> insertCategory(Category category) async {
    try {
      final model = category.toModel();
      await _categoryDao.insertCategory(model);
    } catch (e, stackTrace) {
      _logger.e(
        'CategoryRepository.insertCategory',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategoriesByParentId(String? parentId) async {
    try {
      final models = await _categoryDao.getCategoriesByParentId(parentId);
      return models.map((m) => Category.fromModel(m)).toList();
    } catch (e, stackTrace) {
      _logger.e(
        'CategoryRepository.getCategoriesByParentId',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<CategoryRule>> getRulesByBankAndSpace(
    String bankName,
    String? spaceId,
  ) async {
    try {
      final models = await _ruleDao.getRulesByBankAndSpace(bankName, spaceId);
      return models.map((m) => CategoryRule.fromModel(m)).toList();
    } catch (e, stackTrace) {
      _logger.e(
        'CategoryRepository.getRulesByBankAndSpace',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> insertRule(CategoryRule rule) async {
    try {
      final model = rule.toModel();
      await _ruleDao.insertRule(model);
    } catch (e, stackTrace) {
      _logger.e(
        'CategoryRepository.insertRule',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
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
    try {
      await _categoryDao.updateCategoryFields(
        categoryId: categoryId,
        name: name,
        type: type,
        parentId: parentId,
        iconEmoji: iconEmoji,
        colorHex: colorHex,
        updatedAt: DateTime.now().toUtc(),
      );
      _logger.i('Category updated: $categoryId');
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.e('CategoryRepository.updateCategory', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }

  @override
  Future<Result<void>> deleteCategory(String categoryId) async {
    try {
      await _categoryDao.deleteCategory(categoryId);
      _logger.i('Category deleted (with children re-parented): $categoryId');
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.e('CategoryRepository.deleteCategory', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}

// lib/features/categories/presentation/providers/category_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/providers/util_providers.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/category_rule.dart';
import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/auto_categorize_transaction_usecase.dart';
import '../../domain/repositories/category_repository.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/datasources/category_dao.dart';
import '../../data/datasources/category_rule_dao.dart';

part 'category_providers.g.dart';

@riverpod
CategoryDao categoryDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryDao(db);
}

@riverpod
CategoryRuleDao categoryRuleDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryRuleDao(db);
}

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(
    categoryDao: ref.watch(categoryDaoProvider),
    ruleDao: ref.watch(categoryRuleDaoProvider),
    logger: ref.watch(loggerProvider),
  );
}

@riverpod
CreateCategoryUseCase createCategoryUseCase(Ref ref) {
  return CreateCategoryUseCase(
    repository: ref.watch(categoryRepositoryProvider),
    logger: ref.watch(loggerProvider),
    uuid: ref.watch(uuidProvider),
  );
}

@riverpod
AutoCategorizeTransactionUseCase autoCategorizeTransactionUseCase(Ref ref) {
  return AutoCategorizeTransactionUseCase(
    repository: ref.watch(categoryRepositoryProvider),
    logger: ref.watch(loggerProvider),
    uuid: ref.watch(uuidProvider),
  );
}

@riverpod
Future<List<Category>> categoriesList(Ref ref, String userId) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getCategoriesByUserId(userId);
}

@riverpod
Future<List<Category>> rootCategories(Ref ref, String userId) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getCategoriesByParentId(null);
}

@riverpod
Future<List<Category>> childCategories(Ref ref, String parentId) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getCategoriesByParentId(parentId);
}

@riverpod
Future<List<CategoryRule>> categoryRulesByBank(
  Ref ref,
  String bankName,
  String? spaceId,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getRulesByBankAndSpace(bankName, spaceId);
}

@riverpod
Future<Map<String, List<Category>>> categoriesGroupedByType(
  Ref ref,
  String userId,
) async {
  final categories = await ref.watch(categoriesListProvider(userId).future);

  final grouped = <String, List<Category>>{
    'expense': [],
    'income': [],
    'transfer': [],
  };

  for (final category in categories) {
    grouped.putIfAbsent(category.type, () => []).add(category);
  }

  for (final type in grouped.keys) {
    grouped[type]!.sort((a, b) {
      if (a.sortOrder != null && b.sortOrder != null) {
        return a.sortOrder!.compareTo(b.sortOrder!);
      }
      return a.name.compareTo(b.name);
    });
  }

  return grouped;
}

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
import '../../domain/usecases/update_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';

part 'category_providers.g.dart';

@riverpod
class CategoryDaoNotifier extends _$CategoryDaoNotifier {
  @override
  CategoryDao build() {
    final db = ref.watch(appDatabaseProvider);
    return CategoryDao(db);
  }
}

@riverpod
class CategoryRuleDaoNotifier extends _$CategoryRuleDaoNotifier {
  @override
  CategoryRuleDao build() {
    final db = ref.watch(appDatabaseProvider);
    return CategoryRuleDao(db);
  }
}

@riverpod
class CategoryRepositoryNotifier extends _$CategoryRepositoryNotifier {
  @override
  CategoryRepository build() {
    return CategoryRepositoryImpl(
      categoryDao: ref.watch(categoryDaoProvider),
      ruleDao: ref.watch(categoryRuleDaoProvider),
      logger: ref.watch(loggerProvider),
    );
  }
}

@riverpod
class CreateCategoryUseCaseNotifier extends _$CreateCategoryUseCaseNotifier {
  @override
  CreateCategoryUseCase build() {
    return CreateCategoryUseCase(
      repository: ref.watch(categoryRepositoryProvider),
      logger: ref.watch(loggerProvider),
      uuid: ref.watch(uuidProvider),
    );
  }
}

@riverpod
class AutoCategorizeTransactionUseCaseNotifier
    extends _$AutoCategorizeTransactionUseCaseNotifier {
  @override
  AutoCategorizeTransactionUseCase build() {
    return AutoCategorizeTransactionUseCase(
      repository: ref.watch(categoryRepositoryProvider),
      logger: ref.watch(loggerProvider),
      uuid: ref.watch(uuidProvider),
    );
  }
}

@riverpod
class CategoriesListNotifier extends _$CategoriesListNotifier {
  @override
  Future<List<Category>> build(String userId) async {
    final repository = ref.watch(categoryRepositoryProvider);
    return await repository.getCategoriesByUserId(userId);
  }
}

@riverpod
class RootCategoriesNotifier extends _$RootCategoriesNotifier {
  @override
  Future<List<Category>> build(String userId) async {
    final repository = ref.watch(categoryRepositoryProvider);
    return await repository.getCategoriesByParentId(null);
  }
}

@riverpod
class ChildCategoriesNotifier extends _$ChildCategoriesNotifier {
  @override
  Future<List<Category>> build(String parentId) async {
    final repository = ref.watch(categoryRepositoryProvider);
    return await repository.getCategoriesByParentId(parentId);
  }
}

@riverpod
class CategoryRulesByBankNotifier extends _$CategoryRulesByBankNotifier {
  @override
  Future<List<CategoryRule>> build(String bankName, String? spaceId) async {
    final repository = ref.watch(categoryRepositoryProvider);
    return await repository.getRulesByBankAndSpace(bankName, spaceId);
  }
}

@riverpod
class CategoriesGroupedByTypeNotifier
    extends _$CategoriesGroupedByTypeNotifier {
  @override
  Future<Map<String, List<Category>>> build(String userId) async {
    final categories = await ref.watch(categoriesListProvider(userId).future);

    final grouped = <String, List<Category>>{
      'expense': [],
      'income': [],
      'transfer': [],
    };

    for (final category in categories) {
      grouped.putIfAbsent(category.type, () => []).add(category);
    }

    for (final entry in grouped.entries) {
      entry.value.sort((a, b) {
        if (a.sortOrder != null && b.sortOrder != null) {
          return a.sortOrder!.compareTo(b.sortOrder!);
        }
        return a.name.compareTo(b.name);
      });
    }

    return grouped;
  }
}

@riverpod
class UpdateCategoryUseCaseNotifier extends _$UpdateCategoryUseCaseNotifier {
  @override
  UpdateCategoryUseCase build() {
    return UpdateCategoryUseCase(
      repository: ref.watch(categoryRepositoryProvider),
      logger: ref.watch(loggerProvider),
    );
  }
}

@riverpod
class DeleteCategoryUseCaseNotifier extends _$DeleteCategoryUseCaseNotifier {
  @override
  DeleteCategoryUseCase build() {
    return DeleteCategoryUseCase(
      repository: ref.watch(categoryRepositoryProvider),
      logger: ref.watch(loggerProvider),
    );
  }
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryDao)
final categoryDaoProvider = CategoryDaoProvider._();

final class CategoryDaoProvider
    extends $FunctionalProvider<CategoryDao, CategoryDao, CategoryDao>
    with $Provider<CategoryDao> {
  CategoryDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryDaoHash();

  @$internal
  @override
  $ProviderElement<CategoryDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoryDao create(Ref ref) {
    return categoryDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryDao>(value),
    );
  }
}

String _$categoryDaoHash() => r'18f9327b1de0cf114a1d95c297638bab8cb09ffa';

@ProviderFor(categoryRuleDao)
final categoryRuleDaoProvider = CategoryRuleDaoProvider._();

final class CategoryRuleDaoProvider
    extends
        $FunctionalProvider<CategoryRuleDao, CategoryRuleDao, CategoryRuleDao>
    with $Provider<CategoryRuleDao> {
  CategoryRuleDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRuleDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRuleDaoHash();

  @$internal
  @override
  $ProviderElement<CategoryRuleDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoryRuleDao create(Ref ref) {
    return categoryRuleDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRuleDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRuleDao>(value),
    );
  }
}

String _$categoryRuleDaoHash() => r'0d81108c7d330f8eb92fbb80b3b3282fe37f95ab';

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'a77a9915fdc3f0dc4b02a55774aaa249dafd87ba';

@ProviderFor(createCategoryUseCase)
final createCategoryUseCaseProvider = CreateCategoryUseCaseProvider._();

final class CreateCategoryUseCaseProvider
    extends
        $FunctionalProvider<
          CreateCategoryUseCase,
          CreateCategoryUseCase,
          CreateCategoryUseCase
        >
    with $Provider<CreateCategoryUseCase> {
  CreateCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateCategoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateCategoryUseCase create(Ref ref) {
    return createCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCategoryUseCase>(value),
    );
  }
}

String _$createCategoryUseCaseHash() =>
    r'9bf6c54a034a47131f887d6c84d1ce27e26f52b2';

@ProviderFor(autoCategorizeTransactionUseCase)
final autoCategorizeTransactionUseCaseProvider =
    AutoCategorizeTransactionUseCaseProvider._();

final class AutoCategorizeTransactionUseCaseProvider
    extends
        $FunctionalProvider<
          AutoCategorizeTransactionUseCase,
          AutoCategorizeTransactionUseCase,
          AutoCategorizeTransactionUseCase
        >
    with $Provider<AutoCategorizeTransactionUseCase> {
  AutoCategorizeTransactionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoCategorizeTransactionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoCategorizeTransactionUseCaseHash();

  @$internal
  @override
  $ProviderElement<AutoCategorizeTransactionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AutoCategorizeTransactionUseCase create(Ref ref) {
    return autoCategorizeTransactionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AutoCategorizeTransactionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AutoCategorizeTransactionUseCase>(
        value,
      ),
    );
  }
}

String _$autoCategorizeTransactionUseCaseHash() =>
    r'1973f901b7326d4f404d7102c47c876882928a12';

@ProviderFor(categoriesList)
final categoriesListProvider = CategoriesListFamily._();

final class CategoriesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  CategoriesListProvider._({
    required CategoriesListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoriesListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoriesListHash();

  @override
  String toString() {
    return r'categoriesListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    final argument = this.argument as String;
    return categoriesList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoriesListHash() => r'dbbdb21415c3ea895f3bac8fbf7c73cb12cb67f1';

final class CategoriesListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Category>>, String> {
  CategoriesListFamily._()
    : super(
        retry: null,
        name: r'categoriesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoriesListProvider call(String userId) =>
      CategoriesListProvider._(argument: userId, from: this);

  @override
  String toString() => r'categoriesListProvider';
}

@ProviderFor(rootCategories)
final rootCategoriesProvider = RootCategoriesFamily._();

final class RootCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  RootCategoriesProvider._({
    required RootCategoriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rootCategoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rootCategoriesHash();

  @override
  String toString() {
    return r'rootCategoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    final argument = this.argument as String;
    return rootCategories(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RootCategoriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rootCategoriesHash() => r'379d2556029ab0b619ca4d8dc7336688cdbf76f6';

final class RootCategoriesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Category>>, String> {
  RootCategoriesFamily._()
    : super(
        retry: null,
        name: r'rootCategoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RootCategoriesProvider call(String userId) =>
      RootCategoriesProvider._(argument: userId, from: this);

  @override
  String toString() => r'rootCategoriesProvider';
}

@ProviderFor(childCategories)
final childCategoriesProvider = ChildCategoriesFamily._();

final class ChildCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  ChildCategoriesProvider._({
    required ChildCategoriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'childCategoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$childCategoriesHash();

  @override
  String toString() {
    return r'childCategoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    final argument = this.argument as String;
    return childCategories(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChildCategoriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$childCategoriesHash() => r'd825681a9660945881daba98bc731827e4f9cc18';

final class ChildCategoriesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Category>>, String> {
  ChildCategoriesFamily._()
    : super(
        retry: null,
        name: r'childCategoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChildCategoriesProvider call(String parentId) =>
      ChildCategoriesProvider._(argument: parentId, from: this);

  @override
  String toString() => r'childCategoriesProvider';
}

@ProviderFor(categoryRulesByBank)
final categoryRulesByBankProvider = CategoryRulesByBankFamily._();

final class CategoryRulesByBankProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryRule>>,
          List<CategoryRule>,
          FutureOr<List<CategoryRule>>
        >
    with
        $FutureModifier<List<CategoryRule>>,
        $FutureProvider<List<CategoryRule>> {
  CategoryRulesByBankProvider._({
    required CategoryRulesByBankFamily super.from,
    required (String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'categoryRulesByBankProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryRulesByBankHash();

  @override
  String toString() {
    return r'categoryRulesByBankProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<CategoryRule>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryRule>> create(Ref ref) {
    final argument = this.argument as (String, String?);
    return categoryRulesByBank(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryRulesByBankProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryRulesByBankHash() =>
    r'fe7ccf8e49c1c19fc054b089802d45d5d876231a';

final class CategoryRulesByBankFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<CategoryRule>>,
          (String, String?)
        > {
  CategoryRulesByBankFamily._()
    : super(
        retry: null,
        name: r'categoryRulesByBankProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoryRulesByBankProvider call(String bankName, String? spaceId) =>
      CategoryRulesByBankProvider._(argument: (bankName, spaceId), from: this);

  @override
  String toString() => r'categoryRulesByBankProvider';
}

@ProviderFor(categoriesGroupedByType)
final categoriesGroupedByTypeProvider = CategoriesGroupedByTypeFamily._();

final class CategoriesGroupedByTypeProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<Category>>>,
          Map<String, List<Category>>,
          FutureOr<Map<String, List<Category>>>
        >
    with
        $FutureModifier<Map<String, List<Category>>>,
        $FutureProvider<Map<String, List<Category>>> {
  CategoriesGroupedByTypeProvider._({
    required CategoriesGroupedByTypeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoriesGroupedByTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoriesGroupedByTypeHash();

  @override
  String toString() {
    return r'categoriesGroupedByTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, List<Category>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<Category>>> create(Ref ref) {
    final argument = this.argument as String;
    return categoriesGroupedByType(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesGroupedByTypeProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoriesGroupedByTypeHash() =>
    r'e8d5daeb7e9e8537b6977fbdff5f7f29dcb24926';

final class CategoriesGroupedByTypeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, List<Category>>>,
          String
        > {
  CategoriesGroupedByTypeFamily._()
    : super(
        retry: null,
        name: r'categoriesGroupedByTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoriesGroupedByTypeProvider call(String userId) =>
      CategoriesGroupedByTypeProvider._(argument: userId, from: this);

  @override
  String toString() => r'categoriesGroupedByTypeProvider';
}

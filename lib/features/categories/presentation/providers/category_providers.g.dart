// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoryDaoNotifier)
final categoryDaoProvider = CategoryDaoNotifierProvider._();

final class CategoryDaoNotifierProvider
    extends $NotifierProvider<CategoryDaoNotifier, CategoryDao> {
  CategoryDaoNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$categoryDaoNotifierHash();

  @$internal
  @override
  CategoryDaoNotifier create() => CategoryDaoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryDao>(value),
    );
  }
}

String _$categoryDaoNotifierHash() =>
    r'1ae6319f31e446ef73c9f956cff57f87439014c5';

abstract class _$CategoryDaoNotifier extends $Notifier<CategoryDao> {
  CategoryDao build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CategoryDao, CategoryDao>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CategoryDao, CategoryDao>,
              CategoryDao,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CategoryRuleDaoNotifier)
final categoryRuleDaoProvider = CategoryRuleDaoNotifierProvider._();

final class CategoryRuleDaoNotifierProvider
    extends $NotifierProvider<CategoryRuleDaoNotifier, CategoryRuleDao> {
  CategoryRuleDaoNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$categoryRuleDaoNotifierHash();

  @$internal
  @override
  CategoryRuleDaoNotifier create() => CategoryRuleDaoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRuleDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRuleDao>(value),
    );
  }
}

String _$categoryRuleDaoNotifierHash() =>
    r'34da53a19f4ec191ce9f078a187f2485d5532272';

abstract class _$CategoryRuleDaoNotifier extends $Notifier<CategoryRuleDao> {
  CategoryRuleDao build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CategoryRuleDao, CategoryRuleDao>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CategoryRuleDao, CategoryRuleDao>,
              CategoryRuleDao,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CategoryRepositoryNotifier)
final categoryRepositoryProvider = CategoryRepositoryNotifierProvider._();

final class CategoryRepositoryNotifierProvider
    extends $NotifierProvider<CategoryRepositoryNotifier, CategoryRepository> {
  CategoryRepositoryNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$categoryRepositoryNotifierHash();

  @$internal
  @override
  CategoryRepositoryNotifier create() => CategoryRepositoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryNotifierHash() =>
    r'1182a1452d021c9ceac002030f0805a9f371fdb1';

abstract class _$CategoryRepositoryNotifier
    extends $Notifier<CategoryRepository> {
  CategoryRepository build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CategoryRepository, CategoryRepository>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CategoryRepository, CategoryRepository>,
              CategoryRepository,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CreateCategoryUseCaseNotifier)
final createCategoryUseCaseProvider = CreateCategoryUseCaseNotifierProvider._();

final class CreateCategoryUseCaseNotifierProvider
    extends
        $NotifierProvider<
          CreateCategoryUseCaseNotifier,
          CreateCategoryUseCase
        > {
  CreateCategoryUseCaseNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$createCategoryUseCaseNotifierHash();

  @$internal
  @override
  CreateCategoryUseCaseNotifier create() => CreateCategoryUseCaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCategoryUseCase>(value),
    );
  }
}

String _$createCategoryUseCaseNotifierHash() =>
    r'41873a526ef532189171a22cddd07418d9487846';

abstract class _$CreateCategoryUseCaseNotifier
    extends $Notifier<CreateCategoryUseCase> {
  CreateCategoryUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CreateCategoryUseCase, CreateCategoryUseCase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateCategoryUseCase, CreateCategoryUseCase>,
              CreateCategoryUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AutoCategorizeTransactionUseCaseNotifier)
final autoCategorizeTransactionUseCaseProvider =
    AutoCategorizeTransactionUseCaseNotifierProvider._();

final class AutoCategorizeTransactionUseCaseNotifierProvider
    extends
        $NotifierProvider<
          AutoCategorizeTransactionUseCaseNotifier,
          AutoCategorizeTransactionUseCase
        > {
  AutoCategorizeTransactionUseCaseNotifierProvider._()
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
  String debugGetCreateSourceHash() =>
      _$autoCategorizeTransactionUseCaseNotifierHash();

  @$internal
  @override
  AutoCategorizeTransactionUseCaseNotifier create() =>
      AutoCategorizeTransactionUseCaseNotifier();

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

String _$autoCategorizeTransactionUseCaseNotifierHash() =>
    r'ef66e87d78fa8407ba6b5f038387ecef128e0d91';

abstract class _$AutoCategorizeTransactionUseCaseNotifier
    extends $Notifier<AutoCategorizeTransactionUseCase> {
  AutoCategorizeTransactionUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AutoCategorizeTransactionUseCase,
              AutoCategorizeTransactionUseCase
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AutoCategorizeTransactionUseCase,
                AutoCategorizeTransactionUseCase
              >,
              AutoCategorizeTransactionUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CategoriesListNotifier)
final categoriesListProvider = CategoriesListNotifierFamily._();

final class CategoriesListNotifierProvider
    extends $AsyncNotifierProvider<CategoriesListNotifier, List<Category>> {
  CategoriesListNotifierProvider._({
    required CategoriesListNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoriesListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoriesListNotifierHash();

  @override
  String toString() {
    return r'categoriesListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CategoriesListNotifier create() => CategoriesListNotifier();

  @override
  bool operator ==(Object other) {
    return other is CategoriesListNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoriesListNotifierHash() =>
    r'112010ebc33b718bf93cc93eb4eaded17fa46af8';

final class CategoriesListNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CategoriesListNotifier,
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>,
          String
        > {
  CategoriesListNotifierFamily._()
    : super(
        retry: null,
        name: r'categoriesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoriesListNotifierProvider call(String userId) =>
      CategoriesListNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'categoriesListProvider';
}

abstract class _$CategoriesListNotifier extends $AsyncNotifier<List<Category>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<Category>> build(String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Category>>, List<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Category>>, List<Category>>,
              AsyncValue<List<Category>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(RootCategoriesNotifier)
final rootCategoriesProvider = RootCategoriesNotifierFamily._();

final class RootCategoriesNotifierProvider
    extends $AsyncNotifierProvider<RootCategoriesNotifier, List<Category>> {
  RootCategoriesNotifierProvider._({
    required RootCategoriesNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rootCategoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rootCategoriesNotifierHash();

  @override
  String toString() {
    return r'rootCategoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RootCategoriesNotifier create() => RootCategoriesNotifier();

  @override
  bool operator ==(Object other) {
    return other is RootCategoriesNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rootCategoriesNotifierHash() =>
    r'ccd6048ce0a8f4a3aee9db57e36f49c8c8e85137';

final class RootCategoriesNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RootCategoriesNotifier,
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>,
          String
        > {
  RootCategoriesNotifierFamily._()
    : super(
        retry: null,
        name: r'rootCategoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RootCategoriesNotifierProvider call(String userId) =>
      RootCategoriesNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'rootCategoriesProvider';
}

abstract class _$RootCategoriesNotifier extends $AsyncNotifier<List<Category>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<Category>> build(String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Category>>, List<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Category>>, List<Category>>,
              AsyncValue<List<Category>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ChildCategoriesNotifier)
final childCategoriesProvider = ChildCategoriesNotifierFamily._();

final class ChildCategoriesNotifierProvider
    extends $AsyncNotifierProvider<ChildCategoriesNotifier, List<Category>> {
  ChildCategoriesNotifierProvider._({
    required ChildCategoriesNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'childCategoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$childCategoriesNotifierHash();

  @override
  String toString() {
    return r'childCategoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChildCategoriesNotifier create() => ChildCategoriesNotifier();

  @override
  bool operator ==(Object other) {
    return other is ChildCategoriesNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$childCategoriesNotifierHash() =>
    r'da9f6c9cce9c1b19aafd0e1d507df836489718cb';

final class ChildCategoriesNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ChildCategoriesNotifier,
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>,
          String
        > {
  ChildCategoriesNotifierFamily._()
    : super(
        retry: null,
        name: r'childCategoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChildCategoriesNotifierProvider call(String parentId) =>
      ChildCategoriesNotifierProvider._(argument: parentId, from: this);

  @override
  String toString() => r'childCategoriesProvider';
}

abstract class _$ChildCategoriesNotifier
    extends $AsyncNotifier<List<Category>> {
  late final _$args = ref.$arg as String;
  String get parentId => _$args;

  FutureOr<List<Category>> build(String parentId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Category>>, List<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Category>>, List<Category>>,
              AsyncValue<List<Category>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(CategoryRulesByBankNotifier)
final categoryRulesByBankProvider = CategoryRulesByBankNotifierFamily._();

final class CategoryRulesByBankNotifierProvider
    extends
        $AsyncNotifierProvider<
          CategoryRulesByBankNotifier,
          List<CategoryRule>
        > {
  CategoryRulesByBankNotifierProvider._({
    required CategoryRulesByBankNotifierFamily super.from,
    required (String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'categoryRulesByBankProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryRulesByBankNotifierHash();

  @override
  String toString() {
    return r'categoryRulesByBankProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  CategoryRulesByBankNotifier create() => CategoryRulesByBankNotifier();

  @override
  bool operator ==(Object other) {
    return other is CategoryRulesByBankNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryRulesByBankNotifierHash() =>
    r'88bd60d8a14b836ca7add50c51e7e678907b65ed';

final class CategoryRulesByBankNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CategoryRulesByBankNotifier,
          AsyncValue<List<CategoryRule>>,
          List<CategoryRule>,
          FutureOr<List<CategoryRule>>,
          (String, String?)
        > {
  CategoryRulesByBankNotifierFamily._()
    : super(
        retry: null,
        name: r'categoryRulesByBankProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoryRulesByBankNotifierProvider call(String bankName, String? spaceId) =>
      CategoryRulesByBankNotifierProvider._(
        argument: (bankName, spaceId),
        from: this,
      );

  @override
  String toString() => r'categoryRulesByBankProvider';
}

abstract class _$CategoryRulesByBankNotifier
    extends $AsyncNotifier<List<CategoryRule>> {
  late final _$args = ref.$arg as (String, String?);
  String get bankName => _$args.$1;
  String? get spaceId => _$args.$2;

  FutureOr<List<CategoryRule>> build(String bankName, String? spaceId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CategoryRule>>, List<CategoryRule>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CategoryRule>>, List<CategoryRule>>,
              AsyncValue<List<CategoryRule>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

@ProviderFor(CategoriesGroupedByTypeNotifier)
final categoriesGroupedByTypeProvider =
    CategoriesGroupedByTypeNotifierFamily._();

final class CategoriesGroupedByTypeNotifierProvider
    extends
        $AsyncNotifierProvider<
          CategoriesGroupedByTypeNotifier,
          Map<String, List<Category>>
        > {
  CategoriesGroupedByTypeNotifierProvider._({
    required CategoriesGroupedByTypeNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoriesGroupedByTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoriesGroupedByTypeNotifierHash();

  @override
  String toString() {
    return r'categoriesGroupedByTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CategoriesGroupedByTypeNotifier create() => CategoriesGroupedByTypeNotifier();

  @override
  bool operator ==(Object other) {
    return other is CategoriesGroupedByTypeNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoriesGroupedByTypeNotifierHash() =>
    r'092020a74b101dd2b74c66700a1245e318808857';

final class CategoriesGroupedByTypeNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CategoriesGroupedByTypeNotifier,
          AsyncValue<Map<String, List<Category>>>,
          Map<String, List<Category>>,
          FutureOr<Map<String, List<Category>>>,
          String
        > {
  CategoriesGroupedByTypeNotifierFamily._()
    : super(
        retry: null,
        name: r'categoriesGroupedByTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoriesGroupedByTypeNotifierProvider call(String userId) =>
      CategoriesGroupedByTypeNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'categoriesGroupedByTypeProvider';
}

abstract class _$CategoriesGroupedByTypeNotifier
    extends $AsyncNotifier<Map<String, List<Category>>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<Map<String, List<Category>>> build(String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Map<String, List<Category>>>,
              Map<String, List<Category>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, List<Category>>>,
                Map<String, List<Category>>
              >,
              AsyncValue<Map<String, List<Category>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(UpdateCategoryUseCaseNotifier)
final updateCategoryUseCaseProvider = UpdateCategoryUseCaseNotifierProvider._();

final class UpdateCategoryUseCaseNotifierProvider
    extends
        $NotifierProvider<
          UpdateCategoryUseCaseNotifier,
          UpdateCategoryUseCase
        > {
  UpdateCategoryUseCaseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateCategoryUseCaseNotifierHash();

  @$internal
  @override
  UpdateCategoryUseCaseNotifier create() => UpdateCategoryUseCaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateCategoryUseCase>(value),
    );
  }
}

String _$updateCategoryUseCaseNotifierHash() =>
    r'4288698c41eac154aefed3c21fe853f2715096e2';

abstract class _$UpdateCategoryUseCaseNotifier
    extends $Notifier<UpdateCategoryUseCase> {
  UpdateCategoryUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UpdateCategoryUseCase, UpdateCategoryUseCase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UpdateCategoryUseCase, UpdateCategoryUseCase>,
              UpdateCategoryUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DeleteCategoryUseCaseNotifier)
final deleteCategoryUseCaseProvider = DeleteCategoryUseCaseNotifierProvider._();

final class DeleteCategoryUseCaseNotifierProvider
    extends
        $NotifierProvider<
          DeleteCategoryUseCaseNotifier,
          DeleteCategoryUseCase
        > {
  DeleteCategoryUseCaseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteCategoryUseCaseNotifierHash();

  @$internal
  @override
  DeleteCategoryUseCaseNotifier create() => DeleteCategoryUseCaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteCategoryUseCase>(value),
    );
  }
}

String _$deleteCategoryUseCaseNotifierHash() =>
    r'dec666c2c88460d9354046a577949b65c70f69b5';

abstract class _$DeleteCategoryUseCaseNotifier
    extends $Notifier<DeleteCategoryUseCase> {
  DeleteCategoryUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeleteCategoryUseCase, DeleteCategoryUseCase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeleteCategoryUseCase, DeleteCategoryUseCase>,
              DeleteCategoryUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

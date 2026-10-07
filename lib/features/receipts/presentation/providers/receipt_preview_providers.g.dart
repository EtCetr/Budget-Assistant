// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_preview_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(matchReceiptUseCase)
final matchReceiptUseCaseProvider = MatchReceiptUseCaseProvider._();

final class MatchReceiptUseCaseProvider
    extends
        $FunctionalProvider<
          MatchReceiptUseCase,
          MatchReceiptUseCase,
          MatchReceiptUseCase
        >
    with $Provider<MatchReceiptUseCase> {
  MatchReceiptUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'matchReceiptUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$matchReceiptUseCaseHash();

  @$internal
  @override
  $ProviderElement<MatchReceiptUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MatchReceiptUseCase create(Ref ref) {
    return matchReceiptUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchReceiptUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchReceiptUseCase>(value),
    );
  }
}

String _$matchReceiptUseCaseHash() =>
    r'25fa42da556fae7248f9b066bdd0934a8f082be7';

@ProviderFor(linkReceiptToTransactionUseCase)
final linkReceiptToTransactionUseCaseProvider =
    LinkReceiptToTransactionUseCaseProvider._();

final class LinkReceiptToTransactionUseCaseProvider
    extends
        $FunctionalProvider<
          LinkReceiptToTransactionUseCase,
          LinkReceiptToTransactionUseCase,
          LinkReceiptToTransactionUseCase
        >
    with $Provider<LinkReceiptToTransactionUseCase> {
  LinkReceiptToTransactionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkReceiptToTransactionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkReceiptToTransactionUseCaseHash();

  @$internal
  @override
  $ProviderElement<LinkReceiptToTransactionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LinkReceiptToTransactionUseCase create(Ref ref) {
    return linkReceiptToTransactionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkReceiptToTransactionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkReceiptToTransactionUseCase>(
        value,
      ),
    );
  }
}

String _$linkReceiptToTransactionUseCaseHash() =>
    r'91719f55d59b2b8e5bb364f9143179fe09a2bc36';

@ProviderFor(confirmReceiptUseCase)
final confirmReceiptUseCaseProvider = ConfirmReceiptUseCaseProvider._();

final class ConfirmReceiptUseCaseProvider
    extends
        $FunctionalProvider<
          ConfirmReceiptUseCase,
          ConfirmReceiptUseCase,
          ConfirmReceiptUseCase
        >
    with $Provider<ConfirmReceiptUseCase> {
  ConfirmReceiptUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'confirmReceiptUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$confirmReceiptUseCaseHash();

  @$internal
  @override
  $ProviderElement<ConfirmReceiptUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConfirmReceiptUseCase create(Ref ref) {
    return confirmReceiptUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConfirmReceiptUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConfirmReceiptUseCase>(value),
    );
  }
}

String _$confirmReceiptUseCaseHash() =>
    r'2f7e3c6a301550aff50746bbf57f4980bb6edcbe';

@ProviderFor(recordNamingDecisionUseCase)
final recordNamingDecisionUseCaseProvider =
    RecordNamingDecisionUseCaseProvider._();

final class RecordNamingDecisionUseCaseProvider
    extends
        $FunctionalProvider<
          RecordNamingDecisionUseCase,
          RecordNamingDecisionUseCase,
          RecordNamingDecisionUseCase
        >
    with $Provider<RecordNamingDecisionUseCase> {
  RecordNamingDecisionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordNamingDecisionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordNamingDecisionUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecordNamingDecisionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecordNamingDecisionUseCase create(Ref ref) {
    return recordNamingDecisionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordNamingDecisionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordNamingDecisionUseCase>(value),
    );
  }
}

String _$recordNamingDecisionUseCaseHash() =>
    r'ac345fb6e6f6c9cb0f5f6f20cc77fbcfa99ad345';

/// Чек + позиции.

@ProviderFor(receiptBundle)
final receiptBundleProvider = ReceiptBundleFamily._();

/// Чек + позиции.

final class ReceiptBundleProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReceiptBundle?>,
          ReceiptBundle?,
          FutureOr<ReceiptBundle?>
        >
    with $FutureModifier<ReceiptBundle?>, $FutureProvider<ReceiptBundle?> {
  /// Чек + позиции.
  ReceiptBundleProvider._({
    required ReceiptBundleFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'receiptBundleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$receiptBundleHash();

  @override
  String toString() {
    return r'receiptBundleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReceiptBundle?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReceiptBundle?> create(Ref ref) {
    final argument = this.argument as String;
    return receiptBundle(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceiptBundleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$receiptBundleHash() => r'be5002463650e908bb358efd354bea4107c152e7';

/// Чек + позиции.

final class ReceiptBundleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReceiptBundle?>, String> {
  ReceiptBundleFamily._()
    : super(
        retry: null,
        name: r'receiptBundleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Чек + позиции.

  ReceiptBundleProvider call(String receiptId) =>
      ReceiptBundleProvider._(argument: receiptId, from: this);

  @override
  String toString() => r'receiptBundleProvider';
}

/// Результат матчинга для чека.

@ProviderFor(receiptMatchResult)
final receiptMatchResultProvider = ReceiptMatchResultFamily._();

/// Результат матчинга для чека.

final class ReceiptMatchResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReceiptMatchResult?>,
          ReceiptMatchResult?,
          FutureOr<ReceiptMatchResult?>
        >
    with
        $FutureModifier<ReceiptMatchResult?>,
        $FutureProvider<ReceiptMatchResult?> {
  /// Результат матчинга для чека.
  ReceiptMatchResultProvider._({
    required ReceiptMatchResultFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'receiptMatchResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$receiptMatchResultHash();

  @override
  String toString() {
    return r'receiptMatchResultProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReceiptMatchResult?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReceiptMatchResult?> create(Ref ref) {
    final argument = this.argument as String;
    return receiptMatchResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceiptMatchResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$receiptMatchResultHash() =>
    r'9dc2b8125f2f5e3ede4739b0d81c84c5133886eb';

/// Результат матчинга для чека.

final class ReceiptMatchResultFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReceiptMatchResult?>, String> {
  ReceiptMatchResultFamily._()
    : super(
        retry: null,
        name: r'receiptMatchResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Результат матчинга для чека.

  ReceiptMatchResultProvider call(String receiptId) =>
      ReceiptMatchResultProvider._(argument: receiptId, from: this);

  @override
  String toString() => r'receiptMatchResultProvider';
}

/// Категории expense для dropdown позиций.

@ProviderFor(receiptCategories)
final receiptCategoriesProvider = ReceiptCategoriesProvider._();

/// Категории expense для dropdown позиций.

final class ReceiptCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReceiptCategoryLookup>>,
          List<ReceiptCategoryLookup>,
          FutureOr<List<ReceiptCategoryLookup>>
        >
    with
        $FutureModifier<List<ReceiptCategoryLookup>>,
        $FutureProvider<List<ReceiptCategoryLookup>> {
  /// Категории expense для dropdown позиций.
  ReceiptCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<ReceiptCategoryLookup>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReceiptCategoryLookup>> create(Ref ref) {
    return receiptCategories(ref);
  }
}

String _$receiptCategoriesHash() => r'2f0e51807cf778bc94fe2449f9fef5d5a0703945';

/// Настройки (счётчики спама).

@ProviderFor(receiptSettings)
final receiptSettingsProvider = ReceiptSettingsProvider._();

/// Настройки (счётчики спама).

final class ReceiptSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReceiptOfferSettings>,
          ReceiptOfferSettings,
          FutureOr<ReceiptOfferSettings>
        >
    with
        $FutureModifier<ReceiptOfferSettings>,
        $FutureProvider<ReceiptOfferSettings> {
  /// Настройки (счётчики спама).
  ReceiptSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptSettingsHash();

  @$internal
  @override
  $FutureProviderElement<ReceiptOfferSettings> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReceiptOfferSettings> create(Ref ref) {
    return receiptSettings(ref);
  }
}

String _$receiptSettingsHash() => r'3539b1f306ceb2da53b09bb4f382e63faad6f7de';

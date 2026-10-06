// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_receipt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 'qr' | 'ocr' | 'gallery'

@ProviderFor(ScanMode)
final scanModeProvider = ScanModeProvider._();

/// 'qr' | 'ocr' | 'gallery'
final class ScanModeProvider extends $NotifierProvider<ScanMode, String> {
  /// 'qr' | 'ocr' | 'gallery'
  ScanModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanModeHash();

  @$internal
  @override
  ScanMode create() => ScanMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$scanModeHash() => r'ea11c7fa6dfc74c095abab9a985e8c1ecb84ff23';

/// 'qr' | 'ocr' | 'gallery'

abstract class _$ScanMode extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(GalleryImage)
final galleryImageProvider = GalleryImageProvider._();

final class GalleryImageProvider
    extends $NotifierProvider<GalleryImage, XFile?> {
  GalleryImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'galleryImageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$galleryImageHash();

  @$internal
  @override
  GalleryImage create() => GalleryImage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(XFile? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<XFile?>(value),
    );
  }
}

String _$galleryImageHash() => r'a8de1f2d5b6e4447e04f3fefdf2edcbd724a8bbd';

abstract class _$GalleryImage extends $Notifier<XFile?> {
  XFile? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<XFile?, XFile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<XFile?, XFile?>,
              XFile?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 'qr' | 'text'

@ProviderFor(GalleryContentType)
final galleryContentTypeProvider = GalleryContentTypeProvider._();

/// 'qr' | 'text'
final class GalleryContentTypeProvider
    extends $NotifierProvider<GalleryContentType, String> {
  /// 'qr' | 'text'
  GalleryContentTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'galleryContentTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$galleryContentTypeHash();

  @$internal
  @override
  GalleryContentType create() => GalleryContentType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$galleryContentTypeHash() =>
    r'8d34477bc59a02d5729e086b5b78742c9ce9b983';

/// 'qr' | 'text'

abstract class _$GalleryContentType extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(saveReceiptImageUseCase)
final saveReceiptImageUseCaseProvider = SaveReceiptImageUseCaseProvider._();

final class SaveReceiptImageUseCaseProvider
    extends
        $FunctionalProvider<
          SaveReceiptImageUseCase,
          SaveReceiptImageUseCase,
          SaveReceiptImageUseCase
        >
    with $Provider<SaveReceiptImageUseCase> {
  SaveReceiptImageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveReceiptImageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveReceiptImageUseCaseHash();

  @$internal
  @override
  $ProviderElement<SaveReceiptImageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaveReceiptImageUseCase create(Ref ref) {
    return saveReceiptImageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveReceiptImageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveReceiptImageUseCase>(value),
    );
  }
}

String _$saveReceiptImageUseCaseHash() =>
    r'f09bed7ebc68cde8ae718fb889ad811eb52e3947';

@ProviderFor(createDraftReceiptUseCase)
final createDraftReceiptUseCaseProvider = CreateDraftReceiptUseCaseProvider._();

final class CreateDraftReceiptUseCaseProvider
    extends
        $FunctionalProvider<
          CreateDraftReceiptUseCase,
          CreateDraftReceiptUseCase,
          CreateDraftReceiptUseCase
        >
    with $Provider<CreateDraftReceiptUseCase> {
  CreateDraftReceiptUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createDraftReceiptUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createDraftReceiptUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateDraftReceiptUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateDraftReceiptUseCase create(Ref ref) {
    return createDraftReceiptUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateDraftReceiptUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateDraftReceiptUseCase>(value),
    );
  }
}

String _$createDraftReceiptUseCaseHash() =>
    r'6988e1681449ea4af328a47921e14b9e8ed2babf';

@ProviderFor(scanReceiptQrUseCase)
final scanReceiptQrUseCaseProvider = ScanReceiptQrUseCaseProvider._();

final class ScanReceiptQrUseCaseProvider
    extends
        $FunctionalProvider<
          ScanReceiptQrUseCase,
          ScanReceiptQrUseCase,
          ScanReceiptQrUseCase
        >
    with $Provider<ScanReceiptQrUseCase> {
  ScanReceiptQrUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanReceiptQrUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanReceiptQrUseCaseHash();

  @$internal
  @override
  $ProviderElement<ScanReceiptQrUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanReceiptQrUseCase create(Ref ref) {
    return scanReceiptQrUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanReceiptQrUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanReceiptQrUseCase>(value),
    );
  }
}

String _$scanReceiptQrUseCaseHash() =>
    r'616ce8b2e315b66ac1d31f4c9dd899c6dc498da1';

@ProviderFor(scanReceiptOcrUseCase)
final scanReceiptOcrUseCaseProvider = ScanReceiptOcrUseCaseProvider._();

final class ScanReceiptOcrUseCaseProvider
    extends
        $FunctionalProvider<
          ScanReceiptOcrUseCase,
          ScanReceiptOcrUseCase,
          ScanReceiptOcrUseCase
        >
    with $Provider<ScanReceiptOcrUseCase> {
  ScanReceiptOcrUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanReceiptOcrUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanReceiptOcrUseCaseHash();

  @$internal
  @override
  $ProviderElement<ScanReceiptOcrUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanReceiptOcrUseCase create(Ref ref) {
    return scanReceiptOcrUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanReceiptOcrUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanReceiptOcrUseCase>(value),
    );
  }
}

String _$scanReceiptOcrUseCaseHash() =>
    r'f7bcd8453e72f156e48a9372c3a433916cb1536e';

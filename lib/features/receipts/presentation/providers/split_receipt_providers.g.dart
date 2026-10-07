// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_receipt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splitReceiptUseCase)
final splitReceiptUseCaseProvider = SplitReceiptUseCaseProvider._();

final class SplitReceiptUseCaseProvider
    extends
        $FunctionalProvider<
          SplitReceiptUseCase,
          SplitReceiptUseCase,
          SplitReceiptUseCase
        >
    with $Provider<SplitReceiptUseCase> {
  SplitReceiptUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splitReceiptUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splitReceiptUseCaseHash();

  @$internal
  @override
  $ProviderElement<SplitReceiptUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SplitReceiptUseCase create(Ref ref) {
    return splitReceiptUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplitReceiptUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplitReceiptUseCase>(value),
    );
  }
}

String _$splitReceiptUseCaseHash() =>
    r'ff58eaa5518fb196dee9fa3e96d1eec5ef68e7f3';

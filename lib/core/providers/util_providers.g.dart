// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'util_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoggerNotifier)
final loggerProvider = LoggerNotifierProvider._();

final class LoggerNotifierProvider
    extends $NotifierProvider<LoggerNotifier, Logger> {
  LoggerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loggerNotifierHash();

  @$internal
  @override
  LoggerNotifier create() => LoggerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Logger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Logger>(value),
    );
  }
}

String _$loggerNotifierHash() => r'e22743d4557c754f4edae475c1a55777e7871f27';

abstract class _$LoggerNotifier extends $Notifier<Logger> {
  Logger build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Logger, Logger>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Logger, Logger>,
              Logger,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(UuidNotifier)
final uuidProvider = UuidNotifierProvider._();

final class UuidNotifierProvider extends $NotifierProvider<UuidNotifier, Uuid> {
  UuidNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uuidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uuidNotifierHash();

  @$internal
  @override
  UuidNotifier create() => UuidNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Uuid value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Uuid>(value),
    );
  }
}

String _$uuidNotifierHash() => r'2654c0aa64e1c6b6630477464302ac9ad8f6a31c';

abstract class _$UuidNotifier extends $Notifier<Uuid> {
  Uuid build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Uuid, Uuid>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Uuid, Uuid>,
              Uuid,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

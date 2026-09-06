// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppDatabaseNotifier)
final appDatabaseProvider = AppDatabaseNotifierProvider._();

final class AppDatabaseNotifierProvider
    extends $NotifierProvider<AppDatabaseNotifier, AppDatabase> {
  AppDatabaseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseNotifierHash();

  @$internal
  @override
  AppDatabaseNotifier create() => AppDatabaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseNotifierHash() =>
    r'ce134379484150645b3ed53fe1a293ef013b991e';

abstract class _$AppDatabaseNotifier extends $Notifier<AppDatabase> {
  AppDatabase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppDatabase, AppDatabase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppDatabase, AppDatabase>,
              AppDatabase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

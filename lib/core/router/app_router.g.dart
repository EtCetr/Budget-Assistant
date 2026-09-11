// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppLock)
final appLockProvider = AppLockProvider._();

final class AppLockProvider extends $NotifierProvider<AppLock, bool> {
  AppLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockHash();

  @$internal
  @override
  AppLock create() => AppLock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$appLockHash() => r'd08f8dae5fd1c3f69b679f9bf413e41371f63070';

abstract class _$AppLock extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(OnboardingStatus)
final onboardingStatusProvider = OnboardingStatusProvider._();

final class OnboardingStatusProvider
    extends $NotifierProvider<OnboardingStatus, String> {
  OnboardingStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingStatusHash();

  @$internal
  @override
  OnboardingStatus create() => OnboardingStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$onboardingStatusHash() => r'0e6d4c0b37c3fe22f10aca3bae71bc46c86dcb1f';

abstract class _$OnboardingStatus extends $Notifier<String> {
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

@ProviderFor(CurrentSpaceId)
final currentSpaceIdProvider = CurrentSpaceIdProvider._();

final class CurrentSpaceIdProvider
    extends $NotifierProvider<CurrentSpaceId, String?> {
  CurrentSpaceIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSpaceIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSpaceIdHash();

  @$internal
  @override
  CurrentSpaceId create() => CurrentSpaceId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentSpaceIdHash() => r'9c914131303fa6d32d88f56e1ef1ecb9a02ae0a5';

abstract class _$CurrentSpaceId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PendingInviteToken)
final pendingInviteTokenProvider = PendingInviteTokenProvider._();

final class PendingInviteTokenProvider
    extends $NotifierProvider<PendingInviteToken, String?> {
  PendingInviteTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingInviteTokenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingInviteTokenHash();

  @$internal
  @override
  PendingInviteToken create() => PendingInviteToken();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingInviteTokenHash() =>
    r'fe24fadadc765d709551f2060c650946edccf49d';

abstract class _$PendingInviteToken extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'4194b239e5d4e9096bdad880af111d5fdc1946f3';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccountDaoNotifier)
final accountDaoProvider = AccountDaoNotifierProvider._();

final class AccountDaoNotifierProvider
    extends $NotifierProvider<AccountDaoNotifier, AccountDao> {
  AccountDaoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountDaoNotifierHash();

  @$internal
  @override
  AccountDaoNotifier create() => AccountDaoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountDao>(value),
    );
  }
}

String _$accountDaoNotifierHash() =>
    r'553a41603974df95ea3f9bf984255bd089cce609';

abstract class _$AccountDaoNotifier extends $Notifier<AccountDao> {
  AccountDao build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AccountDao, AccountDao>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccountDao, AccountDao>,
              AccountDao,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(MortgageDaoNotifier)
final mortgageDaoProvider = MortgageDaoNotifierProvider._();

final class MortgageDaoNotifierProvider
    extends $NotifierProvider<MortgageDaoNotifier, MortgageDao> {
  MortgageDaoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mortgageDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mortgageDaoNotifierHash();

  @$internal
  @override
  MortgageDaoNotifier create() => MortgageDaoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MortgageDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MortgageDao>(value),
    );
  }
}

String _$mortgageDaoNotifierHash() =>
    r'703cfbc9151ea6aca127d40f74998fd046f966a9';

abstract class _$MortgageDaoNotifier extends $Notifier<MortgageDao> {
  MortgageDao build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MortgageDao, MortgageDao>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MortgageDao, MortgageDao>,
              MortgageDao,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AccountRepositoryNotifier)
final accountRepositoryProvider = AccountRepositoryNotifierProvider._();

final class AccountRepositoryNotifierProvider
    extends $NotifierProvider<AccountRepositoryNotifier, AccountRepository> {
  AccountRepositoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryNotifierHash();

  @$internal
  @override
  AccountRepositoryNotifier create() => AccountRepositoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRepository>(value),
    );
  }
}

String _$accountRepositoryNotifierHash() =>
    r'f989215de8c874fe49c54484fe62a587e1840d4e';

abstract class _$AccountRepositoryNotifier
    extends $Notifier<AccountRepository> {
  AccountRepository build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AccountRepository, AccountRepository>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccountRepository, AccountRepository>,
              AccountRepository,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CreateAccountUseCaseNotifier)
final createAccountUseCaseProvider = CreateAccountUseCaseNotifierProvider._();

final class CreateAccountUseCaseNotifierProvider
    extends
        $NotifierProvider<CreateAccountUseCaseNotifier, CreateAccountUseCase> {
  CreateAccountUseCaseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createAccountUseCaseNotifierHash();

  @$internal
  @override
  CreateAccountUseCaseNotifier create() => CreateAccountUseCaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateAccountUseCase>(value),
    );
  }
}

String _$createAccountUseCaseNotifierHash() =>
    r'c5160a049bf4c238c0013b7b06c6033785f71e7a';

abstract class _$CreateAccountUseCaseNotifier
    extends $Notifier<CreateAccountUseCase> {
  CreateAccountUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CreateAccountUseCase, CreateAccountUseCase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateAccountUseCase, CreateAccountUseCase>,
              CreateAccountUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DeleteAccountUseCaseNotifier)
final deleteAccountUseCaseProvider = DeleteAccountUseCaseNotifierProvider._();

final class DeleteAccountUseCaseNotifierProvider
    extends
        $NotifierProvider<DeleteAccountUseCaseNotifier, DeleteAccountUseCase> {
  DeleteAccountUseCaseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAccountUseCaseNotifierHash();

  @$internal
  @override
  DeleteAccountUseCaseNotifier create() => DeleteAccountUseCaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteAccountUseCase>(value),
    );
  }
}

String _$deleteAccountUseCaseNotifierHash() =>
    r'b2d4d6d46142eb4706bdd8ee0606799321a0875d';

abstract class _$DeleteAccountUseCaseNotifier
    extends $Notifier<DeleteAccountUseCase> {
  DeleteAccountUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeleteAccountUseCase, DeleteAccountUseCase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeleteAccountUseCase, DeleteAccountUseCase>,
              DeleteAccountUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(UpdateAccountSortOrderUseCaseNotifier)
final updateAccountSortOrderUseCaseProvider =
    UpdateAccountSortOrderUseCaseNotifierProvider._();

final class UpdateAccountSortOrderUseCaseNotifierProvider
    extends
        $NotifierProvider<
          UpdateAccountSortOrderUseCaseNotifier,
          UpdateAccountSortOrderUseCase
        > {
  UpdateAccountSortOrderUseCaseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateAccountSortOrderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$updateAccountSortOrderUseCaseNotifierHash();

  @$internal
  @override
  UpdateAccountSortOrderUseCaseNotifier create() =>
      UpdateAccountSortOrderUseCaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateAccountSortOrderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateAccountSortOrderUseCase>(
        value,
      ),
    );
  }
}

String _$updateAccountSortOrderUseCaseNotifierHash() =>
    r'0b424164e4fb9122d84d6ddbf2de96da9392f7dd';

abstract class _$UpdateAccountSortOrderUseCaseNotifier
    extends $Notifier<UpdateAccountSortOrderUseCase> {
  UpdateAccountSortOrderUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              UpdateAccountSortOrderUseCase,
              UpdateAccountSortOrderUseCase
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                UpdateAccountSortOrderUseCase,
                UpdateAccountSortOrderUseCase
              >,
              UpdateAccountSortOrderUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CalculateNetWorthUseCaseNotifier)
final calculateNetWorthUseCaseProvider =
    CalculateNetWorthUseCaseNotifierProvider._();

final class CalculateNetWorthUseCaseNotifierProvider
    extends
        $NotifierProvider<
          CalculateNetWorthUseCaseNotifier,
          CalculateNetWorthUseCase
        > {
  CalculateNetWorthUseCaseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calculateNetWorthUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calculateNetWorthUseCaseNotifierHash();

  @$internal
  @override
  CalculateNetWorthUseCaseNotifier create() =>
      CalculateNetWorthUseCaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalculateNetWorthUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalculateNetWorthUseCase>(value),
    );
  }
}

String _$calculateNetWorthUseCaseNotifierHash() =>
    r'd183984a341cf8dca06f23617a662471f0e1c198';

abstract class _$CalculateNetWorthUseCaseNotifier
    extends $Notifier<CalculateNetWorthUseCase> {
  CalculateNetWorthUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<CalculateNetWorthUseCase, CalculateNetWorthUseCase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CalculateNetWorthUseCase, CalculateNetWorthUseCase>,
              CalculateNetWorthUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AccountsListNotifier)
final accountsListProvider = AccountsListNotifierFamily._();

final class AccountsListNotifierProvider
    extends $AsyncNotifierProvider<AccountsListNotifier, List<Account>> {
  AccountsListNotifierProvider._({
    required AccountsListNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'accountsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$accountsListNotifierHash();

  @override
  String toString() {
    return r'accountsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AccountsListNotifier create() => AccountsListNotifier();

  @override
  bool operator ==(Object other) {
    return other is AccountsListNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountsListNotifierHash() =>
    r'2a7f9aa1aa086783c05d559d3f69adb641ac0cbf';

final class AccountsListNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AccountsListNotifier,
          AsyncValue<List<Account>>,
          List<Account>,
          FutureOr<List<Account>>,
          String
        > {
  AccountsListNotifierFamily._()
    : super(
        retry: null,
        name: r'accountsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AccountsListNotifierProvider call(String userId) =>
      AccountsListNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'accountsListProvider';
}

abstract class _$AccountsListNotifier extends $AsyncNotifier<List<Account>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<Account>> build(String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Account>>, List<Account>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Account>>, List<Account>>,
              AsyncValue<List<Account>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(NetWorthNotifier)
final netWorthProvider = NetWorthNotifierFamily._();

final class NetWorthNotifierProvider
    extends $AsyncNotifierProvider<NetWorthNotifier, int> {
  NetWorthNotifierProvider._({
    required NetWorthNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'netWorthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$netWorthNotifierHash();

  @override
  String toString() {
    return r'netWorthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NetWorthNotifier create() => NetWorthNotifier();

  @override
  bool operator ==(Object other) {
    return other is NetWorthNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$netWorthNotifierHash() => r'8502ecd121943e39e14a9aff4595f807c9eb857a';

final class NetWorthNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NetWorthNotifier,
          AsyncValue<int>,
          int,
          FutureOr<int>,
          String
        > {
  NetWorthNotifierFamily._()
    : super(
        retry: null,
        name: r'netWorthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NetWorthNotifierProvider call(String userId) =>
      NetWorthNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'netWorthProvider';
}

abstract class _$NetWorthNotifier extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<int> build(String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(UpdateAccountUseCaseNotifier)
final updateAccountUseCaseProvider = UpdateAccountUseCaseNotifierProvider._();

final class UpdateAccountUseCaseNotifierProvider
    extends
        $NotifierProvider<UpdateAccountUseCaseNotifier, UpdateAccountUseCase> {
  UpdateAccountUseCaseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateAccountUseCaseNotifierHash();

  @$internal
  @override
  UpdateAccountUseCaseNotifier create() => UpdateAccountUseCaseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateAccountUseCase>(value),
    );
  }
}

String _$updateAccountUseCaseNotifierHash() =>
    r'eb0530e7db118878137592fdebd3b9d74a9e9e82';

abstract class _$UpdateAccountUseCaseNotifier
    extends $Notifier<UpdateAccountUseCase> {
  UpdateAccountUseCase build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UpdateAccountUseCase, UpdateAccountUseCase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UpdateAccountUseCase, UpdateAccountUseCase>,
              UpdateAccountUseCase,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

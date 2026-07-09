// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountDao)
final accountDaoProvider = AccountDaoProvider._();

final class AccountDaoProvider
    extends $FunctionalProvider<AccountDao, AccountDao, AccountDao>
    with $Provider<AccountDao> {
  AccountDaoProvider._()
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
  String debugGetCreateSourceHash() => _$accountDaoHash();

  @$internal
  @override
  $ProviderElement<AccountDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountDao create(Ref ref) {
    return accountDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountDao>(value),
    );
  }
}

String _$accountDaoHash() => r'96e41bb5f96f9637bb3ffebd344a47b3a3526194';

@ProviderFor(mortgageDao)
final mortgageDaoProvider = MortgageDaoProvider._();

final class MortgageDaoProvider
    extends $FunctionalProvider<MortgageDao, MortgageDao, MortgageDao>
    with $Provider<MortgageDao> {
  MortgageDaoProvider._()
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
  String debugGetCreateSourceHash() => _$mortgageDaoHash();

  @$internal
  @override
  $ProviderElement<MortgageDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MortgageDao create(Ref ref) {
    return mortgageDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MortgageDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MortgageDao>(value),
    );
  }
}

String _$mortgageDaoHash() => r'51736d84b3679a2bd0b87c78dd458f29738858cd';

@ProviderFor(accountRepository)
final accountRepositoryProvider = AccountRepositoryProvider._();

final class AccountRepositoryProvider
    extends
        $FunctionalProvider<
          AccountRepository,
          AccountRepository,
          AccountRepository
        >
    with $Provider<AccountRepository> {
  AccountRepositoryProvider._()
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
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountRepository create(Ref ref) {
    return accountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRepository>(value),
    );
  }
}

String _$accountRepositoryHash() => r'766d164d6cdbd511e9f444c00454b38f7af45e90';

@ProviderFor(createAccountUseCase)
final createAccountUseCaseProvider = CreateAccountUseCaseProvider._();

final class CreateAccountUseCaseProvider
    extends
        $FunctionalProvider<
          CreateAccountUseCase,
          CreateAccountUseCase,
          CreateAccountUseCase
        >
    with $Provider<CreateAccountUseCase> {
  CreateAccountUseCaseProvider._()
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
  String debugGetCreateSourceHash() => _$createAccountUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateAccountUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateAccountUseCase create(Ref ref) {
    return createAccountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateAccountUseCase>(value),
    );
  }
}

String _$createAccountUseCaseHash() =>
    r'7585180dac3ad5aa70ffbf5d02d826e0b96918b9';

@ProviderFor(updateAccountSortOrderUseCase)
final updateAccountSortOrderUseCaseProvider =
    UpdateAccountSortOrderUseCaseProvider._();

final class UpdateAccountSortOrderUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateAccountSortOrderUseCase,
          UpdateAccountSortOrderUseCase,
          UpdateAccountSortOrderUseCase
        >
    with $Provider<UpdateAccountSortOrderUseCase> {
  UpdateAccountSortOrderUseCaseProvider._()
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
  String debugGetCreateSourceHash() => _$updateAccountSortOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateAccountSortOrderUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateAccountSortOrderUseCase create(Ref ref) {
    return updateAccountSortOrderUseCase(ref);
  }

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

String _$updateAccountSortOrderUseCaseHash() =>
    r'6bd84fd701dc0396dd8deafc4762c1b081ec4bdd';

@ProviderFor(calculateNetWorthUseCase)
final calculateNetWorthUseCaseProvider = CalculateNetWorthUseCaseProvider._();

final class CalculateNetWorthUseCaseProvider
    extends
        $FunctionalProvider<
          CalculateNetWorthUseCase,
          CalculateNetWorthUseCase,
          CalculateNetWorthUseCase
        >
    with $Provider<CalculateNetWorthUseCase> {
  CalculateNetWorthUseCaseProvider._()
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
  String debugGetCreateSourceHash() => _$calculateNetWorthUseCaseHash();

  @$internal
  @override
  $ProviderElement<CalculateNetWorthUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CalculateNetWorthUseCase create(Ref ref) {
    return calculateNetWorthUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalculateNetWorthUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalculateNetWorthUseCase>(value),
    );
  }
}

String _$calculateNetWorthUseCaseHash() =>
    r'c78666c2bd388a1f1222d87101e096a94612210a';

@ProviderFor(accountsList)
final accountsListProvider = AccountsListFamily._();

final class AccountsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Account>>,
          List<Account>,
          FutureOr<List<Account>>
        >
    with $FutureModifier<List<Account>>, $FutureProvider<List<Account>> {
  AccountsListProvider._({
    required AccountsListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'accountsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$accountsListHash();

  @override
  String toString() {
    return r'accountsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Account>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Account>> create(Ref ref) {
    final argument = this.argument as String;
    return accountsList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountsListHash() => r'376676ac0b51739cf2caa000ced9cfed0f7351a8';

final class AccountsListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Account>>, String> {
  AccountsListFamily._()
    : super(
        retry: null,
        name: r'accountsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AccountsListProvider call(String userId) =>
      AccountsListProvider._(argument: userId, from: this);

  @override
  String toString() => r'accountsListProvider';
}

@ProviderFor(netWorth)
final netWorthProvider = NetWorthFamily._();

final class NetWorthProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  NetWorthProvider._({
    required NetWorthFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'netWorthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$netWorthHash();

  @override
  String toString() {
    return r'netWorthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return netWorth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NetWorthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$netWorthHash() => r'b85470a2345fd1e4225bc279b8690571adf1afba';

final class NetWorthFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  NetWorthFamily._()
    : super(
        retry: null,
        name: r'netWorthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NetWorthProvider call(String userId) =>
      NetWorthProvider._(argument: userId, from: this);

  @override
  String toString() => r'netWorthProvider';
}

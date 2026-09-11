// lib/features/accounts/presentation/providers/account_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/providers/util_providers.dart';
import '../../domain/entities/account.dart';
import '../../domain/usecases/create_account_usecase.dart';
import '../../domain/usecases/calculate_net_worth_usecase.dart';
import '../../domain/usecases/update_account_sort_order_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/repositories/account_repository.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../data/datasources/account_dao.dart';
import '../../data/datasources/mortgage_dao.dart';
import '../../domain/usecases/update_account_usecase.dart';

part 'account_providers.g.dart';

@riverpod
class AccountDaoNotifier extends _$AccountDaoNotifier {
  @override
  AccountDao build() {
    final db = ref.watch(appDatabaseProvider);
    return AccountDao(db);
  }
}

@riverpod
class MortgageDaoNotifier extends _$MortgageDaoNotifier {
  @override
  MortgageDao build() {
    final db = ref.watch(appDatabaseProvider);
    return MortgageDao(db);
  }
}

@riverpod
class AccountRepositoryNotifier extends _$AccountRepositoryNotifier {
  @override
  AccountRepository build() {
    return AccountRepositoryImpl(
      accountDao: ref.watch(accountDaoProvider),
      mortgageDao: ref.watch(mortgageDaoProvider),
      logger: ref.watch(loggerProvider),
      uuid: ref.watch(uuidProvider),
    );
  }
}

@riverpod
class CreateAccountUseCaseNotifier extends _$CreateAccountUseCaseNotifier {
  @override
  CreateAccountUseCase build() {
    return CreateAccountUseCase(
      repository: ref.watch(accountRepositoryProvider),
      logger: ref.watch(loggerProvider),
      uuid: ref.watch(uuidProvider),
    );
  }
}

@riverpod
class DeleteAccountUseCaseNotifier extends _$DeleteAccountUseCaseNotifier {
  @override
  DeleteAccountUseCase build() {
    return DeleteAccountUseCase(
      repository: ref.watch(accountRepositoryProvider),
      logger: ref.watch(loggerProvider),
    );
  }
}

@riverpod
class UpdateAccountSortOrderUseCaseNotifier
    extends _$UpdateAccountSortOrderUseCaseNotifier {
  @override
  UpdateAccountSortOrderUseCase build() {
    return UpdateAccountSortOrderUseCase(
      repository: ref.watch(accountRepositoryProvider),
      logger: ref.watch(loggerProvider),
    );
  }
}

@riverpod
class CalculateNetWorthUseCaseNotifier
    extends _$CalculateNetWorthUseCaseNotifier {
  @override
  CalculateNetWorthUseCase build() {
    return CalculateNetWorthUseCase(
      repository: ref.watch(accountRepositoryProvider),
      logger: ref.watch(loggerProvider),
    );
  }
}

@riverpod
class AccountsListNotifier extends _$AccountsListNotifier {
  @override
  Future<List<Account>> build(String userId) async {
    final repository = ref.watch(accountRepositoryProvider);
    return await repository.getAccountsByUserId(userId);
  }
}

@riverpod
class NetWorthNotifier extends _$NetWorthNotifier {
  @override
  Future<int> build(String userId) async {
    final useCase = ref.watch(calculateNetWorthUseCaseProvider);
    final result = await useCase.execute(userId);

    return result.when(success: (value) => value, failure: (error) => 0);
  }
}

@riverpod
class UpdateAccountUseCaseNotifier extends _$UpdateAccountUseCaseNotifier {
  @override
  UpdateAccountUseCase build() {
    return UpdateAccountUseCase(
      repository: ref.watch(accountRepositoryProvider),
      logger: ref.watch(loggerProvider),
    );
  }
}
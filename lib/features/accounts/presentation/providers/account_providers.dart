// lib/features/accounts/presentation/providers/account_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/providers/util_providers.dart';
import '../../domain/entities/account.dart';
import '../../domain/usecases/create_account_usecase.dart';
import '../../domain/usecases/calculate_net_worth_usecase.dart';
import '../../domain/usecases/update_account_sort_order_usecase.dart';
import '../../domain/repositories/account_repository.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../data/datasources/account_dao.dart';
import '../../data/datasources/mortgage_dao.dart';

part 'account_providers.g.dart';

@riverpod
AccountDao accountDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return AccountDao(db);
}

@riverpod
MortgageDao mortgageDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return MortgageDao(db);
}

@riverpod
AccountRepository accountRepository(Ref ref) {
  return AccountRepositoryImpl(
    accountDao: ref.watch(accountDaoProvider),
    mortgageDao: ref.watch(mortgageDaoProvider),
    logger: ref.watch(loggerProvider),
    uuid: ref.watch(uuidProvider),
  );
}

@riverpod
CreateAccountUseCase createAccountUseCase(Ref ref) {
  return CreateAccountUseCase(
    repository: ref.watch(accountRepositoryProvider),
    logger: ref.watch(loggerProvider),
    uuid: ref.watch(uuidProvider),
  );
}

@riverpod
UpdateAccountSortOrderUseCase updateAccountSortOrderUseCase(Ref ref) {
  return UpdateAccountSortOrderUseCase(
    repository: ref.watch(accountRepositoryProvider),
    logger: ref.watch(loggerProvider),
  );
}

@riverpod
CalculateNetWorthUseCase calculateNetWorthUseCase(Ref ref) {
  return CalculateNetWorthUseCase(
    repository: ref.watch(accountRepositoryProvider),
    logger: ref.watch(loggerProvider),
  );
}

@riverpod
Future<List<Account>> accountsList(Ref ref, String userId) async {
  final repository = ref.watch(accountRepositoryProvider);
  return await repository.getAccountsByUserId(userId);
}

@riverpod
Future<int> netWorth(Ref ref, String userId) async {
  final useCase = ref.watch(calculateNetWorthUseCaseProvider);
  final result = await useCase.execute(userId);

  return result.when(success: (value) => value, failure: (error) => 0);
}

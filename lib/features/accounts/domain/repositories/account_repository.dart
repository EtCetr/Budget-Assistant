// lib/features/accounts/domain/repositories/account_repository.dart
import '../entities/account.dart';
import '../entities/mortgage.dart';

abstract class AccountRepository {
  Future<List<Account>> getAccountsByUserId(String userId);
  Future<void> insertAccount(Account account);
  Future<void> updateAccountSortOrder(String accountId, int? sortOrder);
  Future<Account?> getSystemAccountByType(String accountType);
  Future<Account> getOrCreateSystemAccount(String accountType);
  Future<Mortgage?> getMortgageByAccountId(String accountId);
  Future<void> insertMortgage(Mortgage mortgage);
  Future<void> ensureLocalUser(String userId, {String email = ''});
    Future<void> deleteAccount(String accountId);
}

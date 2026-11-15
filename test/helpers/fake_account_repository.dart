import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account_types.dart';
import 'package:budget_assistant/features/accounts/domain/entities/mortgage.dart';
import 'package:budget_assistant/features/accounts/domain/repositories/account_repository.dart';

/// Этап 24: заглушка репозитория счетов для доменных тестов.
/// Деньги — целые копейки, даты — UTC.
class FakeAccountRepository implements AccountRepository {
  final Map<String, Account> accounts = <String, Account>{};
  final Map<String, Mortgage> mortgages = <String, Mortgage>{};

  final List<String> calls = <String>[];
  final List<({String id, int? order})> sortUpdates =
      <({String id, int? order})>[];

  /// Если задано — каждый метод бросает эту ошибку.
  Object? error;

  /// Если задано — updateAccount возвращает готовую ошибку (без throw).
  Failure? updateFailure;

  String? lastEnsuredUserId;

  ({
    String accountId,
    String bankName,
    String customName,
    String accountType,
    String currency,
    int currentBalance,
    String? cardNumberMask,
    int? creditLimit,
  })? lastUpdate;

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<List<Account>> getAccountsByUserId(String userId) async {
    _enter('getAccountsByUserId');
    return accounts.values.where((a) => a.userId == userId).toList();
  }

  @override
  Future<void> insertAccount(Account account) async {
    _enter('insertAccount');
    accounts[account.id] = account;
  }

  @override
  Future<void> updateAccountSortOrder(String accountId, int? sortOrder) async {
    _enter('updateAccountSortOrder');
    sortUpdates.add((id: accountId, order: sortOrder));
    final a = accounts[accountId];
    if (a != null) accounts[accountId] = a.copyWith(sortOrder: sortOrder);
  }

  @override
  Future<Account?> getSystemAccountByType(String accountType) async {
    _enter('getSystemAccountByType');
    for (final a in accounts.values) {
      if (a.accountType == accountType && a.isSystem) return a;
    }
    return null;
  }

  @override
  Future<Account> getOrCreateSystemAccount(String accountType) async {
    _enter('getOrCreateSystemAccount');
    final existing = await getSystemAccountByType(accountType);
    if (existing != null) return existing;
    final created = Account(
      id: 'system-$accountType',
      userId: 'u1',
      bankName: 'System',
      customName: 'Virtual Envelope',
      accountType: accountType,
      currency: 'RUB',
      currentBalance: 0,
      isSystem: true,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
    accounts[created.id] = created;
    return created;
  }

  @override
  Future<Mortgage?> getMortgageByAccountId(String accountId) async {
    _enter('getMortgageByAccountId');
    return mortgages[accountId];
  }

  @override
  Future<void> insertMortgage(Mortgage mortgage) async {
    _enter('insertMortgage');
    mortgages[mortgage.accountId] = mortgage;
  }

  @override
  Future<void> ensureLocalUser(String userId, {String email = ''}) async {
    _enter('ensureLocalUser');
    lastEnsuredUserId = userId;
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    _enter('deleteAccount');
    accounts.remove(accountId);
    mortgages.remove(accountId);
  }

  @override
  Future<Result<void>> updateAccount({
    required String accountId,
    required String bankName,
    required String customName,
    required String accountType,
    required String currency,
    required int currentBalance,
    String? cardNumberMask,
    int? creditLimit,
  }) async {
    _enter('updateAccount');
    lastUpdate = (
      accountId: accountId,
      bankName: bankName,
      customName: customName,
      accountType: accountType,
      currency: currency,
      currentBalance: currentBalance,
      cardNumberMask: cardNumberMask,
      creditLimit: creditLimit,
    );
    final f = updateFailure;
    if (f != null) return Result.failure(f);
    final a = accounts[accountId];
    if (a != null) {
      accounts[accountId] = a.copyWith(
        bankName: bankName,
        customName: customName,
        accountType: accountType,
        currency: currency,
        currentBalance: currentBalance,
        cardNumberMask: cardNumberMask,
        creditLimit: creditLimit,
      );
    }
    return Result.success(null);
  }
}

/// Фабрика счёта для тестов (копейки, UTC).
Account makeAccount({
  required String id,
  String userId = 'u1',
  String type = AccountTypes.debit,
  int balance = 0,
  String? spaceId,
  bool isArchived = false,
  bool isSystem = false,
}) =>
    Account(
      id: id,
      userId: userId,
      spaceId: spaceId,
      bankName: 'Банк',
      customName: 'Счёт $id',
      accountType: type,
      currency: 'RUB',
      currentBalance: balance,
      isArchived: isArchived,
      isSystem: isSystem,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

/// Фабрика ипотеки для тестов.
Mortgage makeMortgage({
  required String accountId,
  int propertyValue = 800000000,
  int initialLoanAmount = 500000000,
}) =>
    Mortgage(
      id: 'mort-$accountId',
      accountId: accountId,
      initialLoanAmount: initialLoanAmount,
      propertyValue: propertyValue,
      interestRateBps: 1200,
      remainingTermMonths: 120,
      monthlyPayment: 5000000,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
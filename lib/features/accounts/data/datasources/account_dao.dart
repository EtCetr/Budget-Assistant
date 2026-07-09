// lib/features/accounts/data/datasources/account_dao.dart
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/account_model.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  Future<List<AccountModel>> getAccountsByUserId(String userId) async {
    try {
      final query = select(accounts)..where((t) => t.userId.equals(userId));
      final results = await query.get();

      return results
          .map(
            (row) => AccountModel(
              id: row.id,
              userId: row.userId,
              spaceId: row.spaceId,
              bankName: row.bankName,
              customName: row.customName,
              cardNumberMask: row.cardNumberMask,
              accountType: row.accountType,
              currency: row.currency,
              currentBalance: row.currentBalance,
              creditLimit: row.creditLimit,
              gracePeriodEnd: row.gracePeriodEnd,
              minPaymentAmount: row.minPaymentAmount,
              includeInPersonalBalance: row.includeInPersonalBalance,
              includeInFamilyBalance: row.includeInFamilyBalance,
              isSharedBalance: row.isSharedBalance,
              isSharedExpenses: row.isSharedExpenses,
              expenseDetailLevel: row.expenseDetailLevel,
              isSharedIncomes: row.isSharedIncomes,
              incomeDetailLevel: row.incomeDetailLevel,
              sortOrder: row.sortOrder,
              isArchived: row.isArchived,
              isSystem: row.isSystem,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              syncStatus: row.syncStatus,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get accounts: $e');
    }
  }

  Future<void> insertAccount(AccountModel account) async {
    try {
      await into(accounts).insert(
        AccountsCompanion(
          id: Value(account.id),
          userId: Value(account.userId),
          spaceId: Value(account.spaceId),
          bankName: Value(account.bankName),
          customName: Value(account.customName),
          cardNumberMask: Value(account.cardNumberMask),
          accountType: Value(account.accountType),
          currency: Value(account.currency),
          currentBalance: Value(account.currentBalance),
          creditLimit: Value(account.creditLimit),
          gracePeriodEnd: Value(account.gracePeriodEnd),
          minPaymentAmount: Value(account.minPaymentAmount),
          includeInPersonalBalance: Value(account.includeInPersonalBalance),
          includeInFamilyBalance: Value(account.includeInFamilyBalance),
          isSharedBalance: Value(account.isSharedBalance),
          isSharedExpenses: Value(account.isSharedExpenses),
          expenseDetailLevel: Value(account.expenseDetailLevel),
          isSharedIncomes: Value(account.isSharedIncomes),
          incomeDetailLevel: Value(account.incomeDetailLevel),
          sortOrder: Value(account.sortOrder),
          isArchived: Value(account.isArchived),
          isSystem: Value(account.isSystem),
          createdAt: Value(account.createdAt),
          updatedAt: Value(account.updatedAt),
          syncStatus: Value(account.syncStatus),
        ),
      );
    } catch (e) {
      throw Exception('Failed to insert account: $e');
    }
  }

  Future<void> updateAccountSortOrder(String accountId, int? sortOrder) async {
    try {
      await (update(accounts)..where((t) => t.id.equals(accountId))).write(
        AccountsCompanion(sortOrder: Value(sortOrder)),
      );
    } catch (e) {
      throw Exception('Failed to update sort order: $e');
    }
  }

  Future<AccountModel?> getSystemAccountByType(String accountType) async {
    try {
      final query = select(accounts)
        ..where(
          (t) => t.accountType.equals(accountType) & t.isSystem.equals(true),
        );
      final result = await query.getSingleOrNull();

      if (result == null) return null;

      return AccountModel(
        id: result.id,
        userId: result.userId,
        spaceId: result.spaceId,
        bankName: result.bankName,
        customName: result.customName,
        cardNumberMask: result.cardNumberMask,
        accountType: result.accountType,
        currency: result.currency,
        currentBalance: result.currentBalance,
        creditLimit: result.creditLimit,
        gracePeriodEnd: result.gracePeriodEnd,
        minPaymentAmount: result.minPaymentAmount,
        includeInPersonalBalance: result.includeInPersonalBalance,
        includeInFamilyBalance: result.includeInFamilyBalance,
        isSharedBalance: result.isSharedBalance,
        isSharedExpenses: result.isSharedExpenses,
        expenseDetailLevel: result.expenseDetailLevel,
        isSharedIncomes: result.isSharedIncomes,
        incomeDetailLevel: result.incomeDetailLevel,
        sortOrder: result.sortOrder,
        isArchived: result.isArchived,
        isSystem: result.isSystem,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
        syncStatus: result.syncStatus,
      );
    } catch (e) {
      throw Exception('Failed to get system account: $e');
    }
  }
}

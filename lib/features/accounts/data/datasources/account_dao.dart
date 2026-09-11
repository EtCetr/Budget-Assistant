// lib/features/accounts/data/datasources/account_dao.dart
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/account_model.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  // ✅ НОВЫЙ МЕТОД: Stream для автообновления UI
  Stream<List<AccountModel>> watchAccountsByUserId(String userId) {
    final query = select(accounts)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
                 (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    
    return query.watch().map((results) => results
        .map((row) => AccountModel(
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
            ))
        .toList());
  }

  // ✅ НОВЫЙ МЕТОД: Delete с каскадом для ипотеки
    /// Удаление счёта с каскадным удалением ипотеки
  Future<void> deleteAccount(String accountId) async {
    try {
      await (delete(
        db.mortgages,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(accounts)..where((t) => t.id.equals(accountId))).go();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

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

  // Внутрь класса AccountDao (после существующих методов)

  /// Идемпотентно создаёт локальную копию профиля пользователя.
  /// Нужна, чтобы FK accounts.user_id не падал до первой синхронизации (Этап 8).
  Future<void> ensureLocalUser(String userId, {String email = ''}) async {
    final existing = await (select(
      db.users,
    )..where((u) => u.id.equals(userId))).getSingleOrNull();
    if (existing != null) return;

    final now = DateTime.now().toUtc();
    await into(db.users).insert(
      UsersCompanion(
        id: Value(userId),
        displayName: const Value(''),
        email: Value(email),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

    /// Обновление счёта (Edit): updatedAt + возврат в очередь sync
  Future<void> updateAccountFields({
    required String accountId,
    required String bankName,
    required String customName,
    required String accountType,
    required String currency,
    required int currentBalance,
    required String? cardNumberMask,
    required int? creditLimit,
    required DateTime updatedAt,
  }) async {
    try {
      await (update(accounts)..where((t) => t.id.equals(accountId))).write(
        AccountsCompanion(
          bankName: Value(bankName),
          customName: Value(customName),
          accountType: Value(accountType),
          currency: Value(currency),
          currentBalance: Value(currentBalance),
          cardNumberMask: Value(cardNumberMask),
          creditLimit: Value(creditLimit),
          updatedAt: Value(updatedAt),
          syncStatus: const Value('pending'),
        ),
      );
    } catch (e) {
      throw Exception('Failed to update account: $e');
    }
  }
}

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

/// Этап 24: инфраструктура тестов БД (Drift in-memory).
///
/// Деньги — только целые копейки. Даты хранятся в UTC, а группировка
/// в DAO идёт по локальному месяцу, поэтому фикстуры берут полдень
/// середины месяца: часовой пояс не может сдвинуть месяц.
const kUserId = 'u1';
const kOtherUserId = 'u2';
const kSpaceId = 's1';
const kAccountId = 'a1';

DateTime testDate(int year, int month, [int day = 15]) =>
    DateTime(year, month, day, 12).toUtc();

AppDatabase openTestDb() => AppDatabase.forTesting(NativeDatabase.memory());

class TestSeed {
  TestSeed(this.db);

  final AppDatabase db;
  final Logger _log = Logger();

  Future<void> _guard(String label, Future<void> Function() action) async {
    try {
      await action();
    } catch (e, st) {
      _log.e('TestSeed.$label failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Пользователь + пространство + счёт + 3 категории.
  Future<void> base() async {
    await user(kUserId);
    await space(kSpaceId);
    await account();
    await category('c1', name: 'Продукты');
    await category('c2', name: 'Транспорт');
    await category('i1', name: 'Зарплата', type: 'income');
  }

  Future<void> user(String id) => _guard('user', () async {
        await db.into(db.users).insert(UsersCompanion.insert(
              id: id,
              email: '$id@example.com',
              displayName: 'Пользователь $id',
            ));
      });

  Future<void> space(String id) => _guard('space', () async {
        await db.into(db.spaces).insert(SpacesCompanion.insert(
              id: id,
              name: 'Семья $id',
              encryptionSalt: 'salt-$id',
            ));
      });

  Future<void> account({
    String id = kAccountId,
    String userId = kUserId,
    String? spaceId,
  }) =>
      _guard('account', () async {
        final now = DateTime.now().toUtc();
        await db.into(db.accounts).insert(AccountsCompanion.insert(
              id: id,
              userId: userId,
              spaceId: Value(spaceId),
              bankName: 'Банк',
              customName: 'Карта',
              accountType: 'debit_card',
              currency: 'RUB',
              currentBalance: 0,
              createdAt: now,
              updatedAt: now,
            ));
      });

  Future<void> category(
    String id, {
    String name = '',
    String type = 'expense',
    String userId = kUserId,
    String? spaceId,
    int sortOrder = 0,
  }) =>
      _guard('category', () async {
        final now = DateTime.now().toUtc();
        await db.into(db.categories).insert(CategoriesCompanion.insert(
              id: id,
              userId: userId,
              spaceId: Value(spaceId),
              name: name.isEmpty ? id : name,
              type: type,
              sortOrder: Value(sortOrder),
              createdAt: now,
              updatedAt: now,
            ));
      });

  Future<void> tx({
    required String id,
    required int amountKopecks,
    DateTime? date,
    TransactionType type = TransactionType.expense,
    String userId = kUserId,
    String accountId = kAccountId,
    String? linkedAccountId,
    String? spaceId,
    String? categoryId,
    String? comment,
    AuditStatus auditStatus = AuditStatus.verified,
    bool isSplit = false,
    bool isLargeExpense = false,
    bool isWithdrawal = false,
    String? savingsGoalId,
    String? copyGroupId,
    SyncStatus syncStatus = SyncStatus.pending,
  }) =>
      _guard('tx', () async {
        final now = DateTime.now().toUtc();
        await db.into(db.transactions).insert(TransactionsCompanion.insert(
              id: id,
              accountId: accountId,
              linkedAccountId: Value(linkedAccountId),
              userId: userId,
              spaceId: Value(spaceId),
              date: date ?? testDate(2026, 7),
              amount: amountKopecks,
              type: type,
              customCategoryId: Value(categoryId),
              comment: Value(comment),
              auditStatus: Value(auditStatus),
              isSplit: Value(isSplit),
              isLargeExpense: Value(isLargeExpense),
              isWithdrawal: Value(isWithdrawal),
              savingsGoalId: Value(savingsGoalId),
              copyGroupId: Value(copyGroupId),
              createdAt: now,
              updatedAt: now,
              syncStatus: Value(syncStatus),
            ));
      });

  Future<void> split({
    required String id,
    required String transactionId,
    required String categoryId,
    required int amountKopecks,
    String? description,
  }) =>
      _guard('split', () async {
        final now = DateTime.now().toUtc();
        await db.into(db.transactionSplits).insert(
              TransactionSplitsCompanion.insert(
                id: id,
                transactionId: transactionId,
                categoryId: categoryId,
                amount: amountKopecks,
                description: Value(description),
                createdAt: now,
                updatedAt: now,
              ),
            );
      });

  Future<void> limit({
    required String id,
    required String categoryId,
    required int year,
    required int month,
    required int kopecks,
    String userId = kUserId,
    String? spaceId,
    String status = 'active',
  }) =>
      _guard('limit', () async {
        final now = DateTime.now().toUtc();
        await db.into(db.budgetLimits).insert(BudgetLimitsCompanion.insert(
              id: id,
              userId: userId,
              spaceId: Value(spaceId),
              categoryId: categoryId,
              year: year,
              month: month,
              limitAmount: kopecks,
              status: Value(status),
              createdAt: now,
              updatedAt: now,
            ));
      });

  Future<void> allocated({
    required String id,
    required int year,
    required int month,
    required int kopecks,
    String userId = kUserId,
    String spaceId = '',
  }) =>
      _guard('allocated', () async {
        final now = DateTime.now().toUtc();
        await db.into(db.monthlyBudgets).insert(MonthlyBudgetsCompanion.insert(
              id: id,
              userId: userId,
              spaceId: Value(spaceId),
              year: year,
              month: month,
              allocatedAmount: kopecks,
              createdAt: Value(now),
              updatedAt: Value(now),
            ));
      });
}
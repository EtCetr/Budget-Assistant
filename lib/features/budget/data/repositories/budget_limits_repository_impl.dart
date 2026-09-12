import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import '../../domain/entities/budget_limit.dart';
import '../../domain/entities/monthly_pnl.dart';
import '../../domain/repositories/budget_limits_repository.dart';

class BudgetLimitsRepositoryImpl implements BudgetLimitsRepository {
  final AppDatabase _db;
  final Logger _logger;

  BudgetLimitsRepositoryImpl({required AppDatabase db, required Logger logger})
    : _db = db,
      _logger = logger;

  @override
  Future<List<BudgetLimit>> getForMonth({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  }) async {
    try {
      final rows = await _db.budgetLimitsDao.getForMonth(
        userId: userId,
        spaceId: spaceId,
        year: year,
        month: month,
      );
      return rows.map(_fromDb).toList();
    } catch (e, stack) {
      _logger.e(
        'Failed to get budget limits for month',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Stream<List<BudgetLimit>> watchForMonth({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  }) {
    return _db.budgetLimitsDao
        .watchForMonth(
          userId: userId,
          spaceId: spaceId,
          year: year,
          month: month,
        )
        .map((rows) => rows.map(_fromDb).toList());
  }

  @override
  Future<BudgetLimit?> getById(String id) async {
    try {
      final row = await _db.budgetLimitsDao.getById(id);
      return row == null ? null : _fromDb(row);
    } catch (e, stack) {
      _logger.e(
        'Failed to get budget limit by id',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<BudgetLimit?> getForCategory({
    required String userId,
    String? spaceId,
    required String categoryId,
    required int year,
    required int month,
  }) async {
    try {
      final row = await _db.budgetLimitsDao.getForCategory(
        userId: userId,
        spaceId: spaceId,
        categoryId: categoryId,
        year: year,
        month: month,
      );
      return row == null ? null : _fromDb(row);
    } catch (e, stack) {
      _logger.e(
        'Failed to get budget limit for category',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<Result<BudgetLimit>> upsert(BudgetLimit limit) async {
    try {
      final companion = _toCompanion(limit);
      await _db.budgetLimitsDao.upsert(companion);
      return Success(limit);
    } catch (e, stack) {
      _logger.e('Failed to upsert budget limit', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString(), stack));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _db.budgetLimitsDao.deleteById(id);
      return const Success(null);
    } catch (e, stack) {
      _logger.e('Failed to delete budget limit', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString(), stack));
    }
  }

  @override
  Future<Result<MonthlyPnl>> calculateMonthlyPnl({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
    bool excludeLargeExpenses = false,
  }) async {
    try {
      final localStart = DateTime(year, month, 1);
      final localEnd = DateTime(
        year,
        month + 1,
        1,
      ).subtract(const Duration(seconds: 1));
      final utcStart = localStart.toUtc();
      final utcEnd = localEnd.toUtc();

      final t = _db.transactions;

      Expression<bool> filter =
          t.userId.equals(userId) &
          t.date.isBiggerOrEqualValue(utcStart) &
          t.date.isSmallerOrEqualValue(utcEnd) &
          t.type.equals(TransactionType.transfer.name).not() &
          t.savingsGoalId.isNull() &
          t.isWithdrawal.equals(false) &
          t.auditStatus.equals(AuditStatus.ignored.name).not();

      if (spaceId != null) {
        filter = filter & t.spaceId.equals(spaceId);
      }

      if (excludeLargeExpenses) {
        filter = filter & t.isLargeExpense.equals(false);
      }

      final incomeQuery = _db.selectOnly(t)..addColumns([t.amount.sum()]);
      incomeQuery.where(filter & t.type.equals(TransactionType.income.name));
      final incomeResult = await incomeQuery.getSingle();
      final totalIncome = incomeResult.read(t.amount.sum()) ?? 0;

      final expenseQuery = _db.selectOnly(t)
        ..addColumns([t.amount.sum(), t.id.count()]);
      expenseQuery.where(filter & t.type.equals(TransactionType.expense.name));
      final expenseResult = await expenseQuery.getSingle();
      final totalExpense = expenseResult.read(t.amount.sum()) ?? 0;
      final transactionCount = expenseResult.read(t.id.count()) ?? 0;

      int savingsRate = 0;
      if (totalIncome > 0) {
        savingsRate = ((totalIncome - totalExpense) * 100) ~/ totalIncome;
      }

      return Success(
        MonthlyPnl(
          year: year,
          month: month,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          savingsRate: savingsRate,
          transactionCount: transactionCount,
        ),
      );
    } catch (e, stack) {
      _logger.e('Failed to calculate monthly PnL', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString(), stack));
    }
  }

  @override
  Future<Result<int>> calculateCategoryExpense({
    required String userId,
    String? spaceId,
    required String categoryId,
    required int year,
    required int month,
  }) async {
    try {
      final localStart = DateTime(year, month, 1);
      final localEnd = DateTime(
        year,
        month + 1,
        1,
      ).subtract(const Duration(seconds: 1));
      final utcStart = localStart.toUtc();
      final utcEnd = localEnd.toUtc();

      final t = _db.transactions;

      Expression<bool> filter =
          t.userId.equals(userId) &
          t.date.isBiggerOrEqualValue(utcStart) &
          t.date.isSmallerOrEqualValue(utcEnd) &
          t.type.equals(TransactionType.expense.name) &
          t.customCategoryId.equals(categoryId) &
          t.savingsGoalId.isNull() &
          t.isWithdrawal.equals(false) &
          t.auditStatus.equals(AuditStatus.ignored.name).not();

      if (spaceId != null) {
        filter = filter & t.spaceId.equals(spaceId);
      }

      final query = _db.selectOnly(t)..addColumns([t.amount.sum()]);
      query.where(filter);
      final result = await query.getSingle();
      final total = result.read(t.amount.sum()) ?? 0;

      return Success(total);
    } catch (e, stack) {
      _logger.e(
        'Failed to calculate category expense',
        error: e,
        stackTrace: stack,
      );
      return Error(Failure.database(e.toString(), stack));
    }
  }

  @override
  Stream<int> watchMonthlyTransactionChanges({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  }) {
    try {
      final localStart = DateTime(year, month, 1);
      final localEnd = DateTime(
        year,
        month + 1,
        1,
      ).subtract(const Duration(seconds: 1));
      final utcStart = localStart.toUtc();
      final utcEnd = localEnd.toUtc();

      final t = _db.transactions;

      Expression<bool> filter =
          t.userId.equals(userId) &
          t.date.isBiggerOrEqualValue(utcStart) &
          t.date.isSmallerOrEqualValue(utcEnd) &
          t.type.equals(TransactionType.transfer.name).not() &
          t.savingsGoalId.isNull() &
          t.isWithdrawal.equals(false) &
          t.auditStatus.equals(AuditStatus.ignored.name).not();

      if (spaceId != null) {
        filter = filter & t.spaceId.equals(spaceId);
      }

      final query = _db.selectOnly(t)..addColumns([t.id.count()]);
      query.where(filter);

      // ВАЖНО: возвращаем не агрегат (сумма не меняется при смене категории),
      // а уникальную метку времени. Любая запись в таблицу транзакций
      // (добавление / правка суммы / смена категории / удаление) заставляет
      // Drift перевыполнить запрос, а метка времени гарантирует, что значение
      // будет новым и Riverpod пересчитает зависимые провайдеры.
      return query.watch().map((rows) {
        return DateTime.now().microsecondsSinceEpoch;
      });
    } catch (e, stack) {
      _logger.e(
        'Failed to watch monthly transaction changes',
        error: e,
        stackTrace: stack,
      );
      return Stream.value(0);
    }
  }

  BudgetLimitsCompanion _toCompanion(BudgetLimit limit) {
    return BudgetLimitsCompanion(
      id: Value(limit.id),
      spaceId: Value(limit.spaceId),
      userId: Value(limit.userId),
      categoryId: Value(limit.categoryId),
      year: Value(limit.year),
      month: Value(limit.month),
      limitAmount: Value(limit.limitAmount),
      alertPercent: Value(limit.alertPercent),
      alertAmount: Value(limit.alertAmount),
      createdAt: Value(limit.createdAt),
      updatedAt: Value(limit.updatedAt),
      syncStatus: Value(limit.syncStatus),
    );
  }

  BudgetLimit _fromDb(BudgetLimitDb db) {
    return BudgetLimit(
      id: db.id,
      spaceId: db.spaceId,
      userId: db.userId,
      categoryId: db.categoryId,
      year: db.year,
      month: db.month,
      limitAmount: db.limitAmount,
      alertPercent: db.alertPercent,
      alertAmount: db.alertAmount,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: db.syncStatus,
    );
  }
}

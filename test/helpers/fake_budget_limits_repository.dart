import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/budget/domain/entities/budget_limit.dart';
import 'package:budget_assistant/features/budget/domain/entities/monthly_pnl.dart';
import 'package:budget_assistant/features/budget/domain/repositories/budget_limits_repository.dart';

/// Этап 24: заглушка репозитория лимитов для доменных тестов.
/// Деньги — целые копейки, даты — UTC.
class FakeBudgetLimitsRepository implements BudgetLimitsRepository {
  final List<BudgetLimit> limits = <BudgetLimit>[];
  final Map<String, int> categoryExpenses = <String, int>{};

  int pnlIncome = 0;
  int pnlExpense = 0;

  /// Если задано — каждый метод бросает эту ошибку.
  Object? error;

  final List<String> calls = <String>[];
  String? lastUserId;
  String? lastSpaceId;
  int? lastYear;
  int? lastMonth;
  bool? lastExcludeLarge;

  static String key({
    required int year,
    required int month,
    required String categoryId,
  }) =>
      '$year-$month-$categoryId';

  void putLimit({
    required int year,
    required int month,
    required String categoryId,
    required int kopecks,
    int alertPercent = 80,
    int alertAmount = 0,
    String? spaceId,
    String userId = 'u1',
  }) {
    limits.add(BudgetLimit(
      id: 'lim-$year-$month-$categoryId',
      userId: userId,
      spaceId: spaceId,
      categoryId: categoryId,
      year: year,
      month: month,
      limitAmount: kopecks,
      alertPercent: alertPercent,
      alertAmount: alertAmount,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ));
  }

  void putExpense({
    required int year,
    required int month,
    required String categoryId,
    required int kopecks,
  }) {
    categoryExpenses[key(year: year, month: month, categoryId: categoryId)] =
        kopecks;
  }

  void _enter(
    String name, {
    String? userId,
    String? spaceId,
    int? year,
    int? month,
  }) {
    calls.add(name);
    if (userId != null) lastUserId = userId;
    if (spaceId != null) lastSpaceId = spaceId;
    if (year != null) lastYear = year;
    if (month != null) lastMonth = month;
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<List<BudgetLimit>> getForMonth({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  }) async {
    _enter('getForMonth',
        userId: userId, spaceId: spaceId, year: year, month: month);
    return limits
        .where((l) =>
            l.userId == userId &&
            l.spaceId == spaceId &&
            l.year == year &&
            l.month == month)
        .toList();
  }

  @override
  Stream<List<BudgetLimit>> watchForMonth({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  }) =>
      Stream.fromFuture(getForMonth(
        userId: userId,
        spaceId: spaceId,
        year: year,
        month: month,
      ));

  @override
  Future<BudgetLimit?> getById(String id) async {
    _enter('getById');
    for (final l in limits) {
      if (l.id == id) return l;
    }
    return null;
  }

  @override
  Future<BudgetLimit?> getForCategory({
    required String userId,
    String? spaceId,
    required String categoryId,
    required int year,
    required int month,
  }) async {
    _enter('getForCategory',
        userId: userId, spaceId: spaceId, year: year, month: month);
    for (final l in limits) {
      if (l.userId == userId &&
          l.spaceId == spaceId &&
          l.categoryId == categoryId &&
          l.year == year &&
          l.month == month) {
        return l;
      }
    }
    return null;
  }

  @override
  Future<Result<BudgetLimit>> upsert(BudgetLimit limit) async {
    _enter('upsert');
    limits.removeWhere((l) => l.id == limit.id);
    limits.add(limit);
    return Success(limit);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _enter('delete');
    limits.removeWhere((l) => l.id == id);
    return const Success(null);
  }

  @override
  Future<Result<MonthlyPnl>> calculateMonthlyPnl({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
    bool excludeLargeExpenses = false,
  }) async {
    _enter('calculateMonthlyPnl',
        userId: userId, spaceId: spaceId, year: year, month: month);
    lastExcludeLarge = excludeLargeExpenses;
    final rate =
        pnlIncome > 0 ? ((pnlIncome - pnlExpense) * 100) ~/ pnlIncome : 0;
    return Success(MonthlyPnl(
      year: year,
      month: month,
      totalIncome: pnlIncome,
      totalExpense: pnlExpense,
      savingsRate: rate,
      transactionCount: 1,
    ));
  }

  @override
  Future<Result<int>> calculateCategoryExpense({
    required String userId,
    String? spaceId,
    required String categoryId,
    required int year,
    required int month,
  }) async {
    _enter('calculateCategoryExpense',
        userId: userId, spaceId: spaceId, year: year, month: month);
    return Success(
      categoryExpenses[key(year: year, month: month, categoryId: categoryId)] ??
          0,
    );
  }

  @override
  Stream<int> watchMonthlyTransactionChanges({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  }) =>
      const Stream<int>.empty();
}
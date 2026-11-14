import 'package:budget_assistant/features/year_budget/domain/models/year_budget_models.dart';
import 'package:budget_assistant/features/year_budget/domain/repositories/year_budget_repository.dart';

/// Этап 24: ручная заглушка репозитория годового отчёта.
///
/// Нужна там, где проверяется ДОМЕННАЯ математика, а не SQL.
/// Все суммы — целые копейки (DECISIONS: double для денег запрещён).
class FakeYearBudgetRepository implements YearBudgetRepository {
  List<CategoryInfo> scopeCats = <CategoryInfo>[];
  List<CategoryInfo> allCats = <CategoryInfo>[];
  List<YearCatMonthSum> expenseSums = <YearCatMonthSum>[];
  List<YearCatMonthSum> incomeSums = <YearCatMonthSum>[];
  Map<String, Map<int, int>> yearLimits = <String, Map<int, int>>{};
  Map<String, int> monthLimits = <String, int>{};
  List<MonthTxRow> expenseTx = <MonthTxRow>[];
  List<MonthTxRow> incomeTx = <MonthTxRow>[];
  List<int> years = <int>[];
  int? allocatedValue;
  ({int year, int month})? previous;
  int carryOverResult = 0;

  /// Если задано — каждый метод бросает эту ошибку (проверка try/catch + rethrow).
  Object? error;

  final List<String> calls = <String>[];
  String? lastUserId;
  String? lastSpaceId;
  int? lastYear;
  int? lastMonth;
  final List<int> savedAllocated = <int>[];
  final List<({String categoryId, int kopecks})> savedLimits =
      <({String categoryId, int kopecks})>[];

  void _enter(
    String method, {
    String? userId,
    String? spaceId,
    int? year,
    int? month,
  }) {
    calls.add(method);
    if (userId != null) lastUserId = userId;
    if (spaceId != null) lastSpaceId = spaceId;
    if (year != null) lastYear = year;
    if (month != null) lastMonth = month;
    final e = error;
    if (e != null) {
      throw e;
    }
  }

  @override
  Future<List<YearCatMonthSum>> expenseMatrix({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    _enter('expenseMatrix', userId: userId, spaceId: spaceId, year: year);
    return expenseSums;
  }

  @override
  Future<List<YearCatMonthSum>> incomeMatrix({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    _enter('incomeMatrix', userId: userId, spaceId: spaceId, year: year);
    return incomeSums;
  }

  @override
  Future<List<CategoryInfo>> categories({
    required String userId,
    required String? spaceId,
  }) async {
    _enter('categories', userId: userId, spaceId: spaceId);
    return scopeCats;
  }

  @override
  Future<List<CategoryInfo>> allCategories({required String userId}) async {
    _enter('allCategories', userId: userId);
    return allCats;
  }

  @override
  Future<Map<String, Map<int, int>>> limitsYear({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    _enter('limitsYear', userId: userId, spaceId: spaceId, year: year);
    return yearLimits;
  }

  @override
  Future<List<int>> availableYears({
    required String userId,
    required String? spaceId,
  }) async {
    _enter('availableYears', userId: userId, spaceId: spaceId);
    return years;
  }

  @override
  Future<List<MonthTxRow>> monthTransactions({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required String type,
  }) async {
    _enter('monthTransactions',
        userId: userId, spaceId: spaceId, year: year, month: month);
    return type == 'income' ? incomeTx : expenseTx;
  }

  @override
  Future<int?> allocated({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  }) async {
    _enter('allocated',
        userId: userId, spaceId: spaceId, year: year, month: month);
    return allocatedValue;
  }

  @override
  Future<void> saveAllocated({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required int kopecks,
  }) async {
    _enter('saveAllocated',
        userId: userId, spaceId: spaceId, year: year, month: month);
    savedAllocated.add(kopecks);
  }

  @override
  Future<void> saveLimit({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required String categoryId,
    required int kopecks,
  }) async {
    _enter('saveLimit',
        userId: userId, spaceId: spaceId, year: year, month: month);
    savedLimits.add((categoryId: categoryId, kopecks: kopecks));
  }

  @override
  Future<Map<String, int>> limitsForMonth({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  }) async {
    _enter('limitsForMonth',
        userId: userId, spaceId: spaceId, year: year, month: month);
    return monthLimits;
  }

  @override
  Future<({int year, int month})?> previousBudgetMonth({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  }) async {
    _enter('previousBudgetMonth',
        userId: userId, spaceId: spaceId, year: year, month: month);
    return previous;
  }

  @override
  Future<int> carryOver({
    required String userId,
    required String? spaceId,
    required int fromYear,
    required int fromMonth,
    required int toYear,
    required int toMonth,
  }) async {
    _enter('carryOver',
        userId: userId, spaceId: spaceId, year: toYear, month: toMonth);
    return carryOverResult;
  }
}
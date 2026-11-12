import '../models/year_budget_models.dart';

abstract class YearBudgetRepository {
  Future<List<YearCatMonthSum>> expenseMatrix({
    required String userId,
    required String? spaceId,
    required int year,
  });
  Future<List<YearCatMonthSum>> incomeMatrix({
    required String userId,
    required String? spaceId,
    required int year,
  });
  Future<List<CategoryInfo>> categories({
    required String userId,
    required String? spaceId,
  });
  Future<List<CategoryInfo>> allCategories({required String userId});
  Future<Map<String, Map<int, int>>> limitsYear({
    required String userId,
    required String? spaceId,
    required int year,
  });
  Future<List<int>> availableYears({
    required String userId,
    required String? spaceId,
  });
  Future<List<MonthTxRow>> monthTransactions({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required String type,
  });
  Future<int?> allocated({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  });
  Future<void> saveAllocated({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required int kopecks,
  });
  Future<void> saveLimit({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required String categoryId,
    required int kopecks,
  });
  Future<Map<String, int>> limitsForMonth({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  });
  Future<({int year, int month})?> previousBudgetMonth({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  });
  Future<int> carryOver({
    required String userId,
    required String? spaceId,
    required int fromYear,
    required int fromMonth,
    required int toYear,
    required int toMonth,
  });
}
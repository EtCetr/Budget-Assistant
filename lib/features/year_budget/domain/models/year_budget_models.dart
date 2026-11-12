import 'package:freezed_annotation/freezed_annotation.dart';
part 'year_budget_models.freezed.dart';

@freezed
abstract class YearCatMonthSum with _$YearCatMonthSum {
  const factory YearCatMonthSum({
    required String categoryId,
    required int month,
    required int totalKopecks,
  }) = _YearCatMonthSum;
}

@freezed
abstract class CategoryInfo with _$CategoryInfo {
  const factory CategoryInfo({
    required String id,
    required String name,
    required String type,
    String? colorHex,
    String? emoji,
  }) = _CategoryInfo;
}

@freezed
abstract class YearCategoryRow with _$YearCategoryRow {
  const factory YearCategoryRow({
    required String categoryId,
    required String name,
    String? colorHex,
    String? emoji,
    required List<int?> months,
    required int sumKopecks,
    required int avgKopecks,
    required int percentBps,
  }) = _YearCategoryRow;
}

@freezed
abstract class YearCashflowMonth with _$YearCashflowMonth {
  const factory YearCashflowMonth({
    required int month,
    required int? incomeKopecks,
    required int? expenseKopecks,
    required int surplusKopecks,
    required int? percentBps,
  }) = _YearCashflowMonth;
}

@freezed
abstract class YearBudgetData with _$YearBudgetData {
  const factory YearBudgetData({
    required List<YearCategoryRow> limitRows,
    required List<YearCategoryRow> expenseRows,
    required List<YearCategoryRow> incomeRows,
    required List<YearCashflowMonth> cashflow,
    required int totalLimitKopecks,
    required int totalExpenseKopecks,
    required int totalIncomeKopecks,
    required int totalSurplusKopecks,
    required int? surplusPercentBps,
    required List<int> monthsWithData,
  }) = _YearBudgetData;
}

@freezed
abstract class MonthTxRow with _$MonthTxRow {
  const factory MonthTxRow({
    required String id,
    required DateTime dateUtc,
    required String accountName,
    required String categoryName,
    required int amountKopecks,
    String? comment,
    required bool isSplitPosition,
  }) = _MonthTxRow;
}

@freezed
abstract class MonthCategoryRow with _$MonthCategoryRow {
  const factory MonthCategoryRow({
    required String categoryId,
    required String name,
    String? colorHex,
    String? emoji,
    required int sumKopecks,
    required int? limitKopecks,
    required int remainingKopecks,
  }) = _MonthCategoryRow;
}

@freezed
abstract class MonthStatsKey with _$MonthStatsKey {
  const factory MonthStatsKey({
    required int year,
    required int month,
    String? spaceId,
  }) = _MonthStatsKey;
}

@freezed
abstract class MonthStatsData with _$MonthStatsData {
  const factory MonthStatsData({
    required int year,
    required int month,
    required int? allocatedKopecks,
    required int? unallocatedKopecks,
    required List<MonthCategoryRow> categories,
    required List<MonthTxRow> expenses,
    required List<MonthTxRow> incomes,
    required int sumExpensesKopecks,
    required int sumIncomesKopecks,
    required int sumLimitsKopecks,
    required int? carryFromYear,
    required int? carryFromMonth,
  }) = _MonthStatsData;
}
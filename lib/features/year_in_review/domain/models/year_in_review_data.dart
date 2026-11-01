import 'package:freezed_annotation/freezed_annotation.dart';

part 'year_in_review_data.freezed.dart';
part 'year_in_review_data.g.dart';

/// Категория в годовых итогах (топ трат / топ кэшбэка).
@freezed
abstract class YearCategoryStat with _$YearCategoryStat {
  const factory YearCategoryStat({
    required String name,
    @Default(0) int amount,
    @Default(0) int percent,
    String? color,
    String? emoji,
  }) = _YearCategoryStat;

  factory YearCategoryStat.fromJson(Map<String, dynamic> json) =>
      _$YearCategoryStatFromJson(json);
}

/// DTO годовых итогов. Все суммы — копейки в базовой валюте (копеечная
/// точность, конвертация на этапе фонового расчёта).
@freezed
abstract class YearInReviewData with _$YearInReviewData {
  const factory YearInReviewData({
    @Default(0) int year,
    @Default(false) bool isFamily,
    @Default('') String baseCurrency,
    @Default(0) int totalIncome,
    @Default(0) int totalExpense,
    /// null = нет данных за прошлый год («первый год»).
    int? incomeGrowthPercent,
    int? mostGenerousMonth,
    String? mostGenerousDay,
    @Default(0) int mostGenerousDayAmount,
    @Default([]) List<YearCategoryStat> topCategories,
    /// Нет точного курса хотя бы по одной операции.
    @Default(false) bool hasStaleRates,
    /// Нетто-переводы на инвест-счета (тип 'investment_broker').
    @Default(0) int netInvested,
    @Default(0) int totalSaved,
    @Default(0) int goalsCompleted,
    @Default(0) int goalsTotal,
    @Default(0) int cashbackTotal,
    String? cashbackBestCategory,
    @Default([]) List<YearCategoryStat> cashbackTop,
    @Default(0) int familyTotalExpense,
    @Default(0) int familyMyPercent,
    /// Секретные траты в семье: общей строкой, без детализации (6.3.37.8).
    @Default(0) int familySecretTotal,
    @Default(0) int subscriptionsTotal,
    String? subscriptionsMostExpensive,
    @Default(0) int savingsRate,
    @Default(0) int transactionCount,
    /// Месяц первой транзакции (для слайда «мало данных»).
    int? firstBudgetMonth,
  }) = _YearInReviewData;

  factory YearInReviewData.fromJson(Map<String, dynamic> json) =>
      _$YearInReviewDataFromJson(json);
}
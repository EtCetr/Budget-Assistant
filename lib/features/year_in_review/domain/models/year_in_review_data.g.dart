// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_in_review_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YearCategoryStat _$YearCategoryStatFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_YearCategoryStat', json, ($checkedConvert) {
      final val = _YearCategoryStat(
        name: $checkedConvert('name', (v) => v as String),
        amount: $checkedConvert('amount', (v) => (v as num?)?.toInt() ?? 0),
        percent: $checkedConvert('percent', (v) => (v as num?)?.toInt() ?? 0),
        color: $checkedConvert('color', (v) => v as String?),
        emoji: $checkedConvert('emoji', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$YearCategoryStatToJson(_YearCategoryStat instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'percent': instance.percent,
      'color': instance.color,
      'emoji': instance.emoji,
    };

_YearInReviewData _$YearInReviewDataFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_YearInReviewData', json, ($checkedConvert) {
  final val = _YearInReviewData(
    year: $checkedConvert('year', (v) => (v as num?)?.toInt() ?? 0),
    isFamily: $checkedConvert('isFamily', (v) => v as bool? ?? false),
    baseCurrency: $checkedConvert('baseCurrency', (v) => v as String? ?? ''),
    totalIncome: $checkedConvert(
      'totalIncome',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    totalExpense: $checkedConvert(
      'totalExpense',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    incomeGrowthPercent: $checkedConvert(
      'incomeGrowthPercent',
      (v) => (v as num?)?.toInt(),
    ),
    mostGenerousMonth: $checkedConvert(
      'mostGenerousMonth',
      (v) => (v as num?)?.toInt(),
    ),
    mostGenerousDay: $checkedConvert('mostGenerousDay', (v) => v as String?),
    mostGenerousDayAmount: $checkedConvert(
      'mostGenerousDayAmount',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    topCategories: $checkedConvert(
      'topCategories',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => YearCategoryStat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
    hasStaleRates: $checkedConvert('hasStaleRates', (v) => v as bool? ?? false),
    netInvested: $checkedConvert(
      'netInvested',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    totalSaved: $checkedConvert('totalSaved', (v) => (v as num?)?.toInt() ?? 0),
    goalsCompleted: $checkedConvert(
      'goalsCompleted',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    goalsTotal: $checkedConvert('goalsTotal', (v) => (v as num?)?.toInt() ?? 0),
    cashbackTotal: $checkedConvert(
      'cashbackTotal',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    cashbackBestCategory: $checkedConvert(
      'cashbackBestCategory',
      (v) => v as String?,
    ),
    cashbackTop: $checkedConvert(
      'cashbackTop',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => YearCategoryStat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
    familyTotalExpense: $checkedConvert(
      'familyTotalExpense',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    familyMyPercent: $checkedConvert(
      'familyMyPercent',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    familySecretTotal: $checkedConvert(
      'familySecretTotal',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    subscriptionsTotal: $checkedConvert(
      'subscriptionsTotal',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    subscriptionsMostExpensive: $checkedConvert(
      'subscriptionsMostExpensive',
      (v) => v as String?,
    ),
    savingsRate: $checkedConvert(
      'savingsRate',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    transactionCount: $checkedConvert(
      'transactionCount',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    firstBudgetMonth: $checkedConvert(
      'firstBudgetMonth',
      (v) => (v as num?)?.toInt(),
    ),
  );
  return val;
});

Map<String, dynamic> _$YearInReviewDataToJson(_YearInReviewData instance) =>
    <String, dynamic>{
      'year': instance.year,
      'isFamily': instance.isFamily,
      'baseCurrency': instance.baseCurrency,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'incomeGrowthPercent': instance.incomeGrowthPercent,
      'mostGenerousMonth': instance.mostGenerousMonth,
      'mostGenerousDay': instance.mostGenerousDay,
      'mostGenerousDayAmount': instance.mostGenerousDayAmount,
      'topCategories': instance.topCategories.map((e) => e.toJson()).toList(),
      'hasStaleRates': instance.hasStaleRates,
      'netInvested': instance.netInvested,
      'totalSaved': instance.totalSaved,
      'goalsCompleted': instance.goalsCompleted,
      'goalsTotal': instance.goalsTotal,
      'cashbackTotal': instance.cashbackTotal,
      'cashbackBestCategory': instance.cashbackBestCategory,
      'cashbackTop': instance.cashbackTop.map((e) => e.toJson()).toList(),
      'familyTotalExpense': instance.familyTotalExpense,
      'familyMyPercent': instance.familyMyPercent,
      'familySecretTotal': instance.familySecretTotal,
      'subscriptionsTotal': instance.subscriptionsTotal,
      'subscriptionsMostExpensive': instance.subscriptionsMostExpensive,
      'savingsRate': instance.savingsRate,
      'transactionCount': instance.transactionCount,
      'firstBudgetMonth': instance.firstBudgetMonth,
    };

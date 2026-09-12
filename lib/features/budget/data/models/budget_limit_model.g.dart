// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_limit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetLimitModel _$BudgetLimitModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_BudgetLimitModel', json, ($checkedConvert) {
  final val = _BudgetLimitModel(
    id: $checkedConvert('id', (v) => v as String),
    spaceId: $checkedConvert('spaceId', (v) => v as String?),
    userId: $checkedConvert('userId', (v) => v as String),
    categoryId: $checkedConvert('categoryId', (v) => v as String),
    year: $checkedConvert('year', (v) => (v as num).toInt()),
    month: $checkedConvert('month', (v) => (v as num).toInt()),
    limitAmount: $checkedConvert('limitAmount', (v) => (v as num).toInt()),
    alertPercent: $checkedConvert(
      'alertPercent',
      (v) => (v as num?)?.toInt() ?? 80,
    ),
    alertAmount: $checkedConvert(
      'alertAmount',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$BudgetLimitModelToJson(_BudgetLimitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'spaceId': instance.spaceId,
      'userId': instance.userId,
      'categoryId': instance.categoryId,
      'year': instance.year,
      'month': instance.month,
      'limitAmount': instance.limitAmount,
      'alertPercent': instance.alertPercent,
      'alertAmount': instance.alertAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountModel _$AccountModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_AccountModel', json, ($checkedConvert) {
  final val = _AccountModel(
    id: $checkedConvert('id', (v) => v as String),
    userId: $checkedConvert('userId', (v) => v as String),
    spaceId: $checkedConvert('spaceId', (v) => v as String?),
    bankName: $checkedConvert('bankName', (v) => v as String),
    customName: $checkedConvert('customName', (v) => v as String),
    cardNumberMask: $checkedConvert('cardNumberMask', (v) => v as String?),
    accountType: $checkedConvert('accountType', (v) => v as String),
    currency: $checkedConvert('currency', (v) => v as String),
    currentBalance: $checkedConvert(
      'currentBalance',
      (v) => (v as num).toInt(),
    ),
    creditLimit: $checkedConvert('creditLimit', (v) => (v as num?)?.toInt()),
    gracePeriodEnd: $checkedConvert(
      'gracePeriodEnd',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    minPaymentAmount: $checkedConvert(
      'minPaymentAmount',
      (v) => (v as num?)?.toInt(),
    ),
    includeInPersonalBalance: $checkedConvert(
      'includeInPersonalBalance',
      (v) => v as bool? ?? true,
    ),
    includeInFamilyBalance: $checkedConvert(
      'includeInFamilyBalance',
      (v) => v as bool? ?? false,
    ),
    isSharedBalance: $checkedConvert(
      'isSharedBalance',
      (v) => v as bool? ?? false,
    ),
    isSharedExpenses: $checkedConvert(
      'isSharedExpenses',
      (v) => v as bool? ?? false,
    ),
    expenseDetailLevel: $checkedConvert(
      'expenseDetailLevel',
      (v) => v as String? ?? 'total_only',
    ),
    isSharedIncomes: $checkedConvert(
      'isSharedIncomes',
      (v) => v as bool? ?? false,
    ),
    incomeDetailLevel: $checkedConvert(
      'incomeDetailLevel',
      (v) => v as String? ?? 'total_only',
    ),
    sortOrder: $checkedConvert('sortOrder', (v) => (v as num?)?.toInt()),
    isArchived: $checkedConvert('isArchived', (v) => v as bool? ?? false),
    isSystem: $checkedConvert('isSystem', (v) => v as bool? ?? false),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$AccountModelToJson(_AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'spaceId': instance.spaceId,
      'bankName': instance.bankName,
      'customName': instance.customName,
      'cardNumberMask': instance.cardNumberMask,
      'accountType': instance.accountType,
      'currency': instance.currency,
      'currentBalance': instance.currentBalance,
      'creditLimit': instance.creditLimit,
      'gracePeriodEnd': instance.gracePeriodEnd?.toIso8601String(),
      'minPaymentAmount': instance.minPaymentAmount,
      'includeInPersonalBalance': instance.includeInPersonalBalance,
      'includeInFamilyBalance': instance.includeInFamilyBalance,
      'isSharedBalance': instance.isSharedBalance,
      'isSharedExpenses': instance.isSharedExpenses,
      'expenseDetailLevel': instance.expenseDetailLevel,
      'isSharedIncomes': instance.isSharedIncomes,
      'incomeDetailLevel': instance.incomeDetailLevel,
      'sortOrder': instance.sortOrder,
      'isArchived': instance.isArchived,
      'isSystem': instance.isSystem,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

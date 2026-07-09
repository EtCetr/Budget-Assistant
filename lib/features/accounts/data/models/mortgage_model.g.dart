// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mortgage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MortgageModel _$MortgageModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MortgageModel', json, ($checkedConvert) {
  final val = _MortgageModel(
    id: $checkedConvert('id', (v) => v as String),
    accountId: $checkedConvert('accountId', (v) => v as String),
    initialLoanAmount: $checkedConvert(
      'initialLoanAmount',
      (v) => (v as num).toInt(),
    ),
    propertyValue: $checkedConvert('propertyValue', (v) => (v as num).toInt()),
    interestRateBps: $checkedConvert(
      'interestRateBps',
      (v) => (v as num).toInt(),
    ),
    remainingTermMonths: $checkedConvert(
      'remainingTermMonths',
      (v) => (v as num).toInt(),
    ),
    monthlyPayment: $checkedConvert(
      'monthlyPayment',
      (v) => (v as num).toInt(),
    ),
    nextPaymentDate: $checkedConvert(
      'nextPaymentDate',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$MortgageModelToJson(_MortgageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'initialLoanAmount': instance.initialLoanAmount,
      'propertyValue': instance.propertyValue,
      'interestRateBps': instance.interestRateBps,
      'remainingTermMonths': instance.remainingTermMonths,
      'monthlyPayment': instance.monthlyPayment,
      'nextPaymentDate': instance.nextPaymentDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

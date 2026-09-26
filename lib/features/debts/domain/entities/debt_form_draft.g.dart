// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_form_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtFormDraft _$DebtFormDraftFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DebtFormDraft', json, ($checkedConvert) {
      final val = _DebtFormDraft(
        debtId: $checkedConvert('debtId', (v) => v as String?),
        debtType: $checkedConvert('debtType', (v) => v as String? ?? 'payable'),
        counterpartyType: $checkedConvert(
          'counterpartyType',
          (v) => v as String? ?? 'family_member',
        ),
        selectedMemberIds: $checkedConvert(
          'selectedMemberIds',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
        ),
        externalNameDative: $checkedConvert(
          'externalNameDative',
          (v) => v as String? ?? '',
        ),
        amount: $checkedConvert('amount', (v) => (v as num?)?.toInt()),
        currency: $checkedConvert('currency', (v) => v as String? ?? 'RUB'),
        categoryId: $checkedConvert('categoryId', (v) => v as String?),
        description: $checkedConvert('description', (v) => v as String? ?? ''),
        dueDate: $checkedConvert(
          'dueDate',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        originalTransactionId: $checkedConvert(
          'originalTransactionId',
          (v) => v as String?,
        ),
        splitId: $checkedConvert('splitId', (v) => v as String?),
        autoResolveOnLink: $checkedConvert(
          'autoResolveOnLink',
          (v) => v as bool? ?? true,
        ),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DebtFormDraftToJson(_DebtFormDraft instance) =>
    <String, dynamic>{
      'debtId': instance.debtId,
      'debtType': instance.debtType,
      'counterpartyType': instance.counterpartyType,
      'selectedMemberIds': instance.selectedMemberIds,
      'externalNameDative': instance.externalNameDative,
      'amount': instance.amount,
      'currency': instance.currency,
      'categoryId': instance.categoryId,
      'description': instance.description,
      'dueDate': instance.dueDate?.toIso8601String(),
      'originalTransactionId': instance.originalTransactionId,
      'splitId': instance.splitId,
      'autoResolveOnLink': instance.autoResolveOnLink,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

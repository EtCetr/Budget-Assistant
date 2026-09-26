// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_position_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SplitPositionDraft _$SplitPositionDraftFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SplitPositionDraft', json, ($checkedConvert) {
      final val = _SplitPositionDraft(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String? ?? ''),
        amount: $checkedConvert('amount', (v) => (v as num?)?.toInt() ?? 0),
        categoryId: $checkedConvert('categoryId', (v) => v as String?),
        description: $checkedConvert('description', (v) => v as String?),
        fromOcr: $checkedConvert('fromOcr', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$SplitPositionDraftToJson(_SplitPositionDraft instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'description': instance.description,
      'fromOcr': instance.fromOcr,
    };

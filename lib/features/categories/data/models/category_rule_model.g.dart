// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryRuleModel _$CategoryRuleModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_CategoryRuleModel', json, ($checkedConvert) {
  final val = _CategoryRuleModel(
    id: $checkedConvert('id', (v) => v as String),
    spaceId: $checkedConvert('spaceId', (v) => v as String?),
    userId: $checkedConvert('userId', (v) => v as String),
    bankName: $checkedConvert('bankName', (v) => v as String),
    triggerString: $checkedConvert('triggerString', (v) => v as String),
    targetCategoryId: $checkedConvert('targetCategoryId', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$CategoryRuleModelToJson(_CategoryRuleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'spaceId': instance.spaceId,
      'userId': instance.userId,
      'bankName': instance.bankName,
      'triggerString': instance.triggerString,
      'targetCategoryId': instance.targetCategoryId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

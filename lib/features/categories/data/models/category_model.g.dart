// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_CategoryModel', json, ($checkedConvert) {
  final val = _CategoryModel(
    id: $checkedConvert('id', (v) => v as String),
    spaceId: $checkedConvert('spaceId', (v) => v as String?),
    userId: $checkedConvert('userId', (v) => v as String),
    parentId: $checkedConvert('parentId', (v) => v as String?),
    name: $checkedConvert('name', (v) => v as String),
    type: $checkedConvert('type', (v) => v as String),
    iconEmoji: $checkedConvert('iconEmoji', (v) => v as String?),
    colorHex: $checkedConvert('colorHex', (v) => v as String?),
    isPinnedForCashback: $checkedConvert(
      'isPinnedForCashback',
      (v) => v as bool? ?? false,
    ),
    isSystem: $checkedConvert('isSystem', (v) => v as bool? ?? false),
    sortOrder: $checkedConvert('sortOrder', (v) => (v as num?)?.toInt()),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'spaceId': instance.spaceId,
      'userId': instance.userId,
      'parentId': instance.parentId,
      'name': instance.name,
      'type': instance.type,
      'iconEmoji': instance.iconEmoji,
      'colorHex': instance.colorHex,
      'isPinnedForCashback': instance.isPinnedForCashback,
      'isSystem': instance.isSystem,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

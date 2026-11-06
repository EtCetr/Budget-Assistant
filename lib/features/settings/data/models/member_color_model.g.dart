// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_color_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberColorModel _$MemberColorModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MemberColorModel', json, ($checkedConvert) {
  final val = _MemberColorModel(
    id: $checkedConvert('id', (v) => v as String),
    userId: $checkedConvert('userId', (v) => v as String),
    spaceId: $checkedConvert('spaceId', (v) => v as String? ?? ''),
    customColorHex: $checkedConvert('customColorHex', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$MemberColorModelToJson(_MemberColorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'spaceId': instance.spaceId,
      'customColorHex': instance.customColorHex,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

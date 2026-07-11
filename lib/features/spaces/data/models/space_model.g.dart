// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpaceModel _$SpaceModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_SpaceModel', json, ($checkedConvert) {
  final val = _SpaceModel(
    id: $checkedConvert('id', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    encryptionSalt: $checkedConvert('encryptionSalt', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String? ?? 'active'),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$SpaceModelToJson(_SpaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'encryptionSalt': instance.encryptionSalt,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

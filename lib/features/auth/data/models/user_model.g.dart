// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_UserModel', json, ($checkedConvert) {
  final val = _UserModel(
    id: $checkedConvert('id', (v) => v as String),
    displayName: $checkedConvert('displayName', (v) => v as String),
    email: $checkedConvert('email', (v) => v as String),
    displayNameDative: $checkedConvert(
      'displayNameDative',
      (v) => v as String?,
    ),
    avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'email': instance.email,
      'displayNameDative': instance.displayNameDative,
      'avatarUrl': instance.avatarUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

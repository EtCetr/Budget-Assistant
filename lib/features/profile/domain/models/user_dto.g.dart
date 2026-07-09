// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_UserDto', json, ($checkedConvert) {
  final val = _UserDto(
    id: $checkedConvert('id', (v) => v as String),
    email: $checkedConvert('email', (v) => v as String),
    displayName: $checkedConvert('displayName', (v) => v as String),
    displayNameDative: $checkedConvert(
      'displayNameDative',
      (v) => v as String?,
    ),
    avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'displayNameDative': instance.displayNameDative,
  'avatarUrl': instance.avatarUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'syncStatus': instance.syncStatus,
};

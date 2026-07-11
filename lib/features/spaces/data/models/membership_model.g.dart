// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MembershipModel _$MembershipModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MembershipModel', json, ($checkedConvert) {
  final val = _MembershipModel(
    id: $checkedConvert('id', (v) => v as String),
    userId: $checkedConvert('userId', (v) => v as String),
    spaceId: $checkedConvert('spaceId', (v) => v as String),
    role: $checkedConvert('role', (v) => v as String? ?? 'member'),
    status: $checkedConvert('status', (v) => v as String? ?? 'active'),
    lastActiveAt: $checkedConvert(
      'lastActiveAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    joinedAt: $checkedConvert('joinedAt', (v) => DateTime.parse(v as String)),
    leftAt: $checkedConvert(
      'leftAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$MembershipModelToJson(_MembershipModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'spaceId': instance.spaceId,
      'role': instance.role,
      'status': instance.status,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'joinedAt': instance.joinedAt.toIso8601String(),
      'leftAt': instance.leftAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': instance.syncStatus,
    };

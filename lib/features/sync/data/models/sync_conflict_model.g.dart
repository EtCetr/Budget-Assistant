// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_conflict_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncConflictModel _$SyncConflictModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SyncConflictModel', json, ($checkedConvert) {
      final val = _SyncConflictModel(
        id: $checkedConvert('id', (v) => v as String),
        entityType: $checkedConvert('entityType', (v) => v as String),
        entityId: $checkedConvert('entityId', (v) => v as String),
        localValue: $checkedConvert('localValue', (v) => v as String),
        remoteValue: $checkedConvert('remoteValue', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        resolvedAt: $checkedConvert(
          'resolvedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        resolution: $checkedConvert('resolution', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SyncConflictModelToJson(_SyncConflictModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'localValue': instance.localValue,
      'remoteValue': instance.remoteValue,
      'createdAt': instance.createdAt.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'resolution': instance.resolution,
    };

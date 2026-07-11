// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncLogModel _$SyncLogModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SyncLogModel', json, ($checkedConvert) {
      final val = _SyncLogModel(
        id: $checkedConvert('id', (v) => v as String),
        userId: $checkedConvert('userId', (v) => v as String),
        timestamp: $checkedConvert(
          'timestamp',
          (v) => DateTime.parse(v as String),
        ),
        status: $checkedConvert('status', (v) => v as String),
        errorMessage: $checkedConvert('errorMessage', (v) => v as String?),
        entitiesSyncedCount: $checkedConvert(
          'entitiesSyncedCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$SyncLogModelToJson(_SyncLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': instance.status,
      'errorMessage': instance.errorMessage,
      'entitiesSyncedCount': instance.entitiesSyncedCount,
    };

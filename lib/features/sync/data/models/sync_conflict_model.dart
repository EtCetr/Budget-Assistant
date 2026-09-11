import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_conflict_model.freezed.dart';
part 'sync_conflict_model.g.dart';

@freezed
abstract class SyncConflictModel with _$SyncConflictModel {
  const factory SyncConflictModel({
    required String id,
    required String entityType, // accounts, settings и т.д.
    required String entityId,
    required String localValue, // [E2E] JSON
    required String remoteValue, // [E2E] JSON
    required DateTime createdAt,
    DateTime? resolvedAt,
    String? resolution, // local | remote | merged
  }) = _SyncConflictModel;

  factory SyncConflictModel.fromJson(Map<String, dynamic> json) =>
      _$SyncConflictModelFromJson(json);
}

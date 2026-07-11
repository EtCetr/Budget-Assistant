import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_log_model.freezed.dart';
part 'sync_log_model.g.dart';

@freezed
abstract class SyncLogModel with _$SyncLogModel {
  const factory SyncLogModel({
    required String id,
    required String userId,
    required DateTime timestamp,
    required String status, // success | partial | failed
    String? errorMessage,
    @Default(0) int entitiesSyncedCount,
  }) = _SyncLogModel;

  factory SyncLogModel.fromJson(Map<String, dynamic> json) =>
      _$SyncLogModelFromJson(json);
}

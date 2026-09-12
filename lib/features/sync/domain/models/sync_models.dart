import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_models.freezed.dart';

enum SyncTrigger { manual, pullToRefresh, background }

@freezed
abstract class SyncPendingRow with _$SyncPendingRow {
  const factory SyncPendingRow({
    required String id,
    required Map<String, Object?> raw,
    DateTime? updatedAt,
    String? spaceId,
  }) = _SyncPendingRow;
}

@freezed
abstract class SyncBatchSummary with _$SyncBatchSummary {
  const factory SyncBatchSummary({
    required int pushed,
    required int conflicts,
    required int resolvedByLww,
    required int failed,
    required SyncTrigger trigger,
  }) = _SyncBatchSummary;
}

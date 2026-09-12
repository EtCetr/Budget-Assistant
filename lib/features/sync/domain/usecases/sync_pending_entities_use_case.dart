import 'package:logger/logger.dart';

import 'package:budget_assistant/features/sync/data/crypto/sync_payload_encryptor.dart';
import 'package:budget_assistant/features/sync/data/local/drift_sync_local_source.dart';
import 'package:budget_assistant/features/sync/data/remote/supabase_sync_gateway.dart';
import 'package:budget_assistant/features/sync/data/sync_table_spec.dart';
import 'package:budget_assistant/features/sync/domain/models/sync_models.dart';

class SyncPendingEntitiesUseCase {
  SyncPendingEntitiesUseCase({
    required this.localSource,
    required this.remoteGateway,
    required this.encryptor,
    required this.logger,
    required this.specs,
  });

  final DriftSyncLocalSource localSource;
  final SupabaseSyncGateway remoteGateway;
  final SyncPayloadEncryptor encryptor;
  final Logger logger;
  final List<SyncTableSpec> specs;

  static const int _batchSize = 50;
  static const int _pendingLimitPerEntity = 200;

  Future<SyncBatchSummary> call({
    SyncTrigger trigger = SyncTrigger.manual,
  }) async {
    var pushed = 0;
    var conflicts = 0;
    var resolvedByLww = 0;
    var failed = 0;

    for (final spec in specs) {
      try {
        final pendingRows = await localSource.fetchPending(
          spec,
          limit: _pendingLimitPerEntity,
        );

        if (pendingRows.isEmpty) {
          continue;
        }

        final ids = pendingRows.map((row) => row.id).toList();

        final remoteRows = await _withRetry(
          () =>
              remoteGateway.fetchRemoteRows(table: spec.remoteTable, ids: ids),
          operationName: 'fetchRemoteRows:${spec.remoteTable}',
        );

        final remoteById = <String, Map<String, Object?>>{
          for (final row in remoteRows)
            row[spec.idColumn]?.toString() ?? '': row,
        };

        final rowsToPush = <SyncPendingRow>[];

        for (final localRow in pendingRows) {
          final remoteRow = remoteById[localRow.id];
          final remoteUpdatedAt = _parseDate(remoteRow?[spec.updatedAtColumn]);

          if (_shouldPushLocal(localRow.updatedAt, remoteUpdatedAt)) {
            rowsToPush.add(localRow);
            continue;
          }

          if (spec.entityType == SyncTableSpec.transactions.entityType) {
            final spaceId = localRow.spaceId;

            if (spaceId == null || spaceId.isEmpty) {
              logger.e(
                'LWW remote apply failed: missing spaceId '
                'for transaction ${localRow.id}',
              );
              failed++;
              continue;
            }

            try {
              final decryptedRemote = await encryptor.decryptRow(
                spec: spec,
                remoteRow: remoteRow!,
                spaceId: spaceId,
              );

              await localSource.applyRemoteRow(spec, decryptedRemote);

              await localSource.insertConflict(
                entityType: spec.entityType,
                entityId: localRow.id,
                localValue: _jsonSafe(localRow.raw),
                remoteValue: _jsonSafe(remoteRow),
              );

              resolvedByLww++;
            } catch (e, st) {
              logger.e(
                'LWW remote apply failed for transaction ${localRow.id}',
                error: e,
                stackTrace: st,
              );
              failed++;
            }
          } else {
            await localSource.markConflict(spec, [localRow.id]);

            await localSource.insertConflict(
              entityType: spec.entityType,
              entityId: localRow.id,
              localValue: _jsonSafe(localRow.raw),
              remoteValue: _jsonSafe(remoteRow),
            );

            conflicts++;
          }
        }

        if (rowsToPush.isNotEmpty) {
          final pushResult = await _pushRows(spec: spec, rows: rowsToPush);

          pushed += pushResult.pushed;
          failed += pushResult.failed;
        }
      } catch (e, st) {
        logger.e(
          'Sync entity batch failed for ${spec.entityType}',
          error: e,
          stackTrace: st,
        );
        failed++;
      }
    }

    return SyncBatchSummary(
      pushed: pushed,
      conflicts: conflicts,
      resolvedByLww: resolvedByLww,
      failed: failed,
      trigger: trigger,
    );
  }

  Future<_PushResult> _pushRows({
    required SyncTableSpec spec,
    required List<SyncPendingRow> rows,
  }) async {
    var pushed = 0;
    var failed = 0;

    final groups = <String?, List<SyncPendingRow>>{};

    for (final row in rows) {
      groups.putIfAbsent(row.spaceId, () => []).add(row);
    }

    for (final entry in groups.entries) {
      final spaceId = entry.key;
      final spaceRows = entry.value;

      if (spaceId == null || spaceId.isEmpty) {
        logger.e(
          'Missing spaceId for ${spec.entityType}. '
          'Rows skipped: ${spaceRows.length}',
        );
        failed += spaceRows.length;
        continue;
      }

      final encryptedRows = <Map<String, Object?>>[];

      for (final row in spaceRows) {
        try {
          final encrypted = await encryptor.encryptRow(
            spec: spec,
            row: row.raw,
            spaceId: spaceId,
          );
          encryptedRows.add(encrypted);
        } catch (e, st) {
          logger.e(
            'Encryption failed for ${spec.entityType} ${row.id}',
            error: e,
            stackTrace: st,
          );
          failed++;
        }
      }

      if (encryptedRows.isEmpty) {
        continue;
      }

      for (var i = 0; i < encryptedRows.length; i += _batchSize) {
        final end = i + _batchSize;
        final chunk = encryptedRows.sublist(
          i,
          end > encryptedRows.length ? encryptedRows.length : end,
        );

        try {
          await _withRetry(
            () =>
                remoteGateway.upsertRows(table: spec.remoteTable, rows: chunk),
            operationName: 'upsertRows:${spec.remoteTable}',
          );

          final chunkIds = chunk
              .map((row) => row[spec.idColumn]?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toList();

          await localSource.markSynced(spec, chunkIds);
          pushed += chunkIds.length;
        } catch (e, st) {
          logger.e(
            'Upsert batch failed for ${spec.entityType}',
            error: e,
            stackTrace: st,
          );
          failed += chunk.length;
        }
      }
    }

    return _PushResult(pushed: pushed, failed: failed);
  }

  bool _shouldPushLocal(DateTime? localUpdatedAt, DateTime? remoteUpdatedAt) {
    if (remoteUpdatedAt == null) return true;
    if (localUpdatedAt == null) return false;

    return !localUpdatedAt.isBefore(remoteUpdatedAt);
  }

  Future<T> _withRetry<T>(
    Future<T> Function() operation, {
    required String operationName,
    int maxAttempts = 3,
  }) async {
    var delay = const Duration(seconds: 1);

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await operation();
      } catch (e, st) {
        if (attempt == maxAttempts) {
          rethrow;
        }

        logger.w(
          'Retry $attempt/$maxAttempts for $operationName',
          error: e,
          stackTrace: st,
        );

        await Future<void>.delayed(delay);
        delay *= 2;
      }
    }

    throw StateError('Retry loop failed for $operationName');
  }

  DateTime? _parseDate(Object? value) {
    return DriftSyncLocalSource.parseDate(value);
  }

  Object? _jsonSafe(Object? value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }

    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), _jsonSafe(val)));
    }

    if (value is Iterable) {
      return value.map(_jsonSafe).toList();
    }

    return value;
  }
}

class _PushResult {
  const _PushResult({required this.pushed, required this.failed});

  final int pushed;
  final int failed;
}

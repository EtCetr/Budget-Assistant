import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

import 'package:budget_assistant/features/sync/data/sync_table_spec.dart';
import 'package:budget_assistant/features/sync/domain/models/sync_models.dart';

/// Локальный источник данных для синхронизации.
class DriftSyncLocalSource {
  DriftSyncLocalSource({required this.db, required this.logger});

  final GeneratedDatabase db;
  final Logger logger;

  final Map<String, Set<String>> _columnsCache = {};

  Future<List<SyncPendingRow>> fetchPending(
    SyncTableSpec spec, {
    int limit = 200,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final nowUnix = now.millisecondsSinceEpoch ~/ 1000;

      final variables = <Variable>[Variable.withString('pending')];

      var lockedClause = '';

      if (spec.lockedStartedAtColumn != null &&
          spec.lockedDurationMsColumn != null) {
        lockedClause =
            '''
          AND (
            ${spec.lockedStartedAtColumn} IS NULL
            OR ${spec.lockedDurationMsColumn} IS NULL
            OR (${spec.lockedStartedAtColumn} + ${spec.lockedDurationMsColumn} / 1000) <= ?
          )
        ''';

        variables.add(Variable.withInt(nowUnix));
      }

      variables.add(Variable.withInt(limit));

      final sql =
          '''
        SELECT *
        FROM ${spec.localTable}
        WHERE ${spec.syncStatusColumn} = ?
        $lockedClause
        ORDER BY ${spec.updatedAtColumn} ASC
        LIMIT ?
      ''';

      final rows = await db.customSelect(sql, variables: variables).get();

      return rows
          .map((queryRow) {
            final data = Map<String, Object?>.from(queryRow.data);

            return SyncPendingRow(
              id: data[spec.idColumn]?.toString() ?? '',
              raw: data,
              updatedAt: parseDate(data[spec.updatedAtColumn]),
              spaceId: data[spec.spaceColumn]?.toString(),
            );
          })
          .where((row) => row.id.isNotEmpty)
          .toList();
    } catch (e, st) {
      logger.e(
        'fetchPending failed for ${spec.localTable}',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> markSynced(SyncTableSpec spec, List<String> ids) async {
    if (ids.isEmpty) return;

    try {
      final placeholders = List.filled(ids.length, '?').join(', ');
      final variables = <Variable>[
        Variable.withString('synced'),
        ...ids.map(Variable.withString),
      ];

      await db.customUpdate('''
          UPDATE ${spec.localTable}
          SET ${spec.syncStatusColumn} = ?
          WHERE ${spec.idColumn} IN ($placeholders)
        ''', variables: variables);
    } catch (e, st) {
      logger.e(
        'markSynced failed for ${spec.localTable}',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> markConflict(SyncTableSpec spec, List<String> ids) async {
    if (ids.isEmpty) return;

    try {
      final placeholders = List.filled(ids.length, '?').join(', ');
      final variables = <Variable>[
        Variable.withString('conflict'),
        ...ids.map(Variable.withString),
      ];

      await db.customUpdate('''
          UPDATE ${spec.localTable}
          SET ${spec.syncStatusColumn} = ?
          WHERE ${spec.idColumn} IN ($placeholders)
        ''', variables: variables);
    } catch (e, st) {
      logger.e(
        'markConflict failed for ${spec.localTable}',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> applyRemoteRow(
    SyncTableSpec spec,
    Map<String, Object?> decryptedRemoteRow,
  ) async {
    try {
      final id = decryptedRemoteRow[spec.idColumn]?.toString();
      if (id == null || id.isEmpty) {
        logger.w('applyRemoteRow skipped: empty id');
        return;
      }

      final localColumns = await _getTableColumns(spec.localTable);
      if (localColumns.isEmpty) {
        logger.w('applyRemoteRow skipped: no local columns found');
        return;
      }

      final setClauses = <String>[];
      final variables = <Variable>[];

      decryptedRemoteRow.forEach((column, value) {
        if (column == spec.idColumn) return;
        if (column == spec.syncStatusColumn) return;
        if (!spec.shouldSend(column)) return;
        if (!localColumns.contains(column)) return;

        setClauses.add('$column = ?');
        variables.add(_variable(value));
      });

      if (setClauses.isEmpty) return;

      setClauses.add('${spec.syncStatusColumn} = ?');
      variables.add(Variable.withString('synced'));

      variables.add(Variable.withString(id));

      await db.customUpdate('''
          UPDATE ${spec.localTable}
          SET ${setClauses.join(', ')}
          WHERE ${spec.idColumn} = ?
        ''', variables: variables);
    } catch (e, st) {
      logger.e(
        'applyRemoteRow failed for ${spec.localTable}',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> insertConflict({
    required String entityType,
    required String entityId,
    required Object? localValue,
    required Object? remoteValue,
  }) async {
    try {
      await db.customInsert(
        '''
          INSERT INTO sync_conflicts (
            id,
            entity_type,
            entity_id,
            local_value,
            remote_value,
            created_at
          ) VALUES (?, ?, ?, ?, ?, ?)
        ''',
        variables: [
          Variable.withString(_uuidV4()),
          Variable.withString(entityType),
          Variable.withString(entityId),
          Variable.withString(_encodeJson(localValue)),
          Variable.withString(_encodeJson(remoteValue)),
          Variable.withDateTime(DateTime.now().toUtc()),
        ],
      );
    } catch (e, st) {
      logger.e('insertConflict failed', error: e, stackTrace: st);
    }
  }

  Future<void> writeLog({
    required String userId,
    required String status,
    String? errorMessage,
    int entitiesSyncedCount = 0,
  }) async {
    try {
      if (errorMessage != null) {
        await db.customInsert(
          '''
            INSERT INTO sync_logs (
              id,
              user_id,
              timestamp,
              status,
              error_message,
              entities_synced_count
            ) VALUES (?, ?, ?, ?, ?, ?)
          ''',
          variables: [
            Variable.withString(_uuidV4()),
            Variable.withString(userId),
            Variable.withDateTime(DateTime.now().toUtc()),
            Variable.withString(status),
            Variable.withString(errorMessage),
            Variable.withInt(entitiesSyncedCount),
          ],
        );
      } else {
        await db.customInsert(
          '''
            INSERT INTO sync_logs (
              id,
              user_id,
              timestamp,
              status,
              error_message,
              entities_synced_count
            ) VALUES (?, ?, ?, ?, NULL, ?)
          ''',
          variables: [
            Variable.withString(_uuidV4()),
            Variable.withString(userId),
            Variable.withDateTime(DateTime.now().toUtc()),
            Variable.withString(status),
            Variable.withInt(entitiesSyncedCount),
          ],
        );
      }
    } catch (e, st) {
      logger.w('writeLog failed (non-critical)', error: e, stackTrace: st);
    }
  }

  Future<Set<String>> _getTableColumns(String table) async {
    final cached = _columnsCache[table];
    if (cached != null) return cached;

    try {
      final rows = await db.customSelect('PRAGMA table_info($table)').get();

      final columns = rows
          .map((row) => row.data['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toSet();

      _columnsCache[table] = columns;
      return columns;
    } catch (e, st) {
      logger.e('_getTableColumns failed for $table', error: e, stackTrace: st);
      return {};
    }
  }

  Variable<Object> _variable(Object? value) {
    if (value == null) {
      return Variable.withString('NULL');
    }

    if (value is int) {
      return Variable.withInt(value);
    }

    if (value is bool) {
      return Variable.withBool(value);
    }

    if (value is DateTime) {
      return Variable.withDateTime(value.toUtc());
    }

    return Variable.withString(value.toString());
  }

  String _encodeJson(Object? value) {
    try {
      return jsonEncode(_jsonSafe(value));
    } catch (_) {
      return value.toString();
    }
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

  String _uuidV4() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));

    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    String hex(int value) => value.toRadixString(16).padLeft(2, '0');

    final hexList = bytes.map(hex).join();

    return '${hexList.substring(0, 8)}-'
        '${hexList.substring(8, 12)}-'
        '${hexList.substring(12, 16)}-'
        '${hexList.substring(16, 20)}-'
        '${hexList.substring(20)}';
  }

  static DateTime? parseDate(Object? value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value.toUtc();
    }

    if (value is int) {
      if (value > 1000000000000000) {
        return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true);
      }

      if (value > 1000000000000) {
        return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
      }

      return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
    }

    if (value is String) {
      final direct = DateTime.tryParse(value);
      if (direct != null) return direct.toUtc();

      final withT = DateTime.tryParse(value.replaceFirst(' ', 'T'));
      if (withT != null) return withT.toUtc();
    }

    return null;
  }
}

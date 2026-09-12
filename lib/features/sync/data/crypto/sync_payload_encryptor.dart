import 'package:budget_assistant/core/services/encryption_service.dart';
import 'package:budget_assistant/features/sync/data/sync_table_spec.dart';

/// Шифрует и дешифрует строки/числа в полезных данных сущностей
/// перед отправкой в Supabase.
class SyncPayloadEncryptor {
  const SyncPayloadEncryptor({required this.encryptionService});

  final EncryptionService encryptionService;

  Future<Map<String, Object?>> encryptRow({
    required SyncTableSpec spec,
    required Map<String, Object?> row,
    required String spaceId,
  }) async {
    final out = <String, Object?>{};

    for (final entry in row.entries) {
      final column = entry.key;
      final value = entry.value;

      if (!spec.shouldSend(column)) {
        continue;
      }

      if (spec.isSensitive(column)) {
        if (value == null) {
          out[spec.remoteColumnFor(column)] = null;
          continue;
        }

        try {
          String encrypted;

          if (value is int && spec.numericColumns.contains(column)) {
            encrypted = await encryptionService.encryptInt(value, spaceId);
          } else {
            final plain = value is String ? value : value.toString();
            encrypted = await encryptionService.encryptString(plain, spaceId);
          }

          out[spec.remoteColumnFor(column)] = encrypted;
        } catch (e) {
          throw Exception(
            'Failed to encrypt column $column for ${spec.entityType} ${row[spec.idColumn]}: $e',
          );
        }
      } else {
        out[column] = _toRemoteValue(value);
      }
    }

    out[spec.syncStatusColumn] = 'synced';

    return out;
  }

  Future<Map<String, Object?>> decryptRow({
    required SyncTableSpec spec,
    required Map<String, Object?> remoteRow,
    required String spaceId,
  }) async {
    final out = Map<String, Object?>.from(remoteRow);

    for (final column in spec.sensitiveColumns) {
      final remoteColumn = spec.remoteColumnFor(column);
      final encrypted = remoteRow[remoteColumn] ?? remoteRow[column];

      if (encrypted == null) {
        out[column] = null;
        if (remoteColumn != column) {
          out.remove(remoteColumn);
        }
        continue;
      }

      if (encrypted is! String) {
        out[column] = encrypted;
        if (remoteColumn != column) {
          out.remove(remoteColumn);
        }
        continue;
      }

      try {
        if (spec.numericColumns.contains(column)) {
          out[column] = await encryptionService.decryptInt(encrypted, spaceId);
        } else {
          out[column] = await encryptionService.decryptString(
            encrypted,
            spaceId,
          );
        }
      } catch (e) {
        throw Exception(
          'Failed to decrypt column $column for ${spec.entityType} ${remoteRow[spec.idColumn]}: $e',
        );
      }

      if (remoteColumn != column) {
        out.remove(remoteColumn);
      }
    }

    out[spec.syncStatusColumn] = 'synced';
    return out;
  }

  Object? _toRemoteValue(Object? value) {
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }
    return value;
  }
}

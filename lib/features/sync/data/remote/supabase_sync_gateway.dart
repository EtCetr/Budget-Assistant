import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/errors/sync_exceptions.dart';

/// Gateway для работы с Supabase.
///
/// Этап 24 (D24-12): отсутствие таблицы переводится в доменную ошибку
/// RemoteSchemaMissingException — домен не знает про PostgrestException.
class SupabaseSyncGateway {
  const SupabaseSyncGateway({required this.client});

  final SupabaseClient client;

  /// PGRST205 — таблицы нет в schema cache; 42P01 — relation does not exist.
  static const _schemaMissingCodes = {'PGRST205', '42P01'};

  Future<List<Map<String, Object?>>> fetchRemoteRows({
    required String table,
    required List<String> ids,
  }) async {
    if (ids.isEmpty) return [];
    try {
      final response = await client
          .from(table)
          .select()
          .inFilter('id', ids)
          .limit(ids.length);
      return response.map((row) => Map<String, Object?>.from(row)).toList();
    } on PostgrestException catch (e) {
      if (_schemaMissingCodes.contains(e.code)) {
        throw RemoteSchemaMissingException(table, e.message);
      }
      rethrow;
    }
  }

  Future<void> upsertRows({
    required String table,
    required List<Map<String, Object?>> rows,
  }) async {
    if (rows.isEmpty) return;
    try {
      await client.from(table).upsert(rows, onConflict: 'id');
    } on PostgrestException catch (e) {
      if (_schemaMissingCodes.contains(e.code)) {
        throw RemoteSchemaMissingException(table, e.message);
      }
      rethrow;
    }
  }
}
import 'package:supabase_flutter/supabase_flutter.dart';

/// Gateway для работы с Supabase.
class SupabaseSyncGateway {
  const SupabaseSyncGateway({required this.client});

  final SupabaseClient client;

  Future<List<Map<String, Object?>>> fetchRemoteRows({
    required String table,
    required List<String> ids,
  }) async {
    if (ids.isEmpty) return [];

    final response = await client
        .from(table)
        .select()
        .inFilter('id', ids)
        .limit(ids.length);

    return response.map((row) => Map<String, Object?>.from(row)).toList();
  }

  Future<void> upsertRows({
    required String table,
    required List<Map<String, Object?>> rows,
  }) async {
    if (rows.isEmpty) return;

    await client.from(table).upsert(rows, onConflict: 'id');
  }
}

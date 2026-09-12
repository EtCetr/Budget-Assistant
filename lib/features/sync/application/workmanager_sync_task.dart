import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/sync/application/sync_background_database.dart';
import 'package:budget_assistant/features/sync/application/sync_service.dart';

/// Top-level callback для WorkManager.
@pragma('vm:entry-point')
void syncWorkManagerCallback() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != 'budget_assistant_periodic_sync' &&
        taskName != 'budget_assistant_one_off_sync') {
      return true;
    }

    try {
      WidgetsFlutterBinding.ensureInitialized();

      final storage = SecureStorageService();
      final logger = Logger();

      final supabaseUrl = await storage.read('supabase_url');
      final supabaseAnonKey = await storage.read('supabase_anon_key');

      if (supabaseUrl == null || supabaseAnonKey == null) {
        AppLogger.e(
          'Sync background task failed: missing Supabase config in SecureStorage',
        );
        return false;
      }

      final db = await openSyncDatabaseInBackground();
      final client = SupabaseClient(supabaseUrl, supabaseAnonKey);

      try {
        final syncService = SyncService(
          db: db,
          client: client,
          storage: storage,
          logger: logger,
        );

        final pushed = await syncService.forceSyncNow();

        AppLogger.i('Sync background task completed: pushed=$pushed');

        return true;
      } finally {
        await db.close();
      }
    } catch (e, st) {
      AppLogger.e('Sync background task error', e, st);
      return false;
    }
  });
}

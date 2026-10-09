import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/admin/workers/inactive_admin_check_worker.dart';
import 'package:budget_assistant/features/import/application/clean_import_drafts_task.dart';
import 'package:budget_assistant/features/sync/application/sync_background_database.dart';
import 'package:budget_assistant/features/sync/application/sync_service.dart';

/// Entry point for WorkManager background tasks.
///
/// IMPORTANT: must be a top-level function with @pragma('vm:entry-point'),
/// otherwise WorkManager cannot call it in a separate isolate.
/// Диспетчер ОДИН: маршрутизация по taskName (sync / clean drafts / admin check).
@pragma('vm:entry-point')
void syncWorkManagerCallback() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == InactiveAdminCheckWorker.taskName) {
      return await handleInactiveAdminCheckTask();
    }
    if (taskName == cleanImportDraftsTaskName) {
      return await handleCleanImportDraftsTask();
    }
    if (taskName != 'budget_assistant_periodic_sync' &&
        taskName != 'budget_assistant_one_off_sync') {
      return true;
    }

    // Initialize bindings for background isolate.
    WidgetsFlutterBinding.ensureInitialized();

    final logger = Logger();
    final storage = SecureStorageService();

    final supabaseUrl = await storage.read('supabase_url');
    final supabaseAnonKey = await storage.read('supabase_anon_key');
    if (supabaseUrl == null || supabaseAnonKey == null) {
      logger.w('SyncWorker: Supabase is not configured, skipping sync');
      return true; // Not an error: cloud is simply not connected.
    }

    final client = SupabaseClient(supabaseUrl, supabaseAnonKey);
    final db = await openSyncDatabaseInBackground();

    try {
      final syncService = SyncService(
        db: db,
        client: client,
        logger: logger,
        storage: storage,
      );

      final pushed = await syncService.forceSyncNow();

      // Heartbeat (6.3.33.13 3.a): last_active_at при успешном фоновом sync.
      final uid = await storage.read('current_user_id');
      if (uid != null && uid.isNotEmpty) {
        final epoch = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
        await db.customUpdate(
          "UPDATE memberships SET last_active_at = ?, updated_at = ?, sync_status = 'pending' WHERE user_id = ? AND status = 'active'",
          variables: [
            Variable.withInt(epoch),
            Variable.withInt(epoch),
            Variable.withString(uid),
          ],
        );
      }

      logger.i('SyncWorker: task=$taskName pushed=$pushed');
      return true;
    } catch (e, st) {
      logger.e('SyncWorker: sync error', error: e, stackTrace: st);
      return false; // Will retry per WorkManager backoff policy.
    } finally {
      await db.close();
    }
  });
}
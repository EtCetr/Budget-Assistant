import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'package:budget_assistant/core/services/global_error_handler.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/core/utils/retry_policy.dart';
import 'package:budget_assistant/features/admin/workers/inactive_admin_check_worker.dart';
import 'package:budget_assistant/features/import/application/clean_import_drafts_task.dart';
import 'package:budget_assistant/features/notifications/application/notification_triggers_task.dart';
import 'package:budget_assistant/features/year_in_review/application/yearly_aggregates_task.dart';
import 'package:budget_assistant/features/sync/application/sync_background_database.dart';
import 'package:budget_assistant/features/sync/application/sync_service.dart';

/// Entry point for WorkManager background tasks.
///
/// IMPORTANT: must be a top-level function with @pragma('vm:entry-point'),
/// otherwise WorkManager cannot call it in a separate isolate.
/// Диспетчеризация по taskName (sync / clean drafts / admin check / пуши / YIR).
@pragma('vm:entry-point')
void syncWorkManagerCallback() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == InactiveAdminCheckWorker.taskName) {
      return await handleInactiveAdminCheckTask();
    }
    if (taskName == cleanImportDraftsTaskName) {
      return await handleCleanImportDraftsTask();
    }
    if (taskName == notificationTriggersTaskName) {
      return await handleNotificationTriggersTask();
    }
    if (taskName == yearlyAggregatesTaskName) {
      return await handleYearlyAggregatesTask();
    }
    if (taskName != 'budget_assistant_periodic_sync' &&
        taskName != 'budget_assistant_one_off_sync') {
      return true;
    }

    // Этап 23: синк в защищённой зоне — исключение никогда не вылетает
    // в WorkManager без логирования.
    return await GlobalErrorHandler.runGuardedBackground(() async {
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
        // Этап 23: экспоненциальный бэкофф (2с -> 4с, джиттер +/-20%).
        const retry = RetryPolicy.network;
        final pushed = await retry.run<int>(
          () => syncService.forceSyncNow(),
          label: 'background_sync',
        );
        // Heartbeat (6.3.33.13 3.a): last_active_at при успешном синке.
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
  });
}
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:budget_assistant/features/admin/workers/inactive_admin_check_worker.dart';
import 'package:budget_assistant/features/notifications/application/notification_triggers_task.dart';
import 'package:budget_assistant/features/year_in_review/application/yearly_aggregates_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/app.dart';
import 'package:budget_assistant/core/bootstrap/app_bootstrap_flags.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/performance/drift_query_explainer.dart';
import 'package:budget_assistant/core/services/global_error_handler.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/sync/application/sync_providers.dart';
import 'package:budget_assistant/features/sync/application/sync_scheduler.dart';
import 'package:budget_assistant/features/sync/application/sync_service.dart';

Future<void> main() async {
  GlobalErrorHandler.runWithGuard(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
    Intl.defaultLocale = 'ru';

    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://YOUR-PROJECT.supabase.co',
    );
    const supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'YOUR-ANON-KEY',
    );

    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );

    final storage = SecureStorageService();
    final pendingRoute = await storage.read('pending_deep_link');
    if (pendingRoute != null && pendingRoute.isNotEmpty) {
      await storage.delete('pending_deep_link');
      AppBootstrapFlags.pendingDeepLink = pendingRoute;
    }
    await storage.write('supabase_url', supabaseUrl);
    await storage.write('supabase_anon_key', supabaseAnonKey);

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId != null) {
      await storage.write('current_user_id', currentUserId);
    }

    AppLogger.i('App bootstrap completed successfully');

    final db = AppDatabase();
    await db.customSelect('SELECT 1').get();

    // Этап 18: локально добиваем пользователя email-ом из Supabase Auth.
    if (currentUserId != null) {
      try {
        final email = Supabase.instance.client.auth.currentUser?.email ?? '';
        final epoch = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
        await db.customInsert(
          'INSERT OR IGNORE INTO users '
          '(id, email, display_name, created_at, updated_at, sync_status) '
          "VALUES (?, ?, '', ?, ?, 'pending')",
          variables: [
            Variable.withString(currentUserId),
            Variable.withString(email),
            Variable.withInt(epoch),
            Variable.withInt(epoch),
          ],
        );
        await db.customUpdate(
          'UPDATE users SET email = ?, updated_at = ? '
          "WHERE id = ? AND (email = '' OR email IS NULL)",
          variables: [
            Variable.withString(email),
            Variable.withInt(epoch),
            Variable.withString(currentUserId),
          ],
        );
      } catch (e, st) {
        AppLogger.e('Failed to backfill local user email', e, st);
      }
    }

    // Этап 23: аудит горячих запросов (только debug + PERF_EXPLAIN=true).
    if (kDebugMode && const bool.fromEnvironment('PERF_EXPLAIN')) {
      try {
        await DriftQueryExplainer.audit(db);
      } catch (e, st) {
        AppLogger.e('Drift query audit failed', e, st);
      }
    }

    try {
      final flag = await storage.read('onboarding_completed');
      String status = 'not_started';
      if (flag == 'true') {
        status = 'completed';
      } else {
        final row = await db
            .customSelect('SELECT COUNT(*) AS c FROM accounts')
            .getSingle();
        if (row.read<int>('c') > 0) status = 'completed';
      }
      AppBootstrapFlags.onboardingStatus = status;
      AppLogger.i('Onboarding status at boot: $status');
    } catch (e, st) {
      AppLogger.e('Failed to read onboarding flag', e, st);
      AppBootstrapFlags.onboardingStatus = 'not_started';
    }

    final logger = Logger();

    runApp(
      ProviderScope(
        overrides: [
          syncDatabaseProvider.overrideWithValue(db),
          supabaseSyncClientProvider.overrideWithValue(
            Supabase.instance.client,
          ),
          syncStorageProvider.overrideWithValue(storage),
          syncServiceProvider.overrideWithValue(
            SyncService(
              db: db,
              client: Supabase.instance.client,
              storage: storage,
              logger: logger,
            ),
          ),
        ],
        child: const BudgetAssistantApp(),
      ),
    );

    // Этап 24 (D24-11): фоновые задачи регистрируются ПОСЛЕ runApp.
    // Раньше четыре платформенных вызова шли до первого кадра — приложение
    // не успевало отрисоваться, Android показывал «приложение не отвечает».
    unawaited(_registerBackgroundWorkers());
  });
}

/// Регистрация WorkManager-задач. Ошибка одной не мешает остальным.
Future<void> _registerBackgroundWorkers() async {
  try {
    await SyncScheduler.ensureRegistered();
    AppLogger.i('WorkManager initialized');
  } catch (e, st) {
    AppLogger.e('Failed to initialize WorkManager', e, st);
  }
  try {
    await InactiveAdminCheckWorker.register();
  } catch (e, st) {
    AppLogger.e('Failed to register InactiveAdminCheckWorker', e, st);
  }
  try {
    await NotificationTriggersWorker.register();
  } catch (e, st) {
    AppLogger.e('Failed to register NotificationTriggersWorker', e, st);
  }
  try {
    await YearlyAggregatesWorker.register();
  } catch (e, st) {
    AppLogger.e('Failed to register YearlyAggregatesWorker', e, st);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:budget_assistant/app.dart';
import 'package:budget_assistant/core/bootstrap/app_bootstrap_flags.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
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

    // Сохраняем ключи Supabase в SecureStorage для WorkManager
    final storage = SecureStorageService();
    await storage.write('supabase_url', supabaseUrl);
    await storage.write('supabase_anon_key', supabaseAnonKey);

    AppLogger.i('App bootstrap completed successfully');
    AppLogger.i('🚀 Forcing DB initialization...');

    final db = AppDatabase();
    await db.customSelect('SELECT 1').get();
    AppLogger.i('✅ DB initialized successfully');

    // Флаг онбординга
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
      AppLogger.i('🚦 Onboarding status at boot: $status');
    } catch (e, st) {
      AppLogger.e('Failed to read onboarding flag', e, st);
      AppBootstrapFlags.onboardingStatus = 'not_started';
    }

    // Инициализация WorkManager для фоновой синхронизации
    try {
      await SyncScheduler.ensureRegistered();
      AppLogger.i('✅ WorkManager initialized');
    } catch (e, st) {
      AppLogger.e('Failed to initialize WorkManager', e, st);
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
  });
}

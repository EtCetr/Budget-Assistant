import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/app.dart';
import 'package:budget_assistant/core/services/global_error_handler.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/core/bootstrap/app_bootstrap_flags.dart';
// lib/main.dart
Future<void> main() async {
  GlobalErrorHandler.runWithGuard(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://YOUR-PROJECT.supabase.co',
      ),
      publishableKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'YOUR-ANON-KEY',
      ),
    );

    AppLogger.i('App bootstrap completed successfully');
    AppLogger.i('🚀 Forcing DB initialization...');

    final db = AppDatabase();
    await db.customSelect('SELECT 1').get();
    AppLogger.i('✅ DB initialized successfully');
    // 3.5 Флаг онбординга: читаем ДО runApp, чтобы роутер знал статус сразу
    try {
      final storage = SecureStorageService();
      final flag = await storage.read('onboarding_completed');

      String status = 'not_started';
      if (flag == 'true') {
        status = 'completed';
      } else {
        // Fallback: онбординг пройден ДО введения флага —
        // определяем по наличию счетов в локальной БД
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
    // ❌ УДАЛИТЕ ЭТУ СТРОКУ:
    // await db.close();

    // ✅ БД остаётся открытой на всё время работы приложения
    runApp(const ProviderScope(child: BudgetAssistantApp()));
  });
}

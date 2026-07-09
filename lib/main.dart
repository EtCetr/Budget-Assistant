import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/app.dart';
import 'package:budget_assistant/core/services/global_error_handler.dart';
import 'package:budget_assistant/core/logger.dart';

Future<void> main() async {
  GlobalErrorHandler.runWithGuard(() async {
    // 1. Flutter Binding — ОБЯЗАТЕЛЬНО внутри runZonedGuarded!
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Supabase — тоже внутри зоны.
    // Секреты читаем через --dart-define, чтобы не хардкодить в коде
    // (согласно DECISIONS.md: "Никаких секретов в коде").
    // Запуск: flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
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

    // 3. Здесь в будущем (Этап 2) будет инициализация SecureStorage и EncryptionService
    // await SecureStorageService.instance.init();
    // await EncryptionService.instance.init();

    AppLogger.i('App bootstrap completed successfully');

    // 4. Запуск приложения — в ТОЙ ЖЕ зоне, что и ensureInitialized!
    runApp(const ProviderScope(child: BudgetAssistantApp()));
  });
}

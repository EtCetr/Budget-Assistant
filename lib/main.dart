import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/app.dart';
import 'package:budget_assistant/core/services/global_error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    publishableKey: 'YOUR_SUPABASE_ANON_KEY', // Исправлено с anonKey
  );

  GlobalErrorHandler.runWithGuard(() {
    runApp(
      const ProviderScope(
        child:
            BudgetAssistantApp(), // Убедись, что класс в app.dart называется так же
      ),
    );
  });
}

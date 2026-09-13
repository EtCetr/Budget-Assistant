import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/app_theme.dart';

class BudgetAssistantApp extends ConsumerWidget {
  const BudgetAssistantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Budget Assistant',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Тёмное оформление по умолчанию (токены дизайн-системы — тёмные).
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/app.dart';
import 'package:budget_assistant/core/config/app_config.dart';
import 'package:budget_assistant/core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.init(Flavor.dev);

  runZonedGuarded(
    () async {
      runApp(const ProviderScope(child: BudgetAssistantApp()));
    },
    (error, stack) {
      appLogger.e('Global uncaught error', error: error, stackTrace: stack);
    },
  );
}

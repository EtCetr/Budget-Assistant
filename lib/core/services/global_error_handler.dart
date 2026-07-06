import 'dart:async';
import 'dart:ui';
import 'package:budget_assistant/core/logger.dart';

class GlobalErrorHandler {
  static void runWithGuard(VoidCallback callback) {
    runZonedGuarded<Future<void>>(
      () async {
        callback();
      },
      (error, stack) {
        AppLogger.e('Global Uncaught Error', error, stack);
        // Здесь можно добавить отправку в Sentry/Crashlytics
      },
    );
  }

  static Future<R?> runZonedWithGuard<R>(Future<R> Function() callback) async {
    // runZonedGuarded возвращает Future<R>?, поэтому используем Future<R?>
    return runZonedGuarded<Future<R>>(callback, (error, stack) {
      AppLogger.e('Global Async Error', error, stack);
    });
  }
}

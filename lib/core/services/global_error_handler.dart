import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:budget_assistant/core/logger.dart';

class GlobalErrorHandler {
  /// Главный guard для всего приложения.
  // ignore: unintended_html_in_doc_comment
  /// ВАЖНО: принимает Future<void> Function(), а не VoidCallback,
  /// потому что bootstrap — асинхронный.
  static void runWithGuard(Future<void> Function() body) {
    runZonedGuarded<Future<void>>(
      () async {
        // Глобальный обработчик ошибок Flutter-фреймворка
        FlutterError.onError = (details) {
          AppLogger.e('Flutter Error', details.exception, details.stack);
          // В dev-режиме выводим в консоль, в release — в Sentry/Crashlytics
          if (!kReleaseMode) {
            FlutterError.presentError(details);
          }
        };

        // Выполняем весь bootstrap и запуск приложения В ЭТОЙ ЖЕ ЗОНЕ
        await body();
      },
      (error, stack) {
        // Сюда попадают ошибки, вылетевшие за пределы Flutter (Isolate, async gaps)
        AppLogger.e('Uncaught Zone Error', error, stack);
      },
    );
  }

  /// Для оборачивания отдельных async-операций (UseCases, SyncService)
  static Future<R?> runZonedWithGuard<R>(Future<R> Function() callback) async {
    return runZonedGuarded<Future<R>>(callback, (error, stack) {
      AppLogger.e('Async Operation Error', error, stack);
    });
  }
}

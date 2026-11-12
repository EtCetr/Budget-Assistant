import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'package:budget_assistant/core/logger.dart';

/// Этап 23 (ТОМ 7 §4): глобальная обработка ошибок приложения.
///
/// Уровни защиты:
/// 1. runZonedGuarded — все асинхронные ошибки зоны приложения.
/// 2. FlutterError.onError — ошибки фреймворка (build/layout/рисунок).
/// 3. PlatformDispatcher.onError — последний рубеж неперехваченных ошибок.
/// 4. Слушатель ошибок рутового изолята (вне зоны).
///
/// Приложение не падает: ошибка логируется (AppLogger), пользователь
/// видит дружелюбное состояние с Retry (AsyncValueWrapper / ErrorState).
/// Sentry/Crashlytics намеренно не подключены (нет новых зависимостей).
class GlobalErrorHandler {
  GlobalErrorHandler._();

  static RawReceivePort? _isolateErrorPort;

  /// Главный гард всего приложения.
  ///
  /// Принимает асинхронную функцию (не VoidCallback),
  /// потому что bootstrap — асинхронный.
  static void runWithGuard(Future<void> Function() body) {
    runZonedGuarded<Future<void>>(
      () async {
        _installPlatformHandlers();

        // Ошибки фреймворка (виджет-дерево, layout, paint).
        FlutterError.onError = (details) {
          AppLogger.e(
            'Flutter Error: ${details.exceptionAsString()}',
            details.exception,
            details.stack,
          );
          // В dev показываем красный экран, в release — только лог.
          if (!kReleaseMode) {
            FlutterError.presentError(details);
          }
        };

        await body();
      },
      (error, stack) {
        // Ошибки, вылетевшие за async-гэпы зоны приложения.
        AppLogger.e('Uncaught Zone Error', error, stack);
      },
    );
  }

  /// Для оборачивания отдельных асинхронных операций (совместимость).
  static Future<R?> runZonedWithGuard<R>(Future<R> Function() callback) async {
    return runZonedGuarded<Future<R>>(callback, (error, stack) {
      AppLogger.e('Async Operation Error', error, stack);
    });
  }

  /// Гард для фоновых entry-point (задачи WorkManager).
  ///
  /// Никогда не выпускает исключение наружу: любая ошибка
  /// превращается в `false` (WorkManager повторит задачу по своему
  /// backoff-правилу).
  static Future<bool> runGuardedBackground(
    Future<bool> Function() body,
  ) async {
    final completer = Completer<bool>();
    runZonedGuarded<void>(
      () async {
        try {
          final result = await body();
          if (!completer.isCompleted) completer.complete(result);
        } catch (e, st) {
          AppLogger.e('Background task failed', e, st);
          if (!completer.isCompleted) completer.complete(false);
        }
      },
      (error, stack) {
        AppLogger.e('Background zone error', error, stack);
        if (!completer.isCompleted) completer.complete(false);
      },
    );
    return completer.future;
  }

  static void _installPlatformHandlers() {
    // Последний рубеж: ошибки, проскользнувшие мимо зоны.
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.e('PlatformDispatcher uncaught error', error, stack);
      // true = ошибка обработана, изолят не крашится.
      return true;
    };

    // Ошибки рутового изолята (доставляются парой [ошибка, стек]).
    final port = RawReceivePort((Object? message) {
      try {
        if (message is List && message.length >= 2) {
          final error = message[0];
          final rawStack = message[1];
          final stack = rawStack is StackTrace
              ? rawStack
              : StackTrace.fromString('$rawStack');
          AppLogger.e('Isolate uncaught error', error, stack);
        } else {
          AppLogger.e('Isolate uncaught error (неизвестный формат)', message);
        }
      } catch (e) {
        AppLogger.e('Isolate error listener failed', e);
      }
    });
    _isolateErrorPort?.close();
    _isolateErrorPort = port;
    Isolate.current.addErrorListener(port.sendPort);
  }
}
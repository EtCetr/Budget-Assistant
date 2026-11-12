import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:budget_assistant/core/logger.dart';

/// Этап 23: единая обёртка для тяжёлых операций в изоляте.
///
/// compute() + замер времени + логирование + try/catch.
/// ВАЖНО: [computation] обязана быть топ-функцией (или статическим
/// методом), иначе её нельзя передать в изолят.
class IsolateRunner {
  IsolateRunner._();

  /// Медленнее этого — предупреждение в лог.
  static const int slowThresholdMs = 1000;

  static Future<R> run<Q, R>(
    String label,
    FutureOr<R> Function(Q input) computation,
    Q argument,
  ) async {
    final sw = Stopwatch()..start();
    try {
      final result = await compute<Q, R>(
        computation,
        argument,
        debugLabel: label,
      );
      final ms = sw.elapsedMilliseconds;
      if (ms >= slowThresholdMs) {
        AppLogger.w('IsolateRunner[$label] медленно: $msмс');
      } else {
        AppLogger.d('IsolateRunner[$label]: $msмс');
      }
      return result;
    } catch (e, st) {
      AppLogger.e('IsolateRunner[$label] упало', e, st);
      rethrow;
    }
  }
}
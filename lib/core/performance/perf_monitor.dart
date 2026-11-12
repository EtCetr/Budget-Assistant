import 'package:budget_assistant/core/logger.dart';

/// Этап 23: простой мониторинг производительности.
///
/// Оборачивает операцию секундомером и пишет в лог:
/// debug — всегда, warning — если медленнее порога.
/// Ошибки пробрасывает дальше (не глотает).
class PerfMonitor {
  PerfMonitor._();

  static const int defaultWarnAfterMs = 300;

  static Future<T> measure<T>(
    String label,
    Future<T> Function() action, {
    int warnAfterMs = defaultWarnAfterMs,
  }) async {
    final sw = Stopwatch()..start();
    try {
      final result = await action();
      _report(label, sw.elapsedMilliseconds, warnAfterMs);
      return result;
    } catch (e, st) {
      AppLogger.e(
        'PerfMonitor[$label] упало после ${sw.elapsedMilliseconds}мс',
        e,
        st,
      );
      rethrow;
    }
  }

  static T measureSync<T>(
    String label,
    T Function() action, {
    int warnAfterMs = defaultWarnAfterMs,
  }) {
    final sw = Stopwatch()..start();
    try {
      final result = action();
      _report(label, sw.elapsedMilliseconds, warnAfterMs);
      return result;
    } catch (e, st) {
      AppLogger.e(
        'PerfMonitor[$label] упало после ${sw.elapsedMilliseconds}мс',
        e,
        st,
      );
      rethrow;
    }
  }

  static void _report(String label, int ms, int warnAfterMs) {
    if (ms >= warnAfterMs) {
      AppLogger.w(
        'PerfMonitor[$label] медленно: $msмс (порог $warnAfterMsмс)',
      );
    } else {
      AppLogger.d('PerfMonitor[$label]: $msмс');
    }
  }
}
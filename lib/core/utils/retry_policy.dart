import 'dart:math' as math;

import 'package:budget_assistant/core/logger.dart';

/// Этап 23: повтор операций с экспоненциальным бэкоффом
/// (ТЗ 6.7.5.4, роадмап Этапа 23).
///
/// Задержка = initialDelay * multiplier^(попытка-1), потолок maxDelay,
/// джиттер +/-20%, чтобы параллельные клиенты не били в сервер одновременно.
///
/// Применяется ТОЛЬКО в фоне (синк через WorkManager).
/// Pull-to-refresh — без повторов, чтобы UI не ждал бэкофф.
class RetryPolicy {
  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 2),
    this.multiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.jitter = true,
    this.retryWhen,
  });

  /// Общее число попыток (включая первую).
  final int maxAttempts;
  final Duration initialDelay;
  final double multiplier;
  final Duration maxDelay;
  final bool jitter;

  /// Предикат: повторять ли при данной ошибке (null = повторять при всех).
  final bool Function(Object error)? retryWhen;

  /// Политика для сетевых операций (фоновый синк).
  static const RetryPolicy network = RetryPolicy();

  /// Задержка для попытки N (публичный — для тестов и логов).
  Duration delayForAttempt(int attempt) {
    final raw =
        initialDelay.inMilliseconds * math.pow(multiplier, attempt - 1);
    final capped = raw.clamp(0, maxDelay.inMilliseconds).toInt();
    if (!jitter) return Duration(milliseconds: capped);
    final factor = 0.8 + 0.4 * math.Random().nextDouble(); // 0.8..1.2
    return Duration(milliseconds: (capped * factor).round());
  }

  Future<T> run<T>(
    Future<T> Function() action, {
    required String label,
  }) async {
    var attempt = 0;
    while (true) {
      attempt++;
      try {
        return await action();
      } catch (e, st) {
        final allowed = retryWhen?.call(e) ?? true;
        if (attempt >= maxAttempts || !allowed) {
          AppLogger.e(
            'RetryPolicy[$label]: попытка $attempt не удалась, сдаёмся',
            e,
            st,
          );
          rethrow;
        }
        final delay = delayForAttempt(attempt);
        AppLogger.w(
          'RetryPolicy[$label]: попытка $attempt не удалась ($e), '
          'повтор через ${delay.inMilliseconds}мс',
        );
        await Future<void>.delayed(delay);
      }
    }
  }
}
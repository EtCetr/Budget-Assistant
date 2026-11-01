import 'package:flutter/services.dart';
import 'package:budget_assistant/core/logger.dart';

/// Обёртка над MethodChannel для FLAG_SECURE (ТОМ 3 §6).
/// Нативный слой сам возвращает флаг по таймеру (страховка от краша).
class SecureFlagService {
  static const MethodChannel _channel =
      MethodChannel('budget_assistant/secure_flag');

  /// Временно снимает FLAG_SECURE. Возвращает true, если флаг был установлен
  /// (значит, после операции его нужно вернуть).
  Future<bool> disableTemporarily(Duration duration) async {
    try {
      final was = await _channel.invokeMethod<bool>(
        'disableTemporarily',
        {'durationMs': duration.inMilliseconds},
      );
      return was ?? false;
    } catch (e, st) {
      AppLogger.e('SecureFlag disableTemporarily failed', e, st);
      return false;
    }
  }

  Future<void> restore() async {
    try {
      await _channel.invokeMethod<void>('restoreSecure');
    } catch (e, st) {
      AppLogger.e('SecureFlag restore failed', e, st);
    }
  }
}
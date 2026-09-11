import 'package:flutter/services.dart';

import 'package:budget_assistant/core/ports/clock_port.dart';

/// Боевая реализация монотонных часов через platform channel.
///
/// Канал обрабатывается в MainActivity.kt (Android).
/// ТОЛЬКО Android (см. PROJECT_CONTEXT.md).
class ElapsedRealtimeService implements ClockPort {
  static const MethodChannel _channel = MethodChannel('budget_assistant/clock');

  @override
  Future<int> elapsedRealtimeMs() async {
    try {
      final ms = await _channel.invokeMethod<int>('getElapsedRealtime');

      if (ms == null) {
        throw StateError('elapsedRealtime returned null');
      }

      return ms;
    } on PlatformException catch (e) {
      throw StateError('Platform channel failed: ${e.message}');
    }
  }
}

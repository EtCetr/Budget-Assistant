import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/ports/clock_port.dart';

/// Дефолтная реализация ClockPort — использует DateTime.now().
class SystemClock implements ClockPort {
  const SystemClock();

  @override
  Future<int> elapsedRealtimeMs() async =>
      DateTime.now().millisecondsSinceEpoch;
}

final clockPortProvider = Provider<ClockPort>((ref) => const SystemClock());

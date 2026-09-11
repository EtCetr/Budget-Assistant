import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/core/services/elapsed_realtime_service.dart';

/// Адаптер: инфраструктурный сервис -> доменный порт.
class PlatformClockAdapter implements ClockPort {
  final ElapsedRealtimeService _service;

  const PlatformClockAdapter(this._service);

  @override
  Future<int> elapsedRealtimeMs() => _service.elapsedRealtimeMs();
}

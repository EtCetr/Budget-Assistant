/// Порт домена: монотонные часы устройства.
///
/// Реализация — в data-слое (platform channel).
/// Это защита sync-lock от перевода часов пользователем.
abstract interface class ClockPort {
  /// Milliseconds since boot (Android SystemClock.elapsedRealtime).
  Future<int> elapsedRealtimeMs();
}

/// Конфиг режима секретности для блокировки синхронизации крупных трат.
///
/// На этапе 6 может передаваться из настроек или из провайдера.
/// Позже должен читаться из app_settings.
class SecrecyConfig {
  final bool enabled;

  /// Порог крупной транзакции в копейках.
  final int threshold;

  /// Длительность блокировки в секундах.
  final int timeoutSeconds;

  const SecrecyConfig({
    required this.enabled,
    required this.threshold,
    required this.timeoutSeconds,
  });
}

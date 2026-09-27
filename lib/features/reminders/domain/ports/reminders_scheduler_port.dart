import '../entities/reminder.dart';

/// Порт планировщика локальных уведомлений (Clean Architecture:
/// домен не знает о flutter_local_notifications).
abstract interface class RemindersSchedulerPort {
  /// Инициализация плагина, таймзоны, канала. Идемпотентно.
  Future<void> ensureReady();
  /// Запрашивает runtime-разрешения (POST_NOTIFICATIONS, exact alarms).
  Future<bool> requestPermissions();
  /// Планирует до 3 ближайших срабатываний напоминания.
  /// Перед планированием отменяет старые PendingIntent этого напоминания.
  Future<void> scheduleReminder(Reminder reminder, List<DateTime> occurrencesUtc);
  /// Отменяет все PendingIntent напоминания.
  Future<void> cancelReminder(String reminderId);
}
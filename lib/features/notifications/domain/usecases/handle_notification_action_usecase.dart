import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';

/// Обработка действий из пуша (confirm/dismiss) + бизнес-логика confirm.
/// Идемпотентно: UPDATE по id безопасен повторным нажатием.
class HandleNotificationActionUseCase {
  HandleNotificationActionUseCase(this._db);
  final AppDatabase _db;

  Future<void> call({
    required String notificationId,
    required String action,
    String? type,
    String? entityId,
  }) async {
    try {
      await (_db.update(_db.notifications)
            ..where((n) => n.id.equals(notificationId)))
          .write(NotificationsCompanion(
        actionTaken: Value(action),
        isRead: const Value(true),
      ));
      if (action != 'confirmed') return;
      final entity = entityId != null && entityId.contains(':')
          ? entityId.substring(entityId.indexOf(':') + 1)
          : entityId;
      final nowEpoch = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      switch (type) {
        case 'gift_purchase_alert':
          // «Скрыть»: засекретить покупку на 30 дней.
          if (entity != null) {
            await _db.customUpdate(
              "UPDATE transactions SET is_hidden_by_calendar = 1, "
              "hidden_until_date = ?, sync_status = 'pending' WHERE id = ?",
              variables: [
                Variable.withInt(
                    nowEpoch + const Duration(days: 30).inSeconds),
                Variable.withString(entity),
              ],
            );
          }
          break;
        case 'reminder_due':
          // «Выполнено»: завершить напоминание.
          if (entity != null) {
            await _db.customUpdate(
              "UPDATE reminders SET completed_at = ?, sync_status = 'pending' "
              'WHERE id = ?',
              variables: [
                Variable.withInt(nowEpoch),
                Variable.withString(entity),
              ],
            );
          }
          break;
      }
    } catch (e, st) {
      AppLogger.e('HandleNotificationAction failed', e, st);
      rethrow;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await (_db.update(_db.notifications)
            ..where((n) => n.id.equals(notificationId)))
          .write(const NotificationsCompanion(isRead: Value(true)));
    } catch (e, st) {
      AppLogger.e('markAsRead failed', e, st);
    }
  }
}
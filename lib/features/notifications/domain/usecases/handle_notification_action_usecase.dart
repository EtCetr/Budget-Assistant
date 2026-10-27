import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';

/// Обработка действий из пуша (confirm/dismiss). Идемпотентно.
class HandleNotificationActionUseCase {
  HandleNotificationActionUseCase(this._db);
  final AppDatabase _db;

  Future<void> call({
    required String notificationId,
    required String action, // 'confirmed' | 'dismissed'
  }) async {
    try {
      await (_db.update(_db.notifications)
            ..where((n) => n.id.equals(notificationId)))
          .write(NotificationsCompanion(
        actionTaken: Value(action),
        isRead: const Value(true),
      ));
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
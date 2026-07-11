import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/notifications.dart';

part 'notifications_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationsDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationsDaoMixin {
  NotificationsDao(super.db);

  /// Получить непрочитанные уведомления пользователя
  Future<List<Notification>> getUnread(String userId) {
    return (select(notifications)
          ..where((t) => t.userId.equals(userId) & t.isRead.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Stream<List<Notification>> watchUnread(String userId) {
    return (select(notifications)
          ..where((t) => t.userId.equals(userId) & t.isRead.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Пометить как прочитанное
  Future<int> markAsRead(String id) {
    return (update(notifications)..where((t) => t.id.equals(id))).write(
      const NotificationsCompanion(isRead: Value(true)),
    );
  }

  /// Записать действие пользователя (confirmed/dismissed)
  Future<int> recordAction(String id, String action) {
    return (update(notifications)..where((t) => t.id.equals(id))).write(
      NotificationsCompanion(actionTaken: Value(action)),
    );
  }

  Future<void> insert(Notification notification) {
    return into(notifications).insert(notification.toCompanion(true));
  }

  /// Удалить старые уведомления (старше 90 дней)
  Future<int> cleanupOld() {
    final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 90));
    return (delete(
      notifications,
    )..where((t) => t.createdAt.isSmallerThanValue(cutoff))).go();
  }
}

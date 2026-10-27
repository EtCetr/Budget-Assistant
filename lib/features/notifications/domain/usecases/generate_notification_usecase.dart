import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:uuid/uuid.dart';
import '../models/notification_type.dart';

/// Генерация локального уведомления. Дедуп: тип+сущность за 24ч (critical — всегда).
class GenerateNotificationUseCase {
  GenerateNotificationUseCase(this._db);
  final AppDatabase _db;
  static const Uuid _uuid = Uuid();

  Future<bool> call({
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    String? spaceId,
    String? relatedEntityId,
  }) async {
    try {
      if (!type.critical) {
        final cutoff =
            DateTime.now().toUtc().subtract(const Duration(hours: 24));
        final q = _db.select(_db.notifications)
          ..where((n) =>
              n.userId.equals(userId) &
              n.type.equals(type.dbValue) &
              n.createdAt.isBiggerOrEqualValue(cutoff));
        if (relatedEntityId == null) {
          q.where((n) => n.relatedEntityId.isNull());
        } else {
          q.where((n) => n.relatedEntityId.equals(relatedEntityId));
        }
        final existing = await q.get();
        if (existing.isNotEmpty) {
          AppLogger.d('Notification suppressed (dup): ${type.dbValue}');
          return false;
        }
      }
      await _db.into(_db.notifications).insert(NotificationsCompanion.insert(
            id: _uuid.v4(),
            userId: userId,
            spaceId: Value(spaceId),
            type: type.dbValue,
            title: title,
            body: body,
            relatedEntityId: Value(relatedEntityId),
          ));
      return true;
    } catch (e, st) {
      AppLogger.e('GenerateNotification failed', e, st);
      rethrow;
    }
  }
}
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
    Duration dedupWindow = const Duration(hours: 24),
  }) async {
    try {
      // Этап 21 (D21-16/D21-40): время тишины — блокируем все пуши 22:00-08:00.
      if (await _inQuietHours(userId)) {
        AppLogger.d('Notification suppressed (quiet hours): {type.dbValue}');
        return false;
      }
      if (!type.critical) {
        final cutoff =
            DateTime.now().toUtc().subtract(dedupWindow);
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
  /// Этап 21: проверка ночного окна (переход через полночь учитывается).
  Future<bool> _inQuietHours(String userId) async {
    try {
      final rows = await _db.customSelect(
        'SELECT night_mode_enabled AS e, night_mode_start AS s, '
        'night_mode_end AS x FROM app_settings WHERE user_id = ?',
        variables: [Variable.withString(userId)],
      ).get();
      if (rows.isEmpty) return false;
      final r = rows.first;
      if (!r.read<bool>('e')) return false;
      final now = DateTime.now();
      final minutes = now.hour * 60 + now.minute;
      int parse(String v) {
        final p = v.split(':');
        return int.parse(p[0]) * 60 + (p.length > 1 ? int.parse(p[1]) : 0);
      }
      final start = parse(r.read<String>('s'));
      final end = parse(r.read<String>('x'));
      return start <= end
          ? (minutes >= start && minutes < end)
          : (minutes >= start || minutes < end);
    } catch (e, st) {
      AppLogger.e('quiet hours check failed', e, st);
      return false;
    }
  }
}
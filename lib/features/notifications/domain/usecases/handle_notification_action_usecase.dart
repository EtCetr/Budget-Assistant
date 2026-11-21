import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import '../models/notification_type.dart';

/// Обработка действий из пуша (confirm/dismiss) + бизнес-логика confirm.
/// Идемпотентно: UPDATE по id безопасен повторным нажатием.
///
/// ФИКС Этапа 24 (D24-73): тип пуша в БД хранится как NotificationType.dbValue
/// (camelCase, например giftPurchaseAlert), а switch сравнивал со snake_case
/// (gift_purchase_alert) — при передаче значения из БД действие «Подтвердить»
/// не выполняло бизнес-логику. Нормализуем обе формы к enum.name.
///
/// ФИКС Этапа 24 (D24-74): триггеры формируют entityId как 'id:суффикс'
/// (reminderDue -> 'reminderId:2026-7-15', goalMilestone -> 'goalId:75').
/// Бралась часть ПОСЛЕ двоеточия, то есть суффикс вместо id сущности —
/// UPDATE reminders шёл по несуществующему id и «Выполнено» не работало.
/// Берём часть ДО первого двоеточия.
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
          ? entityId.substring(0, entityId.indexOf(':'))
          : entityId;
      final nowEpoch = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

      switch (_normalizeType(type)) {
        case 'giftPurchaseAlert':
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
        case 'reminderDue':
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

  /// camelCase (NotificationType.dbValue) и legacy snake_case -> enum.name.
  String? _normalizeType(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final t in NotificationType.values) {
      if (t.name == raw) return t.name;
    }
    final parts = raw.split('_');
    final camel = parts.first +
        parts
            .skip(1)
            .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
            .join();
    return camel;
  }
}
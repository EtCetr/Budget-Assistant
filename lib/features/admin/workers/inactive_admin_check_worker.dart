import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/sync/application/sync_background_database.dart';

/// Heartbeat + «Мёртвый админ» (ТОМ 6 6.3.32/6.3.33, раз в сутки).
/// Диспетчер ОДИН на приложение (syncWorkManagerCallback), маршрутизация по taskName.
class InactiveAdminCheckWorker {
  static const String taskName = 'inactive_admin_check';
  static const String uniqueName = 'ba_inactive_admin_check_daily';

  static Future<void> register() async {
    try {
      await Workmanager().registerPeriodicTask(
        uniqueName,
        taskName,
        frequency: const Duration(days: 1),
        initialDelay: const Duration(minutes: 30),
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );
      AppLogger.i('InactiveAdminCheckWorker registered');
    } catch (e, st) {
      AppLogger.e('InactiveAdminCheckWorker register failed', e, st);
    }
  }

  static Future<void> cancel() async {
    try {
      await Workmanager().cancelByUniqueName(uniqueName);
    } catch (e, st) {
      AppLogger.e('InactiveAdminCheckWorker cancel failed', e, st);
    }
  }
}

/// Фон: пространство без активного админа 30+ дней -> аварийно повышаем
/// самого активного участника (DoD Этапа 17), пишем admin_audit_log.
Future<bool> handleInactiveAdminCheckTask() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final db = await openSyncDatabaseInBackground();
    try {
      final now = DateTime.now().toUtc();
      final nowEpoch = now.millisecondsSinceEpoch ~/ 1000;
      final cutoff30Epoch =
          now.subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000;
      final spaces = await db
          .customSelect("SELECT id FROM spaces WHERE status = 'active'")
          .get();
      for (final s in spaces) {
        final spaceId = s.read<String>('id');
        final activeAdmins = await db.customSelect(
          "SELECT COUNT(*) AS c FROM memberships WHERE space_id = ? "
          "AND role = 'admin' AND status = 'active' "
          'AND last_active_at IS NOT NULL AND last_active_at > ?',
          variables: [
            Variable.withString(spaceId),
            Variable.withInt(cutoff30Epoch),
          ],
        ).getSingle();
        if (activeAdmins.read<int>('c') > 0) {
          continue;
        }
        final candidate = await db.customSelect(
          'SELECT m.id AS mid, m.user_id AS uid, COUNT(t.id) AS c '
          'FROM memberships m LEFT JOIN transactions t '
          'ON t.user_id = m.user_id AND t.space_id = m.space_id AND t.date > ? '
          "WHERE m.space_id = ? AND m.status = 'active' AND m.role = 'member' "
          'GROUP BY m.id ORDER BY c DESC LIMIT 1',
          variables: [
            Variable.withInt(cutoff30Epoch),
            Variable.withString(spaceId),
          ],
        ).getSingleOrNull();
        if (candidate == null) {
          continue;
        }
        final mid = candidate.read<String>('mid');
        final uid = candidate.read<String>('uid');
        await db.transaction(() async {
          await db.customUpdate(
            "UPDATE memberships SET role = 'admin', updated_at = ?, "
            "sync_status = 'pending' WHERE id = ?",
            variables: [Variable.withInt(nowEpoch), Variable.withString(mid)],
          );
          await db.customUpdate(
            "UPDATE memberships SET role = 'member', updated_at = ?, "
            "sync_status = 'pending' WHERE space_id = ? AND role = 'admin' "
            'AND id != ? AND (last_active_at IS NULL OR last_active_at <= ?)',
            variables: [
              Variable.withInt(nowEpoch),
              Variable.withString(spaceId),
              Variable.withString(mid),
              Variable.withInt(cutoff30Epoch),
            ],
          );
        });
        await db.customInsert(
          'INSERT INTO admin_audit_log (id, space_id, actor_user_id, action_type, '
          'target_type, target_id, metadata_json, created_at, sync_status) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
          variables: [
            Variable.withString(const Uuid().v4()),
            Variable.withString(spaceId),
            Variable.withString(uid),
            Variable.withString(AuditAction.emergencyPromotion.dbValue),
            Variable.withString('member'),
            Variable.withString(mid),
            Variable.withString('{"type":"emergency_admin_promotion"}'),
            Variable.withInt(nowEpoch),
            Variable.withString('pending'),
          ],
        );
        AppLogger.w('Emergency admin promotion: space=$spaceId newAdmin=$uid');
      }
      return true;
    } finally {
      await db.close();
    }
  } catch (e, st) {
    AppLogger.e('InactiveAdminCheck task failed', e, st);
    return false;
  }
}
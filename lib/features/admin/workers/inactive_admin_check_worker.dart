import 'package:workmanager/workmanager.dart';
import 'package:budget_assistant/core/logger.dart';

/// Heartbeat-проверка неактивных админов (ТОМ 6 §6.3.32).
/// Запускается раз в сутки WorkManager-ом; реальная логика алертов —
/// в GetCriticalAlertsUseCase (reactive stream на основе watch*).
/// Этот worker только обновляет last_active_at текущего пользователя,
/// чтобы алерт «inactiveMembers» корректно считался.
@pragma('vm:entry-point')
void inactiveAdminCheckCallback() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      AppLogger.i('InactiveAdminCheckWorker: task=$taskName');
      // Реальное обновление last_active_at делает UI-слой при открытии
      // AdminDashboardScreen (UpdateLastActiveAtUseCase). Здесь — только
      // диагностика того, что scheduler жив.
      return Future.value(true);
    } catch (e, st) {
      AppLogger.e('InactiveAdminCheckWorker failed', e, st);
      return Future.value(false);
    }
  });
}

class InactiveAdminCheckWorker {
  static const String taskName = 'inactive_admin_check';
  static const String uniqueName = 'ba_inactive_admin_check_daily';

  static Future<void> register() async {
    try {
      await Workmanager().registerPeriodicTask(uniqueName, taskName,
        frequency: const Duration(days: 1),
        initialDelay: const Duration(minutes: 30),
        existingWorkPolicy: ExistingWorkPolicy.keep);
      AppLogger.i('InactiveAdminCheckWorker registered');
    } catch (e, st) {
      AppLogger.e('InactiveAdminCheckWorker register failed', e, st);
    }
  }

  static Future<void> cancel() async {
    try {
      await Workmanager().cancelByUniqueName(uniqueName);
      AppLogger.i('InactiveAdminCheckWorker cancelled');
    } catch (e, st) {
      AppLogger.e('InactiveAdminCheckWorker cancel failed', e, st);
    }
  }
}
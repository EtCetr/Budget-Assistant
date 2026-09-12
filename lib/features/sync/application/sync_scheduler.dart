import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import 'package:budget_assistant/features/sync/application/workmanager_sync_task.dart';

/// Регистрация фоновых задач синхронизации.
class SyncScheduler {
  static const String periodicTaskName = 'budget_assistant_periodic_sync';
  static const String oneOffTaskName = 'budget_assistant_one_off_sync';

  static Future<void> ensureRegistered() async {
    await Workmanager().initialize(
      syncWorkManagerCallback,
      isInDebugMode: kDebugMode,
    );

    await Workmanager().registerPeriodicTask(
      periodicTaskName,
      periodicTaskName,
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 10),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static Future<void> scheduleOneOff() async {
    await Workmanager().registerOneOffTask(
      oneOffTaskName,
      oneOffTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

/// Провайдер базы данных (singleton, живёт всё время работы приложения)
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ═══ Удобные провайдеры для DAO ═══

final usersDaoProvider = Provider(
  (ref) => ref.watch(appDatabaseProvider).usersDao,
);

final spacesDaoProvider = Provider(
  (ref) => ref.watch(appDatabaseProvider).spacesDao,
);

final membershipsDaoProvider = Provider(
  (ref) => ref.watch(appDatabaseProvider).membershipsDao,
);

final appSettingsDaoProvider = Provider(
  (ref) => ref.watch(appDatabaseProvider).appSettingsDao,
);

final notificationsDaoProvider = Provider(
  (ref) => ref.watch(appDatabaseProvider).notificationsDao,
);

final syncConflictsDaoProvider = Provider(
  (ref) => ref.watch(appDatabaseProvider).syncConflictsDao,
);

final syncLogsDaoProvider = Provider(
  (ref) => ref.watch(appDatabaseProvider).syncLogsDao,
);

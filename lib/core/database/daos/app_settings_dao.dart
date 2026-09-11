import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/app_settings.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class AppSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AppSettingsDaoMixin {
  AppSettingsDao(super.db);

  /// Получить настройки пользователя (создать дефолтные, если нет)
  /// Drift генерирует класс `AppSetting` (ед. число), а не `AppSettings`
  Future<AppSetting> getForUser(String userId) async {
    final existing = await (select(
      appSettings,
    )..where((t) => t.userId.equals(userId))).getSingleOrNull();

    if (existing != null) return existing;

    // AppSettingsCompanion — от имени таблицы
    final defaultSettings = AppSettingsCompanion.insert(
      id: 'settings_$userId',
      userId: userId,
      // createdAt и updatedAt подставит SyncableTable mixin
    );
    await into(appSettings).insert(defaultSettings);

    return (select(
      appSettings,
    )..where((t) => t.userId.equals(userId))).getSingle();
  }

  Stream<AppSetting> watchForUser(String userId) {
    return (select(
      appSettings,
    )..where((t) => t.userId.equals(userId))).watchSingle();
  }

  Future<int> updateForUser(String userId, AppSettingsCompanion changes) {
    return (update(appSettings)..where((t) => t.userId.equals(userId))).write(
      changes.copyWith(syncStatus: const Value('pending')),
    );
  }
}

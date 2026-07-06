// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Spaces,
    Memberships,
    AppSettings,
    Notifications,
    SyncConflicts,
    SyncLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();

      // Индексы согласно ТОМ 2, Раздел 22
      await customStatement('''
        CREATE INDEX IF NOT EXISTS idx_memberships_user_space_status
        ON memberships (user_id, space_id, status)
      ''');

      await customStatement('''
        CREATE UNIQUE INDEX IF NOT EXISTS idx_memberships_unique
        ON memberships (user_id, space_id)
      ''');

      await customStatement('''
        CREATE INDEX IF NOT EXISTS idx_notifications_user_type_read
        ON notifications (user_id, type, is_read, created_at)
      ''');

      await customStatement('''
        CREATE INDEX IF NOT EXISTS idx_app_settings_user
        ON app_settings (user_id)
      ''');

      await customStatement('''
        CREATE INDEX IF NOT EXISTS idx_sync_conflicts_entity
        ON sync_conflicts (entity_type, entity_id)
      ''');

      await customStatement('''
        CREATE INDEX IF NOT EXISTS idx_sync_logs_user_timestamp
        ON sync_logs (user_id, timestamp)
      ''');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Миграции будут добавляться инкрементально на следующих этапах
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'budget_assistant_v6');
  }
}

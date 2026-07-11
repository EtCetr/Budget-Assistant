import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// ═══════════════════════════════════════════════════════════════
// Таблицы из Этапа 3 (фундаментальные сущности)
// Импортируем из tables/, так как там есть SyncableTable mixin
// ═══════════════════════════════════════════════════════════════
import 'tables/users.dart';
import 'tables/spaces.dart';
import 'tables/memberships.dart';
import 'tables/app_settings.dart';
import 'tables/notifications.dart';
import 'tables/sync_conflicts.dart';
import 'tables/sync_logs.dart';

// ═══════════════════════════════════════════════════════════════
// DAO (Data Access Objects) — типобезопасные запросы
// ═══════════════════════════════════════════════════════════════
import 'daos/users_dao.dart';
import 'daos/spaces_dao.dart';
import 'daos/memberships_dao.dart';
import 'daos/app_settings_dao.dart';
import 'daos/notifications_dao.dart';
import 'daos/sync_conflicts_dao.dart';
import 'daos/sync_logs_dao.dart';


import 'package:budget_assistant/core/logger.dart';


part 'app_database.g.dart';

// ═══════════════════════════════════════════════════════════════
// Таблицы из Этапа 5 (уже реализованы, остаются здесь)
// В будущем можно вынести в tables/ для единообразия
// ═══════════════════════════════════════════════════════════════

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get bankName => text()();
  TextColumn get customName => text()();
  TextColumn get cardNumberMask => text().nullable()();
  TextColumn get accountType => text()();
  TextColumn get currency => text()();
  IntColumn get currentBalance => integer()();
  IntColumn get creditLimit => integer().nullable()();
  DateTimeColumn get gracePeriodEnd => dateTime().nullable()();
  IntColumn get minPaymentAmount => integer().nullable()();
  BoolColumn get includeInPersonalBalance =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get includeInFamilyBalance =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isSharedBalance =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isSharedExpenses =>
      boolean().withDefault(const Constant(false))();
  TextColumn get expenseDetailLevel =>
      text().withDefault(const Constant('total_only'))();
  BoolColumn get isSharedIncomes =>
      boolean().withDefault(const Constant(false))();
  TextColumn get incomeDetailLevel =>
      text().withDefault(const Constant('total_only'))();
  IntColumn get sortOrder => integer().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Mortgages extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id).unique()();
  IntColumn get initialLoanAmount => integer()();
  IntColumn get propertyValue => integer()();
  IntColumn get interestRateBps => integer()();
  IntColumn get remainingTermMonths => integer()();
  IntColumn get monthlyPayment => integer()();
  DateTimeColumn get nextPaymentDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get parentId => text().nullable().references(Categories, #id)();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get iconEmoji => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  BoolColumn get isPinnedForCashback =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class CategoryRules extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get bankName => text()();
  TextColumn get triggerString => text()();
  TextColumn get targetCategoryId => text().references(Categories, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════
// Основная конфигурация БД
// ═══════════════════════════════════════════════════════════════

@DriftDatabase(
  tables: [
    // Этап 3: Фундаментальные сущности
    Users,
    Spaces,
    Memberships,
    AppSettings,
    Notifications,
    SyncConflicts,
    SyncLogs,
    // Этап 5: Счета, ипотеки, категории
    Accounts,
    Mortgages,
    Categories,
    CategoryRules,
  ],
  daos: [
    UsersDao,
    SpacesDao,
    MembershipsDao,
    AppSettingsDao,
    NotificationsDao,
    SyncConflictsDao,
    SyncLogsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Конструктор для unit-тестов (in-memory БД)
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2; // ← УВЕЛИЧЕНО с 1 до 2 для миграции SyncableTable

  /// Вспомогательный метод для создания всех индексов
  /// Вызывается и в onCreate, и в onUpgrade (после пересоздания таблиц)
  Future<void> _createAllIndexes() async {
    // ═══════════════════════════════════════════════════════
    // ИНДЕКСЫ ДЛЯ ЭТАПА 3 (фундаментальные таблицы)
    // ═══════════════════════════════════════════════════════

    // Memberships: быстрый поиск пространств пользователя и участников пространства
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_memberships_user 
      ON memberships(user_id, status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_memberships_space 
      ON memberships(space_id, status)
    ''');

    // AppSettings: поиск настроек пользователя
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_app_settings_user 
      ON app_settings(user_id)
    ''');

    // Notifications: непрочитанные (для бейджа) + по пространству
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_notifications_user_read 
      ON notifications(user_id, is_read, created_at DESC)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_notifications_space 
      ON notifications(space_id)
    ''');

    // SyncConflicts: неразрешённые конфликты (partial index — только активные)
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_conflicts_unresolved 
      ON sync_conflicts(entity_type, entity_id) 
      WHERE resolved_at IS NULL
    ''');

    // SyncLogs: история синхронизации пользователя (последние сверху)
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_logs_user_timestamp 
      ON sync_logs(user_id, timestamp DESC)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_logs_status 
      ON sync_logs(status)
    ''');

    // ═══════════════════════════════════════════════════════
    // ИНДЕКСЫ ДЛЯ ЭТАПА 5 (счета, ипотеки, категории)
    // ═══════════════════════════════════════════════════════

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_accounts_user_space 
      ON accounts(user_id, space_id, sync_status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_accounts_type 
      ON accounts(account_type)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_mortgages_account 
      ON mortgages(account_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_categories_space_user 
      ON categories(space_id, user_id, type)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_categories_parent 
      ON categories(parent_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_category_rules_space_bank 
      ON category_rules(space_id, bank_name)
    ''');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // 1. Создаём все таблицы (Drift сам обработает UniqueKeys из Memberships)
      await m.createAll();

      // 2. Создаём все индексы
      await _createAllIndexes();
    },

    // ↓ ДОБАВЛЕН БЛОК МИГРАЦИИ С ВЕРСИИ 1 НА 2 ↓
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Миграция v1 → v2: обновляем SyncableTable mixin
        // Drift не умеет изменять колонки "на лету", поэтому:
        // 1. Удаляем ВСЕ таблицы через raw SQL
        // 2. Создаём их заново с новым mixin
        // 3. Пересоздаём все индексы

        final tables = [
          'users',
          'spaces',
          'memberships',
          'app_settings',
          'notifications',
          'sync_conflicts',
          'sync_logs',
          'accounts',
          'mortgages',
          'categories',
          'category_rules',
        ];

        for (final table in tables) {
          await customStatement('DROP TABLE IF EXISTS $table');
        }

        await m.createAll();
        await _createAllIndexes();
      }
    },

    
    beforeOpen: (details) async {
      AppLogger.i('🔧 Migration details: wasCreated=${details.wasCreated}, hadUpgrade=${details.hadUpgrade}, versionNow=${details.versionNow}, versionBefore=${details.versionBefore}');
      // Включаем Foreign Keys (SQLite по умолчанию их не проверяет!)
      await customStatement('PRAGMA foreign_keys = ON');
      // WAL-режим: позволяет читать БД во время записи (критично для UI)
      await customStatement('PRAGMA journal_mode = WAL');
      // NORMAL вместо FULL: уменьшает overhead от sync, безопасно при WAL
      await customStatement('PRAGMA synchronous = NORMAL');
            // Проверяем список таблиц ПОСЛЕ миграции
      final tables = await customSelect("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name").get();
      AppLogger.i('📋 Tables in DB: ${tables.map((r) => r.read<String>('name')).join(', ')}');
    }
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'budget_assistant.sqlite');

    AppLogger.i('📁 DB Path: $dbPath');
    AppLogger.i(
      '📂 Directory exists: ${await Directory(dbFolder.path).exists()}',
    );

    // Проверяем, существует ли файл ДО открытия
    final fileExists = await File(dbPath).exists();
    AppLogger.i('💾 DB file exists before open: $fileExists');

    return NativeDatabase.createInBackground(File(dbPath));
  });
}

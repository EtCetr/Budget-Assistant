import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// ═══════════════════════════════════════════════════════════════
// Таблицы из Этапа 3 (фундаментальные сущности)
// ═══════════════════════════════════════════════════════════════
import 'tables/users.dart';
import 'tables/spaces.dart';
import 'tables/memberships.dart';
import 'tables/app_settings.dart';
import 'tables/notifications.dart';
import 'tables/sync_conflicts.dart';
import 'tables/sync_logs.dart';

// ═══════════════════════════════════════════════════════════════
// Enum'ы Этапа 6 (type, audit_status, sync_status)
// ═══════════════════════════════════════════════════════════════
import 'package:budget_assistant/core/enums/transaction_enums.dart';

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
// ЭТАП 6: Таблица транзакций
//
// Деньги: только IntColumn (копейки).
// Даты: только UTC.
// Внешние ключи: боевые (.references), т.к. все таблицы уже в области видимости.
// sync_locked_*: монотонные часы Android (защита от перевода часов).
// ═══════════════════════════════════════════════════════════════

@DataClassName('TransactionDb')
class Transactions extends Table {
  TextColumn get id => text()();

  /// Счёт-источник/приёмник. Боевой FK на accounts.
  TextColumn get accountId => text().references(Accounts, #id)();

  /// Счёт-получатель (только для type = 'transfer').
  TextColumn get linkedAccountId =>
      text().nullable().references(Accounts, #id)();

  TextColumn get userId => text().references(Users, #id)();

  TextColumn get spaceId => text().nullable().references(Spaces, #id)();

  /// Пространство создания (для кросс-группового шеринга).
  TextColumn get originalSpaceId => text().nullable().references(Spaces, #id)();

  /// ID от банка (защита от дублей при Batch-импорте).
  TextColumn get bankTransactionId => text().nullable()();

  /// Точное время операции, строго UTC.
  DateTimeColumn get date => dateTime()();

  /// Сумма в копейках, всегда > 0. Направление задаёт type.
  IntColumn get amount => integer()();

  TextColumn get originalCurrency => text().nullable()();

  /// Сумма в валюте операции (копейки/минорные единицы).
  IntColumn get originalAmount => integer().nullable()();

  TextColumn get type => textEnum<TransactionType>()();

  /// Сырая категория от банка.
  TextColumn get bankCategory => text().nullable()();

  /// Итоговая категория. Боевой FK на categories.
  TextColumn get customCategoryId =>
      text().nullable().references(Categories, #id)();

  TextColumn get merchantName => text().nullable()();

  TextColumn get comment => text().nullable()();

  /// Запрещает авто-категоризации перезаписывать выбор пользователя.
  BoolColumn get isUserEdited => boolean().withDefault(const Constant(false))();

    TextColumn get auditStatus =>
      textEnum<AuditStatus>().withDefault(const Constant('verified'))();

  /// Режим секретности (подарки).
  BoolColumn get isHiddenByCalendar =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get hiddenUntilDate => dateTime().nullable()();

  /// Значение SystemClock.elapsedRealtime() в момент создания.
  IntColumn get syncLockedStartedAt => integer().nullable()();

  /// Длительность блокировки в мс.
  IntColumn get syncLockedDurationMs => integer().nullable()();

  BoolColumn get isArchivedForSpace =>
      boolean().withDefault(const Constant(false))();

  /// Зеркалирование в кастомную вкладку (микро-P&L).
  BoolColumn get businessMirror =>
      boolean().withDefault(const Constant(false))();

  /// Привязка к цели накопления (таблица появится в Этапе 12, поле уже есть).
  TextColumn get savingsGoalId => text().nullable()();

  /// Флаг изъятия из цели (игнорируется в P&L).
  BoolColumn get isWithdrawal => boolean().withDefault(const Constant(false))();

  /// Флаг наличия сплитов (чеков/долгов).
  BoolColumn get isSplit => boolean().withDefault(const Constant(false))();

  /// Связь с прикреплённым чеком (таблица появится в Этапе 16).
  TextColumn get receiptId => text().nullable()();

  /// Флаг крупной траты для аналитического фильтра.
  /// Используется в P&L / Dashboard / Monthly Analytics.
  /// В лимитах по категориям не учитывается.
  BoolColumn get isLargeExpense =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
    textEnum<SyncStatus>().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════
// ЭТАП 6: Сплиты чека/долга
// ═══════════════════════════════════════════════════════════════

@DataClassName('TransactionSplitDb')
class TransactionSplits extends Table {
  TextColumn get id => text()();

  TextColumn get transactionId => text().references(Transactions, #id)();

  TextColumn get categoryId => text().references(Categories, #id)();

  /// Сумма части в копейках.
  IntColumn get amount => integer()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();

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
    // Этап 6: Транзакции и сплиты
    Transactions,
    TransactionSplits,
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
  AppDatabase._internal() : super(_openConnection());

  /// Единственный экземпляр на всё приложение (защита от race conditions)
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  /// Конструктор для unit-тестов (in-memory БД)
  AppDatabase.forTesting(super.e);

  /// Конструктор для background isolate (WorkManager)
  AppDatabase.forBackground(super.e);
  
  /// v1: старт (Этап 3)
  /// v2: миграция SyncableTable (Этап 3/5)
  /// v3: Этап 6 — таблицы transactions и transaction_splits
  /// v4: Этап 8+ — поле is_large_expense (аналитический фильтр)
  @override
  int get schemaVersion => 4;

  /// Вспомогательный метод для создания всех индексов
  /// Вызывается и в onCreate, и в onUpgrade (после пересоздания таблиц)
  Future<void> _createAllIndexes() async {
    // ═══════════════════════════════════════════════════════
    // ИНДЕКСЫ ДЛЯ ЭТАПА 3 (фундаментальные таблицы)
    // ═══════════════════════════════════════════════════════

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_memberships_user 
      ON memberships(user_id, status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_memberships_space 
      ON memberships(space_id, status)
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_app_settings_user 
      ON app_settings(user_id)
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_notifications_user_read 
      ON notifications(user_id, is_read, created_at DESC)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_notifications_space 
      ON notifications(space_id)
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_conflicts_unresolved 
      ON sync_conflicts(entity_type, entity_id) 
      WHERE resolved_at IS NULL
    ''');

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

    // ═══════════════════════════════════════════════════════
    // ИНДЕКСЫ ДЛЯ ЭТАПА 6 (транзакции и сплиты)
    // ТОМ 2, раздел 22 + DECISIONS.md
    // ═══════════════════════════════════════════════════════

    // КРИТИЧНЫЙ индекс: P&L, календарь, batch sync.
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_user_space_date 
      ON transactions(user_id, space_id, date)
    ''');

    // Календарь и дневная статистика (ORDER BY date).
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_date 
      ON transactions(date)
    ''');

    // Фильтрация по счёту и категории.
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_account_category 
      ON transactions(account_id, custom_category_id)
    ''');

    // Обязателен для Offline-First синхронизации.
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_sync_status 
      ON transactions(sync_status)
    ''');

    // Фильтрация hold-операций (pending).
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_audit_status 
      ON transactions(audit_status)
    ''');

    // Связь с копилками (Этап 12).
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_savings_goal 
      ON transactions(savings_goal_id)
    ''');

    // Аналитический фильтр крупных трат.
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_large_expense 
      ON transactions(is_large_expense)
    ''');

    // Защита от дублей при Batch-импорте.
    // Частичный уникальный: большинство ручных операций не имеют bank ID.
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_transactions_bank_tx_id 
      ON transactions(bank_transaction_id) 
      WHERE bank_transaction_id IS NOT NULL
    ''');

    // JOIN сплитов с родительской транзакцией.
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transaction_splits_transaction 
      ON transaction_splits(transaction_id)
    ''');

    // Pending-сплиты для синхронизации.
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transaction_splits_sync_status 
      ON transaction_splits(sync_status)
    ''');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // 1. Создаём все таблицы
      await m.createAll();

      // 2. Создаём все индексы
      await _createAllIndexes();
    },

    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Миграция v1 → v2: обновляем SyncableTable mixin.
        // ВНИМАНИЕ: Эта ветка выполнялась только на ранних версиях проекта.
        // Теперь, когда схема стабилизирована (Этап 6+), мы НЕ удаляем таблицы.
        // Вместо этого добавляем недостающие колонки через ALTER TABLE.
        AppLogger.w('Migration v1→v2 skipped: tables already stable');
      } else if (from < 3) {
        // Миграция v2 → v3: Этап 6, таблицы транзакций и сплитов.
        await m.createTable(transactions);
        await m.createTable(transactionSplits);
        await _createAllIndexes();
      } else if (from < 4) {
        // Миграция v3 → v4: добавляем поле is_large_expense
        await customStatement(
          'ALTER TABLE transactions '
          'ADD COLUMN is_large_expense INTEGER NOT NULL DEFAULT 0',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_transactions_large_expense '
          'ON transactions(is_large_expense)',
        );
      }
    },

    beforeOpen: (details) async {
      AppLogger.i(
        '🔧 Migration details: wasCreated=${details.wasCreated}, hadUpgrade=${details.hadUpgrade}, versionNow=${details.versionNow}, versionBefore=${details.versionBefore}',
      );
      // Включаем Foreign Keys (SQLite по умолчанию их не проверяет!)
      await customStatement('PRAGMA foreign_keys = ON');
      // WAL-режим: позволяет читать БД во время записи (критично для UI)
      await customStatement('PRAGMA journal_mode = WAL');
      // NORMAL вместо FULL: уменьшает overhead от sync, безопасно при WAL
      await customStatement('PRAGMA synchronous = NORMAL');
      // Проверяем список таблиц ПОСЛЕ миграции
      final tables = await customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
      ).get();
      AppLogger.i(
        '📋 Tables in DB: ${tables.map((r) => r.read<String>('name')).join(', ')}',
      );
    },
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

    // ✅ Синхронная БД в основном isolate: нет isolate-канала,
    // нечему закрываться после hot restart
    return NativeDatabase(File(dbPath));
  });
}

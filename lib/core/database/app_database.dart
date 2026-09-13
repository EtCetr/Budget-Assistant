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
import 'daos/budget_limits_dao.dart';

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
// ═══════════════════════════════════════════════════════════════
@DataClassName('TransactionDb')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get linkedAccountId =>
      text().nullable().references(Accounts, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get originalSpaceId => text().nullable().references(Spaces, #id)();
  TextColumn get bankTransactionId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get amount => integer()();
  TextColumn get originalCurrency => text().nullable()();
  IntColumn get originalAmount => integer().nullable()();
  TextColumn get type => textEnum<TransactionType>()();
  TextColumn get bankCategory => text().nullable()();
  TextColumn get customCategoryId =>
      text().nullable().references(Categories, #id)();
  TextColumn get merchantName => text().nullable()();
  TextColumn get comment => text().nullable()();
  BoolColumn get isUserEdited => boolean().withDefault(const Constant(false))();
  TextColumn get auditStatus =>
      textEnum<AuditStatus>().withDefault(const Constant('verified'))();
  BoolColumn get isHiddenByCalendar =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get hiddenUntilDate => dateTime().nullable()();
  IntColumn get syncLockedStartedAt => integer().nullable()();
  IntColumn get syncLockedDurationMs => integer().nullable()();
  BoolColumn get isArchivedForSpace =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get businessMirror =>
      boolean().withDefault(const Constant(false))();
  TextColumn get savingsGoalId => text().nullable()();
  BoolColumn get isWithdrawal => boolean().withDefault(const Constant(false))();
  BoolColumn get isSplit => boolean().withDefault(const Constant(false))();
  TextColumn get receiptId => text().nullable()();
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
// ЭТАП 9: Бюджетные лимиты по категориям
//
// Уникальный констрейнт: (space_id, user_id, category_id, year, month)
// Деньги: IntColumn (копейки), E2E-шифрование limit_amount и alert_amount
// ═══════════════════════════════════════════════════════════════
@DataClassName('BudgetLimitDb')
class BudgetLimits extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get categoryId => text().references(Categories, #id)();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get limitAmount => integer()();
  IntColumn get alertPercent => integer().withDefault(const Constant(80))();
  IntColumn get alertAmount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════
// Основная конфигурация БД
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// ЭТАП 10: Курсы валют (мультивалютность, ТОМ 2 §18.2)
// ═══════════════════════════════════════════════════════════════
@DataClassName('ExchangeRateDb')
class ExchangeRates extends Table {
  TextColumn get id => text()();
  TextColumn get fromCurrency => text()();
  TextColumn get toCurrency => text()();
  DateTimeColumn get date => dateTime()();
  // Мультипликатор (не деньги).
  RealColumn get rate => real()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════
// ЭТАП 10: Матрица кэшбэка по картам (ТОМ 2 §14.3)
// ═══════════════════════════════════════════════════════════════
@DataClassName('CashbackMatrixDb')
class CashbackMatrix extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  // Привязка к локальной категории для расчёта NET-суммы (ТОМ 4 Правило 1).
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  // Название категории банка (в Supabase шифруется [E2E]).
  TextColumn get categoryName => text()();
  IntColumn get percentBps => integer()();
  TextColumn get status => text().withDefault(const Constant('potential'))();
  TextColumn get lifetimeType => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
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
    // Этап 9: Бюджетные лимиты
    BudgetLimits,
    // Этап 10: Кэшбэк и курсы валют
    ExchangeRates,
    CashbackMatrix,
  ],
  daos: [
    UsersDao,
    SpacesDao,
    MembershipsDao,
    AppSettingsDao,
    NotificationsDao,
    SyncConflictsDao,
    SyncLogsDao,
    BudgetLimitsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  AppDatabase.forTesting(super.e);
  AppDatabase.forBackground(super.e);

  /// v1: старт (Этап 3)
  /// v2: миграция SyncableTable (Этап 3/5) — ИСТОРИЧЕСКАЯ МИНА, удалена в v5
  /// v3: Этап 6 — таблицы transactions и transaction_splits
  /// v4: Этап 8+ — поле is_large_expense
  /// v5: Этап 9 — таблица budget_limits + индексы
  @override
  int get schemaVersion => 6;

  Future<void> _createAllIndexes() async {
    // ИНДЕКСЫ ДЛЯ ЭТАПА 3
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

    // ИНДЕКСЫ ДЛЯ ЭТАПА 5
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

    // ИНДЕКСЫ ДЛЯ ЭТАПА 6
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_user_space_date
      ON transactions(user_id, space_id, date)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_date
      ON transactions(date)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_account_category
      ON transactions(account_id, custom_category_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_sync_status
      ON transactions(sync_status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_audit_status
      ON transactions(audit_status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_savings_goal
      ON transactions(savings_goal_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_large_expense
      ON transactions(is_large_expense)
    ''');
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_transactions_bank_tx_id
      ON transactions(bank_transaction_id)
      WHERE bank_transaction_id IS NOT NULL
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transaction_splits_transaction
      ON transaction_splits(transaction_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transaction_splits_sync_status
      ON transaction_splits(sync_status)
    ''');

    // ИНДЕКСЫ ДЛЯ ЭТАПА 9 (budget_limits)
    // Уникальный констрейнт: один лимит на категорию в месяц
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_budget_limits_unique
      ON budget_limits(space_id, user_id, category_id, year, month)
    ''');
    // Поиск лимитов по категории
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_budget_limits_category
      ON budget_limits(category_id)
    ''');
    // Pending-лимиты для синхронизации
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_budget_limits_sync_status
      ON budget_limits(sync_status)
    ''');
    // Фильтрация по пользователю и пространству
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_budget_limits_user_space
      ON budget_limits(user_id, space_id)
    ''');
    // ИНДЕКСЫ ДЛЯ ЭТАПА 10 (кэшбэк + курсы валют)
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_exchange_rates_unique
      ON exchange_rates(from_currency, to_currency, date)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_cashback_matrix_account
      ON cashback_matrix(account_id, expires_at)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_cashback_matrix_sync_status
      ON cashback_matrix(sync_status)
    ''');

  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _createAllIndexes();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // ИСТОРИЧЕСКАЯ МИНА УДАЛЕНА: ветка from < 2 с DROP TABLE
      // больше не нужна, т.к. схема стабилизирована на v4+
      if (from < 3) {
        await m.createTable(transactions);
        await m.createTable(transactionSplits);
        await _createAllIndexes();
      }
      if (from < 4) {
        await customStatement(
          'ALTER TABLE transactions '
          'ADD COLUMN is_large_expense INTEGER NOT NULL DEFAULT 0',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_transactions_large_expense '
          'ON transactions(is_large_expense)',
        );
      }
      if (from < 5) {
        // ЭТАП 9: создаём таблицу budget_limits
        await m.createTable(budgetLimits);
        // Создаём индексы для budget_limits
        await customStatement('''
              CREATE UNIQUE INDEX IF NOT EXISTS idx_budget_limits_unique
              ON budget_limits(space_id, user_id, category_id, year, month)
            ''');
        await customStatement('''
              CREATE INDEX IF NOT EXISTS idx_budget_limits_category
              ON budget_limits(category_id)
            ''');
        await customStatement('''
              CREATE INDEX IF NOT EXISTS idx_budget_limits_sync_status
              ON budget_limits(sync_status)
            ''');
        await customStatement('''
              CREATE INDEX IF NOT EXISTS idx_budget_limits_user_space
              ON budget_limits(user_id, space_id)
            ''');
      }
    
        if (from < 6) {
          // ЭТАП 10: кэшбэк + мультивалютность
          await m.createTable(exchangeRates);
          await m.createTable(cashbackMatrix);
          await customStatement('''
            CREATE UNIQUE INDEX IF NOT EXISTS idx_exchange_rates_unique
            ON exchange_rates(from_currency, to_currency, date)
          ''');
          await customStatement('''
            CREATE INDEX IF NOT EXISTS idx_cashback_matrix_account
            ON cashback_matrix(account_id, expires_at)
          ''');
          await customStatement('''
            CREATE INDEX IF NOT EXISTS idx_cashback_matrix_sync_status
            ON cashback_matrix(sync_status)
          ''');
        }
},
    beforeOpen: (details) async {
      AppLogger.i(
        '🔧 Migration details: wasCreated=${details.wasCreated}, hadUpgrade=${details.hadUpgrade}, versionNow=${details.versionNow}, versionBefore=${details.versionBefore}',
      );
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
      await customStatement('PRAGMA synchronous = NORMAL');
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
    final fileExists = await File(dbPath).exists();
    AppLogger.i('💾 DB file exists before open: $fileExists');
    return NativeDatabase(File(dbPath));
  });
}

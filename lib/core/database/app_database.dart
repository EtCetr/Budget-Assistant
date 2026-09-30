import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
// Таблицы из Этапа 3 (центральные сущности)
import 'tables/users.dart';
import 'tables/spaces.dart';
import 'tables/memberships.dart';
import 'tables/app_settings.dart';
import 'tables/notifications.dart';
import 'tables/sync_conflicts.dart';
import 'tables/sync_logs.dart';
import 'tables/parser_configs.dart';
import 'tables/import_drafts.dart';
// Enum'ы из Этапа 6 (type, audit_status, sync_status)
import 'package:budget_assistant/core/enums/transaction_enums.dart';
// DAO — типобезопасный доступ к таблицам
import 'daos/users_dao.dart';
import 'daos/spaces_dao.dart';
import 'daos/memberships_dao.dart';
import 'daos/app_settings_dao.dart';
import 'daos/notifications_dao.dart';
import 'daos/sync_conflicts_dao.dart';
import 'daos/sync_logs_dao.dart';
import 'daos/budget_limits_dao.dart';
import 'package:budget_assistant/core/logger.dart';
import 'seeds/default_holidays_seed.dart';
import 'package:budget_assistant/features/import/data/seeds/default_parser_configs_seed.dart';
part 'app_database.g.dart';

// Этап 5: Счета, Ипотеки, Категории
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

// Этап 6: Транзакции и Сплиты
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

// Этап 9: Месячные лимиты
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

// Этап 10: Курсы валют
@DataClassName('ExchangeRateDb')
class ExchangeRates extends Table {
  TextColumn get id => text()();
  TextColumn get fromCurrency => text()();
  TextColumn get toCurrency => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get rate => real()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

// Этап 10: Матрица кэшбэка
@DataClassName('CashbackMatrixDb')
class CashbackMatrix extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
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

class DashboardWidgets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get widgetType => text()();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}

// Этап 12: Цели накопления + локальные черновики форм
@DataClassName('SavingsGoalDb')
class SavingsGoals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get name => text()(); // [E2E]
  IntColumn get targetAmount => integer()(); // [E2E]
  IntColumn get currentAmount =>
      integer().withDefault(const Constant(0))(); // [E2E]
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get linkedAccountId =>
      text().nullable().references(Accounts, #id)();
  TextColumn get currency => text().withDefault(const Constant('RUB'))();
  IntColumn get draftAmount => integer().nullable()(); // [E2E]
  BoolColumn get autoReminderEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SavingsGoalDraftDb')
class SavingsGoalDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get goalId => text().nullable()();
  TextColumn get formDataJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

// ЭТАП 13: Долги + локальные черновики (долги, сплиты)
@DataClassName('DebtDb')
class Debts extends Table {
  TextColumn get id => text()();
  TextColumn get creditorId => text().nullable().references(Users, #id)();
  TextColumn get debtorId => text().nullable().references(Users, #id)();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get categoryId =>
      text().nullable().references(Categories, #id)();
  IntColumn get amount => integer()();
  TextColumn get currency => text().withDefault(const Constant('RUB'))();
  TextColumn get description => text().nullable()();
  TextColumn get counterpartyNameDative => text().nullable()();
  TextColumn get originalTransactionId =>
      text().nullable().references(Transactions, #id)();
  TextColumn get splitId =>
      text().nullable().references(TransactionSplits, #id)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  TextColumn get resolutionStatus =>
      text().withDefault(const Constant('active'))();
  BoolColumn get isExMemberDebt =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get autoResolve =>
      boolean().withDefault(const Constant(true))();
  TextColumn get createdBy => text().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DebtDraftDb')
class DebtDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get debtId => text().nullable()();
  TextColumn get formDataJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SplitDraftDb')
class SplitDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text().references(Transactions, #id)();
  TextColumn get positionsJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────────────────────────────────────────
// ЭТАП 14: Напоминания (RRULE) + Календарь
// (ТОМ 2 §15, §16.1, §20.1, §23.3; расширения ТОМ 6 §6.3.9/6.3.11)
// ─────────────────────────────────────────────────────────────

/// Регулярные платежи (подписки и регулярки).
/// E2E-поля (merchant_name, average_amount) хранятся локально открыто и
/// шифруются AES-256-GCM перед sync-пейлоадом (Этап 25) — как цели/долги.
/// merchant_name_normalized и average_amount_bucket — ОТКРЫТЫ: это ключ
/// идемпотентного upsert (ТЗ 6.3.9.9).
@DataClassName('RecurringTransactionDb')
class RecurringTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  /// Личная сущность: фактически всегда NULL (ТЗ 6.3.9.15).
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get merchantName => text()(); // [E2E]
  TextColumn get merchantNameNormalized => text()(); // [OPEN] ключ upsert
  IntColumn get averageAmount => integer()(); // [E2E] копейки
  /// Копейки, округлённые до 100 рублей (ключ upsert).
  IntColumn get averageAmountBucket => integer()();
  IntColumn get averageDayOfMonth => integer()();
  IntColumn get occurrenceCount => integer().withDefault(const Constant(0))();
  /// 'high' | 'medium' | 'low'.
  TextColumn get confidence => text().withDefault(const Constant('medium'))();
  /// 'pending_confirmation' | 'active'.
  TextColumn get status =>
      text().withDefault(const Constant('pending_confirmation'))();
  DateTimeColumn get firstSeenDate => dateTime().nullable()();
  DateTimeColumn get lastSeenDate => dateTime().nullable()();
  /// Связь с напоминанием. Plain text: циклический FK с reminders
  /// ломает сортировку таблиц Drift (отклонение зафиксировано).
  TextColumn get linkedReminderId => text().nullable()();
  TextColumn get categoryId =>
      text().nullable().references(Categories, #id)();
  DateTimeColumn get detectedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}

/// Умные напоминания (Фича 10). assignee_id -> memberships.id, НЕ users.id.
@DataClassName('ReminderDb')
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get title => text()(); // [E2E]
  TextColumn get description => text().nullable()(); // [E2E]
  DateTimeColumn get remindAt => dateTime()(); // UTC
  /// iCal RRULE строка (nullable = однократно).
  TextColumn get recurrenceRule => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get assigneeId =>
      text().nullable().references(Memberships, #id)();
  /// Plain text: циклический FK с recurring_transactions (отклонение).
  TextColumn get linkedRecurringId => text().nullable()();
  TextColumn get linkedCategoryId =>
      text().nullable().references(Categories, #id)();
  TextColumn get linkedAccountId =>
      text().nullable().references(Accounts, #id)();
  IntColumn get expectedAmount => integer().nullable()(); // [E2E] копейки
  /// 'low' | 'normal' | 'high'.
  TextColumn get priority => text().withDefault(const Constant('normal'))();
  IntColumn get snoozeCount => integer().withDefault(const Constant(0))();
  /// [LOCAL] JSON-массив истории откладываний, не синхронизируется.
  TextColumn get snoozeHistory => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}

/// Праздники для режима секретности и календаря.
/// Пресеты РФ (is_preset = TRUE) — локальные сиды, не синхронизируются.
@DataClassName('HolidayDb')
class Holidays extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get userId => text().nullable().references(Users, #id)();
  TextColumn get name => text()(); // [E2E]
  DateTimeColumn get date => dateTime()(); // UTC
  BoolColumn get isAnnuallyRecurring =>
      boolean().withDefault(const Constant(true))();
  TextColumn get iconEmoji => text().nullable()(); // [E2E]
  TextColumn get colorHex => text().nullable()();
  BoolColumn get isPreset => boolean().withDefault(const Constant(false))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}

/// Кэш прогноза баланса. Локальный кэш: без sync_status и created_at
/// (ТОМ 2 §20.1) — UI читает готовые агрегаты.
@DataClassName('ForecastCacheDb')
class ForecastCache extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  /// Формат 'YYYY-MM'.
  TextColumn get monthYear => text()();
  TextColumn get categoryId =>
      text().nullable().references(Categories, #id)();
  IntColumn get forecastedAmount => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

/// Локальный черновик формы напоминания (без sync, ТОМ 2 §23.3).
@DataClassName('ReminderDraftDb')
class ReminderDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get reminderId => text().nullable()();
  TextColumn get formDataJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Users,
    Spaces,
    Memberships,
    AppSettings,
    Notifications,
    SyncConflicts,
    SyncLogs,
    Accounts,
    Mortgages,
    Categories,
    CategoryRules,
    Transactions,
    TransactionSplits,
    BudgetLimits,
    ExchangeRates,
    CashbackMatrix,
    DashboardWidgets,
    SavingsGoals,
    SavingsGoalDrafts,
    Debts,
    DebtDrafts,
    SplitDrafts,
    // Этап 14: напоминания, праздники, регулярки, кэш прогноза, черновики
    RecurringTransactions,
    Reminders,
    Holidays,
    ForecastCache,
    ReminderDrafts,
    // Этап 15: импорт
    ParserConfigs,
    ImportDrafts,
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

  /// v13: Этап 14 — reminders, holidays, recurring_transactions,
  /// forecast_cache, reminder_drafts + 5 колонок app_settings + сиды РФ.
  @override
  int get schemaVersion => 15;

  Future<void> _createSavingsIndexes() async {
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_savings_goals_user_status
ON savings_goals(user_id, space_id, status, deadline, sync_status)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_savings_goals_sync_status
ON savings_goals(sync_status)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_savings_goal_drafts_user
ON savings_goal_drafts(user_id, updated_at)
''');
  }

  Future<void> _createDebtsIndexes() async {
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_debts_creditor
ON debts(creditor_id, resolution_status)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_debts_debtor
ON debts(debtor_id, resolution_status)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_debts_space_status
ON debts(space_id, resolution_status)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_debts_due_date
ON debts(due_date)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_debts_sync_status
ON debts(sync_status)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_debt_drafts_user
ON debt_drafts(user_id, updated_at)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_split_drafts_transaction
ON split_drafts(transaction_id)
''');
  }

  Future<void> _createRemindersIndexes() async {
    // ТОМ 2 §22: планировщик уведомлений и фильтры напоминаний.
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_reminders_schedule
ON reminders(remind_at, assignee_id, space_id, is_completed, sync_status)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_reminders_linked_recurring
ON reminders(linked_recurring_id)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_holidays_space_date
ON holidays(space_id, date, is_annually_recurring)
''');
    // ТОМ 2 §22 + ТЗ 6.3.9.9: уникальность ключа upsert
    // (нормализованный мерчант + бакет суммы).
    await customStatement('''
CREATE UNIQUE INDEX IF NOT EXISTS idx_recurring_upsert
ON recurring_transactions(user_id, merchant_name_normalized, average_amount_bucket)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_recurring_last_seen
ON recurring_transactions(last_seen_date)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_forecast_cache_month
ON forecast_cache(user_id, space_id, month_year)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS idx_reminder_drafts_user
ON reminder_drafts(user_id, updated_at)
''');
  }

  Future<void> _createImportIndexes() async {
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_parser_configs_bank_code
      ON parser_configs(bank_code)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_parser_configs_bank_name
      ON parser_configs(bank_name, supported_formats)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_import_drafts_user
      ON import_drafts(user_id, updated_at)
    ''');
  }

  Future<void> _createAllIndexes() async {
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
    await _createSavingsIndexes();
    // Фикс Этапа 14: на чистой установке индексы долгов ранее не создавались.
    await _createDebtsIndexes();
    await _createRemindersIndexes();
    await _createImportIndexes();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _createAllIndexes();
          await DefaultHolidaysSeed.seedIfEmpty(this);
await DefaultParserConfigsSeed.seedIfEmpty(this);
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 9) {
            await m.createTable(savingsGoals);
            await m.createTable(savingsGoalDrafts);
            await _createSavingsIndexes();
          }
          if (from < 12) {
            // Этап 13: консолидированная миграция v10–v12 (идемпотентна).
            final debtsExists = await customSelect(
              "SELECT COUNT(*) AS c FROM sqlite_master WHERE type='table' AND name='debts'",
            ).getSingle();
            if (debtsExists.read<int>('c') != 0) {
              await customStatement('DROP TABLE debts');
            }
            await m.createTable(debts);
            final debtDraftsExists = await customSelect(
              "SELECT COUNT(*) AS c FROM sqlite_master WHERE type='table' AND name='debt_drafts'",
            ).getSingle();
            if (debtDraftsExists.read<int>('c') == 0) {
              await m.createTable(debtDrafts);
            }
            final splitDraftsExists = await customSelect(
              "SELECT COUNT(*) AS c FROM sqlite_master WHERE type='table' AND name='split_drafts'",
            ).getSingle();
            if (splitDraftsExists.read<int>('c') == 0) {
              await m.createTable(splitDrafts);
            }
            await _createDebtsIndexes();
          }
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
            await m.createTable(budgetLimits);
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
          if (from < 8) {
            final dashboardTableExists = await customSelect(
              "SELECT COUNT(*) AS c FROM sqlite_master "
              "WHERE type='table' AND name='dashboard_widgets'",
            ).getSingle();
            if (dashboardTableExists.read<int>('c') == 0) {
              await m.createTable(dashboardWidgets);
            }
            await customStatement('''
CREATE UNIQUE INDEX IF NOT EXISTS idx_dashboard_widgets_user_type
ON dashboard_widgets(user_id, widget_type)
''');
            await customStatement('''
CREATE INDEX IF NOT EXISTS idx_dashboard_widgets_sync_status
ON dashboard_widgets(sync_status)
''');
          }
          if (from < 14) {
          // Этап 15: parser_configs + import_drafts
          await m.createTable(parserConfigs);
          await m.createTable(importDrafts);
          await _createImportIndexes();
          await DefaultParserConfigsSeed.seedIfEmpty(this);
        }
        if (from < 15) {
  // Этап 15: добавляем колонку detection_patterns для автоопределения банка
  await customStatement(
    'ALTER TABLE parser_configs ADD COLUMN detection_patterns TEXT',
  );
}
if (from < 13) {
            // Этап 14: Reminders (RRULE) + Calendar.
            await m.createTable(recurringTransactions);
            await m.createTable(reminders);
            await m.createTable(holidays);
            await m.createTable(forecastCache);
            await m.createTable(reminderDrafts);
            await m.addColumn(appSettings, appSettings.holidaysInfoDismissed);
            await m.addColumn(
                appSettings, appSettings.recurringDetectionInfoDismissed);
            await m.addColumn(
                appSettings, appSettings.recurringDetectionDismissCount);
            await m.addColumn(appSettings, appSettings.autoDetectRecurring);
            await m.addColumn(
                appSettings, appSettings.enableFamilyHolidayAlerts);
            await _createRemindersIndexes();
    await _createImportIndexes();
            await DefaultHolidaysSeed.seedIfEmpty(this);
await DefaultParserConfigsSeed.seedIfEmpty(this);
          }
        },
        beforeOpen: (details) async {
          AppLogger.i(
            '📦 Migration details: wasCreated=${details.wasCreated}, hadUpgrade=${details.hadUpgrade}, versionNow=${details.versionNow}, versionBefore=${details.versionBefore}',
          );
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement(
              'CREATE UNIQUE INDEX IF NOT EXISTS idx_dashboard_widgets_user_type ON dashboard_widgets(user_id, widget_type)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_dashboard_widgets_sync_status ON dashboard_widgets(sync_status)');
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
    AppLogger.i('📄 DB file exists before open: $fileExists');
    return NativeDatabase(File(dbPath));
  });
}
/// Описание таблицы для синхронизации.
///
/// Здесь же задаётся, какие поля шифруются перед Supabase.
class SyncTableSpec {
  const SyncTableSpec({
    required this.entityType,
    required this.localTable,
    required this.remoteTable,
    required this.idColumn,
    required this.userColumn,
    required this.spaceColumn,
    required this.updatedAtColumn,
    required this.syncStatusColumn,
    this.lockedStartedAtColumn,
    this.lockedDurationMsColumn,
    this.sensitiveColumns = const [],
    this.numericColumns = const [],
    this.ignoredColumns = const [],
    this.remoteColumnMap = const {},
  });

  /// Тип сущности для логов и конфликтов.
  final String entityType;

  /// Локальная таблица Drift/SQLite.
  final String localTable;

  /// Таблица в Supabase.
  final String remoteTable;

  final String idColumn;
  final String userColumn;
  final String spaceColumn;
  final String updatedAtColumn;
  final String syncStatusColumn;

  /// Только для транзакций: монотонные часы начала блокировки.
  final String? lockedStartedAtColumn;

  /// Только для транзакций: длительность блокировки в мс.
  final String? lockedDurationMsColumn;

  /// Поля, которые должны быть зашифрованы перед отправкой.
  final List<String> sensitiveColumns;

  /// Поля, которые после расшифровки должны стать int.
  final List<String> numericColumns;

  /// Локальные поля, которые не синхронизируются.
  final List<String> ignoredColumns;

  /// Маппинг локальное поле -> удалённое поле.
  final Map<String, String> remoteColumnMap;

  String remoteColumnFor(String localColumn) {
    return remoteColumnMap[localColumn] ?? localColumn;
  }

  bool isSensitive(String column) => sensitiveColumns.contains(column);

  bool shouldSend(String column) => !ignoredColumns.contains(column);

  static const accounts = SyncTableSpec(
    entityType: 'account',
    localTable: 'accounts',
    remoteTable: 'accounts',
    idColumn: 'id',
    userColumn: 'user_id',
    spaceColumn: 'space_id',
    updatedAtColumn: 'updated_at',
    syncStatusColumn: 'sync_status',
    sensitiveColumns: ['custom_name', 'bank_name'],
    numericColumns: [],
    ignoredColumns: ['sort_order'],
  );

  static const categories = SyncTableSpec(
    entityType: 'category',
    localTable: 'categories',
    remoteTable: 'categories',
    idColumn: 'id',
    userColumn: 'user_id',
    spaceColumn: 'space_id',
    updatedAtColumn: 'updated_at',
    syncStatusColumn: 'sync_status',
    sensitiveColumns: ['name'],
    numericColumns: [],
    ignoredColumns: ['sort_order'],
  );

  static const transactions = SyncTableSpec(
    entityType: 'transaction',
    localTable: 'transactions',
    remoteTable: 'transactions',
    idColumn: 'id',
    userColumn: 'user_id',
    spaceColumn: 'space_id',
    updatedAtColumn: 'updated_at',
    syncStatusColumn: 'sync_status',
    lockedStartedAtColumn: 'sync_locked_started_at',
    lockedDurationMsColumn: 'sync_locked_duration_ms',
    sensitiveColumns: ['amount', 'comment', 'merchant_name', 'bank_category'],
    numericColumns: ['amount', 'original_amount'],
    ignoredColumns: [],
  );

  static const budgetLimits = SyncTableSpec(
    entityType: 'budget_limit',
    localTable: 'budget_limits',
    remoteTable: 'budget_limits',
    idColumn: 'id',
    userColumn: 'user_id',
    spaceColumn: 'space_id',
    updatedAtColumn: 'updated_at',
    syncStatusColumn: 'sync_status',
    sensitiveColumns: ['limit_amount', 'alert_amount'],
    numericColumns: ['limit_amount', 'alert_amount'],
    ignoredColumns: [],
  );

  static const defaultSpecs = [accounts, categories, transactions, budgetLimits];
}

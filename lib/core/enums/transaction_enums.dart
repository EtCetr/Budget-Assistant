/// Типы транзакций.
///
/// Важно:
/// - переводы не участвуют в P&L;
/// - возвраты создаются как income, отдельного is_refund нет.
enum TransactionType { expense, income, transfer }

/// Статус аудита транзакции.
///
/// Возможные значения:
/// - verified — обычная подтверждённая операция;
/// - suspicious — подозрительная операция;
/// - ignored — исключена из аналитики;
/// - pending — hold-операция из импорта.
enum AuditStatus { verified, suspicious, ignored, pending }

/// Статус офлайн-синхронизации.
///
/// Используется во всех синхронизируемых сущностях.
enum SyncStatus { pending, synced, conflict }

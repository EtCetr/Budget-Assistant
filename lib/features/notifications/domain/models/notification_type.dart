/// Каналы Android-уведомлений (ТОМ 5 §4.4, D18-2).
enum NotificationChannel {
  budget('channel_budget', 'Бюджет и финансы', 'Лимиты, долги, цели, прогнозы'),
  reminders('channel_reminders', 'Напоминания', 'Напоминания, праздники, дайджесты'),
  importReceipts('channel_import_receipts', 'Импорт и чеки', 'Импорт выписок, чеки, дубликаты'),
  systemSync('channel_system_sync', 'Система и синхронизация', 'Синхронизация, участники, конфликты');

  const NotificationChannel(this.id, this.title, this.description);

  final String id;
  final String title;
  final String description;
}

/// 27 типов уведомлений (ТОМ 5 §2) + системные дополнения (D18-1).
/// dbValue — значение колонки notifications.type.
/// alwaysOn — нельзя выключить свитчем.
/// critical — исключение из 24-часовой дедупликации (ТОМ 5 §4.1).
enum NotificationType {
  // 1-5: бюджеты
  limitGlobalPercent('limit_global_percent', NotificationChannel.budget),
  limitGlobalAmount('limit_global_amount', NotificationChannel.budget),
  limitIndividual('limit_individual', NotificationChannel.budget),
  deficitForecastWarning('deficit_forecast_warning', NotificationChannel.budget, critical: true),
  savingsRateDrop('savings_rate_drop', NotificationChannel.budget),
  // 6-9: долги
  debtCreated('debt_created', NotificationChannel.budget),
  debtClosed('debt_closed', NotificationChannel.budget),
  debtForgiven('debt_forgiven', NotificationChannel.budget),
  debtOverdue('debt_overdue', NotificationChannel.budget),
  // 10-15: импорт/чеки
  unmatchedReceipt('unmatched_receipt', NotificationChannel.importReceipts),
  duplicateReceipt('duplicate_receipt', NotificationChannel.importReceipts, alwaysOn: true),
  duplicateDetected('duplicate_detected', NotificationChannel.importReceipts),
  transferDetected('transfer_detected', NotificationChannel.importReceipts),
  holdConfirmed('hold_confirmed', NotificationChannel.importReceipts, alwaysOn: true),
  bankStatementReminder('bank_statement_reminder', NotificationChannel.importReceipts),
  // 16-20: напоминания
  reminderDue('reminder_due', NotificationChannel.reminders),
  reminderSnoozeWarning('reminder_snooze_warning', NotificationChannel.reminders),
  recurringDetected('recurring_detected', NotificationChannel.importReceipts, alwaysOn: true),
  holidaySecrecyStart('holiday_secrecy_start', NotificationChannel.reminders),
  giftPurchaseAlert('gift_purchase_alert', NotificationChannel.budget),
  // 21-23: цели
  goalMilestone('goal_milestone', NotificationChannel.budget),
  goalDeadlineApproaching('goal_deadline_approaching', NotificationChannel.budget),
  investmentYieldReceived('investment_yield_received', NotificationChannel.budget),
  // 24-27: админка/система
  adminHeartbeatWarning('admin_heartbeat_warning', NotificationChannel.systemSync),
  memberActivity('member_activity', NotificationChannel.systemSync),
  syncConflictManual('sync_conflict_manual', NotificationChannel.systemSync, alwaysOn: true, critical: true),
  yearReviewReady('year_review_ready', NotificationChannel.systemSync),
  // Системные дополнения (без настроек).
  spaceDissolved('space_dissolved', NotificationChannel.systemSync, alwaysOn: true),
  adminReminder('admin_reminder', NotificationChannel.systemSync, alwaysOn: true),
  syncReminder('sync_reminder', NotificationChannel.systemSync, alwaysOn: true),
  dailyDigest('daily_digest', NotificationChannel.reminders, alwaysOn: true);

  const NotificationType(
    this.dbValue,
    this.channel, {
    this.alwaysOn = false,
    this.critical = false,
  });

  final String dbValue;
  final NotificationChannel channel;
  final bool alwaysOn;
  final bool critical;

  static NotificationType? fromDb(String? v) {
    if (v == null) return null;
    for (final t in values) {
      if (t.dbValue == v) return t;
    }
    return null;
  }
}
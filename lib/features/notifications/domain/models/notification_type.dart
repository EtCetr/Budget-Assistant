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

/// 27 канонических типов уведомлений (ТОМ 5 §2).
/// alwaysOn — нет свитча в настройках. critical — без дедупликации 24ч.
enum NotificationType {
  limitGlobalPercent(NotificationChannel.budget),
  limitGlobalAmount(NotificationChannel.budget),
  limitIndividual(NotificationChannel.budget),
  deficitForecastWarning(NotificationChannel.budget, critical: true),
  savingsRateDrop(NotificationChannel.budget),
  debtCreated(NotificationChannel.budget),
  debtClosed(NotificationChannel.budget),
  debtForgiven(NotificationChannel.budget),
  debtOverdue(NotificationChannel.budget),
  unmatchedReceipt(NotificationChannel.importReceipts),
  duplicateReceipt(NotificationChannel.importReceipts, alwaysOn: true),
  duplicateDetected(NotificationChannel.importReceipts),
  transferDetected(NotificationChannel.importReceipts),
  holdConfirmed(NotificationChannel.importReceipts, alwaysOn: true),
  bankStatementReminder(NotificationChannel.importReceipts),
  reminderDue(NotificationChannel.reminders),
  reminderSnoozeWarning(NotificationChannel.reminders),
  recurringDetected(NotificationChannel.importReceipts, alwaysOn: true),
  holidaySecrecyStart(NotificationChannel.reminders),
  giftPurchaseAlert(NotificationChannel.budget),
  goalMilestone(NotificationChannel.budget),
  goalDeadlineApproaching(NotificationChannel.budget),
  investmentYieldReceived(NotificationChannel.budget),
  adminHeartbeatWarning(NotificationChannel.systemSync),
  memberActivity(NotificationChannel.systemSync),
  syncConflictManual(NotificationChannel.systemSync, alwaysOn: true, critical: true),
  yearReviewReady(NotificationChannel.systemSync),
  dailyDigest(NotificationChannel.reminders),
  weeklyDigest(NotificationChannel.reminders),
  monthlyDigest(NotificationChannel.reminders);

  const NotificationType(
    this.channel, {
    this.alwaysOn = false,
    this.critical = false,
  });

  final NotificationChannel channel;
  final bool alwaysOn;
  final bool critical;

  String get dbValue => name;
  String get channelId => channel.id;

  String get label => switch (this) {
    NotificationType.limitGlobalPercent => 'Лимит: 80% месячного бюджета',
    NotificationType.limitGlobalAmount => 'Лимит: превышение суммы',
    NotificationType.limitIndividual => 'Лимит категории',
    NotificationType.deficitForecastWarning => 'Прогноз дефицита',
    NotificationType.savingsRateDrop => 'Норма сбережений снизилась',
    NotificationType.debtCreated => 'Создан долг',
    NotificationType.debtClosed => 'Долг закрыт',
    NotificationType.debtForgiven => 'Долг прощён',
    NotificationType.debtOverdue => 'Просроченный долг',
    NotificationType.unmatchedReceipt => 'Чек без категории',
    NotificationType.duplicateReceipt => 'Дубликат чека',
    NotificationType.duplicateDetected => 'Найден дубликат операции',
    NotificationType.transferDetected => 'Найден перевод между счетами',
    NotificationType.holdConfirmed => 'Заморозка подтверждена',
    NotificationType.bankStatementReminder => 'Напоминание о выписке',
    NotificationType.reminderDue => 'Напоминание',
    NotificationType.reminderSnoozeWarning => 'Напоминание откладывается',
    NotificationType.recurringDetected => 'Найдена скрытая подписка',
    NotificationType.holidaySecrecyStart => 'Режим секретности праздника',
    NotificationType.giftPurchaseAlert => 'Крупная покупка',
    NotificationType.goalMilestone => 'Цель: прогресс',
    NotificationType.goalDeadlineApproaching => 'Цель: скоро дедлайн',
    NotificationType.investmentYieldReceived => 'Начислен инвестиционный доход',
    NotificationType.adminHeartbeatWarning => 'Админ давно не заходил',
    NotificationType.memberActivity => 'Активность участников',
    NotificationType.syncConflictManual => 'Конфликт синхронизации',
    NotificationType.yearReviewReady => 'Годовой отчёт готов',
    NotificationType.dailyDigest => 'Дайджест за день',
    NotificationType.weeklyDigest => 'Дайджест за неделю',
    NotificationType.monthlyDigest => 'Дайджест за месяц',
  };

  static NotificationType fromDb(String? v) => NotificationType.values
      .firstWhere((e) => e.name == v, orElse: () => NotificationType.reminderDue);
}
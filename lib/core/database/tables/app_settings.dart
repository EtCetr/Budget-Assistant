// lib/core/database/tables/app_settings.dart
import 'package:drift/drift.dart';
import 'syncable_mixin.dart';
import 'users.dart';

class AppSettings extends Table with SyncableTable {
  TextColumn get id => text().named('id')();
  TextColumn get userId => text().named('user_id').references(Users, #id)();

  // Финансы и Валюты [SYNC]
  TextColumn get baseCurrency =>
      text().named('base_currency').withDefault(const Constant('RUB'))();
  BoolColumn get useHistoricalExchangeRate => boolean()
      .named('use_historical_exchange_rate')
      .withDefault(const Constant(true))();

  // Лимиты и Бюджеты [SYNC]
  BoolColumn get inheritLimitFromPreviousMonth => boolean()
      .named('inherit_limit_from_previous_month')
      .withDefault(const Constant(false))();
  BoolColumn get carryOverUnusedLimit => boolean()
      .named('carry_over_unused_limit')
      .withDefault(const Constant(false))();
  TextColumn get limitAlertMode => text()
      .named('limit_alert_mode')
      .withDefault(const Constant('global_percent'))();
  IntColumn get globalAlertPercent =>
      integer().named('global_alert_percent').withDefault(const Constant(80))();
  IntColumn get globalAlertAmount =>
      integer().named('global_alert_amount').withDefault(const Constant(0))();

  // Режим Секретности [SYNC]
  BoolColumn get enableSecrecyMode => boolean()
      .named('enable_secrecy_mode')
      .withDefault(const Constant(true))();
  IntColumn get secrecyDaysBefore =>
      integer().named('secrecy_days_before').withDefault(const Constant(14))();
  IntColumn get secrecyTimeoutSeconds => integer()
      .named('secrecy_timeout_seconds')
      .withDefault(const Constant(120))();
  IntColumn get largeTransactionThreshold => integer()
      .named('large_transaction_threshold')
      .withDefault(const Constant(10000000))();
  BoolColumn get autoHideGiftsOnImport => boolean()
      .named('auto_hide_gifts_on_import')
      .withDefault(const Constant(true))();

  // Безопасность и Приватность [LOCAL]
  TextColumn get defaultBalanceVisibility => text()
      .named('default_balance_visibility')
      .withDefault(const Constant('visible'))();
  BoolColumn get enableShakeToHide => boolean()
      .named('enable_shake_to_hide')
      .withDefault(const Constant(true))();
  BoolColumn get enableFaceDownHide => boolean()
      .named('enable_face_down_hide')
      .withDefault(const Constant(true))();
  BoolColumn get enableAutoHideTimeout => boolean()
      .named('enable_auto_hide_timeout')
      .withDefault(const Constant(true))();
  BoolColumn get enableScreenCaptureProtection => boolean()
      .named('enable_screen_capture_protection')
      .withDefault(const Constant(false))();
  BoolColumn get requireBiometricsToUnhide => boolean()
      .named('require_biometrics_to_unhide')
      .withDefault(const Constant(false))();
  BoolColumn get enablePinCode =>
      boolean().named('enable_pin_code').withDefault(const Constant(false))();
  BoolColumn get enableBiometricLogin => boolean()
      .named('enable_biometric_login')
      .withDefault(const Constant(false))();

  // Импорт и Чеки [LOCAL]
  BoolColumn get enableAutoDetectDuplicates => boolean()
      .named('enable_auto_detect_duplicates')
      .withDefault(const Constant(true))();
  BoolColumn get enableAutoDetectTransfers => boolean()
      .named('enable_auto_detect_transfers')
      .withDefault(const Constant(true))();
  IntColumn get duplicateDateToleranceDays => integer()
      .named('duplicate_date_tolerance_days')
      .withDefault(const Constant(1))();
  IntColumn get transferTimeToleranceMinutes => integer()
      .named('transfer_time_tolerance_minutes')
      .withDefault(const Constant(5))();
  BoolColumn get autoOfferReceiptSplit => boolean()
      .named('auto_offer_receipt_split')
      .withDefault(const Constant(true))();
  IntColumn get offerReceiptSplitCount => integer()
      .named('offer_receipt_split_count')
      .withDefault(const Constant(0))();
  BoolColumn get autoOfferProductNaming => boolean()
      .named('auto_offer_product_naming')
      .withDefault(const Constant(true))();
  IntColumn get offerProductNamingCount => integer()
      .named('offer_product_naming_count')
      .withDefault(const Constant(0))();
  BoolColumn get syncImagesToCloud => boolean()
      .named('sync_images_to_cloud')
      .withDefault(const Constant(false))();
  BoolColumn get enableBankStatementReminder => boolean()
      .named('enable_bank_statement_reminder')
      .withDefault(const Constant(true))();

  // Уведомления и Пуши [LOCAL]
  BoolColumn get enableGroupActivityAlerts => boolean()
      .named('enable_group_activity_alerts')
      .withDefault(const Constant(true))();
  BoolColumn get enableDeficitForecastAlerts => boolean()
      .named('enable_deficit_forecast_alerts')
      .withDefault(const Constant(true))();
  BoolColumn get enableYearInReviewAlerts => boolean()
      .named('enable_year_in_review_alerts')
      .withDefault(const Constant(true))();
  BoolColumn get enableDebtAlerts =>
      boolean().named('enable_debt_alerts').withDefault(const Constant(true))();
  BoolColumn get enableReminderNotifications => boolean()
      .named('enable_reminder_notifications')
      .withDefault(const Constant(true))();
  IntColumn get reminderAdvanceDays =>
      integer().named('reminder_advance_days').withDefault(const Constant(1))();
  TextColumn get reminderTimeOfDay => text()
      .named('reminder_time_of_day')
      .withDefault(const Constant('17:00'))();
  BoolColumn get autoCreateRemindersForRecurring => boolean()
      .named('auto_create_reminders_for_recurring')
      .withDefault(const Constant(true))();
  TextColumn get digestConfig =>
      text().named('digest_config').withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

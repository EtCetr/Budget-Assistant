import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_model.freezed.dart';
part 'app_settings_model.g.dart';

@freezed
abstract class AppSettingsModel with _$AppSettingsModel {
  const factory AppSettingsModel({
    required String id,
    required String userId,

    // Финансы
    @Default('RUB') String baseCurrency,
    @Default(true) bool useHistoricalExchangeRate,

    // Лимиты
    @Default(false) bool inheritLimitFromPreviousMonth,
    @Default(false) bool carryOverUnusedLimit,
    @Default('global_percent') String limitAlertMode,
    @Default(80) int globalAlertPercent,
    @Default(0) int globalAlertAmount,

    // Режим секретности
    @Default(true) bool enableSecrecyMode,
    @Default(14) int secrecyDaysBefore,
    @Default(120) int secrecyTimeoutSeconds,
    @Default(10000000) int largeTransactionThreshold,
    @Default(true) bool autoHideGiftsOnImport,

    // Безопасность
    @Default('visible') String defaultBalanceVisibility,
    @Default(true) bool enableShakeToHide,
    @Default(true) bool enableFaceDownHide,
    @Default(true) bool enableAutoHideTimeout,
    @Default(false) bool enableScreenCaptureProtection,
    @Default(false) bool requireBiometricsToUnhide,
    @Default(false) bool enablePinCode,
    @Default(false) bool enableBiometricLogin,

    // Импорт
    @Default(true) bool enableAutoDetectDuplicates,
    @Default(true) bool enableAutoDetectTransfers,
    @Default(1) int duplicateDateToleranceDays,
    @Default(5) int transferTimeToleranceMinutes,
    @Default(true) bool autoOfferReceiptSplit,
    @Default(0) int offerReceiptSplitCount,
    @Default(true) bool autoOfferProductNaming,
    @Default(0) int offerProductNamingCount,
    @Default(false) bool syncImagesToCloud,
    @Default(true) bool enableBankStatementReminder,

    // Уведомления
    @Default(true) bool enableGroupActivityAlerts,
    @Default(true) bool enableDeficitForecastAlerts,
    @Default(true) bool enableYearInReviewAlerts,
    @Default(true) bool enableDebtAlerts,
    @Default(true) bool enableReminderNotifications,
    @Default(1) int reminderAdvanceDays,
    @Default('17:00') String reminderTimeOfDay,
    @Default(true) bool autoCreateRemindersForRecurring,
    @Default('{}') String digestConfig,

    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _AppSettingsModel;

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);
}

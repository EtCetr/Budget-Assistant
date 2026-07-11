// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettingsModel _$AppSettingsModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_AppSettingsModel', json, ($checkedConvert) {
  final val = _AppSettingsModel(
    id: $checkedConvert('id', (v) => v as String),
    userId: $checkedConvert('userId', (v) => v as String),
    baseCurrency: $checkedConvert('baseCurrency', (v) => v as String? ?? 'RUB'),
    useHistoricalExchangeRate: $checkedConvert(
      'useHistoricalExchangeRate',
      (v) => v as bool? ?? true,
    ),
    inheritLimitFromPreviousMonth: $checkedConvert(
      'inheritLimitFromPreviousMonth',
      (v) => v as bool? ?? false,
    ),
    carryOverUnusedLimit: $checkedConvert(
      'carryOverUnusedLimit',
      (v) => v as bool? ?? false,
    ),
    limitAlertMode: $checkedConvert(
      'limitAlertMode',
      (v) => v as String? ?? 'global_percent',
    ),
    globalAlertPercent: $checkedConvert(
      'globalAlertPercent',
      (v) => (v as num?)?.toInt() ?? 80,
    ),
    globalAlertAmount: $checkedConvert(
      'globalAlertAmount',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    enableSecrecyMode: $checkedConvert(
      'enableSecrecyMode',
      (v) => v as bool? ?? true,
    ),
    secrecyDaysBefore: $checkedConvert(
      'secrecyDaysBefore',
      (v) => (v as num?)?.toInt() ?? 14,
    ),
    secrecyTimeoutSeconds: $checkedConvert(
      'secrecyTimeoutSeconds',
      (v) => (v as num?)?.toInt() ?? 120,
    ),
    largeTransactionThreshold: $checkedConvert(
      'largeTransactionThreshold',
      (v) => (v as num?)?.toInt() ?? 10000000,
    ),
    autoHideGiftsOnImport: $checkedConvert(
      'autoHideGiftsOnImport',
      (v) => v as bool? ?? true,
    ),
    defaultBalanceVisibility: $checkedConvert(
      'defaultBalanceVisibility',
      (v) => v as String? ?? 'visible',
    ),
    enableShakeToHide: $checkedConvert(
      'enableShakeToHide',
      (v) => v as bool? ?? true,
    ),
    enableFaceDownHide: $checkedConvert(
      'enableFaceDownHide',
      (v) => v as bool? ?? true,
    ),
    enableAutoHideTimeout: $checkedConvert(
      'enableAutoHideTimeout',
      (v) => v as bool? ?? true,
    ),
    enableScreenCaptureProtection: $checkedConvert(
      'enableScreenCaptureProtection',
      (v) => v as bool? ?? false,
    ),
    requireBiometricsToUnhide: $checkedConvert(
      'requireBiometricsToUnhide',
      (v) => v as bool? ?? false,
    ),
    enablePinCode: $checkedConvert('enablePinCode', (v) => v as bool? ?? false),
    enableBiometricLogin: $checkedConvert(
      'enableBiometricLogin',
      (v) => v as bool? ?? false,
    ),
    enableAutoDetectDuplicates: $checkedConvert(
      'enableAutoDetectDuplicates',
      (v) => v as bool? ?? true,
    ),
    enableAutoDetectTransfers: $checkedConvert(
      'enableAutoDetectTransfers',
      (v) => v as bool? ?? true,
    ),
    duplicateDateToleranceDays: $checkedConvert(
      'duplicateDateToleranceDays',
      (v) => (v as num?)?.toInt() ?? 1,
    ),
    transferTimeToleranceMinutes: $checkedConvert(
      'transferTimeToleranceMinutes',
      (v) => (v as num?)?.toInt() ?? 5,
    ),
    autoOfferReceiptSplit: $checkedConvert(
      'autoOfferReceiptSplit',
      (v) => v as bool? ?? true,
    ),
    offerReceiptSplitCount: $checkedConvert(
      'offerReceiptSplitCount',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    autoOfferProductNaming: $checkedConvert(
      'autoOfferProductNaming',
      (v) => v as bool? ?? true,
    ),
    offerProductNamingCount: $checkedConvert(
      'offerProductNamingCount',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    syncImagesToCloud: $checkedConvert(
      'syncImagesToCloud',
      (v) => v as bool? ?? false,
    ),
    enableBankStatementReminder: $checkedConvert(
      'enableBankStatementReminder',
      (v) => v as bool? ?? true,
    ),
    enableGroupActivityAlerts: $checkedConvert(
      'enableGroupActivityAlerts',
      (v) => v as bool? ?? true,
    ),
    enableDeficitForecastAlerts: $checkedConvert(
      'enableDeficitForecastAlerts',
      (v) => v as bool? ?? true,
    ),
    enableYearInReviewAlerts: $checkedConvert(
      'enableYearInReviewAlerts',
      (v) => v as bool? ?? true,
    ),
    enableDebtAlerts: $checkedConvert(
      'enableDebtAlerts',
      (v) => v as bool? ?? true,
    ),
    enableReminderNotifications: $checkedConvert(
      'enableReminderNotifications',
      (v) => v as bool? ?? true,
    ),
    reminderAdvanceDays: $checkedConvert(
      'reminderAdvanceDays',
      (v) => (v as num?)?.toInt() ?? 1,
    ),
    reminderTimeOfDay: $checkedConvert(
      'reminderTimeOfDay',
      (v) => v as String? ?? '17:00',
    ),
    autoCreateRemindersForRecurring: $checkedConvert(
      'autoCreateRemindersForRecurring',
      (v) => v as bool? ?? true,
    ),
    digestConfig: $checkedConvert('digestConfig', (v) => v as String? ?? '{}'),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    syncStatus: $checkedConvert('syncStatus', (v) => v as String? ?? 'pending'),
  );
  return val;
});

Map<String, dynamic> _$AppSettingsModelToJson(
  _AppSettingsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'baseCurrency': instance.baseCurrency,
  'useHistoricalExchangeRate': instance.useHistoricalExchangeRate,
  'inheritLimitFromPreviousMonth': instance.inheritLimitFromPreviousMonth,
  'carryOverUnusedLimit': instance.carryOverUnusedLimit,
  'limitAlertMode': instance.limitAlertMode,
  'globalAlertPercent': instance.globalAlertPercent,
  'globalAlertAmount': instance.globalAlertAmount,
  'enableSecrecyMode': instance.enableSecrecyMode,
  'secrecyDaysBefore': instance.secrecyDaysBefore,
  'secrecyTimeoutSeconds': instance.secrecyTimeoutSeconds,
  'largeTransactionThreshold': instance.largeTransactionThreshold,
  'autoHideGiftsOnImport': instance.autoHideGiftsOnImport,
  'defaultBalanceVisibility': instance.defaultBalanceVisibility,
  'enableShakeToHide': instance.enableShakeToHide,
  'enableFaceDownHide': instance.enableFaceDownHide,
  'enableAutoHideTimeout': instance.enableAutoHideTimeout,
  'enableScreenCaptureProtection': instance.enableScreenCaptureProtection,
  'requireBiometricsToUnhide': instance.requireBiometricsToUnhide,
  'enablePinCode': instance.enablePinCode,
  'enableBiometricLogin': instance.enableBiometricLogin,
  'enableAutoDetectDuplicates': instance.enableAutoDetectDuplicates,
  'enableAutoDetectTransfers': instance.enableAutoDetectTransfers,
  'duplicateDateToleranceDays': instance.duplicateDateToleranceDays,
  'transferTimeToleranceMinutes': instance.transferTimeToleranceMinutes,
  'autoOfferReceiptSplit': instance.autoOfferReceiptSplit,
  'offerReceiptSplitCount': instance.offerReceiptSplitCount,
  'autoOfferProductNaming': instance.autoOfferProductNaming,
  'offerProductNamingCount': instance.offerProductNamingCount,
  'syncImagesToCloud': instance.syncImagesToCloud,
  'enableBankStatementReminder': instance.enableBankStatementReminder,
  'enableGroupActivityAlerts': instance.enableGroupActivityAlerts,
  'enableDeficitForecastAlerts': instance.enableDeficitForecastAlerts,
  'enableYearInReviewAlerts': instance.enableYearInReviewAlerts,
  'enableDebtAlerts': instance.enableDebtAlerts,
  'enableReminderNotifications': instance.enableReminderNotifications,
  'reminderAdvanceDays': instance.reminderAdvanceDays,
  'reminderTimeOfDay': instance.reminderTimeOfDay,
  'autoCreateRemindersForRecurring': instance.autoCreateRemindersForRecurring,
  'digestConfig': instance.digestConfig,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'syncStatus': instance.syncStatus,
};

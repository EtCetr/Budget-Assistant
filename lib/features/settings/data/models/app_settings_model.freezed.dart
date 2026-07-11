// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettingsModel {

 String get id; String get userId; String get baseCurrency; bool get useHistoricalExchangeRate; bool get inheritLimitFromPreviousMonth; bool get carryOverUnusedLimit; String get limitAlertMode; int get globalAlertPercent; int get globalAlertAmount; bool get enableSecrecyMode; int get secrecyDaysBefore; int get secrecyTimeoutSeconds; int get largeTransactionThreshold; bool get autoHideGiftsOnImport; String get defaultBalanceVisibility; bool get enableShakeToHide; bool get enableFaceDownHide; bool get enableAutoHideTimeout; bool get enableScreenCaptureProtection; bool get requireBiometricsToUnhide; bool get enablePinCode; bool get enableBiometricLogin; bool get enableAutoDetectDuplicates; bool get enableAutoDetectTransfers; int get duplicateDateToleranceDays; int get transferTimeToleranceMinutes; bool get autoOfferReceiptSplit; int get offerReceiptSplitCount; bool get autoOfferProductNaming; int get offerProductNamingCount; bool get syncImagesToCloud; bool get enableBankStatementReminder; bool get enableGroupActivityAlerts; bool get enableDeficitForecastAlerts; bool get enableYearInReviewAlerts; bool get enableDebtAlerts; bool get enableReminderNotifications; int get reminderAdvanceDays; String get reminderTimeOfDay; bool get autoCreateRemindersForRecurring; String get digestConfig; DateTime get createdAt; DateTime get updatedAt; String get syncStatus;
/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsModelCopyWith<AppSettingsModel> get copyWith => _$AppSettingsModelCopyWithImpl<AppSettingsModel>(this as AppSettingsModel, _$identity);

  /// Serializes this AppSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.baseCurrency, baseCurrency) || other.baseCurrency == baseCurrency)&&(identical(other.useHistoricalExchangeRate, useHistoricalExchangeRate) || other.useHistoricalExchangeRate == useHistoricalExchangeRate)&&(identical(other.inheritLimitFromPreviousMonth, inheritLimitFromPreviousMonth) || other.inheritLimitFromPreviousMonth == inheritLimitFromPreviousMonth)&&(identical(other.carryOverUnusedLimit, carryOverUnusedLimit) || other.carryOverUnusedLimit == carryOverUnusedLimit)&&(identical(other.limitAlertMode, limitAlertMode) || other.limitAlertMode == limitAlertMode)&&(identical(other.globalAlertPercent, globalAlertPercent) || other.globalAlertPercent == globalAlertPercent)&&(identical(other.globalAlertAmount, globalAlertAmount) || other.globalAlertAmount == globalAlertAmount)&&(identical(other.enableSecrecyMode, enableSecrecyMode) || other.enableSecrecyMode == enableSecrecyMode)&&(identical(other.secrecyDaysBefore, secrecyDaysBefore) || other.secrecyDaysBefore == secrecyDaysBefore)&&(identical(other.secrecyTimeoutSeconds, secrecyTimeoutSeconds) || other.secrecyTimeoutSeconds == secrecyTimeoutSeconds)&&(identical(other.largeTransactionThreshold, largeTransactionThreshold) || other.largeTransactionThreshold == largeTransactionThreshold)&&(identical(other.autoHideGiftsOnImport, autoHideGiftsOnImport) || other.autoHideGiftsOnImport == autoHideGiftsOnImport)&&(identical(other.defaultBalanceVisibility, defaultBalanceVisibility) || other.defaultBalanceVisibility == defaultBalanceVisibility)&&(identical(other.enableShakeToHide, enableShakeToHide) || other.enableShakeToHide == enableShakeToHide)&&(identical(other.enableFaceDownHide, enableFaceDownHide) || other.enableFaceDownHide == enableFaceDownHide)&&(identical(other.enableAutoHideTimeout, enableAutoHideTimeout) || other.enableAutoHideTimeout == enableAutoHideTimeout)&&(identical(other.enableScreenCaptureProtection, enableScreenCaptureProtection) || other.enableScreenCaptureProtection == enableScreenCaptureProtection)&&(identical(other.requireBiometricsToUnhide, requireBiometricsToUnhide) || other.requireBiometricsToUnhide == requireBiometricsToUnhide)&&(identical(other.enablePinCode, enablePinCode) || other.enablePinCode == enablePinCode)&&(identical(other.enableBiometricLogin, enableBiometricLogin) || other.enableBiometricLogin == enableBiometricLogin)&&(identical(other.enableAutoDetectDuplicates, enableAutoDetectDuplicates) || other.enableAutoDetectDuplicates == enableAutoDetectDuplicates)&&(identical(other.enableAutoDetectTransfers, enableAutoDetectTransfers) || other.enableAutoDetectTransfers == enableAutoDetectTransfers)&&(identical(other.duplicateDateToleranceDays, duplicateDateToleranceDays) || other.duplicateDateToleranceDays == duplicateDateToleranceDays)&&(identical(other.transferTimeToleranceMinutes, transferTimeToleranceMinutes) || other.transferTimeToleranceMinutes == transferTimeToleranceMinutes)&&(identical(other.autoOfferReceiptSplit, autoOfferReceiptSplit) || other.autoOfferReceiptSplit == autoOfferReceiptSplit)&&(identical(other.offerReceiptSplitCount, offerReceiptSplitCount) || other.offerReceiptSplitCount == offerReceiptSplitCount)&&(identical(other.autoOfferProductNaming, autoOfferProductNaming) || other.autoOfferProductNaming == autoOfferProductNaming)&&(identical(other.offerProductNamingCount, offerProductNamingCount) || other.offerProductNamingCount == offerProductNamingCount)&&(identical(other.syncImagesToCloud, syncImagesToCloud) || other.syncImagesToCloud == syncImagesToCloud)&&(identical(other.enableBankStatementReminder, enableBankStatementReminder) || other.enableBankStatementReminder == enableBankStatementReminder)&&(identical(other.enableGroupActivityAlerts, enableGroupActivityAlerts) || other.enableGroupActivityAlerts == enableGroupActivityAlerts)&&(identical(other.enableDeficitForecastAlerts, enableDeficitForecastAlerts) || other.enableDeficitForecastAlerts == enableDeficitForecastAlerts)&&(identical(other.enableYearInReviewAlerts, enableYearInReviewAlerts) || other.enableYearInReviewAlerts == enableYearInReviewAlerts)&&(identical(other.enableDebtAlerts, enableDebtAlerts) || other.enableDebtAlerts == enableDebtAlerts)&&(identical(other.enableReminderNotifications, enableReminderNotifications) || other.enableReminderNotifications == enableReminderNotifications)&&(identical(other.reminderAdvanceDays, reminderAdvanceDays) || other.reminderAdvanceDays == reminderAdvanceDays)&&(identical(other.reminderTimeOfDay, reminderTimeOfDay) || other.reminderTimeOfDay == reminderTimeOfDay)&&(identical(other.autoCreateRemindersForRecurring, autoCreateRemindersForRecurring) || other.autoCreateRemindersForRecurring == autoCreateRemindersForRecurring)&&(identical(other.digestConfig, digestConfig) || other.digestConfig == digestConfig)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,baseCurrency,useHistoricalExchangeRate,inheritLimitFromPreviousMonth,carryOverUnusedLimit,limitAlertMode,globalAlertPercent,globalAlertAmount,enableSecrecyMode,secrecyDaysBefore,secrecyTimeoutSeconds,largeTransactionThreshold,autoHideGiftsOnImport,defaultBalanceVisibility,enableShakeToHide,enableFaceDownHide,enableAutoHideTimeout,enableScreenCaptureProtection,requireBiometricsToUnhide,enablePinCode,enableBiometricLogin,enableAutoDetectDuplicates,enableAutoDetectTransfers,duplicateDateToleranceDays,transferTimeToleranceMinutes,autoOfferReceiptSplit,offerReceiptSplitCount,autoOfferProductNaming,offerProductNamingCount,syncImagesToCloud,enableBankStatementReminder,enableGroupActivityAlerts,enableDeficitForecastAlerts,enableYearInReviewAlerts,enableDebtAlerts,enableReminderNotifications,reminderAdvanceDays,reminderTimeOfDay,autoCreateRemindersForRecurring,digestConfig,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'AppSettingsModel(id: $id, userId: $userId, baseCurrency: $baseCurrency, useHistoricalExchangeRate: $useHistoricalExchangeRate, inheritLimitFromPreviousMonth: $inheritLimitFromPreviousMonth, carryOverUnusedLimit: $carryOverUnusedLimit, limitAlertMode: $limitAlertMode, globalAlertPercent: $globalAlertPercent, globalAlertAmount: $globalAlertAmount, enableSecrecyMode: $enableSecrecyMode, secrecyDaysBefore: $secrecyDaysBefore, secrecyTimeoutSeconds: $secrecyTimeoutSeconds, largeTransactionThreshold: $largeTransactionThreshold, autoHideGiftsOnImport: $autoHideGiftsOnImport, defaultBalanceVisibility: $defaultBalanceVisibility, enableShakeToHide: $enableShakeToHide, enableFaceDownHide: $enableFaceDownHide, enableAutoHideTimeout: $enableAutoHideTimeout, enableScreenCaptureProtection: $enableScreenCaptureProtection, requireBiometricsToUnhide: $requireBiometricsToUnhide, enablePinCode: $enablePinCode, enableBiometricLogin: $enableBiometricLogin, enableAutoDetectDuplicates: $enableAutoDetectDuplicates, enableAutoDetectTransfers: $enableAutoDetectTransfers, duplicateDateToleranceDays: $duplicateDateToleranceDays, transferTimeToleranceMinutes: $transferTimeToleranceMinutes, autoOfferReceiptSplit: $autoOfferReceiptSplit, offerReceiptSplitCount: $offerReceiptSplitCount, autoOfferProductNaming: $autoOfferProductNaming, offerProductNamingCount: $offerProductNamingCount, syncImagesToCloud: $syncImagesToCloud, enableBankStatementReminder: $enableBankStatementReminder, enableGroupActivityAlerts: $enableGroupActivityAlerts, enableDeficitForecastAlerts: $enableDeficitForecastAlerts, enableYearInReviewAlerts: $enableYearInReviewAlerts, enableDebtAlerts: $enableDebtAlerts, enableReminderNotifications: $enableReminderNotifications, reminderAdvanceDays: $reminderAdvanceDays, reminderTimeOfDay: $reminderTimeOfDay, autoCreateRemindersForRecurring: $autoCreateRemindersForRecurring, digestConfig: $digestConfig, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $AppSettingsModelCopyWith<$Res>  {
  factory $AppSettingsModelCopyWith(AppSettingsModel value, $Res Function(AppSettingsModel) _then) = _$AppSettingsModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String baseCurrency, bool useHistoricalExchangeRate, bool inheritLimitFromPreviousMonth, bool carryOverUnusedLimit, String limitAlertMode, int globalAlertPercent, int globalAlertAmount, bool enableSecrecyMode, int secrecyDaysBefore, int secrecyTimeoutSeconds, int largeTransactionThreshold, bool autoHideGiftsOnImport, String defaultBalanceVisibility, bool enableShakeToHide, bool enableFaceDownHide, bool enableAutoHideTimeout, bool enableScreenCaptureProtection, bool requireBiometricsToUnhide, bool enablePinCode, bool enableBiometricLogin, bool enableAutoDetectDuplicates, bool enableAutoDetectTransfers, int duplicateDateToleranceDays, int transferTimeToleranceMinutes, bool autoOfferReceiptSplit, int offerReceiptSplitCount, bool autoOfferProductNaming, int offerProductNamingCount, bool syncImagesToCloud, bool enableBankStatementReminder, bool enableGroupActivityAlerts, bool enableDeficitForecastAlerts, bool enableYearInReviewAlerts, bool enableDebtAlerts, bool enableReminderNotifications, int reminderAdvanceDays, String reminderTimeOfDay, bool autoCreateRemindersForRecurring, String digestConfig, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class _$AppSettingsModelCopyWithImpl<$Res>
    implements $AppSettingsModelCopyWith<$Res> {
  _$AppSettingsModelCopyWithImpl(this._self, this._then);

  final AppSettingsModel _self;
  final $Res Function(AppSettingsModel) _then;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? baseCurrency = null,Object? useHistoricalExchangeRate = null,Object? inheritLimitFromPreviousMonth = null,Object? carryOverUnusedLimit = null,Object? limitAlertMode = null,Object? globalAlertPercent = null,Object? globalAlertAmount = null,Object? enableSecrecyMode = null,Object? secrecyDaysBefore = null,Object? secrecyTimeoutSeconds = null,Object? largeTransactionThreshold = null,Object? autoHideGiftsOnImport = null,Object? defaultBalanceVisibility = null,Object? enableShakeToHide = null,Object? enableFaceDownHide = null,Object? enableAutoHideTimeout = null,Object? enableScreenCaptureProtection = null,Object? requireBiometricsToUnhide = null,Object? enablePinCode = null,Object? enableBiometricLogin = null,Object? enableAutoDetectDuplicates = null,Object? enableAutoDetectTransfers = null,Object? duplicateDateToleranceDays = null,Object? transferTimeToleranceMinutes = null,Object? autoOfferReceiptSplit = null,Object? offerReceiptSplitCount = null,Object? autoOfferProductNaming = null,Object? offerProductNamingCount = null,Object? syncImagesToCloud = null,Object? enableBankStatementReminder = null,Object? enableGroupActivityAlerts = null,Object? enableDeficitForecastAlerts = null,Object? enableYearInReviewAlerts = null,Object? enableDebtAlerts = null,Object? enableReminderNotifications = null,Object? reminderAdvanceDays = null,Object? reminderTimeOfDay = null,Object? autoCreateRemindersForRecurring = null,Object? digestConfig = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,baseCurrency: null == baseCurrency ? _self.baseCurrency : baseCurrency // ignore: cast_nullable_to_non_nullable
as String,useHistoricalExchangeRate: null == useHistoricalExchangeRate ? _self.useHistoricalExchangeRate : useHistoricalExchangeRate // ignore: cast_nullable_to_non_nullable
as bool,inheritLimitFromPreviousMonth: null == inheritLimitFromPreviousMonth ? _self.inheritLimitFromPreviousMonth : inheritLimitFromPreviousMonth // ignore: cast_nullable_to_non_nullable
as bool,carryOverUnusedLimit: null == carryOverUnusedLimit ? _self.carryOverUnusedLimit : carryOverUnusedLimit // ignore: cast_nullable_to_non_nullable
as bool,limitAlertMode: null == limitAlertMode ? _self.limitAlertMode : limitAlertMode // ignore: cast_nullable_to_non_nullable
as String,globalAlertPercent: null == globalAlertPercent ? _self.globalAlertPercent : globalAlertPercent // ignore: cast_nullable_to_non_nullable
as int,globalAlertAmount: null == globalAlertAmount ? _self.globalAlertAmount : globalAlertAmount // ignore: cast_nullable_to_non_nullable
as int,enableSecrecyMode: null == enableSecrecyMode ? _self.enableSecrecyMode : enableSecrecyMode // ignore: cast_nullable_to_non_nullable
as bool,secrecyDaysBefore: null == secrecyDaysBefore ? _self.secrecyDaysBefore : secrecyDaysBefore // ignore: cast_nullable_to_non_nullable
as int,secrecyTimeoutSeconds: null == secrecyTimeoutSeconds ? _self.secrecyTimeoutSeconds : secrecyTimeoutSeconds // ignore: cast_nullable_to_non_nullable
as int,largeTransactionThreshold: null == largeTransactionThreshold ? _self.largeTransactionThreshold : largeTransactionThreshold // ignore: cast_nullable_to_non_nullable
as int,autoHideGiftsOnImport: null == autoHideGiftsOnImport ? _self.autoHideGiftsOnImport : autoHideGiftsOnImport // ignore: cast_nullable_to_non_nullable
as bool,defaultBalanceVisibility: null == defaultBalanceVisibility ? _self.defaultBalanceVisibility : defaultBalanceVisibility // ignore: cast_nullable_to_non_nullable
as String,enableShakeToHide: null == enableShakeToHide ? _self.enableShakeToHide : enableShakeToHide // ignore: cast_nullable_to_non_nullable
as bool,enableFaceDownHide: null == enableFaceDownHide ? _self.enableFaceDownHide : enableFaceDownHide // ignore: cast_nullable_to_non_nullable
as bool,enableAutoHideTimeout: null == enableAutoHideTimeout ? _self.enableAutoHideTimeout : enableAutoHideTimeout // ignore: cast_nullable_to_non_nullable
as bool,enableScreenCaptureProtection: null == enableScreenCaptureProtection ? _self.enableScreenCaptureProtection : enableScreenCaptureProtection // ignore: cast_nullable_to_non_nullable
as bool,requireBiometricsToUnhide: null == requireBiometricsToUnhide ? _self.requireBiometricsToUnhide : requireBiometricsToUnhide // ignore: cast_nullable_to_non_nullable
as bool,enablePinCode: null == enablePinCode ? _self.enablePinCode : enablePinCode // ignore: cast_nullable_to_non_nullable
as bool,enableBiometricLogin: null == enableBiometricLogin ? _self.enableBiometricLogin : enableBiometricLogin // ignore: cast_nullable_to_non_nullable
as bool,enableAutoDetectDuplicates: null == enableAutoDetectDuplicates ? _self.enableAutoDetectDuplicates : enableAutoDetectDuplicates // ignore: cast_nullable_to_non_nullable
as bool,enableAutoDetectTransfers: null == enableAutoDetectTransfers ? _self.enableAutoDetectTransfers : enableAutoDetectTransfers // ignore: cast_nullable_to_non_nullable
as bool,duplicateDateToleranceDays: null == duplicateDateToleranceDays ? _self.duplicateDateToleranceDays : duplicateDateToleranceDays // ignore: cast_nullable_to_non_nullable
as int,transferTimeToleranceMinutes: null == transferTimeToleranceMinutes ? _self.transferTimeToleranceMinutes : transferTimeToleranceMinutes // ignore: cast_nullable_to_non_nullable
as int,autoOfferReceiptSplit: null == autoOfferReceiptSplit ? _self.autoOfferReceiptSplit : autoOfferReceiptSplit // ignore: cast_nullable_to_non_nullable
as bool,offerReceiptSplitCount: null == offerReceiptSplitCount ? _self.offerReceiptSplitCount : offerReceiptSplitCount // ignore: cast_nullable_to_non_nullable
as int,autoOfferProductNaming: null == autoOfferProductNaming ? _self.autoOfferProductNaming : autoOfferProductNaming // ignore: cast_nullable_to_non_nullable
as bool,offerProductNamingCount: null == offerProductNamingCount ? _self.offerProductNamingCount : offerProductNamingCount // ignore: cast_nullable_to_non_nullable
as int,syncImagesToCloud: null == syncImagesToCloud ? _self.syncImagesToCloud : syncImagesToCloud // ignore: cast_nullable_to_non_nullable
as bool,enableBankStatementReminder: null == enableBankStatementReminder ? _self.enableBankStatementReminder : enableBankStatementReminder // ignore: cast_nullable_to_non_nullable
as bool,enableGroupActivityAlerts: null == enableGroupActivityAlerts ? _self.enableGroupActivityAlerts : enableGroupActivityAlerts // ignore: cast_nullable_to_non_nullable
as bool,enableDeficitForecastAlerts: null == enableDeficitForecastAlerts ? _self.enableDeficitForecastAlerts : enableDeficitForecastAlerts // ignore: cast_nullable_to_non_nullable
as bool,enableYearInReviewAlerts: null == enableYearInReviewAlerts ? _self.enableYearInReviewAlerts : enableYearInReviewAlerts // ignore: cast_nullable_to_non_nullable
as bool,enableDebtAlerts: null == enableDebtAlerts ? _self.enableDebtAlerts : enableDebtAlerts // ignore: cast_nullable_to_non_nullable
as bool,enableReminderNotifications: null == enableReminderNotifications ? _self.enableReminderNotifications : enableReminderNotifications // ignore: cast_nullable_to_non_nullable
as bool,reminderAdvanceDays: null == reminderAdvanceDays ? _self.reminderAdvanceDays : reminderAdvanceDays // ignore: cast_nullable_to_non_nullable
as int,reminderTimeOfDay: null == reminderTimeOfDay ? _self.reminderTimeOfDay : reminderTimeOfDay // ignore: cast_nullable_to_non_nullable
as String,autoCreateRemindersForRecurring: null == autoCreateRemindersForRecurring ? _self.autoCreateRemindersForRecurring : autoCreateRemindersForRecurring // ignore: cast_nullable_to_non_nullable
as bool,digestConfig: null == digestConfig ? _self.digestConfig : digestConfig // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettingsModel].
extension AppSettingsModelPatterns on AppSettingsModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettingsModel implements AppSettingsModel {
  const _AppSettingsModel({required this.id, required this.userId, this.baseCurrency = 'RUB', this.useHistoricalExchangeRate = true, this.inheritLimitFromPreviousMonth = false, this.carryOverUnusedLimit = false, this.limitAlertMode = 'global_percent', this.globalAlertPercent = 80, this.globalAlertAmount = 0, this.enableSecrecyMode = true, this.secrecyDaysBefore = 14, this.secrecyTimeoutSeconds = 120, this.largeTransactionThreshold = 10000000, this.autoHideGiftsOnImport = true, this.defaultBalanceVisibility = 'visible', this.enableShakeToHide = true, this.enableFaceDownHide = true, this.enableAutoHideTimeout = true, this.enableScreenCaptureProtection = false, this.requireBiometricsToUnhide = false, this.enablePinCode = false, this.enableBiometricLogin = false, this.enableAutoDetectDuplicates = true, this.enableAutoDetectTransfers = true, this.duplicateDateToleranceDays = 1, this.transferTimeToleranceMinutes = 5, this.autoOfferReceiptSplit = true, this.offerReceiptSplitCount = 0, this.autoOfferProductNaming = true, this.offerProductNamingCount = 0, this.syncImagesToCloud = false, this.enableBankStatementReminder = true, this.enableGroupActivityAlerts = true, this.enableDeficitForecastAlerts = true, this.enableYearInReviewAlerts = true, this.enableDebtAlerts = true, this.enableReminderNotifications = true, this.reminderAdvanceDays = 1, this.reminderTimeOfDay = '17:00', this.autoCreateRemindersForRecurring = true, this.digestConfig = '{}', required this.createdAt, required this.updatedAt, this.syncStatus = 'pending'});
  factory _AppSettingsModel.fromJson(Map<String, dynamic> json) => _$AppSettingsModelFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  String baseCurrency;
@override@JsonKey() final  bool useHistoricalExchangeRate;
@override@JsonKey() final  bool inheritLimitFromPreviousMonth;
@override@JsonKey() final  bool carryOverUnusedLimit;
@override@JsonKey() final  String limitAlertMode;
@override@JsonKey() final  int globalAlertPercent;
@override@JsonKey() final  int globalAlertAmount;
@override@JsonKey() final  bool enableSecrecyMode;
@override@JsonKey() final  int secrecyDaysBefore;
@override@JsonKey() final  int secrecyTimeoutSeconds;
@override@JsonKey() final  int largeTransactionThreshold;
@override@JsonKey() final  bool autoHideGiftsOnImport;
@override@JsonKey() final  String defaultBalanceVisibility;
@override@JsonKey() final  bool enableShakeToHide;
@override@JsonKey() final  bool enableFaceDownHide;
@override@JsonKey() final  bool enableAutoHideTimeout;
@override@JsonKey() final  bool enableScreenCaptureProtection;
@override@JsonKey() final  bool requireBiometricsToUnhide;
@override@JsonKey() final  bool enablePinCode;
@override@JsonKey() final  bool enableBiometricLogin;
@override@JsonKey() final  bool enableAutoDetectDuplicates;
@override@JsonKey() final  bool enableAutoDetectTransfers;
@override@JsonKey() final  int duplicateDateToleranceDays;
@override@JsonKey() final  int transferTimeToleranceMinutes;
@override@JsonKey() final  bool autoOfferReceiptSplit;
@override@JsonKey() final  int offerReceiptSplitCount;
@override@JsonKey() final  bool autoOfferProductNaming;
@override@JsonKey() final  int offerProductNamingCount;
@override@JsonKey() final  bool syncImagesToCloud;
@override@JsonKey() final  bool enableBankStatementReminder;
@override@JsonKey() final  bool enableGroupActivityAlerts;
@override@JsonKey() final  bool enableDeficitForecastAlerts;
@override@JsonKey() final  bool enableYearInReviewAlerts;
@override@JsonKey() final  bool enableDebtAlerts;
@override@JsonKey() final  bool enableReminderNotifications;
@override@JsonKey() final  int reminderAdvanceDays;
@override@JsonKey() final  String reminderTimeOfDay;
@override@JsonKey() final  bool autoCreateRemindersForRecurring;
@override@JsonKey() final  String digestConfig;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String syncStatus;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsModelCopyWith<_AppSettingsModel> get copyWith => __$AppSettingsModelCopyWithImpl<_AppSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.baseCurrency, baseCurrency) || other.baseCurrency == baseCurrency)&&(identical(other.useHistoricalExchangeRate, useHistoricalExchangeRate) || other.useHistoricalExchangeRate == useHistoricalExchangeRate)&&(identical(other.inheritLimitFromPreviousMonth, inheritLimitFromPreviousMonth) || other.inheritLimitFromPreviousMonth == inheritLimitFromPreviousMonth)&&(identical(other.carryOverUnusedLimit, carryOverUnusedLimit) || other.carryOverUnusedLimit == carryOverUnusedLimit)&&(identical(other.limitAlertMode, limitAlertMode) || other.limitAlertMode == limitAlertMode)&&(identical(other.globalAlertPercent, globalAlertPercent) || other.globalAlertPercent == globalAlertPercent)&&(identical(other.globalAlertAmount, globalAlertAmount) || other.globalAlertAmount == globalAlertAmount)&&(identical(other.enableSecrecyMode, enableSecrecyMode) || other.enableSecrecyMode == enableSecrecyMode)&&(identical(other.secrecyDaysBefore, secrecyDaysBefore) || other.secrecyDaysBefore == secrecyDaysBefore)&&(identical(other.secrecyTimeoutSeconds, secrecyTimeoutSeconds) || other.secrecyTimeoutSeconds == secrecyTimeoutSeconds)&&(identical(other.largeTransactionThreshold, largeTransactionThreshold) || other.largeTransactionThreshold == largeTransactionThreshold)&&(identical(other.autoHideGiftsOnImport, autoHideGiftsOnImport) || other.autoHideGiftsOnImport == autoHideGiftsOnImport)&&(identical(other.defaultBalanceVisibility, defaultBalanceVisibility) || other.defaultBalanceVisibility == defaultBalanceVisibility)&&(identical(other.enableShakeToHide, enableShakeToHide) || other.enableShakeToHide == enableShakeToHide)&&(identical(other.enableFaceDownHide, enableFaceDownHide) || other.enableFaceDownHide == enableFaceDownHide)&&(identical(other.enableAutoHideTimeout, enableAutoHideTimeout) || other.enableAutoHideTimeout == enableAutoHideTimeout)&&(identical(other.enableScreenCaptureProtection, enableScreenCaptureProtection) || other.enableScreenCaptureProtection == enableScreenCaptureProtection)&&(identical(other.requireBiometricsToUnhide, requireBiometricsToUnhide) || other.requireBiometricsToUnhide == requireBiometricsToUnhide)&&(identical(other.enablePinCode, enablePinCode) || other.enablePinCode == enablePinCode)&&(identical(other.enableBiometricLogin, enableBiometricLogin) || other.enableBiometricLogin == enableBiometricLogin)&&(identical(other.enableAutoDetectDuplicates, enableAutoDetectDuplicates) || other.enableAutoDetectDuplicates == enableAutoDetectDuplicates)&&(identical(other.enableAutoDetectTransfers, enableAutoDetectTransfers) || other.enableAutoDetectTransfers == enableAutoDetectTransfers)&&(identical(other.duplicateDateToleranceDays, duplicateDateToleranceDays) || other.duplicateDateToleranceDays == duplicateDateToleranceDays)&&(identical(other.transferTimeToleranceMinutes, transferTimeToleranceMinutes) || other.transferTimeToleranceMinutes == transferTimeToleranceMinutes)&&(identical(other.autoOfferReceiptSplit, autoOfferReceiptSplit) || other.autoOfferReceiptSplit == autoOfferReceiptSplit)&&(identical(other.offerReceiptSplitCount, offerReceiptSplitCount) || other.offerReceiptSplitCount == offerReceiptSplitCount)&&(identical(other.autoOfferProductNaming, autoOfferProductNaming) || other.autoOfferProductNaming == autoOfferProductNaming)&&(identical(other.offerProductNamingCount, offerProductNamingCount) || other.offerProductNamingCount == offerProductNamingCount)&&(identical(other.syncImagesToCloud, syncImagesToCloud) || other.syncImagesToCloud == syncImagesToCloud)&&(identical(other.enableBankStatementReminder, enableBankStatementReminder) || other.enableBankStatementReminder == enableBankStatementReminder)&&(identical(other.enableGroupActivityAlerts, enableGroupActivityAlerts) || other.enableGroupActivityAlerts == enableGroupActivityAlerts)&&(identical(other.enableDeficitForecastAlerts, enableDeficitForecastAlerts) || other.enableDeficitForecastAlerts == enableDeficitForecastAlerts)&&(identical(other.enableYearInReviewAlerts, enableYearInReviewAlerts) || other.enableYearInReviewAlerts == enableYearInReviewAlerts)&&(identical(other.enableDebtAlerts, enableDebtAlerts) || other.enableDebtAlerts == enableDebtAlerts)&&(identical(other.enableReminderNotifications, enableReminderNotifications) || other.enableReminderNotifications == enableReminderNotifications)&&(identical(other.reminderAdvanceDays, reminderAdvanceDays) || other.reminderAdvanceDays == reminderAdvanceDays)&&(identical(other.reminderTimeOfDay, reminderTimeOfDay) || other.reminderTimeOfDay == reminderTimeOfDay)&&(identical(other.autoCreateRemindersForRecurring, autoCreateRemindersForRecurring) || other.autoCreateRemindersForRecurring == autoCreateRemindersForRecurring)&&(identical(other.digestConfig, digestConfig) || other.digestConfig == digestConfig)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,baseCurrency,useHistoricalExchangeRate,inheritLimitFromPreviousMonth,carryOverUnusedLimit,limitAlertMode,globalAlertPercent,globalAlertAmount,enableSecrecyMode,secrecyDaysBefore,secrecyTimeoutSeconds,largeTransactionThreshold,autoHideGiftsOnImport,defaultBalanceVisibility,enableShakeToHide,enableFaceDownHide,enableAutoHideTimeout,enableScreenCaptureProtection,requireBiometricsToUnhide,enablePinCode,enableBiometricLogin,enableAutoDetectDuplicates,enableAutoDetectTransfers,duplicateDateToleranceDays,transferTimeToleranceMinutes,autoOfferReceiptSplit,offerReceiptSplitCount,autoOfferProductNaming,offerProductNamingCount,syncImagesToCloud,enableBankStatementReminder,enableGroupActivityAlerts,enableDeficitForecastAlerts,enableYearInReviewAlerts,enableDebtAlerts,enableReminderNotifications,reminderAdvanceDays,reminderTimeOfDay,autoCreateRemindersForRecurring,digestConfig,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'AppSettingsModel(id: $id, userId: $userId, baseCurrency: $baseCurrency, useHistoricalExchangeRate: $useHistoricalExchangeRate, inheritLimitFromPreviousMonth: $inheritLimitFromPreviousMonth, carryOverUnusedLimit: $carryOverUnusedLimit, limitAlertMode: $limitAlertMode, globalAlertPercent: $globalAlertPercent, globalAlertAmount: $globalAlertAmount, enableSecrecyMode: $enableSecrecyMode, secrecyDaysBefore: $secrecyDaysBefore, secrecyTimeoutSeconds: $secrecyTimeoutSeconds, largeTransactionThreshold: $largeTransactionThreshold, autoHideGiftsOnImport: $autoHideGiftsOnImport, defaultBalanceVisibility: $defaultBalanceVisibility, enableShakeToHide: $enableShakeToHide, enableFaceDownHide: $enableFaceDownHide, enableAutoHideTimeout: $enableAutoHideTimeout, enableScreenCaptureProtection: $enableScreenCaptureProtection, requireBiometricsToUnhide: $requireBiometricsToUnhide, enablePinCode: $enablePinCode, enableBiometricLogin: $enableBiometricLogin, enableAutoDetectDuplicates: $enableAutoDetectDuplicates, enableAutoDetectTransfers: $enableAutoDetectTransfers, duplicateDateToleranceDays: $duplicateDateToleranceDays, transferTimeToleranceMinutes: $transferTimeToleranceMinutes, autoOfferReceiptSplit: $autoOfferReceiptSplit, offerReceiptSplitCount: $offerReceiptSplitCount, autoOfferProductNaming: $autoOfferProductNaming, offerProductNamingCount: $offerProductNamingCount, syncImagesToCloud: $syncImagesToCloud, enableBankStatementReminder: $enableBankStatementReminder, enableGroupActivityAlerts: $enableGroupActivityAlerts, enableDeficitForecastAlerts: $enableDeficitForecastAlerts, enableYearInReviewAlerts: $enableYearInReviewAlerts, enableDebtAlerts: $enableDebtAlerts, enableReminderNotifications: $enableReminderNotifications, reminderAdvanceDays: $reminderAdvanceDays, reminderTimeOfDay: $reminderTimeOfDay, autoCreateRemindersForRecurring: $autoCreateRemindersForRecurring, digestConfig: $digestConfig, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsModelCopyWith<$Res> implements $AppSettingsModelCopyWith<$Res> {
  factory _$AppSettingsModelCopyWith(_AppSettingsModel value, $Res Function(_AppSettingsModel) _then) = __$AppSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String baseCurrency, bool useHistoricalExchangeRate, bool inheritLimitFromPreviousMonth, bool carryOverUnusedLimit, String limitAlertMode, int globalAlertPercent, int globalAlertAmount, bool enableSecrecyMode, int secrecyDaysBefore, int secrecyTimeoutSeconds, int largeTransactionThreshold, bool autoHideGiftsOnImport, String defaultBalanceVisibility, bool enableShakeToHide, bool enableFaceDownHide, bool enableAutoHideTimeout, bool enableScreenCaptureProtection, bool requireBiometricsToUnhide, bool enablePinCode, bool enableBiometricLogin, bool enableAutoDetectDuplicates, bool enableAutoDetectTransfers, int duplicateDateToleranceDays, int transferTimeToleranceMinutes, bool autoOfferReceiptSplit, int offerReceiptSplitCount, bool autoOfferProductNaming, int offerProductNamingCount, bool syncImagesToCloud, bool enableBankStatementReminder, bool enableGroupActivityAlerts, bool enableDeficitForecastAlerts, bool enableYearInReviewAlerts, bool enableDebtAlerts, bool enableReminderNotifications, int reminderAdvanceDays, String reminderTimeOfDay, bool autoCreateRemindersForRecurring, String digestConfig, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class __$AppSettingsModelCopyWithImpl<$Res>
    implements _$AppSettingsModelCopyWith<$Res> {
  __$AppSettingsModelCopyWithImpl(this._self, this._then);

  final _AppSettingsModel _self;
  final $Res Function(_AppSettingsModel) _then;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? baseCurrency = null,Object? useHistoricalExchangeRate = null,Object? inheritLimitFromPreviousMonth = null,Object? carryOverUnusedLimit = null,Object? limitAlertMode = null,Object? globalAlertPercent = null,Object? globalAlertAmount = null,Object? enableSecrecyMode = null,Object? secrecyDaysBefore = null,Object? secrecyTimeoutSeconds = null,Object? largeTransactionThreshold = null,Object? autoHideGiftsOnImport = null,Object? defaultBalanceVisibility = null,Object? enableShakeToHide = null,Object? enableFaceDownHide = null,Object? enableAutoHideTimeout = null,Object? enableScreenCaptureProtection = null,Object? requireBiometricsToUnhide = null,Object? enablePinCode = null,Object? enableBiometricLogin = null,Object? enableAutoDetectDuplicates = null,Object? enableAutoDetectTransfers = null,Object? duplicateDateToleranceDays = null,Object? transferTimeToleranceMinutes = null,Object? autoOfferReceiptSplit = null,Object? offerReceiptSplitCount = null,Object? autoOfferProductNaming = null,Object? offerProductNamingCount = null,Object? syncImagesToCloud = null,Object? enableBankStatementReminder = null,Object? enableGroupActivityAlerts = null,Object? enableDeficitForecastAlerts = null,Object? enableYearInReviewAlerts = null,Object? enableDebtAlerts = null,Object? enableReminderNotifications = null,Object? reminderAdvanceDays = null,Object? reminderTimeOfDay = null,Object? autoCreateRemindersForRecurring = null,Object? digestConfig = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_AppSettingsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,baseCurrency: null == baseCurrency ? _self.baseCurrency : baseCurrency // ignore: cast_nullable_to_non_nullable
as String,useHistoricalExchangeRate: null == useHistoricalExchangeRate ? _self.useHistoricalExchangeRate : useHistoricalExchangeRate // ignore: cast_nullable_to_non_nullable
as bool,inheritLimitFromPreviousMonth: null == inheritLimitFromPreviousMonth ? _self.inheritLimitFromPreviousMonth : inheritLimitFromPreviousMonth // ignore: cast_nullable_to_non_nullable
as bool,carryOverUnusedLimit: null == carryOverUnusedLimit ? _self.carryOverUnusedLimit : carryOverUnusedLimit // ignore: cast_nullable_to_non_nullable
as bool,limitAlertMode: null == limitAlertMode ? _self.limitAlertMode : limitAlertMode // ignore: cast_nullable_to_non_nullable
as String,globalAlertPercent: null == globalAlertPercent ? _self.globalAlertPercent : globalAlertPercent // ignore: cast_nullable_to_non_nullable
as int,globalAlertAmount: null == globalAlertAmount ? _self.globalAlertAmount : globalAlertAmount // ignore: cast_nullable_to_non_nullable
as int,enableSecrecyMode: null == enableSecrecyMode ? _self.enableSecrecyMode : enableSecrecyMode // ignore: cast_nullable_to_non_nullable
as bool,secrecyDaysBefore: null == secrecyDaysBefore ? _self.secrecyDaysBefore : secrecyDaysBefore // ignore: cast_nullable_to_non_nullable
as int,secrecyTimeoutSeconds: null == secrecyTimeoutSeconds ? _self.secrecyTimeoutSeconds : secrecyTimeoutSeconds // ignore: cast_nullable_to_non_nullable
as int,largeTransactionThreshold: null == largeTransactionThreshold ? _self.largeTransactionThreshold : largeTransactionThreshold // ignore: cast_nullable_to_non_nullable
as int,autoHideGiftsOnImport: null == autoHideGiftsOnImport ? _self.autoHideGiftsOnImport : autoHideGiftsOnImport // ignore: cast_nullable_to_non_nullable
as bool,defaultBalanceVisibility: null == defaultBalanceVisibility ? _self.defaultBalanceVisibility : defaultBalanceVisibility // ignore: cast_nullable_to_non_nullable
as String,enableShakeToHide: null == enableShakeToHide ? _self.enableShakeToHide : enableShakeToHide // ignore: cast_nullable_to_non_nullable
as bool,enableFaceDownHide: null == enableFaceDownHide ? _self.enableFaceDownHide : enableFaceDownHide // ignore: cast_nullable_to_non_nullable
as bool,enableAutoHideTimeout: null == enableAutoHideTimeout ? _self.enableAutoHideTimeout : enableAutoHideTimeout // ignore: cast_nullable_to_non_nullable
as bool,enableScreenCaptureProtection: null == enableScreenCaptureProtection ? _self.enableScreenCaptureProtection : enableScreenCaptureProtection // ignore: cast_nullable_to_non_nullable
as bool,requireBiometricsToUnhide: null == requireBiometricsToUnhide ? _self.requireBiometricsToUnhide : requireBiometricsToUnhide // ignore: cast_nullable_to_non_nullable
as bool,enablePinCode: null == enablePinCode ? _self.enablePinCode : enablePinCode // ignore: cast_nullable_to_non_nullable
as bool,enableBiometricLogin: null == enableBiometricLogin ? _self.enableBiometricLogin : enableBiometricLogin // ignore: cast_nullable_to_non_nullable
as bool,enableAutoDetectDuplicates: null == enableAutoDetectDuplicates ? _self.enableAutoDetectDuplicates : enableAutoDetectDuplicates // ignore: cast_nullable_to_non_nullable
as bool,enableAutoDetectTransfers: null == enableAutoDetectTransfers ? _self.enableAutoDetectTransfers : enableAutoDetectTransfers // ignore: cast_nullable_to_non_nullable
as bool,duplicateDateToleranceDays: null == duplicateDateToleranceDays ? _self.duplicateDateToleranceDays : duplicateDateToleranceDays // ignore: cast_nullable_to_non_nullable
as int,transferTimeToleranceMinutes: null == transferTimeToleranceMinutes ? _self.transferTimeToleranceMinutes : transferTimeToleranceMinutes // ignore: cast_nullable_to_non_nullable
as int,autoOfferReceiptSplit: null == autoOfferReceiptSplit ? _self.autoOfferReceiptSplit : autoOfferReceiptSplit // ignore: cast_nullable_to_non_nullable
as bool,offerReceiptSplitCount: null == offerReceiptSplitCount ? _self.offerReceiptSplitCount : offerReceiptSplitCount // ignore: cast_nullable_to_non_nullable
as int,autoOfferProductNaming: null == autoOfferProductNaming ? _self.autoOfferProductNaming : autoOfferProductNaming // ignore: cast_nullable_to_non_nullable
as bool,offerProductNamingCount: null == offerProductNamingCount ? _self.offerProductNamingCount : offerProductNamingCount // ignore: cast_nullable_to_non_nullable
as int,syncImagesToCloud: null == syncImagesToCloud ? _self.syncImagesToCloud : syncImagesToCloud // ignore: cast_nullable_to_non_nullable
as bool,enableBankStatementReminder: null == enableBankStatementReminder ? _self.enableBankStatementReminder : enableBankStatementReminder // ignore: cast_nullable_to_non_nullable
as bool,enableGroupActivityAlerts: null == enableGroupActivityAlerts ? _self.enableGroupActivityAlerts : enableGroupActivityAlerts // ignore: cast_nullable_to_non_nullable
as bool,enableDeficitForecastAlerts: null == enableDeficitForecastAlerts ? _self.enableDeficitForecastAlerts : enableDeficitForecastAlerts // ignore: cast_nullable_to_non_nullable
as bool,enableYearInReviewAlerts: null == enableYearInReviewAlerts ? _self.enableYearInReviewAlerts : enableYearInReviewAlerts // ignore: cast_nullable_to_non_nullable
as bool,enableDebtAlerts: null == enableDebtAlerts ? _self.enableDebtAlerts : enableDebtAlerts // ignore: cast_nullable_to_non_nullable
as bool,enableReminderNotifications: null == enableReminderNotifications ? _self.enableReminderNotifications : enableReminderNotifications // ignore: cast_nullable_to_non_nullable
as bool,reminderAdvanceDays: null == reminderAdvanceDays ? _self.reminderAdvanceDays : reminderAdvanceDays // ignore: cast_nullable_to_non_nullable
as int,reminderTimeOfDay: null == reminderTimeOfDay ? _self.reminderTimeOfDay : reminderTimeOfDay // ignore: cast_nullable_to_non_nullable
as String,autoCreateRemindersForRecurring: null == autoCreateRemindersForRecurring ? _self.autoCreateRemindersForRecurring : autoCreateRemindersForRecurring // ignore: cast_nullable_to_non_nullable
as bool,digestConfig: null == digestConfig ? _self.digestConfig : digestConfig // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

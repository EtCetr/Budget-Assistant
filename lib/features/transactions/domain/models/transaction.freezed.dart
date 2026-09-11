// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transaction {

 String get id; String get accountId; String? get linkedAccountId; String get userId; String? get spaceId; String? get originalSpaceId; String? get bankTransactionId;/// UTC.
 DateTime get date;/// Копейки.
 int get amount; String? get originalCurrency;/// Копейки/минорные единицы исходной валюты.
 int? get originalAmount; TransactionType get type; String? get bankCategory; String? get customCategoryId; String? get merchantName; String? get comment; bool get isUserEdited; AuditStatus get auditStatus; bool get isHiddenByCalendar; DateTime? get hiddenUntilDate; int? get syncLockedStartedAt; int? get syncLockedDurationMs; bool get isArchivedForSpace; bool get businessMirror; String? get savingsGoalId; bool get isWithdrawal; bool get isSplit; String? get receiptId; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.originalSpaceId, originalSpaceId) || other.originalSpaceId == originalSpaceId)&&(identical(other.bankTransactionId, bankTransactionId) || other.bankTransactionId == bankTransactionId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.type, type) || other.type == type)&&(identical(other.bankCategory, bankCategory) || other.bankCategory == bankCategory)&&(identical(other.customCategoryId, customCategoryId) || other.customCategoryId == customCategoryId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isUserEdited, isUserEdited) || other.isUserEdited == isUserEdited)&&(identical(other.auditStatus, auditStatus) || other.auditStatus == auditStatus)&&(identical(other.isHiddenByCalendar, isHiddenByCalendar) || other.isHiddenByCalendar == isHiddenByCalendar)&&(identical(other.hiddenUntilDate, hiddenUntilDate) || other.hiddenUntilDate == hiddenUntilDate)&&(identical(other.syncLockedStartedAt, syncLockedStartedAt) || other.syncLockedStartedAt == syncLockedStartedAt)&&(identical(other.syncLockedDurationMs, syncLockedDurationMs) || other.syncLockedDurationMs == syncLockedDurationMs)&&(identical(other.isArchivedForSpace, isArchivedForSpace) || other.isArchivedForSpace == isArchivedForSpace)&&(identical(other.businessMirror, businessMirror) || other.businessMirror == businessMirror)&&(identical(other.savingsGoalId, savingsGoalId) || other.savingsGoalId == savingsGoalId)&&(identical(other.isWithdrawal, isWithdrawal) || other.isWithdrawal == isWithdrawal)&&(identical(other.isSplit, isSplit) || other.isSplit == isSplit)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,accountId,linkedAccountId,userId,spaceId,originalSpaceId,bankTransactionId,date,amount,originalCurrency,originalAmount,type,bankCategory,customCategoryId,merchantName,comment,isUserEdited,auditStatus,isHiddenByCalendar,hiddenUntilDate,syncLockedStartedAt,syncLockedDurationMs,isArchivedForSpace,businessMirror,savingsGoalId,isWithdrawal,isSplit,receiptId,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'Transaction(id: $id, accountId: $accountId, linkedAccountId: $linkedAccountId, userId: $userId, spaceId: $spaceId, originalSpaceId: $originalSpaceId, bankTransactionId: $bankTransactionId, date: $date, amount: $amount, originalCurrency: $originalCurrency, originalAmount: $originalAmount, type: $type, bankCategory: $bankCategory, customCategoryId: $customCategoryId, merchantName: $merchantName, comment: $comment, isUserEdited: $isUserEdited, auditStatus: $auditStatus, isHiddenByCalendar: $isHiddenByCalendar, hiddenUntilDate: $hiddenUntilDate, syncLockedStartedAt: $syncLockedStartedAt, syncLockedDurationMs: $syncLockedDurationMs, isArchivedForSpace: $isArchivedForSpace, businessMirror: $businessMirror, savingsGoalId: $savingsGoalId, isWithdrawal: $isWithdrawal, isSplit: $isSplit, receiptId: $receiptId, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String id, String accountId, String? linkedAccountId, String userId, String? spaceId, String? originalSpaceId, String? bankTransactionId, DateTime date, int amount, String? originalCurrency, int? originalAmount, TransactionType type, String? bankCategory, String? customCategoryId, String? merchantName, String? comment, bool isUserEdited, AuditStatus auditStatus, bool isHiddenByCalendar, DateTime? hiddenUntilDate, int? syncLockedStartedAt, int? syncLockedDurationMs, bool isArchivedForSpace, bool businessMirror, String? savingsGoalId, bool isWithdrawal, bool isSplit, String? receiptId, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? linkedAccountId = freezed,Object? userId = null,Object? spaceId = freezed,Object? originalSpaceId = freezed,Object? bankTransactionId = freezed,Object? date = null,Object? amount = null,Object? originalCurrency = freezed,Object? originalAmount = freezed,Object? type = null,Object? bankCategory = freezed,Object? customCategoryId = freezed,Object? merchantName = freezed,Object? comment = freezed,Object? isUserEdited = null,Object? auditStatus = null,Object? isHiddenByCalendar = null,Object? hiddenUntilDate = freezed,Object? syncLockedStartedAt = freezed,Object? syncLockedDurationMs = freezed,Object? isArchivedForSpace = null,Object? businessMirror = null,Object? savingsGoalId = freezed,Object? isWithdrawal = null,Object? isSplit = null,Object? receiptId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,originalSpaceId: freezed == originalSpaceId ? _self.originalSpaceId : originalSpaceId // ignore: cast_nullable_to_non_nullable
as String?,bankTransactionId: freezed == bankTransactionId ? _self.bankTransactionId : bankTransactionId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: freezed == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,bankCategory: freezed == bankCategory ? _self.bankCategory : bankCategory // ignore: cast_nullable_to_non_nullable
as String?,customCategoryId: freezed == customCategoryId ? _self.customCategoryId : customCategoryId // ignore: cast_nullable_to_non_nullable
as String?,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,isUserEdited: null == isUserEdited ? _self.isUserEdited : isUserEdited // ignore: cast_nullable_to_non_nullable
as bool,auditStatus: null == auditStatus ? _self.auditStatus : auditStatus // ignore: cast_nullable_to_non_nullable
as AuditStatus,isHiddenByCalendar: null == isHiddenByCalendar ? _self.isHiddenByCalendar : isHiddenByCalendar // ignore: cast_nullable_to_non_nullable
as bool,hiddenUntilDate: freezed == hiddenUntilDate ? _self.hiddenUntilDate : hiddenUntilDate // ignore: cast_nullable_to_non_nullable
as DateTime?,syncLockedStartedAt: freezed == syncLockedStartedAt ? _self.syncLockedStartedAt : syncLockedStartedAt // ignore: cast_nullable_to_non_nullable
as int?,syncLockedDurationMs: freezed == syncLockedDurationMs ? _self.syncLockedDurationMs : syncLockedDurationMs // ignore: cast_nullable_to_non_nullable
as int?,isArchivedForSpace: null == isArchivedForSpace ? _self.isArchivedForSpace : isArchivedForSpace // ignore: cast_nullable_to_non_nullable
as bool,businessMirror: null == businessMirror ? _self.businessMirror : businessMirror // ignore: cast_nullable_to_non_nullable
as bool,savingsGoalId: freezed == savingsGoalId ? _self.savingsGoalId : savingsGoalId // ignore: cast_nullable_to_non_nullable
as String?,isWithdrawal: null == isWithdrawal ? _self.isWithdrawal : isWithdrawal // ignore: cast_nullable_to_non_nullable
as bool,isSplit: null == isSplit ? _self.isSplit : isSplit // ignore: cast_nullable_to_non_nullable
as bool,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _Transaction implements Transaction {
  const _Transaction({required this.id, required this.accountId, this.linkedAccountId, required this.userId, this.spaceId, this.originalSpaceId, this.bankTransactionId, required this.date, required this.amount, this.originalCurrency, this.originalAmount, required this.type, this.bankCategory, this.customCategoryId, this.merchantName, this.comment, this.isUserEdited = false, this.auditStatus = AuditStatus.verified, this.isHiddenByCalendar = false, this.hiddenUntilDate, this.syncLockedStartedAt, this.syncLockedDurationMs, this.isArchivedForSpace = false, this.businessMirror = false, this.savingsGoalId, this.isWithdrawal = false, this.isSplit = false, this.receiptId, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  

@override final  String id;
@override final  String accountId;
@override final  String? linkedAccountId;
@override final  String userId;
@override final  String? spaceId;
@override final  String? originalSpaceId;
@override final  String? bankTransactionId;
/// UTC.
@override final  DateTime date;
/// Копейки.
@override final  int amount;
@override final  String? originalCurrency;
/// Копейки/минорные единицы исходной валюты.
@override final  int? originalAmount;
@override final  TransactionType type;
@override final  String? bankCategory;
@override final  String? customCategoryId;
@override final  String? merchantName;
@override final  String? comment;
@override@JsonKey() final  bool isUserEdited;
@override@JsonKey() final  AuditStatus auditStatus;
@override@JsonKey() final  bool isHiddenByCalendar;
@override final  DateTime? hiddenUntilDate;
@override final  int? syncLockedStartedAt;
@override final  int? syncLockedDurationMs;
@override@JsonKey() final  bool isArchivedForSpace;
@override@JsonKey() final  bool businessMirror;
@override final  String? savingsGoalId;
@override@JsonKey() final  bool isWithdrawal;
@override@JsonKey() final  bool isSplit;
@override final  String? receiptId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.originalSpaceId, originalSpaceId) || other.originalSpaceId == originalSpaceId)&&(identical(other.bankTransactionId, bankTransactionId) || other.bankTransactionId == bankTransactionId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.type, type) || other.type == type)&&(identical(other.bankCategory, bankCategory) || other.bankCategory == bankCategory)&&(identical(other.customCategoryId, customCategoryId) || other.customCategoryId == customCategoryId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isUserEdited, isUserEdited) || other.isUserEdited == isUserEdited)&&(identical(other.auditStatus, auditStatus) || other.auditStatus == auditStatus)&&(identical(other.isHiddenByCalendar, isHiddenByCalendar) || other.isHiddenByCalendar == isHiddenByCalendar)&&(identical(other.hiddenUntilDate, hiddenUntilDate) || other.hiddenUntilDate == hiddenUntilDate)&&(identical(other.syncLockedStartedAt, syncLockedStartedAt) || other.syncLockedStartedAt == syncLockedStartedAt)&&(identical(other.syncLockedDurationMs, syncLockedDurationMs) || other.syncLockedDurationMs == syncLockedDurationMs)&&(identical(other.isArchivedForSpace, isArchivedForSpace) || other.isArchivedForSpace == isArchivedForSpace)&&(identical(other.businessMirror, businessMirror) || other.businessMirror == businessMirror)&&(identical(other.savingsGoalId, savingsGoalId) || other.savingsGoalId == savingsGoalId)&&(identical(other.isWithdrawal, isWithdrawal) || other.isWithdrawal == isWithdrawal)&&(identical(other.isSplit, isSplit) || other.isSplit == isSplit)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,accountId,linkedAccountId,userId,spaceId,originalSpaceId,bankTransactionId,date,amount,originalCurrency,originalAmount,type,bankCategory,customCategoryId,merchantName,comment,isUserEdited,auditStatus,isHiddenByCalendar,hiddenUntilDate,syncLockedStartedAt,syncLockedDurationMs,isArchivedForSpace,businessMirror,savingsGoalId,isWithdrawal,isSplit,receiptId,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'Transaction(id: $id, accountId: $accountId, linkedAccountId: $linkedAccountId, userId: $userId, spaceId: $spaceId, originalSpaceId: $originalSpaceId, bankTransactionId: $bankTransactionId, date: $date, amount: $amount, originalCurrency: $originalCurrency, originalAmount: $originalAmount, type: $type, bankCategory: $bankCategory, customCategoryId: $customCategoryId, merchantName: $merchantName, comment: $comment, isUserEdited: $isUserEdited, auditStatus: $auditStatus, isHiddenByCalendar: $isHiddenByCalendar, hiddenUntilDate: $hiddenUntilDate, syncLockedStartedAt: $syncLockedStartedAt, syncLockedDurationMs: $syncLockedDurationMs, isArchivedForSpace: $isArchivedForSpace, businessMirror: $businessMirror, savingsGoalId: $savingsGoalId, isWithdrawal: $isWithdrawal, isSplit: $isSplit, receiptId: $receiptId, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String accountId, String? linkedAccountId, String userId, String? spaceId, String? originalSpaceId, String? bankTransactionId, DateTime date, int amount, String? originalCurrency, int? originalAmount, TransactionType type, String? bankCategory, String? customCategoryId, String? merchantName, String? comment, bool isUserEdited, AuditStatus auditStatus, bool isHiddenByCalendar, DateTime? hiddenUntilDate, int? syncLockedStartedAt, int? syncLockedDurationMs, bool isArchivedForSpace, bool businessMirror, String? savingsGoalId, bool isWithdrawal, bool isSplit, String? receiptId, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? linkedAccountId = freezed,Object? userId = null,Object? spaceId = freezed,Object? originalSpaceId = freezed,Object? bankTransactionId = freezed,Object? date = null,Object? amount = null,Object? originalCurrency = freezed,Object? originalAmount = freezed,Object? type = null,Object? bankCategory = freezed,Object? customCategoryId = freezed,Object? merchantName = freezed,Object? comment = freezed,Object? isUserEdited = null,Object? auditStatus = null,Object? isHiddenByCalendar = null,Object? hiddenUntilDate = freezed,Object? syncLockedStartedAt = freezed,Object? syncLockedDurationMs = freezed,Object? isArchivedForSpace = null,Object? businessMirror = null,Object? savingsGoalId = freezed,Object? isWithdrawal = null,Object? isSplit = null,Object? receiptId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,originalSpaceId: freezed == originalSpaceId ? _self.originalSpaceId : originalSpaceId // ignore: cast_nullable_to_non_nullable
as String?,bankTransactionId: freezed == bankTransactionId ? _self.bankTransactionId : bankTransactionId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: freezed == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,bankCategory: freezed == bankCategory ? _self.bankCategory : bankCategory // ignore: cast_nullable_to_non_nullable
as String?,customCategoryId: freezed == customCategoryId ? _self.customCategoryId : customCategoryId // ignore: cast_nullable_to_non_nullable
as String?,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,isUserEdited: null == isUserEdited ? _self.isUserEdited : isUserEdited // ignore: cast_nullable_to_non_nullable
as bool,auditStatus: null == auditStatus ? _self.auditStatus : auditStatus // ignore: cast_nullable_to_non_nullable
as AuditStatus,isHiddenByCalendar: null == isHiddenByCalendar ? _self.isHiddenByCalendar : isHiddenByCalendar // ignore: cast_nullable_to_non_nullable
as bool,hiddenUntilDate: freezed == hiddenUntilDate ? _self.hiddenUntilDate : hiddenUntilDate // ignore: cast_nullable_to_non_nullable
as DateTime?,syncLockedStartedAt: freezed == syncLockedStartedAt ? _self.syncLockedStartedAt : syncLockedStartedAt // ignore: cast_nullable_to_non_nullable
as int?,syncLockedDurationMs: freezed == syncLockedDurationMs ? _self.syncLockedDurationMs : syncLockedDurationMs // ignore: cast_nullable_to_non_nullable
as int?,isArchivedForSpace: null == isArchivedForSpace ? _self.isArchivedForSpace : isArchivedForSpace // ignore: cast_nullable_to_non_nullable
as bool,businessMirror: null == businessMirror ? _self.businessMirror : businessMirror // ignore: cast_nullable_to_non_nullable
as bool,savingsGoalId: freezed == savingsGoalId ? _self.savingsGoalId : savingsGoalId // ignore: cast_nullable_to_non_nullable
as String?,isWithdrawal: null == isWithdrawal ? _self.isWithdrawal : isWithdrawal // ignore: cast_nullable_to_non_nullable
as bool,isSplit: null == isSplit ? _self.isSplit : isSplit // ignore: cast_nullable_to_non_nullable
as bool,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

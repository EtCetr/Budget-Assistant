// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringTransaction {

 String get id; String get userId;/// Личная сущность: фактически всегда NULL (ТЗ 6.3.9.15).
 String? get spaceId; String get merchantName; String get merchantNameNormalized;/// Копейки.
 int get averageAmount;/// Копейки, округлённые до 100 рублей (ключ upsert).
 int get averageAmountBucket; int get averageDayOfMonth; int get occurrenceCount; String get confidence; String get status; DateTime? get firstSeenDate; DateTime? get lastSeenDate;/// Без FK: циклическая ссылка с reminders.
 String? get linkedReminderId; String? get categoryId; DateTime? get detectedAt; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of RecurringTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringTransactionCopyWith<RecurringTransaction> get copyWith => _$RecurringTransactionCopyWithImpl<RecurringTransaction>(this as RecurringTransaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.merchantNameNormalized, merchantNameNormalized) || other.merchantNameNormalized == merchantNameNormalized)&&(identical(other.averageAmount, averageAmount) || other.averageAmount == averageAmount)&&(identical(other.averageAmountBucket, averageAmountBucket) || other.averageAmountBucket == averageAmountBucket)&&(identical(other.averageDayOfMonth, averageDayOfMonth) || other.averageDayOfMonth == averageDayOfMonth)&&(identical(other.occurrenceCount, occurrenceCount) || other.occurrenceCount == occurrenceCount)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.status, status) || other.status == status)&&(identical(other.firstSeenDate, firstSeenDate) || other.firstSeenDate == firstSeenDate)&&(identical(other.lastSeenDate, lastSeenDate) || other.lastSeenDate == lastSeenDate)&&(identical(other.linkedReminderId, linkedReminderId) || other.linkedReminderId == linkedReminderId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,userId,spaceId,merchantName,merchantNameNormalized,averageAmount,averageAmountBucket,averageDayOfMonth,occurrenceCount,confidence,status,firstSeenDate,lastSeenDate,linkedReminderId,categoryId,detectedAt,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'RecurringTransaction(id: $id, userId: $userId, spaceId: $spaceId, merchantName: $merchantName, merchantNameNormalized: $merchantNameNormalized, averageAmount: $averageAmount, averageAmountBucket: $averageAmountBucket, averageDayOfMonth: $averageDayOfMonth, occurrenceCount: $occurrenceCount, confidence: $confidence, status: $status, firstSeenDate: $firstSeenDate, lastSeenDate: $lastSeenDate, linkedReminderId: $linkedReminderId, categoryId: $categoryId, detectedAt: $detectedAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $RecurringTransactionCopyWith<$Res>  {
  factory $RecurringTransactionCopyWith(RecurringTransaction value, $Res Function(RecurringTransaction) _then) = _$RecurringTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, String merchantName, String merchantNameNormalized, int averageAmount, int averageAmountBucket, int averageDayOfMonth, int occurrenceCount, String confidence, String status, DateTime? firstSeenDate, DateTime? lastSeenDate, String? linkedReminderId, String? categoryId, DateTime? detectedAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$RecurringTransactionCopyWithImpl<$Res>
    implements $RecurringTransactionCopyWith<$Res> {
  _$RecurringTransactionCopyWithImpl(this._self, this._then);

  final RecurringTransaction _self;
  final $Res Function(RecurringTransaction) _then;

/// Create a copy of RecurringTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? merchantName = null,Object? merchantNameNormalized = null,Object? averageAmount = null,Object? averageAmountBucket = null,Object? averageDayOfMonth = null,Object? occurrenceCount = null,Object? confidence = null,Object? status = null,Object? firstSeenDate = freezed,Object? lastSeenDate = freezed,Object? linkedReminderId = freezed,Object? categoryId = freezed,Object? detectedAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,merchantName: null == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String,merchantNameNormalized: null == merchantNameNormalized ? _self.merchantNameNormalized : merchantNameNormalized // ignore: cast_nullable_to_non_nullable
as String,averageAmount: null == averageAmount ? _self.averageAmount : averageAmount // ignore: cast_nullable_to_non_nullable
as int,averageAmountBucket: null == averageAmountBucket ? _self.averageAmountBucket : averageAmountBucket // ignore: cast_nullable_to_non_nullable
as int,averageDayOfMonth: null == averageDayOfMonth ? _self.averageDayOfMonth : averageDayOfMonth // ignore: cast_nullable_to_non_nullable
as int,occurrenceCount: null == occurrenceCount ? _self.occurrenceCount : occurrenceCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,firstSeenDate: freezed == firstSeenDate ? _self.firstSeenDate : firstSeenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSeenDate: freezed == lastSeenDate ? _self.lastSeenDate : lastSeenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedReminderId: freezed == linkedReminderId ? _self.linkedReminderId : linkedReminderId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,detectedAt: freezed == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringTransaction].
extension RecurringTransactionPatterns on RecurringTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringTransaction value)  $default,){
final _that = this;
switch (_that) {
case _RecurringTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringTransaction() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringTransaction implements RecurringTransaction {
  const _RecurringTransaction({required this.id, required this.userId, this.spaceId, required this.merchantName, required this.merchantNameNormalized, required this.averageAmount, required this.averageAmountBucket, required this.averageDayOfMonth, this.occurrenceCount = 0, this.confidence = RecurringConfidence.medium, this.status = RecurringStatus.pendingConfirmation, this.firstSeenDate, this.lastSeenDate, this.linkedReminderId, this.categoryId, this.detectedAt, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  

@override final  String id;
@override final  String userId;
/// Личная сущность: фактически всегда NULL (ТЗ 6.3.9.15).
@override final  String? spaceId;
@override final  String merchantName;
@override final  String merchantNameNormalized;
/// Копейки.
@override final  int averageAmount;
/// Копейки, округлённые до 100 рублей (ключ upsert).
@override final  int averageAmountBucket;
@override final  int averageDayOfMonth;
@override@JsonKey() final  int occurrenceCount;
@override@JsonKey() final  String confidence;
@override@JsonKey() final  String status;
@override final  DateTime? firstSeenDate;
@override final  DateTime? lastSeenDate;
/// Без FK: циклическая ссылка с reminders.
@override final  String? linkedReminderId;
@override final  String? categoryId;
@override final  DateTime? detectedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of RecurringTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringTransactionCopyWith<_RecurringTransaction> get copyWith => __$RecurringTransactionCopyWithImpl<_RecurringTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.merchantNameNormalized, merchantNameNormalized) || other.merchantNameNormalized == merchantNameNormalized)&&(identical(other.averageAmount, averageAmount) || other.averageAmount == averageAmount)&&(identical(other.averageAmountBucket, averageAmountBucket) || other.averageAmountBucket == averageAmountBucket)&&(identical(other.averageDayOfMonth, averageDayOfMonth) || other.averageDayOfMonth == averageDayOfMonth)&&(identical(other.occurrenceCount, occurrenceCount) || other.occurrenceCount == occurrenceCount)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.status, status) || other.status == status)&&(identical(other.firstSeenDate, firstSeenDate) || other.firstSeenDate == firstSeenDate)&&(identical(other.lastSeenDate, lastSeenDate) || other.lastSeenDate == lastSeenDate)&&(identical(other.linkedReminderId, linkedReminderId) || other.linkedReminderId == linkedReminderId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,userId,spaceId,merchantName,merchantNameNormalized,averageAmount,averageAmountBucket,averageDayOfMonth,occurrenceCount,confidence,status,firstSeenDate,lastSeenDate,linkedReminderId,categoryId,detectedAt,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'RecurringTransaction(id: $id, userId: $userId, spaceId: $spaceId, merchantName: $merchantName, merchantNameNormalized: $merchantNameNormalized, averageAmount: $averageAmount, averageAmountBucket: $averageAmountBucket, averageDayOfMonth: $averageDayOfMonth, occurrenceCount: $occurrenceCount, confidence: $confidence, status: $status, firstSeenDate: $firstSeenDate, lastSeenDate: $lastSeenDate, linkedReminderId: $linkedReminderId, categoryId: $categoryId, detectedAt: $detectedAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$RecurringTransactionCopyWith<$Res> implements $RecurringTransactionCopyWith<$Res> {
  factory _$RecurringTransactionCopyWith(_RecurringTransaction value, $Res Function(_RecurringTransaction) _then) = __$RecurringTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, String merchantName, String merchantNameNormalized, int averageAmount, int averageAmountBucket, int averageDayOfMonth, int occurrenceCount, String confidence, String status, DateTime? firstSeenDate, DateTime? lastSeenDate, String? linkedReminderId, String? categoryId, DateTime? detectedAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$RecurringTransactionCopyWithImpl<$Res>
    implements _$RecurringTransactionCopyWith<$Res> {
  __$RecurringTransactionCopyWithImpl(this._self, this._then);

  final _RecurringTransaction _self;
  final $Res Function(_RecurringTransaction) _then;

/// Create a copy of RecurringTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? merchantName = null,Object? merchantNameNormalized = null,Object? averageAmount = null,Object? averageAmountBucket = null,Object? averageDayOfMonth = null,Object? occurrenceCount = null,Object? confidence = null,Object? status = null,Object? firstSeenDate = freezed,Object? lastSeenDate = freezed,Object? linkedReminderId = freezed,Object? categoryId = freezed,Object? detectedAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_RecurringTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,merchantName: null == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String,merchantNameNormalized: null == merchantNameNormalized ? _self.merchantNameNormalized : merchantNameNormalized // ignore: cast_nullable_to_non_nullable
as String,averageAmount: null == averageAmount ? _self.averageAmount : averageAmount // ignore: cast_nullable_to_non_nullable
as int,averageAmountBucket: null == averageAmountBucket ? _self.averageAmountBucket : averageAmountBucket // ignore: cast_nullable_to_non_nullable
as int,averageDayOfMonth: null == averageDayOfMonth ? _self.averageDayOfMonth : averageDayOfMonth // ignore: cast_nullable_to_non_nullable
as int,occurrenceCount: null == occurrenceCount ? _self.occurrenceCount : occurrenceCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,firstSeenDate: freezed == firstSeenDate ? _self.firstSeenDate : firstSeenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSeenDate: freezed == lastSeenDate ? _self.lastSeenDate : lastSeenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedReminderId: freezed == linkedReminderId ? _self.linkedReminderId : linkedReminderId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,detectedAt: freezed == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

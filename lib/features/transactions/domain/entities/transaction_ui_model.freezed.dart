// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionUiModel {

 String get id; String get userId; String? get spaceId; String get accountId; String? get categoryId; TransactionType get type; int get amountKopecks; String get currencyCode; DateTime get date; String? get merchantName; String? get comment; String? get receiptId; bool get isSplit; AuditStatus get auditStatus; SyncStatus get syncStatus; String get categoryName; String get categoryColorHex; String? get memberDisplayName; String? get memberColorHex; bool get isHiddenByCalendar;
/// Create a copy of TransactionUiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionUiModelCopyWith<TransactionUiModel> get copyWith => _$TransactionUiModelCopyWithImpl<TransactionUiModel>(this as TransactionUiModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionUiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountKopecks, amountKopecks) || other.amountKopecks == amountKopecks)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.date, date) || other.date == date)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.isSplit, isSplit) || other.isSplit == isSplit)&&(identical(other.auditStatus, auditStatus) || other.auditStatus == auditStatus)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryColorHex, categoryColorHex) || other.categoryColorHex == categoryColorHex)&&(identical(other.memberDisplayName, memberDisplayName) || other.memberDisplayName == memberDisplayName)&&(identical(other.memberColorHex, memberColorHex) || other.memberColorHex == memberColorHex)&&(identical(other.isHiddenByCalendar, isHiddenByCalendar) || other.isHiddenByCalendar == isHiddenByCalendar));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,userId,spaceId,accountId,categoryId,type,amountKopecks,currencyCode,date,merchantName,comment,receiptId,isSplit,auditStatus,syncStatus,categoryName,categoryColorHex,memberDisplayName,memberColorHex,isHiddenByCalendar]);

@override
String toString() {
  return 'TransactionUiModel(id: $id, userId: $userId, spaceId: $spaceId, accountId: $accountId, categoryId: $categoryId, type: $type, amountKopecks: $amountKopecks, currencyCode: $currencyCode, date: $date, merchantName: $merchantName, comment: $comment, receiptId: $receiptId, isSplit: $isSplit, auditStatus: $auditStatus, syncStatus: $syncStatus, categoryName: $categoryName, categoryColorHex: $categoryColorHex, memberDisplayName: $memberDisplayName, memberColorHex: $memberColorHex, isHiddenByCalendar: $isHiddenByCalendar)';
}


}

/// @nodoc
abstract mixin class $TransactionUiModelCopyWith<$Res>  {
  factory $TransactionUiModelCopyWith(TransactionUiModel value, $Res Function(TransactionUiModel) _then) = _$TransactionUiModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, String accountId, String? categoryId, TransactionType type, int amountKopecks, String currencyCode, DateTime date, String? merchantName, String? comment, String? receiptId, bool isSplit, AuditStatus auditStatus, SyncStatus syncStatus, String categoryName, String categoryColorHex, String? memberDisplayName, String? memberColorHex, bool isHiddenByCalendar
});




}
/// @nodoc
class _$TransactionUiModelCopyWithImpl<$Res>
    implements $TransactionUiModelCopyWith<$Res> {
  _$TransactionUiModelCopyWithImpl(this._self, this._then);

  final TransactionUiModel _self;
  final $Res Function(TransactionUiModel) _then;

/// Create a copy of TransactionUiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? accountId = null,Object? categoryId = freezed,Object? type = null,Object? amountKopecks = null,Object? currencyCode = null,Object? date = null,Object? merchantName = freezed,Object? comment = freezed,Object? receiptId = freezed,Object? isSplit = null,Object? auditStatus = null,Object? syncStatus = null,Object? categoryName = null,Object? categoryColorHex = null,Object? memberDisplayName = freezed,Object? memberColorHex = freezed,Object? isHiddenByCalendar = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amountKopecks: null == amountKopecks ? _self.amountKopecks : amountKopecks // ignore: cast_nullable_to_non_nullable
as int,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,isSplit: null == isSplit ? _self.isSplit : isSplit // ignore: cast_nullable_to_non_nullable
as bool,auditStatus: null == auditStatus ? _self.auditStatus : auditStatus // ignore: cast_nullable_to_non_nullable
as AuditStatus,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryColorHex: null == categoryColorHex ? _self.categoryColorHex : categoryColorHex // ignore: cast_nullable_to_non_nullable
as String,memberDisplayName: freezed == memberDisplayName ? _self.memberDisplayName : memberDisplayName // ignore: cast_nullable_to_non_nullable
as String?,memberColorHex: freezed == memberColorHex ? _self.memberColorHex : memberColorHex // ignore: cast_nullable_to_non_nullable
as String?,isHiddenByCalendar: null == isHiddenByCalendar ? _self.isHiddenByCalendar : isHiddenByCalendar // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionUiModel].
extension TransactionUiModelPatterns on TransactionUiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionUiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionUiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionUiModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionUiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionUiModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionUiModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionUiModel implements TransactionUiModel {
  const _TransactionUiModel({required this.id, required this.userId, required this.spaceId, required this.accountId, required this.categoryId, required this.type, required this.amountKopecks, required this.currencyCode, required this.date, required this.merchantName, required this.comment, required this.receiptId, required this.isSplit, required this.auditStatus, required this.syncStatus, required this.categoryName, required this.categoryColorHex, required this.memberDisplayName, required this.memberColorHex, this.isHiddenByCalendar = false});
  

@override final  String id;
@override final  String userId;
@override final  String? spaceId;
@override final  String accountId;
@override final  String? categoryId;
@override final  TransactionType type;
@override final  int amountKopecks;
@override final  String currencyCode;
@override final  DateTime date;
@override final  String? merchantName;
@override final  String? comment;
@override final  String? receiptId;
@override final  bool isSplit;
@override final  AuditStatus auditStatus;
@override final  SyncStatus syncStatus;
@override final  String categoryName;
@override final  String categoryColorHex;
@override final  String? memberDisplayName;
@override final  String? memberColorHex;
@override@JsonKey() final  bool isHiddenByCalendar;

/// Create a copy of TransactionUiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionUiModelCopyWith<_TransactionUiModel> get copyWith => __$TransactionUiModelCopyWithImpl<_TransactionUiModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionUiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountKopecks, amountKopecks) || other.amountKopecks == amountKopecks)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.date, date) || other.date == date)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.isSplit, isSplit) || other.isSplit == isSplit)&&(identical(other.auditStatus, auditStatus) || other.auditStatus == auditStatus)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryColorHex, categoryColorHex) || other.categoryColorHex == categoryColorHex)&&(identical(other.memberDisplayName, memberDisplayName) || other.memberDisplayName == memberDisplayName)&&(identical(other.memberColorHex, memberColorHex) || other.memberColorHex == memberColorHex)&&(identical(other.isHiddenByCalendar, isHiddenByCalendar) || other.isHiddenByCalendar == isHiddenByCalendar));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,userId,spaceId,accountId,categoryId,type,amountKopecks,currencyCode,date,merchantName,comment,receiptId,isSplit,auditStatus,syncStatus,categoryName,categoryColorHex,memberDisplayName,memberColorHex,isHiddenByCalendar]);

@override
String toString() {
  return 'TransactionUiModel(id: $id, userId: $userId, spaceId: $spaceId, accountId: $accountId, categoryId: $categoryId, type: $type, amountKopecks: $amountKopecks, currencyCode: $currencyCode, date: $date, merchantName: $merchantName, comment: $comment, receiptId: $receiptId, isSplit: $isSplit, auditStatus: $auditStatus, syncStatus: $syncStatus, categoryName: $categoryName, categoryColorHex: $categoryColorHex, memberDisplayName: $memberDisplayName, memberColorHex: $memberColorHex, isHiddenByCalendar: $isHiddenByCalendar)';
}


}

/// @nodoc
abstract mixin class _$TransactionUiModelCopyWith<$Res> implements $TransactionUiModelCopyWith<$Res> {
  factory _$TransactionUiModelCopyWith(_TransactionUiModel value, $Res Function(_TransactionUiModel) _then) = __$TransactionUiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, String accountId, String? categoryId, TransactionType type, int amountKopecks, String currencyCode, DateTime date, String? merchantName, String? comment, String? receiptId, bool isSplit, AuditStatus auditStatus, SyncStatus syncStatus, String categoryName, String categoryColorHex, String? memberDisplayName, String? memberColorHex, bool isHiddenByCalendar
});




}
/// @nodoc
class __$TransactionUiModelCopyWithImpl<$Res>
    implements _$TransactionUiModelCopyWith<$Res> {
  __$TransactionUiModelCopyWithImpl(this._self, this._then);

  final _TransactionUiModel _self;
  final $Res Function(_TransactionUiModel) _then;

/// Create a copy of TransactionUiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? accountId = null,Object? categoryId = freezed,Object? type = null,Object? amountKopecks = null,Object? currencyCode = null,Object? date = null,Object? merchantName = freezed,Object? comment = freezed,Object? receiptId = freezed,Object? isSplit = null,Object? auditStatus = null,Object? syncStatus = null,Object? categoryName = null,Object? categoryColorHex = null,Object? memberDisplayName = freezed,Object? memberColorHex = freezed,Object? isHiddenByCalendar = null,}) {
  return _then(_TransactionUiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amountKopecks: null == amountKopecks ? _self.amountKopecks : amountKopecks // ignore: cast_nullable_to_non_nullable
as int,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,isSplit: null == isSplit ? _self.isSplit : isSplit // ignore: cast_nullable_to_non_nullable
as bool,auditStatus: null == auditStatus ? _self.auditStatus : auditStatus // ignore: cast_nullable_to_non_nullable
as AuditStatus,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryColorHex: null == categoryColorHex ? _self.categoryColorHex : categoryColorHex // ignore: cast_nullable_to_non_nullable
as String,memberDisplayName: freezed == memberDisplayName ? _self.memberDisplayName : memberDisplayName // ignore: cast_nullable_to_non_nullable
as String?,memberColorHex: freezed == memberColorHex ? _self.memberColorHex : memberColorHex // ignore: cast_nullable_to_non_nullable
as String?,isHiddenByCalendar: null == isHiddenByCalendar ? _self.isHiddenByCalendar : isHiddenByCalendar // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

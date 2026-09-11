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

 String get id; DateTime get date;/// Копейки.
 int get amount; TransactionType get type; String? get merchantName; String? get comment; bool get isPendingSync; bool get isSyncLocked; bool get isHidden; String? get categoryName; String? get categoryEmoji; String? get categoryColorHex; String? get accountName;
/// Create a copy of TransactionUiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionUiModelCopyWith<TransactionUiModel> get copyWith => _$TransactionUiModelCopyWithImpl<TransactionUiModel>(this as TransactionUiModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionUiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isPendingSync, isPendingSync) || other.isPendingSync == isPendingSync)&&(identical(other.isSyncLocked, isSyncLocked) || other.isSyncLocked == isSyncLocked)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryEmoji, categoryEmoji) || other.categoryEmoji == categoryEmoji)&&(identical(other.categoryColorHex, categoryColorHex) || other.categoryColorHex == categoryColorHex)&&(identical(other.accountName, accountName) || other.accountName == accountName));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,amount,type,merchantName,comment,isPendingSync,isSyncLocked,isHidden,categoryName,categoryEmoji,categoryColorHex,accountName);

@override
String toString() {
  return 'TransactionUiModel(id: $id, date: $date, amount: $amount, type: $type, merchantName: $merchantName, comment: $comment, isPendingSync: $isPendingSync, isSyncLocked: $isSyncLocked, isHidden: $isHidden, categoryName: $categoryName, categoryEmoji: $categoryEmoji, categoryColorHex: $categoryColorHex, accountName: $accountName)';
}


}

/// @nodoc
abstract mixin class $TransactionUiModelCopyWith<$Res>  {
  factory $TransactionUiModelCopyWith(TransactionUiModel value, $Res Function(TransactionUiModel) _then) = _$TransactionUiModelCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, int amount, TransactionType type, String? merchantName, String? comment, bool isPendingSync, bool isSyncLocked, bool isHidden, String? categoryName, String? categoryEmoji, String? categoryColorHex, String? accountName
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? amount = null,Object? type = null,Object? merchantName = freezed,Object? comment = freezed,Object? isPendingSync = null,Object? isSyncLocked = null,Object? isHidden = null,Object? categoryName = freezed,Object? categoryEmoji = freezed,Object? categoryColorHex = freezed,Object? accountName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,isPendingSync: null == isPendingSync ? _self.isPendingSync : isPendingSync // ignore: cast_nullable_to_non_nullable
as bool,isSyncLocked: null == isSyncLocked ? _self.isSyncLocked : isSyncLocked // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,categoryEmoji: freezed == categoryEmoji ? _self.categoryEmoji : categoryEmoji // ignore: cast_nullable_to_non_nullable
as String?,categoryColorHex: freezed == categoryColorHex ? _self.categoryColorHex : categoryColorHex // ignore: cast_nullable_to_non_nullable
as String?,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,
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
  const _TransactionUiModel({required this.id, required this.date, required this.amount, required this.type, this.merchantName, this.comment, required this.isPendingSync, required this.isSyncLocked, required this.isHidden, this.categoryName, this.categoryEmoji, this.categoryColorHex, this.accountName});
  

@override final  String id;
@override final  DateTime date;
/// Копейки.
@override final  int amount;
@override final  TransactionType type;
@override final  String? merchantName;
@override final  String? comment;
@override final  bool isPendingSync;
@override final  bool isSyncLocked;
@override final  bool isHidden;
@override final  String? categoryName;
@override final  String? categoryEmoji;
@override final  String? categoryColorHex;
@override final  String? accountName;

/// Create a copy of TransactionUiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionUiModelCopyWith<_TransactionUiModel> get copyWith => __$TransactionUiModelCopyWithImpl<_TransactionUiModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionUiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isPendingSync, isPendingSync) || other.isPendingSync == isPendingSync)&&(identical(other.isSyncLocked, isSyncLocked) || other.isSyncLocked == isSyncLocked)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryEmoji, categoryEmoji) || other.categoryEmoji == categoryEmoji)&&(identical(other.categoryColorHex, categoryColorHex) || other.categoryColorHex == categoryColorHex)&&(identical(other.accountName, accountName) || other.accountName == accountName));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,amount,type,merchantName,comment,isPendingSync,isSyncLocked,isHidden,categoryName,categoryEmoji,categoryColorHex,accountName);

@override
String toString() {
  return 'TransactionUiModel(id: $id, date: $date, amount: $amount, type: $type, merchantName: $merchantName, comment: $comment, isPendingSync: $isPendingSync, isSyncLocked: $isSyncLocked, isHidden: $isHidden, categoryName: $categoryName, categoryEmoji: $categoryEmoji, categoryColorHex: $categoryColorHex, accountName: $accountName)';
}


}

/// @nodoc
abstract mixin class _$TransactionUiModelCopyWith<$Res> implements $TransactionUiModelCopyWith<$Res> {
  factory _$TransactionUiModelCopyWith(_TransactionUiModel value, $Res Function(_TransactionUiModel) _then) = __$TransactionUiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, int amount, TransactionType type, String? merchantName, String? comment, bool isPendingSync, bool isSyncLocked, bool isHidden, String? categoryName, String? categoryEmoji, String? categoryColorHex, String? accountName
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? amount = null,Object? type = null,Object? merchantName = freezed,Object? comment = freezed,Object? isPendingSync = null,Object? isSyncLocked = null,Object? isHidden = null,Object? categoryName = freezed,Object? categoryEmoji = freezed,Object? categoryColorHex = freezed,Object? accountName = freezed,}) {
  return _then(_TransactionUiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,isPendingSync: null == isPendingSync ? _self.isPendingSync : isPendingSync // ignore: cast_nullable_to_non_nullable
as bool,isSyncLocked: null == isSyncLocked ? _self.isSyncLocked : isSyncLocked // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,categoryEmoji: freezed == categoryEmoji ? _self.categoryEmoji : categoryEmoji // ignore: cast_nullable_to_non_nullable
as String?,categoryColorHex: freezed == categoryColorHex ? _self.categoryColorHex : categoryColorHex // ignore: cast_nullable_to_non_nullable
as String?,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

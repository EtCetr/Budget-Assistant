// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cashback_raw_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashbackTransactionRaw {

 String get id; TransactionType get type; int get amount; String? get originalCurrency; int? get originalAmount; String? get customCategoryId; bool get isSplit; DateTime get date;
/// Create a copy of CashbackTransactionRaw
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashbackTransactionRawCopyWith<CashbackTransactionRaw> get copyWith => _$CashbackTransactionRawCopyWithImpl<CashbackTransactionRaw>(this as CashbackTransactionRaw, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashbackTransactionRaw&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.customCategoryId, customCategoryId) || other.customCategoryId == customCategoryId)&&(identical(other.isSplit, isSplit) || other.isSplit == isSplit)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,amount,originalCurrency,originalAmount,customCategoryId,isSplit,date);

@override
String toString() {
  return 'CashbackTransactionRaw(id: $id, type: $type, amount: $amount, originalCurrency: $originalCurrency, originalAmount: $originalAmount, customCategoryId: $customCategoryId, isSplit: $isSplit, date: $date)';
}


}

/// @nodoc
abstract mixin class $CashbackTransactionRawCopyWith<$Res>  {
  factory $CashbackTransactionRawCopyWith(CashbackTransactionRaw value, $Res Function(CashbackTransactionRaw) _then) = _$CashbackTransactionRawCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type, int amount, String? originalCurrency, int? originalAmount, String? customCategoryId, bool isSplit, DateTime date
});




}
/// @nodoc
class _$CashbackTransactionRawCopyWithImpl<$Res>
    implements $CashbackTransactionRawCopyWith<$Res> {
  _$CashbackTransactionRawCopyWithImpl(this._self, this._then);

  final CashbackTransactionRaw _self;
  final $Res Function(CashbackTransactionRaw) _then;

/// Create a copy of CashbackTransactionRaw
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? originalCurrency = freezed,Object? originalAmount = freezed,Object? customCategoryId = freezed,Object? isSplit = null,Object? date = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: freezed == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as int?,customCategoryId: freezed == customCategoryId ? _self.customCategoryId : customCategoryId // ignore: cast_nullable_to_non_nullable
as String?,isSplit: null == isSplit ? _self.isSplit : isSplit // ignore: cast_nullable_to_non_nullable
as bool,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CashbackTransactionRaw].
extension CashbackTransactionRawPatterns on CashbackTransactionRaw {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashbackTransactionRaw value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashbackTransactionRaw() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashbackTransactionRaw value)  $default,){
final _that = this;
switch (_that) {
case _CashbackTransactionRaw():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashbackTransactionRaw value)?  $default,){
final _that = this;
switch (_that) {
case _CashbackTransactionRaw() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CashbackTransactionRaw implements CashbackTransactionRaw {
  const _CashbackTransactionRaw({required this.id, required this.type, required this.amount, this.originalCurrency, this.originalAmount, this.customCategoryId, required this.isSplit, required this.date});
  

@override final  String id;
@override final  TransactionType type;
@override final  int amount;
@override final  String? originalCurrency;
@override final  int? originalAmount;
@override final  String? customCategoryId;
@override final  bool isSplit;
@override final  DateTime date;

/// Create a copy of CashbackTransactionRaw
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashbackTransactionRawCopyWith<_CashbackTransactionRaw> get copyWith => __$CashbackTransactionRawCopyWithImpl<_CashbackTransactionRaw>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashbackTransactionRaw&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.customCategoryId, customCategoryId) || other.customCategoryId == customCategoryId)&&(identical(other.isSplit, isSplit) || other.isSplit == isSplit)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,amount,originalCurrency,originalAmount,customCategoryId,isSplit,date);

@override
String toString() {
  return 'CashbackTransactionRaw(id: $id, type: $type, amount: $amount, originalCurrency: $originalCurrency, originalAmount: $originalAmount, customCategoryId: $customCategoryId, isSplit: $isSplit, date: $date)';
}


}

/// @nodoc
abstract mixin class _$CashbackTransactionRawCopyWith<$Res> implements $CashbackTransactionRawCopyWith<$Res> {
  factory _$CashbackTransactionRawCopyWith(_CashbackTransactionRaw value, $Res Function(_CashbackTransactionRaw) _then) = __$CashbackTransactionRawCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type, int amount, String? originalCurrency, int? originalAmount, String? customCategoryId, bool isSplit, DateTime date
});




}
/// @nodoc
class __$CashbackTransactionRawCopyWithImpl<$Res>
    implements _$CashbackTransactionRawCopyWith<$Res> {
  __$CashbackTransactionRawCopyWithImpl(this._self, this._then);

  final _CashbackTransactionRaw _self;
  final $Res Function(_CashbackTransactionRaw) _then;

/// Create a copy of CashbackTransactionRaw
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? originalCurrency = freezed,Object? originalAmount = freezed,Object? customCategoryId = freezed,Object? isSplit = null,Object? date = null,}) {
  return _then(_CashbackTransactionRaw(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: freezed == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as int?,customCategoryId: freezed == customCategoryId ? _self.customCategoryId : customCategoryId // ignore: cast_nullable_to_non_nullable
as String?,isSplit: null == isSplit ? _self.isSplit : isSplit // ignore: cast_nullable_to_non_nullable
as bool,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$CashbackSplitRaw {

 String get id; String get transactionId; String get categoryId; int get amount;
/// Create a copy of CashbackSplitRaw
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashbackSplitRawCopyWith<CashbackSplitRaw> get copyWith => _$CashbackSplitRawCopyWithImpl<CashbackSplitRaw>(this as CashbackSplitRaw, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashbackSplitRaw&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,id,transactionId,categoryId,amount);

@override
String toString() {
  return 'CashbackSplitRaw(id: $id, transactionId: $transactionId, categoryId: $categoryId, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $CashbackSplitRawCopyWith<$Res>  {
  factory $CashbackSplitRawCopyWith(CashbackSplitRaw value, $Res Function(CashbackSplitRaw) _then) = _$CashbackSplitRawCopyWithImpl;
@useResult
$Res call({
 String id, String transactionId, String categoryId, int amount
});




}
/// @nodoc
class _$CashbackSplitRawCopyWithImpl<$Res>
    implements $CashbackSplitRawCopyWith<$Res> {
  _$CashbackSplitRawCopyWithImpl(this._self, this._then);

  final CashbackSplitRaw _self;
  final $Res Function(CashbackSplitRaw) _then;

/// Create a copy of CashbackSplitRaw
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionId = null,Object? categoryId = null,Object? amount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CashbackSplitRaw].
extension CashbackSplitRawPatterns on CashbackSplitRaw {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashbackSplitRaw value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashbackSplitRaw() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashbackSplitRaw value)  $default,){
final _that = this;
switch (_that) {
case _CashbackSplitRaw():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashbackSplitRaw value)?  $default,){
final _that = this;
switch (_that) {
case _CashbackSplitRaw() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CashbackSplitRaw implements CashbackSplitRaw {
  const _CashbackSplitRaw({required this.id, required this.transactionId, required this.categoryId, required this.amount});
  

@override final  String id;
@override final  String transactionId;
@override final  String categoryId;
@override final  int amount;

/// Create a copy of CashbackSplitRaw
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashbackSplitRawCopyWith<_CashbackSplitRaw> get copyWith => __$CashbackSplitRawCopyWithImpl<_CashbackSplitRaw>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashbackSplitRaw&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,id,transactionId,categoryId,amount);

@override
String toString() {
  return 'CashbackSplitRaw(id: $id, transactionId: $transactionId, categoryId: $categoryId, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$CashbackSplitRawCopyWith<$Res> implements $CashbackSplitRawCopyWith<$Res> {
  factory _$CashbackSplitRawCopyWith(_CashbackSplitRaw value, $Res Function(_CashbackSplitRaw) _then) = __$CashbackSplitRawCopyWithImpl;
@override @useResult
$Res call({
 String id, String transactionId, String categoryId, int amount
});




}
/// @nodoc
class __$CashbackSplitRawCopyWithImpl<$Res>
    implements _$CashbackSplitRawCopyWith<$Res> {
  __$CashbackSplitRawCopyWithImpl(this._self, this._then);

  final _CashbackSplitRaw _self;
  final $Res Function(_CashbackSplitRaw) _then;

/// Create a copy of CashbackSplitRaw
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionId = null,Object? categoryId = null,Object? amount = null,}) {
  return _then(_CashbackSplitRaw(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

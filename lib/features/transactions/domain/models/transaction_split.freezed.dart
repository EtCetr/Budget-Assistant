// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_split.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionSplit {

 String get id; String get transactionId; String get categoryId;/// Копейки.
 int get amount; String? get description; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of TransactionSplit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionSplitCopyWith<TransactionSplit> get copyWith => _$TransactionSplitCopyWithImpl<TransactionSplit>(this as TransactionSplit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSplit&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,transactionId,categoryId,amount,description,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'TransactionSplit(id: $id, transactionId: $transactionId, categoryId: $categoryId, amount: $amount, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $TransactionSplitCopyWith<$Res>  {
  factory $TransactionSplitCopyWith(TransactionSplit value, $Res Function(TransactionSplit) _then) = _$TransactionSplitCopyWithImpl;
@useResult
$Res call({
 String id, String transactionId, String categoryId, int amount, String? description, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$TransactionSplitCopyWithImpl<$Res>
    implements $TransactionSplitCopyWith<$Res> {
  _$TransactionSplitCopyWithImpl(this._self, this._then);

  final TransactionSplit _self;
  final $Res Function(TransactionSplit) _then;

/// Create a copy of TransactionSplit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionId = null,Object? categoryId = null,Object? amount = null,Object? description = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionSplit].
extension TransactionSplitPatterns on TransactionSplit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionSplit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionSplit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionSplit value)  $default,){
final _that = this;
switch (_that) {
case _TransactionSplit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionSplit value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionSplit() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionSplit implements TransactionSplit {
  const _TransactionSplit({required this.id, required this.transactionId, required this.categoryId, required this.amount, this.description, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  

@override final  String id;
@override final  String transactionId;
@override final  String categoryId;
/// Копейки.
@override final  int amount;
@override final  String? description;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of TransactionSplit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionSplitCopyWith<_TransactionSplit> get copyWith => __$TransactionSplitCopyWithImpl<_TransactionSplit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionSplit&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,transactionId,categoryId,amount,description,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'TransactionSplit(id: $id, transactionId: $transactionId, categoryId: $categoryId, amount: $amount, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$TransactionSplitCopyWith<$Res> implements $TransactionSplitCopyWith<$Res> {
  factory _$TransactionSplitCopyWith(_TransactionSplit value, $Res Function(_TransactionSplit) _then) = __$TransactionSplitCopyWithImpl;
@override @useResult
$Res call({
 String id, String transactionId, String categoryId, int amount, String? description, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$TransactionSplitCopyWithImpl<$Res>
    implements _$TransactionSplitCopyWith<$Res> {
  __$TransactionSplitCopyWithImpl(this._self, this._then);

  final _TransactionSplit _self;
  final $Res Function(_TransactionSplit) _then;

/// Create a copy of TransactionSplit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionId = null,Object? categoryId = null,Object? amount = null,Object? description = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_TransactionSplit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

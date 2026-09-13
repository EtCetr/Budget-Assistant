// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cashback_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashbackEntry {

 String get id; String get accountId; String? get categoryId; String get categoryName; int get percentBps; String get status; String get lifetimeType; DateTime get expiresAt; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of CashbackEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashbackEntryCopyWith<CashbackEntry> get copyWith => _$CashbackEntryCopyWithImpl<CashbackEntry>(this as CashbackEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashbackEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps)&&(identical(other.status, status) || other.status == status)&&(identical(other.lifetimeType, lifetimeType) || other.lifetimeType == lifetimeType)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,accountId,categoryId,categoryName,percentBps,status,lifetimeType,expiresAt,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'CashbackEntry(id: $id, accountId: $accountId, categoryId: $categoryId, categoryName: $categoryName, percentBps: $percentBps, status: $status, lifetimeType: $lifetimeType, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $CashbackEntryCopyWith<$Res>  {
  factory $CashbackEntryCopyWith(CashbackEntry value, $Res Function(CashbackEntry) _then) = _$CashbackEntryCopyWithImpl;
@useResult
$Res call({
 String id, String accountId, String? categoryId, String categoryName, int percentBps, String status, String lifetimeType, DateTime expiresAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$CashbackEntryCopyWithImpl<$Res>
    implements $CashbackEntryCopyWith<$Res> {
  _$CashbackEntryCopyWithImpl(this._self, this._then);

  final CashbackEntry _self;
  final $Res Function(CashbackEntry) _then;

/// Create a copy of CashbackEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? categoryId = freezed,Object? categoryName = null,Object? percentBps = null,Object? status = null,Object? lifetimeType = null,Object? expiresAt = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,percentBps: null == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lifetimeType: null == lifetimeType ? _self.lifetimeType : lifetimeType // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CashbackEntry].
extension CashbackEntryPatterns on CashbackEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashbackEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashbackEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashbackEntry value)  $default,){
final _that = this;
switch (_that) {
case _CashbackEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashbackEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CashbackEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CashbackEntry implements CashbackEntry {
  const _CashbackEntry({required this.id, required this.accountId, this.categoryId, required this.categoryName, required this.percentBps, required this.status, required this.lifetimeType, required this.expiresAt, required this.createdAt, required this.updatedAt, required this.syncStatus});
  

@override final  String id;
@override final  String accountId;
@override final  String? categoryId;
@override final  String categoryName;
@override final  int percentBps;
@override final  String status;
@override final  String lifetimeType;
@override final  DateTime expiresAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  SyncStatus syncStatus;

/// Create a copy of CashbackEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashbackEntryCopyWith<_CashbackEntry> get copyWith => __$CashbackEntryCopyWithImpl<_CashbackEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashbackEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps)&&(identical(other.status, status) || other.status == status)&&(identical(other.lifetimeType, lifetimeType) || other.lifetimeType == lifetimeType)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,accountId,categoryId,categoryName,percentBps,status,lifetimeType,expiresAt,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'CashbackEntry(id: $id, accountId: $accountId, categoryId: $categoryId, categoryName: $categoryName, percentBps: $percentBps, status: $status, lifetimeType: $lifetimeType, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$CashbackEntryCopyWith<$Res> implements $CashbackEntryCopyWith<$Res> {
  factory _$CashbackEntryCopyWith(_CashbackEntry value, $Res Function(_CashbackEntry) _then) = __$CashbackEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String accountId, String? categoryId, String categoryName, int percentBps, String status, String lifetimeType, DateTime expiresAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$CashbackEntryCopyWithImpl<$Res>
    implements _$CashbackEntryCopyWith<$Res> {
  __$CashbackEntryCopyWithImpl(this._self, this._then);

  final _CashbackEntry _self;
  final $Res Function(_CashbackEntry) _then;

/// Create a copy of CashbackEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? categoryId = freezed,Object? categoryName = null,Object? percentBps = null,Object? status = null,Object? lifetimeType = null,Object? expiresAt = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_CashbackEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,percentBps: null == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lifetimeType: null == lifetimeType ? _self.lifetimeType : lifetimeType // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

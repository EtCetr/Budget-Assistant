// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_alias.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductAlias {

 String get id; String get userId; String? get spaceId; String get originalNameHash; String get normalizedName; String get categoryId; int get usageCount; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of ProductAlias
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductAliasCopyWith<ProductAlias> get copyWith => _$ProductAliasCopyWithImpl<ProductAlias>(this as ProductAlias, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductAlias&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.originalNameHash, originalNameHash) || other.originalNameHash == originalNameHash)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,originalNameHash,normalizedName,categoryId,usageCount,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'ProductAlias(id: $id, userId: $userId, spaceId: $spaceId, originalNameHash: $originalNameHash, normalizedName: $normalizedName, categoryId: $categoryId, usageCount: $usageCount, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $ProductAliasCopyWith<$Res>  {
  factory $ProductAliasCopyWith(ProductAlias value, $Res Function(ProductAlias) _then) = _$ProductAliasCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, String originalNameHash, String normalizedName, String categoryId, int usageCount, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$ProductAliasCopyWithImpl<$Res>
    implements $ProductAliasCopyWith<$Res> {
  _$ProductAliasCopyWithImpl(this._self, this._then);

  final ProductAlias _self;
  final $Res Function(ProductAlias) _then;

/// Create a copy of ProductAlias
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? originalNameHash = null,Object? normalizedName = null,Object? categoryId = null,Object? usageCount = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,originalNameHash: null == originalNameHash ? _self.originalNameHash : originalNameHash // ignore: cast_nullable_to_non_nullable
as String,normalizedName: null == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductAlias].
extension ProductAliasPatterns on ProductAlias {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductAlias value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductAlias() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductAlias value)  $default,){
final _that = this;
switch (_that) {
case _ProductAlias():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductAlias value)?  $default,){
final _that = this;
switch (_that) {
case _ProductAlias() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ProductAlias implements ProductAlias {
  const _ProductAlias({required this.id, required this.userId, this.spaceId, required this.originalNameHash, required this.normalizedName, required this.categoryId, required this.usageCount, required this.createdAt, required this.updatedAt, required this.syncStatus});
  

@override final  String id;
@override final  String userId;
@override final  String? spaceId;
@override final  String originalNameHash;
@override final  String normalizedName;
@override final  String categoryId;
@override final  int usageCount;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  SyncStatus syncStatus;

/// Create a copy of ProductAlias
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductAliasCopyWith<_ProductAlias> get copyWith => __$ProductAliasCopyWithImpl<_ProductAlias>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductAlias&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.originalNameHash, originalNameHash) || other.originalNameHash == originalNameHash)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,originalNameHash,normalizedName,categoryId,usageCount,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'ProductAlias(id: $id, userId: $userId, spaceId: $spaceId, originalNameHash: $originalNameHash, normalizedName: $normalizedName, categoryId: $categoryId, usageCount: $usageCount, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$ProductAliasCopyWith<$Res> implements $ProductAliasCopyWith<$Res> {
  factory _$ProductAliasCopyWith(_ProductAlias value, $Res Function(_ProductAlias) _then) = __$ProductAliasCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, String originalNameHash, String normalizedName, String categoryId, int usageCount, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$ProductAliasCopyWithImpl<$Res>
    implements _$ProductAliasCopyWith<$Res> {
  __$ProductAliasCopyWithImpl(this._self, this._then);

  final _ProductAlias _self;
  final $Res Function(_ProductAlias) _then;

/// Create a copy of ProductAlias
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? originalNameHash = null,Object? normalizedName = null,Object? categoryId = null,Object? usageCount = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_ProductAlias(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,originalNameHash: null == originalNameHash ? _self.originalNameHash : originalNameHash // ignore: cast_nullable_to_non_nullable
as String,normalizedName: null == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

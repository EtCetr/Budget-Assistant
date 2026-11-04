// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_analytics_cache_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductAnalyticsCacheEntry {

 String get id; String get userId; String get spaceId; String get day; String get productHash; String? get categoryId; int get purchases; int get totalSpendKopecks;/// Количество (не деньги — double допустим, ТОМ 2 §17.3).
 double get totalQuantity; int get avgPriceKopecks; DateTime get updatedAt;
/// Create a copy of ProductAnalyticsCacheEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductAnalyticsCacheEntryCopyWith<ProductAnalyticsCacheEntry> get copyWith => _$ProductAnalyticsCacheEntryCopyWithImpl<ProductAnalyticsCacheEntry>(this as ProductAnalyticsCacheEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductAnalyticsCacheEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.day, day) || other.day == day)&&(identical(other.productHash, productHash) || other.productHash == productHash)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.purchases, purchases) || other.purchases == purchases)&&(identical(other.totalSpendKopecks, totalSpendKopecks) || other.totalSpendKopecks == totalSpendKopecks)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.avgPriceKopecks, avgPriceKopecks) || other.avgPriceKopecks == avgPriceKopecks)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,day,productHash,categoryId,purchases,totalSpendKopecks,totalQuantity,avgPriceKopecks,updatedAt);

@override
String toString() {
  return 'ProductAnalyticsCacheEntry(id: $id, userId: $userId, spaceId: $spaceId, day: $day, productHash: $productHash, categoryId: $categoryId, purchases: $purchases, totalSpendKopecks: $totalSpendKopecks, totalQuantity: $totalQuantity, avgPriceKopecks: $avgPriceKopecks, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductAnalyticsCacheEntryCopyWith<$Res>  {
  factory $ProductAnalyticsCacheEntryCopyWith(ProductAnalyticsCacheEntry value, $Res Function(ProductAnalyticsCacheEntry) _then) = _$ProductAnalyticsCacheEntryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String spaceId, String day, String productHash, String? categoryId, int purchases, int totalSpendKopecks, double totalQuantity, int avgPriceKopecks, DateTime updatedAt
});




}
/// @nodoc
class _$ProductAnalyticsCacheEntryCopyWithImpl<$Res>
    implements $ProductAnalyticsCacheEntryCopyWith<$Res> {
  _$ProductAnalyticsCacheEntryCopyWithImpl(this._self, this._then);

  final ProductAnalyticsCacheEntry _self;
  final $Res Function(ProductAnalyticsCacheEntry) _then;

/// Create a copy of ProductAnalyticsCacheEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = null,Object? day = null,Object? productHash = null,Object? categoryId = freezed,Object? purchases = null,Object? totalSpendKopecks = null,Object? totalQuantity = null,Object? avgPriceKopecks = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,productHash: null == productHash ? _self.productHash : productHash // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as int,totalSpendKopecks: null == totalSpendKopecks ? _self.totalSpendKopecks : totalSpendKopecks // ignore: cast_nullable_to_non_nullable
as int,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as double,avgPriceKopecks: null == avgPriceKopecks ? _self.avgPriceKopecks : avgPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductAnalyticsCacheEntry].
extension ProductAnalyticsCacheEntryPatterns on ProductAnalyticsCacheEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductAnalyticsCacheEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductAnalyticsCacheEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductAnalyticsCacheEntry value)  $default,){
final _that = this;
switch (_that) {
case _ProductAnalyticsCacheEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductAnalyticsCacheEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ProductAnalyticsCacheEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ProductAnalyticsCacheEntry implements ProductAnalyticsCacheEntry {
  const _ProductAnalyticsCacheEntry({required this.id, required this.userId, this.spaceId = '', required this.day, required this.productHash, this.categoryId, this.purchases = 0, this.totalSpendKopecks = 0, this.totalQuantity = 0.0, this.avgPriceKopecks = 0, required this.updatedAt});
  

@override final  String id;
@override final  String userId;
@override@JsonKey() final  String spaceId;
@override final  String day;
@override final  String productHash;
@override final  String? categoryId;
@override@JsonKey() final  int purchases;
@override@JsonKey() final  int totalSpendKopecks;
/// Количество (не деньги — double допустим, ТОМ 2 §17.3).
@override@JsonKey() final  double totalQuantity;
@override@JsonKey() final  int avgPriceKopecks;
@override final  DateTime updatedAt;

/// Create a copy of ProductAnalyticsCacheEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductAnalyticsCacheEntryCopyWith<_ProductAnalyticsCacheEntry> get copyWith => __$ProductAnalyticsCacheEntryCopyWithImpl<_ProductAnalyticsCacheEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductAnalyticsCacheEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.day, day) || other.day == day)&&(identical(other.productHash, productHash) || other.productHash == productHash)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.purchases, purchases) || other.purchases == purchases)&&(identical(other.totalSpendKopecks, totalSpendKopecks) || other.totalSpendKopecks == totalSpendKopecks)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.avgPriceKopecks, avgPriceKopecks) || other.avgPriceKopecks == avgPriceKopecks)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,day,productHash,categoryId,purchases,totalSpendKopecks,totalQuantity,avgPriceKopecks,updatedAt);

@override
String toString() {
  return 'ProductAnalyticsCacheEntry(id: $id, userId: $userId, spaceId: $spaceId, day: $day, productHash: $productHash, categoryId: $categoryId, purchases: $purchases, totalSpendKopecks: $totalSpendKopecks, totalQuantity: $totalQuantity, avgPriceKopecks: $avgPriceKopecks, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductAnalyticsCacheEntryCopyWith<$Res> implements $ProductAnalyticsCacheEntryCopyWith<$Res> {
  factory _$ProductAnalyticsCacheEntryCopyWith(_ProductAnalyticsCacheEntry value, $Res Function(_ProductAnalyticsCacheEntry) _then) = __$ProductAnalyticsCacheEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String spaceId, String day, String productHash, String? categoryId, int purchases, int totalSpendKopecks, double totalQuantity, int avgPriceKopecks, DateTime updatedAt
});




}
/// @nodoc
class __$ProductAnalyticsCacheEntryCopyWithImpl<$Res>
    implements _$ProductAnalyticsCacheEntryCopyWith<$Res> {
  __$ProductAnalyticsCacheEntryCopyWithImpl(this._self, this._then);

  final _ProductAnalyticsCacheEntry _self;
  final $Res Function(_ProductAnalyticsCacheEntry) _then;

/// Create a copy of ProductAnalyticsCacheEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = null,Object? day = null,Object? productHash = null,Object? categoryId = freezed,Object? purchases = null,Object? totalSpendKopecks = null,Object? totalQuantity = null,Object? avgPriceKopecks = null,Object? updatedAt = null,}) {
  return _then(_ProductAnalyticsCacheEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,productHash: null == productHash ? _self.productHash : productHash // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as int,totalSpendKopecks: null == totalSpendKopecks ? _self.totalSpendKopecks : totalSpendKopecks // ignore: cast_nullable_to_non_nullable
as int,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as double,avgPriceKopecks: null == avgPriceKopecks ? _self.avgPriceKopecks : avgPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

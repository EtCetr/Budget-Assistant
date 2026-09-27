// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast_cache_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForecastCacheEntry {

 String get id; String get userId; String? get spaceId;/// Формат 'YYYY-MM'.
 String get monthYear;/// NULL = тотал по пространству/пользователю.
 String? get categoryId;/// Копейки.
 int get forecastedAmount; DateTime get updatedAt;
/// Create a copy of ForecastCacheEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastCacheEntryCopyWith<ForecastCacheEntry> get copyWith => _$ForecastCacheEntryCopyWithImpl<ForecastCacheEntry>(this as ForecastCacheEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastCacheEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.monthYear, monthYear) || other.monthYear == monthYear)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.forecastedAmount, forecastedAmount) || other.forecastedAmount == forecastedAmount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,monthYear,categoryId,forecastedAmount,updatedAt);

@override
String toString() {
  return 'ForecastCacheEntry(id: $id, userId: $userId, spaceId: $spaceId, monthYear: $monthYear, categoryId: $categoryId, forecastedAmount: $forecastedAmount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ForecastCacheEntryCopyWith<$Res>  {
  factory $ForecastCacheEntryCopyWith(ForecastCacheEntry value, $Res Function(ForecastCacheEntry) _then) = _$ForecastCacheEntryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, String monthYear, String? categoryId, int forecastedAmount, DateTime updatedAt
});




}
/// @nodoc
class _$ForecastCacheEntryCopyWithImpl<$Res>
    implements $ForecastCacheEntryCopyWith<$Res> {
  _$ForecastCacheEntryCopyWithImpl(this._self, this._then);

  final ForecastCacheEntry _self;
  final $Res Function(ForecastCacheEntry) _then;

/// Create a copy of ForecastCacheEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? monthYear = null,Object? categoryId = freezed,Object? forecastedAmount = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,monthYear: null == monthYear ? _self.monthYear : monthYear // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,forecastedAmount: null == forecastedAmount ? _self.forecastedAmount : forecastedAmount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastCacheEntry].
extension ForecastCacheEntryPatterns on ForecastCacheEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastCacheEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastCacheEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastCacheEntry value)  $default,){
final _that = this;
switch (_that) {
case _ForecastCacheEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastCacheEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastCacheEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ForecastCacheEntry implements ForecastCacheEntry {
  const _ForecastCacheEntry({required this.id, required this.userId, this.spaceId, required this.monthYear, this.categoryId, this.forecastedAmount = 0, required this.updatedAt});
  

@override final  String id;
@override final  String userId;
@override final  String? spaceId;
/// Формат 'YYYY-MM'.
@override final  String monthYear;
/// NULL = тотал по пространству/пользователю.
@override final  String? categoryId;
/// Копейки.
@override@JsonKey() final  int forecastedAmount;
@override final  DateTime updatedAt;

/// Create a copy of ForecastCacheEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastCacheEntryCopyWith<_ForecastCacheEntry> get copyWith => __$ForecastCacheEntryCopyWithImpl<_ForecastCacheEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastCacheEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.monthYear, monthYear) || other.monthYear == monthYear)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.forecastedAmount, forecastedAmount) || other.forecastedAmount == forecastedAmount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,monthYear,categoryId,forecastedAmount,updatedAt);

@override
String toString() {
  return 'ForecastCacheEntry(id: $id, userId: $userId, spaceId: $spaceId, monthYear: $monthYear, categoryId: $categoryId, forecastedAmount: $forecastedAmount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ForecastCacheEntryCopyWith<$Res> implements $ForecastCacheEntryCopyWith<$Res> {
  factory _$ForecastCacheEntryCopyWith(_ForecastCacheEntry value, $Res Function(_ForecastCacheEntry) _then) = __$ForecastCacheEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, String monthYear, String? categoryId, int forecastedAmount, DateTime updatedAt
});




}
/// @nodoc
class __$ForecastCacheEntryCopyWithImpl<$Res>
    implements _$ForecastCacheEntryCopyWith<$Res> {
  __$ForecastCacheEntryCopyWithImpl(this._self, this._then);

  final _ForecastCacheEntry _self;
  final $Res Function(_ForecastCacheEntry) _then;

/// Create a copy of ForecastCacheEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? monthYear = null,Object? categoryId = freezed,Object? forecastedAmount = null,Object? updatedAt = null,}) {
  return _then(_ForecastCacheEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,monthYear: null == monthYear ? _self.monthYear : monthYear // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,forecastedAmount: null == forecastedAmount ? _self.forecastedAmount : forecastedAmount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

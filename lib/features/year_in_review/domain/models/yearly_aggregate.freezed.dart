// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'yearly_aggregate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$YearlyAggregate {

 String get id; String get userId; String? get spaceId; int get year; String get dataJson; bool get isViewed; DateTime get lastCalculatedAt; String get syncStatus;
/// Create a copy of YearlyAggregate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearlyAggregateCopyWith<YearlyAggregate> get copyWith => _$YearlyAggregateCopyWithImpl<YearlyAggregate>(this as YearlyAggregate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearlyAggregate&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.year, year) || other.year == year)&&(identical(other.dataJson, dataJson) || other.dataJson == dataJson)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed)&&(identical(other.lastCalculatedAt, lastCalculatedAt) || other.lastCalculatedAt == lastCalculatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,year,dataJson,isViewed,lastCalculatedAt,syncStatus);

@override
String toString() {
  return 'YearlyAggregate(id: $id, userId: $userId, spaceId: $spaceId, year: $year, dataJson: $dataJson, isViewed: $isViewed, lastCalculatedAt: $lastCalculatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $YearlyAggregateCopyWith<$Res>  {
  factory $YearlyAggregateCopyWith(YearlyAggregate value, $Res Function(YearlyAggregate) _then) = _$YearlyAggregateCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, int year, String dataJson, bool isViewed, DateTime lastCalculatedAt, String syncStatus
});




}
/// @nodoc
class _$YearlyAggregateCopyWithImpl<$Res>
    implements $YearlyAggregateCopyWith<$Res> {
  _$YearlyAggregateCopyWithImpl(this._self, this._then);

  final YearlyAggregate _self;
  final $Res Function(YearlyAggregate) _then;

/// Create a copy of YearlyAggregate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? year = null,Object? dataJson = null,Object? isViewed = null,Object? lastCalculatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,dataJson: null == dataJson ? _self.dataJson : dataJson // ignore: cast_nullable_to_non_nullable
as String,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,lastCalculatedAt: null == lastCalculatedAt ? _self.lastCalculatedAt : lastCalculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [YearlyAggregate].
extension YearlyAggregatePatterns on YearlyAggregate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearlyAggregate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearlyAggregate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearlyAggregate value)  $default,){
final _that = this;
switch (_that) {
case _YearlyAggregate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearlyAggregate value)?  $default,){
final _that = this;
switch (_that) {
case _YearlyAggregate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _YearlyAggregate implements YearlyAggregate {
  const _YearlyAggregate({required this.id, required this.userId, required this.spaceId, required this.year, required this.dataJson, required this.isViewed, required this.lastCalculatedAt, required this.syncStatus});
  

@override final  String id;
@override final  String userId;
@override final  String? spaceId;
@override final  int year;
@override final  String dataJson;
@override final  bool isViewed;
@override final  DateTime lastCalculatedAt;
@override final  String syncStatus;

/// Create a copy of YearlyAggregate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearlyAggregateCopyWith<_YearlyAggregate> get copyWith => __$YearlyAggregateCopyWithImpl<_YearlyAggregate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearlyAggregate&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.year, year) || other.year == year)&&(identical(other.dataJson, dataJson) || other.dataJson == dataJson)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed)&&(identical(other.lastCalculatedAt, lastCalculatedAt) || other.lastCalculatedAt == lastCalculatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,year,dataJson,isViewed,lastCalculatedAt,syncStatus);

@override
String toString() {
  return 'YearlyAggregate(id: $id, userId: $userId, spaceId: $spaceId, year: $year, dataJson: $dataJson, isViewed: $isViewed, lastCalculatedAt: $lastCalculatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$YearlyAggregateCopyWith<$Res> implements $YearlyAggregateCopyWith<$Res> {
  factory _$YearlyAggregateCopyWith(_YearlyAggregate value, $Res Function(_YearlyAggregate) _then) = __$YearlyAggregateCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, int year, String dataJson, bool isViewed, DateTime lastCalculatedAt, String syncStatus
});




}
/// @nodoc
class __$YearlyAggregateCopyWithImpl<$Res>
    implements _$YearlyAggregateCopyWith<$Res> {
  __$YearlyAggregateCopyWithImpl(this._self, this._then);

  final _YearlyAggregate _self;
  final $Res Function(_YearlyAggregate) _then;

/// Create a copy of YearlyAggregate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? year = null,Object? dataJson = null,Object? isViewed = null,Object? lastCalculatedAt = null,Object? syncStatus = null,}) {
  return _then(_YearlyAggregate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,dataJson: null == dataJson ? _self.dataJson : dataJson // ignore: cast_nullable_to_non_nullable
as String,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,lastCalculatedAt: null == lastCalculatedAt ? _self.lastCalculatedAt : lastCalculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$YearInReviewYearInfo {

 int get year;/// Есть ли уже посчитанный кэш в yearly_aggregates.
 bool get isCalculated; bool get isViewed; int get transactionCount;
/// Create a copy of YearInReviewYearInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearInReviewYearInfoCopyWith<YearInReviewYearInfo> get copyWith => _$YearInReviewYearInfoCopyWithImpl<YearInReviewYearInfo>(this as YearInReviewYearInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearInReviewYearInfo&&(identical(other.year, year) || other.year == year)&&(identical(other.isCalculated, isCalculated) || other.isCalculated == isCalculated)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}


@override
int get hashCode => Object.hash(runtimeType,year,isCalculated,isViewed,transactionCount);

@override
String toString() {
  return 'YearInReviewYearInfo(year: $year, isCalculated: $isCalculated, isViewed: $isViewed, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class $YearInReviewYearInfoCopyWith<$Res>  {
  factory $YearInReviewYearInfoCopyWith(YearInReviewYearInfo value, $Res Function(YearInReviewYearInfo) _then) = _$YearInReviewYearInfoCopyWithImpl;
@useResult
$Res call({
 int year, bool isCalculated, bool isViewed, int transactionCount
});




}
/// @nodoc
class _$YearInReviewYearInfoCopyWithImpl<$Res>
    implements $YearInReviewYearInfoCopyWith<$Res> {
  _$YearInReviewYearInfoCopyWithImpl(this._self, this._then);

  final YearInReviewYearInfo _self;
  final $Res Function(YearInReviewYearInfo) _then;

/// Create a copy of YearInReviewYearInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? isCalculated = null,Object? isViewed = null,Object? transactionCount = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,isCalculated: null == isCalculated ? _self.isCalculated : isCalculated // ignore: cast_nullable_to_non_nullable
as bool,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [YearInReviewYearInfo].
extension YearInReviewYearInfoPatterns on YearInReviewYearInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearInReviewYearInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearInReviewYearInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearInReviewYearInfo value)  $default,){
final _that = this;
switch (_that) {
case _YearInReviewYearInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearInReviewYearInfo value)?  $default,){
final _that = this;
switch (_that) {
case _YearInReviewYearInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _YearInReviewYearInfo implements YearInReviewYearInfo {
  const _YearInReviewYearInfo({required this.year, this.isCalculated = false, this.isViewed = false, this.transactionCount = 0});
  

@override final  int year;
/// Есть ли уже посчитанный кэш в yearly_aggregates.
@override@JsonKey() final  bool isCalculated;
@override@JsonKey() final  bool isViewed;
@override@JsonKey() final  int transactionCount;

/// Create a copy of YearInReviewYearInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearInReviewYearInfoCopyWith<_YearInReviewYearInfo> get copyWith => __$YearInReviewYearInfoCopyWithImpl<_YearInReviewYearInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearInReviewYearInfo&&(identical(other.year, year) || other.year == year)&&(identical(other.isCalculated, isCalculated) || other.isCalculated == isCalculated)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}


@override
int get hashCode => Object.hash(runtimeType,year,isCalculated,isViewed,transactionCount);

@override
String toString() {
  return 'YearInReviewYearInfo(year: $year, isCalculated: $isCalculated, isViewed: $isViewed, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class _$YearInReviewYearInfoCopyWith<$Res> implements $YearInReviewYearInfoCopyWith<$Res> {
  factory _$YearInReviewYearInfoCopyWith(_YearInReviewYearInfo value, $Res Function(_YearInReviewYearInfo) _then) = __$YearInReviewYearInfoCopyWithImpl;
@override @useResult
$Res call({
 int year, bool isCalculated, bool isViewed, int transactionCount
});




}
/// @nodoc
class __$YearInReviewYearInfoCopyWithImpl<$Res>
    implements _$YearInReviewYearInfoCopyWith<$Res> {
  __$YearInReviewYearInfoCopyWithImpl(this._self, this._then);

  final _YearInReviewYearInfo _self;
  final $Res Function(_YearInReviewYearInfo) _then;

/// Create a copy of YearInReviewYearInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? isCalculated = null,Object? isViewed = null,Object? transactionCount = null,}) {
  return _then(_YearInReviewYearInfo(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,isCalculated: null == isCalculated ? _self.isCalculated : isCalculated // ignore: cast_nullable_to_non_nullable
as bool,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

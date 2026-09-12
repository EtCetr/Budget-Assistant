// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_limit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetLimitModel {

 String get id; String? get spaceId; String get userId; String get categoryId; int get year; int get month; int get limitAmount; int get alertPercent; int get alertAmount; DateTime get createdAt; DateTime get updatedAt; String get syncStatus;
/// Create a copy of BudgetLimitModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetLimitModelCopyWith<BudgetLimitModel> get copyWith => _$BudgetLimitModelCopyWithImpl<BudgetLimitModel>(this as BudgetLimitModel, _$identity);

  /// Serializes this BudgetLimitModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetLimitModel&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.alertPercent, alertPercent) || other.alertPercent == alertPercent)&&(identical(other.alertAmount, alertAmount) || other.alertAmount == alertAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,categoryId,year,month,limitAmount,alertPercent,alertAmount,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'BudgetLimitModel(id: $id, spaceId: $spaceId, userId: $userId, categoryId: $categoryId, year: $year, month: $month, limitAmount: $limitAmount, alertPercent: $alertPercent, alertAmount: $alertAmount, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $BudgetLimitModelCopyWith<$Res>  {
  factory $BudgetLimitModelCopyWith(BudgetLimitModel value, $Res Function(BudgetLimitModel) _then) = _$BudgetLimitModelCopyWithImpl;
@useResult
$Res call({
 String id, String? spaceId, String userId, String categoryId, int year, int month, int limitAmount, int alertPercent, int alertAmount, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class _$BudgetLimitModelCopyWithImpl<$Res>
    implements $BudgetLimitModelCopyWith<$Res> {
  _$BudgetLimitModelCopyWithImpl(this._self, this._then);

  final BudgetLimitModel _self;
  final $Res Function(BudgetLimitModel) _then;

/// Create a copy of BudgetLimitModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = freezed,Object? userId = null,Object? categoryId = null,Object? year = null,Object? month = null,Object? limitAmount = null,Object? alertPercent = null,Object? alertAmount = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,alertPercent: null == alertPercent ? _self.alertPercent : alertPercent // ignore: cast_nullable_to_non_nullable
as int,alertAmount: null == alertAmount ? _self.alertAmount : alertAmount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetLimitModel].
extension BudgetLimitModelPatterns on BudgetLimitModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetLimitModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetLimitModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetLimitModel value)  $default,){
final _that = this;
switch (_that) {
case _BudgetLimitModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetLimitModel value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetLimitModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetLimitModel implements BudgetLimitModel {
  const _BudgetLimitModel({required this.id, this.spaceId, required this.userId, required this.categoryId, required this.year, required this.month, required this.limitAmount, this.alertPercent = 80, this.alertAmount = 0, required this.createdAt, required this.updatedAt, this.syncStatus = 'pending'});
  factory _BudgetLimitModel.fromJson(Map<String, dynamic> json) => _$BudgetLimitModelFromJson(json);

@override final  String id;
@override final  String? spaceId;
@override final  String userId;
@override final  String categoryId;
@override final  int year;
@override final  int month;
@override final  int limitAmount;
@override@JsonKey() final  int alertPercent;
@override@JsonKey() final  int alertAmount;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String syncStatus;

/// Create a copy of BudgetLimitModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetLimitModelCopyWith<_BudgetLimitModel> get copyWith => __$BudgetLimitModelCopyWithImpl<_BudgetLimitModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetLimitModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetLimitModel&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.alertPercent, alertPercent) || other.alertPercent == alertPercent)&&(identical(other.alertAmount, alertAmount) || other.alertAmount == alertAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,categoryId,year,month,limitAmount,alertPercent,alertAmount,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'BudgetLimitModel(id: $id, spaceId: $spaceId, userId: $userId, categoryId: $categoryId, year: $year, month: $month, limitAmount: $limitAmount, alertPercent: $alertPercent, alertAmount: $alertAmount, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$BudgetLimitModelCopyWith<$Res> implements $BudgetLimitModelCopyWith<$Res> {
  factory _$BudgetLimitModelCopyWith(_BudgetLimitModel value, $Res Function(_BudgetLimitModel) _then) = __$BudgetLimitModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? spaceId, String userId, String categoryId, int year, int month, int limitAmount, int alertPercent, int alertAmount, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class __$BudgetLimitModelCopyWithImpl<$Res>
    implements _$BudgetLimitModelCopyWith<$Res> {
  __$BudgetLimitModelCopyWithImpl(this._self, this._then);

  final _BudgetLimitModel _self;
  final $Res Function(_BudgetLimitModel) _then;

/// Create a copy of BudgetLimitModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = freezed,Object? userId = null,Object? categoryId = null,Object? year = null,Object? month = null,Object? limitAmount = null,Object? alertPercent = null,Object? alertAmount = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_BudgetLimitModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,alertPercent: null == alertPercent ? _self.alertPercent : alertPercent // ignore: cast_nullable_to_non_nullable
as int,alertAmount: null == alertAmount ? _self.alertAmount : alertAmount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

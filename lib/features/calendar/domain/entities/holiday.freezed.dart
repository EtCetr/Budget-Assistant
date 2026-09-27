// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holiday.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Holiday {

 String get id; String? get spaceId; String? get userId; String get name;/// UTC. Для ежегодных матчинг по месяц/день.
 DateTime get date; bool get isAnnuallyRecurring; String? get iconEmoji; String? get colorHex; bool get isPreset; bool get isEnabled; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of Holiday
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HolidayCopyWith<Holiday> get copyWith => _$HolidayCopyWithImpl<Holiday>(this as Holiday, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Holiday&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.isAnnuallyRecurring, isAnnuallyRecurring) || other.isAnnuallyRecurring == isAnnuallyRecurring)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.isPreset, isPreset) || other.isPreset == isPreset)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,name,date,isAnnuallyRecurring,iconEmoji,colorHex,isPreset,isEnabled,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'Holiday(id: $id, spaceId: $spaceId, userId: $userId, name: $name, date: $date, isAnnuallyRecurring: $isAnnuallyRecurring, iconEmoji: $iconEmoji, colorHex: $colorHex, isPreset: $isPreset, isEnabled: $isEnabled, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $HolidayCopyWith<$Res>  {
  factory $HolidayCopyWith(Holiday value, $Res Function(Holiday) _then) = _$HolidayCopyWithImpl;
@useResult
$Res call({
 String id, String? spaceId, String? userId, String name, DateTime date, bool isAnnuallyRecurring, String? iconEmoji, String? colorHex, bool isPreset, bool isEnabled, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$HolidayCopyWithImpl<$Res>
    implements $HolidayCopyWith<$Res> {
  _$HolidayCopyWithImpl(this._self, this._then);

  final Holiday _self;
  final $Res Function(Holiday) _then;

/// Create a copy of Holiday
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = freezed,Object? userId = freezed,Object? name = null,Object? date = null,Object? isAnnuallyRecurring = null,Object? iconEmoji = freezed,Object? colorHex = freezed,Object? isPreset = null,Object? isEnabled = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isAnnuallyRecurring: null == isAnnuallyRecurring ? _self.isAnnuallyRecurring : isAnnuallyRecurring // ignore: cast_nullable_to_non_nullable
as bool,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,isPreset: null == isPreset ? _self.isPreset : isPreset // ignore: cast_nullable_to_non_nullable
as bool,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Holiday].
extension HolidayPatterns on Holiday {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Holiday value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Holiday() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Holiday value)  $default,){
final _that = this;
switch (_that) {
case _Holiday():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Holiday value)?  $default,){
final _that = this;
switch (_that) {
case _Holiday() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _Holiday implements Holiday {
  const _Holiday({required this.id, this.spaceId, this.userId, required this.name, required this.date, this.isAnnuallyRecurring = true, this.iconEmoji, this.colorHex, this.isPreset = false, this.isEnabled = true, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  

@override final  String id;
@override final  String? spaceId;
@override final  String? userId;
@override final  String name;
/// UTC. Для ежегодных матчинг по месяц/день.
@override final  DateTime date;
@override@JsonKey() final  bool isAnnuallyRecurring;
@override final  String? iconEmoji;
@override final  String? colorHex;
@override@JsonKey() final  bool isPreset;
@override@JsonKey() final  bool isEnabled;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of Holiday
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HolidayCopyWith<_Holiday> get copyWith => __$HolidayCopyWithImpl<_Holiday>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Holiday&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.isAnnuallyRecurring, isAnnuallyRecurring) || other.isAnnuallyRecurring == isAnnuallyRecurring)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.isPreset, isPreset) || other.isPreset == isPreset)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,name,date,isAnnuallyRecurring,iconEmoji,colorHex,isPreset,isEnabled,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'Holiday(id: $id, spaceId: $spaceId, userId: $userId, name: $name, date: $date, isAnnuallyRecurring: $isAnnuallyRecurring, iconEmoji: $iconEmoji, colorHex: $colorHex, isPreset: $isPreset, isEnabled: $isEnabled, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$HolidayCopyWith<$Res> implements $HolidayCopyWith<$Res> {
  factory _$HolidayCopyWith(_Holiday value, $Res Function(_Holiday) _then) = __$HolidayCopyWithImpl;
@override @useResult
$Res call({
 String id, String? spaceId, String? userId, String name, DateTime date, bool isAnnuallyRecurring, String? iconEmoji, String? colorHex, bool isPreset, bool isEnabled, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$HolidayCopyWithImpl<$Res>
    implements _$HolidayCopyWith<$Res> {
  __$HolidayCopyWithImpl(this._self, this._then);

  final _Holiday _self;
  final $Res Function(_Holiday) _then;

/// Create a copy of Holiday
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = freezed,Object? userId = freezed,Object? name = null,Object? date = null,Object? isAnnuallyRecurring = null,Object? iconEmoji = freezed,Object? colorHex = freezed,Object? isPreset = null,Object? isEnabled = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_Holiday(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isAnnuallyRecurring: null == isAnnuallyRecurring ? _self.isAnnuallyRecurring : isAnnuallyRecurring // ignore: cast_nullable_to_non_nullable
as bool,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,isPreset: null == isPreset ? _self.isPreset : isPreset // ignore: cast_nullable_to_non_nullable
as bool,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

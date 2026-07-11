// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncLogModel {

 String get id; String get userId; DateTime get timestamp; String get status; String? get errorMessage; int get entitiesSyncedCount;
/// Create a copy of SyncLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncLogModelCopyWith<SyncLogModel> get copyWith => _$SyncLogModelCopyWithImpl<SyncLogModel>(this as SyncLogModel, _$identity);

  /// Serializes this SyncLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.entitiesSyncedCount, entitiesSyncedCount) || other.entitiesSyncedCount == entitiesSyncedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,timestamp,status,errorMessage,entitiesSyncedCount);

@override
String toString() {
  return 'SyncLogModel(id: $id, userId: $userId, timestamp: $timestamp, status: $status, errorMessage: $errorMessage, entitiesSyncedCount: $entitiesSyncedCount)';
}


}

/// @nodoc
abstract mixin class $SyncLogModelCopyWith<$Res>  {
  factory $SyncLogModelCopyWith(SyncLogModel value, $Res Function(SyncLogModel) _then) = _$SyncLogModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime timestamp, String status, String? errorMessage, int entitiesSyncedCount
});




}
/// @nodoc
class _$SyncLogModelCopyWithImpl<$Res>
    implements $SyncLogModelCopyWith<$Res> {
  _$SyncLogModelCopyWithImpl(this._self, this._then);

  final SyncLogModel _self;
  final $Res Function(SyncLogModel) _then;

/// Create a copy of SyncLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? timestamp = null,Object? status = null,Object? errorMessage = freezed,Object? entitiesSyncedCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,entitiesSyncedCount: null == entitiesSyncedCount ? _self.entitiesSyncedCount : entitiesSyncedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncLogModel].
extension SyncLogModelPatterns on SyncLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncLogModel value)  $default,){
final _that = this;
switch (_that) {
case _SyncLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _SyncLogModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncLogModel implements SyncLogModel {
  const _SyncLogModel({required this.id, required this.userId, required this.timestamp, required this.status, this.errorMessage, this.entitiesSyncedCount = 0});
  factory _SyncLogModel.fromJson(Map<String, dynamic> json) => _$SyncLogModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DateTime timestamp;
@override final  String status;
@override final  String? errorMessage;
@override@JsonKey() final  int entitiesSyncedCount;

/// Create a copy of SyncLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncLogModelCopyWith<_SyncLogModel> get copyWith => __$SyncLogModelCopyWithImpl<_SyncLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.entitiesSyncedCount, entitiesSyncedCount) || other.entitiesSyncedCount == entitiesSyncedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,timestamp,status,errorMessage,entitiesSyncedCount);

@override
String toString() {
  return 'SyncLogModel(id: $id, userId: $userId, timestamp: $timestamp, status: $status, errorMessage: $errorMessage, entitiesSyncedCount: $entitiesSyncedCount)';
}


}

/// @nodoc
abstract mixin class _$SyncLogModelCopyWith<$Res> implements $SyncLogModelCopyWith<$Res> {
  factory _$SyncLogModelCopyWith(_SyncLogModel value, $Res Function(_SyncLogModel) _then) = __$SyncLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime timestamp, String status, String? errorMessage, int entitiesSyncedCount
});




}
/// @nodoc
class __$SyncLogModelCopyWithImpl<$Res>
    implements _$SyncLogModelCopyWith<$Res> {
  __$SyncLogModelCopyWithImpl(this._self, this._then);

  final _SyncLogModel _self;
  final $Res Function(_SyncLogModel) _then;

/// Create a copy of SyncLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? timestamp = null,Object? status = null,Object? errorMessage = freezed,Object? entitiesSyncedCount = null,}) {
  return _then(_SyncLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,entitiesSyncedCount: null == entitiesSyncedCount ? _self.entitiesSyncedCount : entitiesSyncedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

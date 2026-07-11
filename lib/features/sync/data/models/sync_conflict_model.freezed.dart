// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_conflict_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncConflictModel {

 String get id; String get entityType; String get entityId; String get localValue; String get remoteValue; DateTime get createdAt; DateTime? get resolvedAt; String? get resolution;
/// Create a copy of SyncConflictModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncConflictModelCopyWith<SyncConflictModel> get copyWith => _$SyncConflictModelCopyWithImpl<SyncConflictModel>(this as SyncConflictModel, _$identity);

  /// Serializes this SyncConflictModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncConflictModel&&(identical(other.id, id) || other.id == id)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.localValue, localValue) || other.localValue == localValue)&&(identical(other.remoteValue, remoteValue) || other.remoteValue == remoteValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.resolution, resolution) || other.resolution == resolution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityType,entityId,localValue,remoteValue,createdAt,resolvedAt,resolution);

@override
String toString() {
  return 'SyncConflictModel(id: $id, entityType: $entityType, entityId: $entityId, localValue: $localValue, remoteValue: $remoteValue, createdAt: $createdAt, resolvedAt: $resolvedAt, resolution: $resolution)';
}


}

/// @nodoc
abstract mixin class $SyncConflictModelCopyWith<$Res>  {
  factory $SyncConflictModelCopyWith(SyncConflictModel value, $Res Function(SyncConflictModel) _then) = _$SyncConflictModelCopyWithImpl;
@useResult
$Res call({
 String id, String entityType, String entityId, String localValue, String remoteValue, DateTime createdAt, DateTime? resolvedAt, String? resolution
});




}
/// @nodoc
class _$SyncConflictModelCopyWithImpl<$Res>
    implements $SyncConflictModelCopyWith<$Res> {
  _$SyncConflictModelCopyWithImpl(this._self, this._then);

  final SyncConflictModel _self;
  final $Res Function(SyncConflictModel) _then;

/// Create a copy of SyncConflictModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? entityType = null,Object? entityId = null,Object? localValue = null,Object? remoteValue = null,Object? createdAt = null,Object? resolvedAt = freezed,Object? resolution = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,localValue: null == localValue ? _self.localValue : localValue // ignore: cast_nullable_to_non_nullable
as String,remoteValue: null == remoteValue ? _self.remoteValue : remoteValue // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncConflictModel].
extension SyncConflictModelPatterns on SyncConflictModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncConflictModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncConflictModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncConflictModel value)  $default,){
final _that = this;
switch (_that) {
case _SyncConflictModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncConflictModel value)?  $default,){
final _that = this;
switch (_that) {
case _SyncConflictModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncConflictModel implements SyncConflictModel {
  const _SyncConflictModel({required this.id, required this.entityType, required this.entityId, required this.localValue, required this.remoteValue, required this.createdAt, this.resolvedAt, this.resolution});
  factory _SyncConflictModel.fromJson(Map<String, dynamic> json) => _$SyncConflictModelFromJson(json);

@override final  String id;
@override final  String entityType;
@override final  String entityId;
@override final  String localValue;
@override final  String remoteValue;
@override final  DateTime createdAt;
@override final  DateTime? resolvedAt;
@override final  String? resolution;

/// Create a copy of SyncConflictModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncConflictModelCopyWith<_SyncConflictModel> get copyWith => __$SyncConflictModelCopyWithImpl<_SyncConflictModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncConflictModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncConflictModel&&(identical(other.id, id) || other.id == id)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.localValue, localValue) || other.localValue == localValue)&&(identical(other.remoteValue, remoteValue) || other.remoteValue == remoteValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.resolution, resolution) || other.resolution == resolution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityType,entityId,localValue,remoteValue,createdAt,resolvedAt,resolution);

@override
String toString() {
  return 'SyncConflictModel(id: $id, entityType: $entityType, entityId: $entityId, localValue: $localValue, remoteValue: $remoteValue, createdAt: $createdAt, resolvedAt: $resolvedAt, resolution: $resolution)';
}


}

/// @nodoc
abstract mixin class _$SyncConflictModelCopyWith<$Res> implements $SyncConflictModelCopyWith<$Res> {
  factory _$SyncConflictModelCopyWith(_SyncConflictModel value, $Res Function(_SyncConflictModel) _then) = __$SyncConflictModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String entityType, String entityId, String localValue, String remoteValue, DateTime createdAt, DateTime? resolvedAt, String? resolution
});




}
/// @nodoc
class __$SyncConflictModelCopyWithImpl<$Res>
    implements _$SyncConflictModelCopyWith<$Res> {
  __$SyncConflictModelCopyWithImpl(this._self, this._then);

  final _SyncConflictModel _self;
  final $Res Function(_SyncConflictModel) _then;

/// Create a copy of SyncConflictModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entityType = null,Object? entityId = null,Object? localValue = null,Object? remoteValue = null,Object? createdAt = null,Object? resolvedAt = freezed,Object? resolution = freezed,}) {
  return _then(_SyncConflictModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,localValue: null == localValue ? _self.localValue : localValue // ignore: cast_nullable_to_non_nullable
as String,remoteValue: null == remoteValue ? _self.remoteValue : remoteValue // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

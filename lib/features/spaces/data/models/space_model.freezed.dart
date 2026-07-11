// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpaceModel {

 String get id; String get name; String get encryptionSalt; String get status; DateTime get createdAt; DateTime get updatedAt; String get syncStatus;
/// Create a copy of SpaceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceModelCopyWith<SpaceModel> get copyWith => _$SpaceModelCopyWithImpl<SpaceModel>(this as SpaceModel, _$identity);

  /// Serializes this SpaceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.encryptionSalt, encryptionSalt) || other.encryptionSalt == encryptionSalt)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,encryptionSalt,status,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'SpaceModel(id: $id, name: $name, encryptionSalt: $encryptionSalt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $SpaceModelCopyWith<$Res>  {
  factory $SpaceModelCopyWith(SpaceModel value, $Res Function(SpaceModel) _then) = _$SpaceModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String encryptionSalt, String status, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class _$SpaceModelCopyWithImpl<$Res>
    implements $SpaceModelCopyWith<$Res> {
  _$SpaceModelCopyWithImpl(this._self, this._then);

  final SpaceModel _self;
  final $Res Function(SpaceModel) _then;

/// Create a copy of SpaceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? encryptionSalt = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,encryptionSalt: null == encryptionSalt ? _self.encryptionSalt : encryptionSalt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceModel].
extension SpaceModelPatterns on SpaceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceModel value)  $default,){
final _that = this;
switch (_that) {
case _SpaceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceModel value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpaceModel implements SpaceModel {
  const _SpaceModel({required this.id, required this.name, required this.encryptionSalt, this.status = 'active', required this.createdAt, required this.updatedAt, this.syncStatus = 'pending'});
  factory _SpaceModel.fromJson(Map<String, dynamic> json) => _$SpaceModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String encryptionSalt;
@override@JsonKey() final  String status;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String syncStatus;

/// Create a copy of SpaceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceModelCopyWith<_SpaceModel> get copyWith => __$SpaceModelCopyWithImpl<_SpaceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.encryptionSalt, encryptionSalt) || other.encryptionSalt == encryptionSalt)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,encryptionSalt,status,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'SpaceModel(id: $id, name: $name, encryptionSalt: $encryptionSalt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$SpaceModelCopyWith<$Res> implements $SpaceModelCopyWith<$Res> {
  factory _$SpaceModelCopyWith(_SpaceModel value, $Res Function(_SpaceModel) _then) = __$SpaceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String encryptionSalt, String status, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class __$SpaceModelCopyWithImpl<$Res>
    implements _$SpaceModelCopyWith<$Res> {
  __$SpaceModelCopyWithImpl(this._self, this._then);

  final _SpaceModel _self;
  final $Res Function(_SpaceModel) _then;

/// Create a copy of SpaceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? encryptionSalt = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_SpaceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,encryptionSalt: null == encryptionSalt ? _self.encryptionSalt : encryptionSalt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

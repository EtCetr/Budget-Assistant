// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_color_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberColorModel {

 String get id; String get userId; String get spaceId; String get customColorHex; DateTime get createdAt; DateTime get updatedAt; String get syncStatus;
/// Create a copy of MemberColorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberColorModelCopyWith<MemberColorModel> get copyWith => _$MemberColorModelCopyWithImpl<MemberColorModel>(this as MemberColorModel, _$identity);

  /// Serializes this MemberColorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberColorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.customColorHex, customColorHex) || other.customColorHex == customColorHex)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,customColorHex,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'MemberColorModel(id: $id, userId: $userId, spaceId: $spaceId, customColorHex: $customColorHex, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $MemberColorModelCopyWith<$Res>  {
  factory $MemberColorModelCopyWith(MemberColorModel value, $Res Function(MemberColorModel) _then) = _$MemberColorModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String spaceId, String customColorHex, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class _$MemberColorModelCopyWithImpl<$Res>
    implements $MemberColorModelCopyWith<$Res> {
  _$MemberColorModelCopyWithImpl(this._self, this._then);

  final MemberColorModel _self;
  final $Res Function(MemberColorModel) _then;

/// Create a copy of MemberColorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = null,Object? customColorHex = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,customColorHex: null == customColorHex ? _self.customColorHex : customColorHex // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberColorModel].
extension MemberColorModelPatterns on MemberColorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberColorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberColorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberColorModel value)  $default,){
final _that = this;
switch (_that) {
case _MemberColorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberColorModel value)?  $default,){
final _that = this;
switch (_that) {
case _MemberColorModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberColorModel implements MemberColorModel {
  const _MemberColorModel({required this.id, required this.userId, this.spaceId = '', required this.customColorHex, required this.createdAt, required this.updatedAt, this.syncStatus = 'pending'});
  factory _MemberColorModel.fromJson(Map<String, dynamic> json) => _$MemberColorModelFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  String spaceId;
@override final  String customColorHex;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String syncStatus;

/// Create a copy of MemberColorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberColorModelCopyWith<_MemberColorModel> get copyWith => __$MemberColorModelCopyWithImpl<_MemberColorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberColorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberColorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.customColorHex, customColorHex) || other.customColorHex == customColorHex)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,customColorHex,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'MemberColorModel(id: $id, userId: $userId, spaceId: $spaceId, customColorHex: $customColorHex, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$MemberColorModelCopyWith<$Res> implements $MemberColorModelCopyWith<$Res> {
  factory _$MemberColorModelCopyWith(_MemberColorModel value, $Res Function(_MemberColorModel) _then) = __$MemberColorModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String spaceId, String customColorHex, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class __$MemberColorModelCopyWithImpl<$Res>
    implements _$MemberColorModelCopyWith<$Res> {
  __$MemberColorModelCopyWithImpl(this._self, this._then);

  final _MemberColorModel _self;
  final $Res Function(_MemberColorModel) _then;

/// Create a copy of MemberColorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = null,Object? customColorHex = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_MemberColorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,customColorHex: null == customColorHex ? _self.customColorHex : customColorHex // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MembershipModel {

 String get id; String get userId; String get spaceId; String get role; String get status; DateTime? get lastActiveAt; DateTime get joinedAt; DateTime? get leftAt; DateTime get createdAt; DateTime get updatedAt; String get syncStatus;
/// Create a copy of MembershipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipModelCopyWith<MembershipModel> get copyWith => _$MembershipModelCopyWithImpl<MembershipModel>(this as MembershipModel, _$identity);

  /// Serializes this MembershipModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.leftAt, leftAt) || other.leftAt == leftAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,role,status,lastActiveAt,joinedAt,leftAt,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'MembershipModel(id: $id, userId: $userId, spaceId: $spaceId, role: $role, status: $status, lastActiveAt: $lastActiveAt, joinedAt: $joinedAt, leftAt: $leftAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $MembershipModelCopyWith<$Res>  {
  factory $MembershipModelCopyWith(MembershipModel value, $Res Function(MembershipModel) _then) = _$MembershipModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String spaceId, String role, String status, DateTime? lastActiveAt, DateTime joinedAt, DateTime? leftAt, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class _$MembershipModelCopyWithImpl<$Res>
    implements $MembershipModelCopyWith<$Res> {
  _$MembershipModelCopyWithImpl(this._self, this._then);

  final MembershipModel _self;
  final $Res Function(MembershipModel) _then;

/// Create a copy of MembershipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = null,Object? role = null,Object? status = null,Object? lastActiveAt = freezed,Object? joinedAt = null,Object? leftAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,leftAt: freezed == leftAt ? _self.leftAt : leftAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipModel].
extension MembershipModelPatterns on MembershipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipModel value)  $default,){
final _that = this;
switch (_that) {
case _MembershipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipModel value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MembershipModel implements MembershipModel {
  const _MembershipModel({required this.id, required this.userId, required this.spaceId, this.role = 'member', this.status = 'active', this.lastActiveAt, required this.joinedAt, this.leftAt, required this.createdAt, required this.updatedAt, this.syncStatus = 'pending'});
  factory _MembershipModel.fromJson(Map<String, dynamic> json) => _$MembershipModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String spaceId;
@override@JsonKey() final  String role;
@override@JsonKey() final  String status;
@override final  DateTime? lastActiveAt;
@override final  DateTime joinedAt;
@override final  DateTime? leftAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String syncStatus;

/// Create a copy of MembershipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipModelCopyWith<_MembershipModel> get copyWith => __$MembershipModelCopyWithImpl<_MembershipModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.leftAt, leftAt) || other.leftAt == leftAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,role,status,lastActiveAt,joinedAt,leftAt,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'MembershipModel(id: $id, userId: $userId, spaceId: $spaceId, role: $role, status: $status, lastActiveAt: $lastActiveAt, joinedAt: $joinedAt, leftAt: $leftAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$MembershipModelCopyWith<$Res> implements $MembershipModelCopyWith<$Res> {
  factory _$MembershipModelCopyWith(_MembershipModel value, $Res Function(_MembershipModel) _then) = __$MembershipModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String spaceId, String role, String status, DateTime? lastActiveAt, DateTime joinedAt, DateTime? leftAt, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class __$MembershipModelCopyWithImpl<$Res>
    implements _$MembershipModelCopyWith<$Res> {
  __$MembershipModelCopyWithImpl(this._self, this._then);

  final _MembershipModel _self;
  final $Res Function(_MembershipModel) _then;

/// Create a copy of MembershipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = null,Object? role = null,Object? status = null,Object? lastActiveAt = freezed,Object? joinedAt = null,Object? leftAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_MembershipModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,leftAt: freezed == leftAt ? _self.leftAt : leftAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

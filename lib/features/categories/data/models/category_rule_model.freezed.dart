// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_rule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryRuleModel {

 String get id; String? get spaceId; String get userId; String get bankName; String get triggerString; String get targetCategoryId; DateTime get createdAt; DateTime get updatedAt; String get syncStatus;
/// Create a copy of CategoryRuleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryRuleModelCopyWith<CategoryRuleModel> get copyWith => _$CategoryRuleModelCopyWithImpl<CategoryRuleModel>(this as CategoryRuleModel, _$identity);

  /// Serializes this CategoryRuleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryRuleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.triggerString, triggerString) || other.triggerString == triggerString)&&(identical(other.targetCategoryId, targetCategoryId) || other.targetCategoryId == targetCategoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,bankName,triggerString,targetCategoryId,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'CategoryRuleModel(id: $id, spaceId: $spaceId, userId: $userId, bankName: $bankName, triggerString: $triggerString, targetCategoryId: $targetCategoryId, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $CategoryRuleModelCopyWith<$Res>  {
  factory $CategoryRuleModelCopyWith(CategoryRuleModel value, $Res Function(CategoryRuleModel) _then) = _$CategoryRuleModelCopyWithImpl;
@useResult
$Res call({
 String id, String? spaceId, String userId, String bankName, String triggerString, String targetCategoryId, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class _$CategoryRuleModelCopyWithImpl<$Res>
    implements $CategoryRuleModelCopyWith<$Res> {
  _$CategoryRuleModelCopyWithImpl(this._self, this._then);

  final CategoryRuleModel _self;
  final $Res Function(CategoryRuleModel) _then;

/// Create a copy of CategoryRuleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = freezed,Object? userId = null,Object? bankName = null,Object? triggerString = null,Object? targetCategoryId = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,triggerString: null == triggerString ? _self.triggerString : triggerString // ignore: cast_nullable_to_non_nullable
as String,targetCategoryId: null == targetCategoryId ? _self.targetCategoryId : targetCategoryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryRuleModel].
extension CategoryRuleModelPatterns on CategoryRuleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryRuleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryRuleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryRuleModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryRuleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryRuleModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryRuleModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryRuleModel implements CategoryRuleModel {
  const _CategoryRuleModel({required this.id, this.spaceId, required this.userId, required this.bankName, required this.triggerString, required this.targetCategoryId, required this.createdAt, required this.updatedAt, this.syncStatus = 'pending'});
  factory _CategoryRuleModel.fromJson(Map<String, dynamic> json) => _$CategoryRuleModelFromJson(json);

@override final  String id;
@override final  String? spaceId;
@override final  String userId;
@override final  String bankName;
@override final  String triggerString;
@override final  String targetCategoryId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String syncStatus;

/// Create a copy of CategoryRuleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryRuleModelCopyWith<_CategoryRuleModel> get copyWith => __$CategoryRuleModelCopyWithImpl<_CategoryRuleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryRuleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryRuleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.triggerString, triggerString) || other.triggerString == triggerString)&&(identical(other.targetCategoryId, targetCategoryId) || other.targetCategoryId == targetCategoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,bankName,triggerString,targetCategoryId,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'CategoryRuleModel(id: $id, spaceId: $spaceId, userId: $userId, bankName: $bankName, triggerString: $triggerString, targetCategoryId: $targetCategoryId, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$CategoryRuleModelCopyWith<$Res> implements $CategoryRuleModelCopyWith<$Res> {
  factory _$CategoryRuleModelCopyWith(_CategoryRuleModel value, $Res Function(_CategoryRuleModel) _then) = __$CategoryRuleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? spaceId, String userId, String bankName, String triggerString, String targetCategoryId, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class __$CategoryRuleModelCopyWithImpl<$Res>
    implements _$CategoryRuleModelCopyWith<$Res> {
  __$CategoryRuleModelCopyWithImpl(this._self, this._then);

  final _CategoryRuleModel _self;
  final $Res Function(_CategoryRuleModel) _then;

/// Create a copy of CategoryRuleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = freezed,Object? userId = null,Object? bankName = null,Object? triggerString = null,Object? targetCategoryId = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_CategoryRuleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,triggerString: null == triggerString ? _self.triggerString : triggerString // ignore: cast_nullable_to_non_nullable
as String,targetCategoryId: null == targetCategoryId ? _self.targetCategoryId : targetCategoryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

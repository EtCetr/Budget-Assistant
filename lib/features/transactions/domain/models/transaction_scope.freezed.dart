// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionGroupScopes {

 bool get personal; Set<String> get spaceIds; String? get groupId;
/// Create a copy of TransactionGroupScopes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionGroupScopesCopyWith<TransactionGroupScopes> get copyWith => _$TransactionGroupScopesCopyWithImpl<TransactionGroupScopes>(this as TransactionGroupScopes, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionGroupScopes&&(identical(other.personal, personal) || other.personal == personal)&&const DeepCollectionEquality().equals(other.spaceIds, spaceIds)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}


@override
int get hashCode => Object.hash(runtimeType,personal,const DeepCollectionEquality().hash(spaceIds),groupId);

@override
String toString() {
  return 'TransactionGroupScopes(personal: $personal, spaceIds: $spaceIds, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class $TransactionGroupScopesCopyWith<$Res>  {
  factory $TransactionGroupScopesCopyWith(TransactionGroupScopes value, $Res Function(TransactionGroupScopes) _then) = _$TransactionGroupScopesCopyWithImpl;
@useResult
$Res call({
 bool personal, Set<String> spaceIds, String? groupId
});




}
/// @nodoc
class _$TransactionGroupScopesCopyWithImpl<$Res>
    implements $TransactionGroupScopesCopyWith<$Res> {
  _$TransactionGroupScopesCopyWithImpl(this._self, this._then);

  final TransactionGroupScopes _self;
  final $Res Function(TransactionGroupScopes) _then;

/// Create a copy of TransactionGroupScopes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? personal = null,Object? spaceIds = null,Object? groupId = freezed,}) {
  return _then(_self.copyWith(
personal: null == personal ? _self.personal : personal // ignore: cast_nullable_to_non_nullable
as bool,spaceIds: null == spaceIds ? _self.spaceIds : spaceIds // ignore: cast_nullable_to_non_nullable
as Set<String>,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionGroupScopes].
extension TransactionGroupScopesPatterns on TransactionGroupScopes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionGroupScopes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionGroupScopes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionGroupScopes value)  $default,){
final _that = this;
switch (_that) {
case _TransactionGroupScopes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionGroupScopes value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionGroupScopes() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionGroupScopes implements TransactionGroupScopes {
  const _TransactionGroupScopes({required this.personal, required final  Set<String> spaceIds, this.groupId}): _spaceIds = spaceIds;
  

@override final  bool personal;
 final  Set<String> _spaceIds;
@override Set<String> get spaceIds {
  if (_spaceIds is EqualUnmodifiableSetView) return _spaceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_spaceIds);
}

@override final  String? groupId;

/// Create a copy of TransactionGroupScopes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionGroupScopesCopyWith<_TransactionGroupScopes> get copyWith => __$TransactionGroupScopesCopyWithImpl<_TransactionGroupScopes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionGroupScopes&&(identical(other.personal, personal) || other.personal == personal)&&const DeepCollectionEquality().equals(other._spaceIds, _spaceIds)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}


@override
int get hashCode => Object.hash(runtimeType,personal,const DeepCollectionEquality().hash(_spaceIds),groupId);

@override
String toString() {
  return 'TransactionGroupScopes(personal: $personal, spaceIds: $spaceIds, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class _$TransactionGroupScopesCopyWith<$Res> implements $TransactionGroupScopesCopyWith<$Res> {
  factory _$TransactionGroupScopesCopyWith(_TransactionGroupScopes value, $Res Function(_TransactionGroupScopes) _then) = __$TransactionGroupScopesCopyWithImpl;
@override @useResult
$Res call({
 bool personal, Set<String> spaceIds, String? groupId
});




}
/// @nodoc
class __$TransactionGroupScopesCopyWithImpl<$Res>
    implements _$TransactionGroupScopesCopyWith<$Res> {
  __$TransactionGroupScopesCopyWithImpl(this._self, this._then);

  final _TransactionGroupScopes _self;
  final $Res Function(_TransactionGroupScopes) _then;

/// Create a copy of TransactionGroupScopes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? personal = null,Object? spaceIds = null,Object? groupId = freezed,}) {
  return _then(_TransactionGroupScopes(
personal: null == personal ? _self.personal : personal // ignore: cast_nullable_to_non_nullable
as bool,spaceIds: null == spaceIds ? _self._spaceIds : spaceIds // ignore: cast_nullable_to_non_nullable
as Set<String>,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

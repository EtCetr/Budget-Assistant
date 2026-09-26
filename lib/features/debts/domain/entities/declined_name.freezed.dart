// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'declined_name.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeclinedName {

 String get original;/// Дательный падеж; при неудаче равен original.
 String get dative;/// false — правила не смогли просклонять (UI 6.3.14 предложит ручной ввод).
 bool get success;
/// Create a copy of DeclinedName
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeclinedNameCopyWith<DeclinedName> get copyWith => _$DeclinedNameCopyWithImpl<DeclinedName>(this as DeclinedName, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeclinedName&&(identical(other.original, original) || other.original == original)&&(identical(other.dative, dative) || other.dative == dative)&&(identical(other.success, success) || other.success == success));
}


@override
int get hashCode => Object.hash(runtimeType,original,dative,success);

@override
String toString() {
  return 'DeclinedName(original: $original, dative: $dative, success: $success)';
}


}

/// @nodoc
abstract mixin class $DeclinedNameCopyWith<$Res>  {
  factory $DeclinedNameCopyWith(DeclinedName value, $Res Function(DeclinedName) _then) = _$DeclinedNameCopyWithImpl;
@useResult
$Res call({
 String original, String dative, bool success
});




}
/// @nodoc
class _$DeclinedNameCopyWithImpl<$Res>
    implements $DeclinedNameCopyWith<$Res> {
  _$DeclinedNameCopyWithImpl(this._self, this._then);

  final DeclinedName _self;
  final $Res Function(DeclinedName) _then;

/// Create a copy of DeclinedName
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? dative = null,Object? success = null,}) {
  return _then(_self.copyWith(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,dative: null == dative ? _self.dative : dative // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeclinedName].
extension DeclinedNamePatterns on DeclinedName {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeclinedName value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeclinedName() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeclinedName value)  $default,){
final _that = this;
switch (_that) {
case _DeclinedName():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeclinedName value)?  $default,){
final _that = this;
switch (_that) {
case _DeclinedName() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _DeclinedName implements DeclinedName {
  const _DeclinedName({required this.original, required this.dative, required this.success});
  

@override final  String original;
/// Дательный падеж; при неудаче равен original.
@override final  String dative;
/// false — правила не смогли просклонять (UI 6.3.14 предложит ручной ввод).
@override final  bool success;

/// Create a copy of DeclinedName
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeclinedNameCopyWith<_DeclinedName> get copyWith => __$DeclinedNameCopyWithImpl<_DeclinedName>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeclinedName&&(identical(other.original, original) || other.original == original)&&(identical(other.dative, dative) || other.dative == dative)&&(identical(other.success, success) || other.success == success));
}


@override
int get hashCode => Object.hash(runtimeType,original,dative,success);

@override
String toString() {
  return 'DeclinedName(original: $original, dative: $dative, success: $success)';
}


}

/// @nodoc
abstract mixin class _$DeclinedNameCopyWith<$Res> implements $DeclinedNameCopyWith<$Res> {
  factory _$DeclinedNameCopyWith(_DeclinedName value, $Res Function(_DeclinedName) _then) = __$DeclinedNameCopyWithImpl;
@override @useResult
$Res call({
 String original, String dative, bool success
});




}
/// @nodoc
class __$DeclinedNameCopyWithImpl<$Res>
    implements _$DeclinedNameCopyWith<$Res> {
  __$DeclinedNameCopyWithImpl(this._self, this._then);

  final _DeclinedName _self;
  final $Res Function(_DeclinedName) _then;

/// Create a copy of DeclinedName
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? dative = null,Object? success = null,}) {
  return _then(_DeclinedName(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,dative: null == dative ? _self.dative : dative // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

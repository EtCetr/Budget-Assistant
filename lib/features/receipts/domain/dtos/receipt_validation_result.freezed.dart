// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_validation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptValidationResult {

 List<String> get errorCodes;
/// Create a copy of ReceiptValidationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptValidationResultCopyWith<ReceiptValidationResult> get copyWith => _$ReceiptValidationResultCopyWithImpl<ReceiptValidationResult>(this as ReceiptValidationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptValidationResult&&const DeepCollectionEquality().equals(other.errorCodes, errorCodes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(errorCodes));

@override
String toString() {
  return 'ReceiptValidationResult(errorCodes: $errorCodes)';
}


}

/// @nodoc
abstract mixin class $ReceiptValidationResultCopyWith<$Res>  {
  factory $ReceiptValidationResultCopyWith(ReceiptValidationResult value, $Res Function(ReceiptValidationResult) _then) = _$ReceiptValidationResultCopyWithImpl;
@useResult
$Res call({
 List<String> errorCodes
});




}
/// @nodoc
class _$ReceiptValidationResultCopyWithImpl<$Res>
    implements $ReceiptValidationResultCopyWith<$Res> {
  _$ReceiptValidationResultCopyWithImpl(this._self, this._then);

  final ReceiptValidationResult _self;
  final $Res Function(ReceiptValidationResult) _then;

/// Create a copy of ReceiptValidationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? errorCodes = null,}) {
  return _then(_self.copyWith(
errorCodes: null == errorCodes ? _self.errorCodes : errorCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptValidationResult].
extension ReceiptValidationResultPatterns on ReceiptValidationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptValidationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptValidationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptValidationResult value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptValidationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptValidationResult value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptValidationResult() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptValidationResult implements ReceiptValidationResult {
  const _ReceiptValidationResult({required final  List<String> errorCodes}): _errorCodes = errorCodes;
  

 final  List<String> _errorCodes;
@override List<String> get errorCodes {
  if (_errorCodes is EqualUnmodifiableListView) return _errorCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errorCodes);
}


/// Create a copy of ReceiptValidationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptValidationResultCopyWith<_ReceiptValidationResult> get copyWith => __$ReceiptValidationResultCopyWithImpl<_ReceiptValidationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptValidationResult&&const DeepCollectionEquality().equals(other._errorCodes, _errorCodes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_errorCodes));

@override
String toString() {
  return 'ReceiptValidationResult(errorCodes: $errorCodes)';
}


}

/// @nodoc
abstract mixin class _$ReceiptValidationResultCopyWith<$Res> implements $ReceiptValidationResultCopyWith<$Res> {
  factory _$ReceiptValidationResultCopyWith(_ReceiptValidationResult value, $Res Function(_ReceiptValidationResult) _then) = __$ReceiptValidationResultCopyWithImpl;
@override @useResult
$Res call({
 List<String> errorCodes
});




}
/// @nodoc
class __$ReceiptValidationResultCopyWithImpl<$Res>
    implements _$ReceiptValidationResultCopyWith<$Res> {
  __$ReceiptValidationResultCopyWithImpl(this._self, this._then);

  final _ReceiptValidationResult _self;
  final $Res Function(_ReceiptValidationResult) _then;

/// Create a copy of ReceiptValidationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? errorCodes = null,}) {
  return _then(_ReceiptValidationResult(
errorCodes: null == errorCodes ? _self._errorCodes : errorCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

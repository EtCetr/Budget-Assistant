// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'confirm_receipt_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConfirmReceiptResult {

 bool get success; List<String> get errorCodes;
/// Create a copy of ConfirmReceiptResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfirmReceiptResultCopyWith<ConfirmReceiptResult> get copyWith => _$ConfirmReceiptResultCopyWithImpl<ConfirmReceiptResult>(this as ConfirmReceiptResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfirmReceiptResult&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.errorCodes, errorCodes));
}


@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(errorCodes));

@override
String toString() {
  return 'ConfirmReceiptResult(success: $success, errorCodes: $errorCodes)';
}


}

/// @nodoc
abstract mixin class $ConfirmReceiptResultCopyWith<$Res>  {
  factory $ConfirmReceiptResultCopyWith(ConfirmReceiptResult value, $Res Function(ConfirmReceiptResult) _then) = _$ConfirmReceiptResultCopyWithImpl;
@useResult
$Res call({
 bool success, List<String> errorCodes
});




}
/// @nodoc
class _$ConfirmReceiptResultCopyWithImpl<$Res>
    implements $ConfirmReceiptResultCopyWith<$Res> {
  _$ConfirmReceiptResultCopyWithImpl(this._self, this._then);

  final ConfirmReceiptResult _self;
  final $Res Function(ConfirmReceiptResult) _then;

/// Create a copy of ConfirmReceiptResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? errorCodes = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,errorCodes: null == errorCodes ? _self.errorCodes : errorCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfirmReceiptResult].
extension ConfirmReceiptResultPatterns on ConfirmReceiptResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfirmReceiptResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfirmReceiptResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfirmReceiptResult value)  $default,){
final _that = this;
switch (_that) {
case _ConfirmReceiptResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfirmReceiptResult value)?  $default,){
final _that = this;
switch (_that) {
case _ConfirmReceiptResult() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ConfirmReceiptResult implements ConfirmReceiptResult {
  const _ConfirmReceiptResult({required this.success, final  List<String> errorCodes = const <String>[]}): _errorCodes = errorCodes;
  

@override final  bool success;
 final  List<String> _errorCodes;
@override@JsonKey() List<String> get errorCodes {
  if (_errorCodes is EqualUnmodifiableListView) return _errorCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errorCodes);
}


/// Create a copy of ConfirmReceiptResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfirmReceiptResultCopyWith<_ConfirmReceiptResult> get copyWith => __$ConfirmReceiptResultCopyWithImpl<_ConfirmReceiptResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmReceiptResult&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._errorCodes, _errorCodes));
}


@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_errorCodes));

@override
String toString() {
  return 'ConfirmReceiptResult(success: $success, errorCodes: $errorCodes)';
}


}

/// @nodoc
abstract mixin class _$ConfirmReceiptResultCopyWith<$Res> implements $ConfirmReceiptResultCopyWith<$Res> {
  factory _$ConfirmReceiptResultCopyWith(_ConfirmReceiptResult value, $Res Function(_ConfirmReceiptResult) _then) = __$ConfirmReceiptResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<String> errorCodes
});




}
/// @nodoc
class __$ConfirmReceiptResultCopyWithImpl<$Res>
    implements _$ConfirmReceiptResultCopyWith<$Res> {
  __$ConfirmReceiptResultCopyWithImpl(this._self, this._then);

  final _ConfirmReceiptResult _self;
  final $Res Function(_ConfirmReceiptResult) _then;

/// Create a copy of ConfirmReceiptResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? errorCodes = null,}) {
  return _then(_ConfirmReceiptResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,errorCodes: null == errorCodes ? _self._errorCodes : errorCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cashback_cycle_bounds.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashbackCycleBounds {

 DateTime get startUtc; DateTime get endUtc;
/// Create a copy of CashbackCycleBounds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashbackCycleBoundsCopyWith<CashbackCycleBounds> get copyWith => _$CashbackCycleBoundsCopyWithImpl<CashbackCycleBounds>(this as CashbackCycleBounds, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashbackCycleBounds&&(identical(other.startUtc, startUtc) || other.startUtc == startUtc)&&(identical(other.endUtc, endUtc) || other.endUtc == endUtc));
}


@override
int get hashCode => Object.hash(runtimeType,startUtc,endUtc);

@override
String toString() {
  return 'CashbackCycleBounds(startUtc: $startUtc, endUtc: $endUtc)';
}


}

/// @nodoc
abstract mixin class $CashbackCycleBoundsCopyWith<$Res>  {
  factory $CashbackCycleBoundsCopyWith(CashbackCycleBounds value, $Res Function(CashbackCycleBounds) _then) = _$CashbackCycleBoundsCopyWithImpl;
@useResult
$Res call({
 DateTime startUtc, DateTime endUtc
});




}
/// @nodoc
class _$CashbackCycleBoundsCopyWithImpl<$Res>
    implements $CashbackCycleBoundsCopyWith<$Res> {
  _$CashbackCycleBoundsCopyWithImpl(this._self, this._then);

  final CashbackCycleBounds _self;
  final $Res Function(CashbackCycleBounds) _then;

/// Create a copy of CashbackCycleBounds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startUtc = null,Object? endUtc = null,}) {
  return _then(_self.copyWith(
startUtc: null == startUtc ? _self.startUtc : startUtc // ignore: cast_nullable_to_non_nullable
as DateTime,endUtc: null == endUtc ? _self.endUtc : endUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CashbackCycleBounds].
extension CashbackCycleBoundsPatterns on CashbackCycleBounds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashbackCycleBounds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashbackCycleBounds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashbackCycleBounds value)  $default,){
final _that = this;
switch (_that) {
case _CashbackCycleBounds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashbackCycleBounds value)?  $default,){
final _that = this;
switch (_that) {
case _CashbackCycleBounds() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CashbackCycleBounds implements CashbackCycleBounds {
  const _CashbackCycleBounds({required this.startUtc, required this.endUtc});
  

@override final  DateTime startUtc;
@override final  DateTime endUtc;

/// Create a copy of CashbackCycleBounds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashbackCycleBoundsCopyWith<_CashbackCycleBounds> get copyWith => __$CashbackCycleBoundsCopyWithImpl<_CashbackCycleBounds>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashbackCycleBounds&&(identical(other.startUtc, startUtc) || other.startUtc == startUtc)&&(identical(other.endUtc, endUtc) || other.endUtc == endUtc));
}


@override
int get hashCode => Object.hash(runtimeType,startUtc,endUtc);

@override
String toString() {
  return 'CashbackCycleBounds(startUtc: $startUtc, endUtc: $endUtc)';
}


}

/// @nodoc
abstract mixin class _$CashbackCycleBoundsCopyWith<$Res> implements $CashbackCycleBoundsCopyWith<$Res> {
  factory _$CashbackCycleBoundsCopyWith(_CashbackCycleBounds value, $Res Function(_CashbackCycleBounds) _then) = __$CashbackCycleBoundsCopyWithImpl;
@override @useResult
$Res call({
 DateTime startUtc, DateTime endUtc
});




}
/// @nodoc
class __$CashbackCycleBoundsCopyWithImpl<$Res>
    implements _$CashbackCycleBoundsCopyWith<$Res> {
  __$CashbackCycleBoundsCopyWithImpl(this._self, this._then);

  final _CashbackCycleBounds _self;
  final $Res Function(_CashbackCycleBounds) _then;

/// Create a copy of CashbackCycleBounds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startUtc = null,Object? endUtc = null,}) {
  return _then(_CashbackCycleBounds(
startUtc: null == startUtc ? _self.startUtc : startUtc // ignore: cast_nullable_to_non_nullable
as DateTime,endUtc: null == endUtc ? _self.endUtc : endUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

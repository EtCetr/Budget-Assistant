// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debts_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DebtsStats {

 int get payableTotalKopecks; int get receivableTotalKopecks; int get overdueCount;
/// Create a copy of DebtsStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtsStatsCopyWith<DebtsStats> get copyWith => _$DebtsStatsCopyWithImpl<DebtsStats>(this as DebtsStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtsStats&&(identical(other.payableTotalKopecks, payableTotalKopecks) || other.payableTotalKopecks == payableTotalKopecks)&&(identical(other.receivableTotalKopecks, receivableTotalKopecks) || other.receivableTotalKopecks == receivableTotalKopecks)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount));
}


@override
int get hashCode => Object.hash(runtimeType,payableTotalKopecks,receivableTotalKopecks,overdueCount);

@override
String toString() {
  return 'DebtsStats(payableTotalKopecks: $payableTotalKopecks, receivableTotalKopecks: $receivableTotalKopecks, overdueCount: $overdueCount)';
}


}

/// @nodoc
abstract mixin class $DebtsStatsCopyWith<$Res>  {
  factory $DebtsStatsCopyWith(DebtsStats value, $Res Function(DebtsStats) _then) = _$DebtsStatsCopyWithImpl;
@useResult
$Res call({
 int payableTotalKopecks, int receivableTotalKopecks, int overdueCount
});




}
/// @nodoc
class _$DebtsStatsCopyWithImpl<$Res>
    implements $DebtsStatsCopyWith<$Res> {
  _$DebtsStatsCopyWithImpl(this._self, this._then);

  final DebtsStats _self;
  final $Res Function(DebtsStats) _then;

/// Create a copy of DebtsStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payableTotalKopecks = null,Object? receivableTotalKopecks = null,Object? overdueCount = null,}) {
  return _then(_self.copyWith(
payableTotalKopecks: null == payableTotalKopecks ? _self.payableTotalKopecks : payableTotalKopecks // ignore: cast_nullable_to_non_nullable
as int,receivableTotalKopecks: null == receivableTotalKopecks ? _self.receivableTotalKopecks : receivableTotalKopecks // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtsStats].
extension DebtsStatsPatterns on DebtsStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtsStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtsStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtsStats value)  $default,){
final _that = this;
switch (_that) {
case _DebtsStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtsStats value)?  $default,){
final _that = this;
switch (_that) {
case _DebtsStats() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _DebtsStats implements DebtsStats {
  const _DebtsStats({required this.payableTotalKopecks, required this.receivableTotalKopecks, required this.overdueCount});
  

@override final  int payableTotalKopecks;
@override final  int receivableTotalKopecks;
@override final  int overdueCount;

/// Create a copy of DebtsStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtsStatsCopyWith<_DebtsStats> get copyWith => __$DebtsStatsCopyWithImpl<_DebtsStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtsStats&&(identical(other.payableTotalKopecks, payableTotalKopecks) || other.payableTotalKopecks == payableTotalKopecks)&&(identical(other.receivableTotalKopecks, receivableTotalKopecks) || other.receivableTotalKopecks == receivableTotalKopecks)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount));
}


@override
int get hashCode => Object.hash(runtimeType,payableTotalKopecks,receivableTotalKopecks,overdueCount);

@override
String toString() {
  return 'DebtsStats(payableTotalKopecks: $payableTotalKopecks, receivableTotalKopecks: $receivableTotalKopecks, overdueCount: $overdueCount)';
}


}

/// @nodoc
abstract mixin class _$DebtsStatsCopyWith<$Res> implements $DebtsStatsCopyWith<$Res> {
  factory _$DebtsStatsCopyWith(_DebtsStats value, $Res Function(_DebtsStats) _then) = __$DebtsStatsCopyWithImpl;
@override @useResult
$Res call({
 int payableTotalKopecks, int receivableTotalKopecks, int overdueCount
});




}
/// @nodoc
class __$DebtsStatsCopyWithImpl<$Res>
    implements _$DebtsStatsCopyWith<$Res> {
  __$DebtsStatsCopyWithImpl(this._self, this._then);

  final _DebtsStats _self;
  final $Res Function(_DebtsStats) _then;

/// Create a copy of DebtsStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payableTotalKopecks = null,Object? receivableTotalKopecks = null,Object? overdueCount = null,}) {
  return _then(_DebtsStats(
payableTotalKopecks: null == payableTotalKopecks ? _self.payableTotalKopecks : payableTotalKopecks // ignore: cast_nullable_to_non_nullable
as int,receivableTotalKopecks: null == receivableTotalKopecks ? _self.receivableTotalKopecks : receivableTotalKopecks // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_pnl.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyPnl {

 int get year; int get month; int get totalIncome; int get totalExpense; int get savingsRate; int get transactionCount;
/// Create a copy of MonthlyPnl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyPnlCopyWith<MonthlyPnl> get copyWith => _$MonthlyPnlCopyWithImpl<MonthlyPnl>(this as MonthlyPnl, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyPnl&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,totalIncome,totalExpense,savingsRate,transactionCount);

@override
String toString() {
  return 'MonthlyPnl(year: $year, month: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, savingsRate: $savingsRate, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class $MonthlyPnlCopyWith<$Res>  {
  factory $MonthlyPnlCopyWith(MonthlyPnl value, $Res Function(MonthlyPnl) _then) = _$MonthlyPnlCopyWithImpl;
@useResult
$Res call({
 int year, int month, int totalIncome, int totalExpense, int savingsRate, int transactionCount
});




}
/// @nodoc
class _$MonthlyPnlCopyWithImpl<$Res>
    implements $MonthlyPnlCopyWith<$Res> {
  _$MonthlyPnlCopyWithImpl(this._self, this._then);

  final MonthlyPnl _self;
  final $Res Function(MonthlyPnl) _then;

/// Create a copy of MonthlyPnl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? totalIncome = null,Object? totalExpense = null,Object? savingsRate = null,Object? transactionCount = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as int,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyPnl].
extension MonthlyPnlPatterns on MonthlyPnl {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyPnl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyPnl() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyPnl value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyPnl():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyPnl value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyPnl() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyPnl implements MonthlyPnl {
  const _MonthlyPnl({required this.year, required this.month, required this.totalIncome, required this.totalExpense, required this.savingsRate, required this.transactionCount});
  

@override final  int year;
@override final  int month;
@override final  int totalIncome;
@override final  int totalExpense;
@override final  int savingsRate;
@override final  int transactionCount;

/// Create a copy of MonthlyPnl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyPnlCopyWith<_MonthlyPnl> get copyWith => __$MonthlyPnlCopyWithImpl<_MonthlyPnl>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyPnl&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,totalIncome,totalExpense,savingsRate,transactionCount);

@override
String toString() {
  return 'MonthlyPnl(year: $year, month: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, savingsRate: $savingsRate, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class _$MonthlyPnlCopyWith<$Res> implements $MonthlyPnlCopyWith<$Res> {
  factory _$MonthlyPnlCopyWith(_MonthlyPnl value, $Res Function(_MonthlyPnl) _then) = __$MonthlyPnlCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, int totalIncome, int totalExpense, int savingsRate, int transactionCount
});




}
/// @nodoc
class __$MonthlyPnlCopyWithImpl<$Res>
    implements _$MonthlyPnlCopyWith<$Res> {
  __$MonthlyPnlCopyWithImpl(this._self, this._then);

  final _MonthlyPnl _self;
  final $Res Function(_MonthlyPnl) _then;

/// Create a copy of MonthlyPnl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? totalIncome = null,Object? totalExpense = null,Object? savingsRate = null,Object? transactionCount = null,}) {
  return _then(_MonthlyPnl(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as int,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

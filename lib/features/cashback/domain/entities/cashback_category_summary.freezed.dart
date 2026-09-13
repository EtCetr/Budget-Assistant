// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cashback_category_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashbackCategorySummary {

 String get entryId; String get accountId; String? get categoryId; String get categoryName; int get percentBps; String get lifetimeType; DateTime get cycleStartUtc; DateTime get cycleEndUtc; int get grossExpenseKopecks; int get refundKopecks; int get netExpenseKopecks; int get cashbackKopecks; String get currency;
/// Create a copy of CashbackCategorySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashbackCategorySummaryCopyWith<CashbackCategorySummary> get copyWith => _$CashbackCategorySummaryCopyWithImpl<CashbackCategorySummary>(this as CashbackCategorySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashbackCategorySummary&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps)&&(identical(other.lifetimeType, lifetimeType) || other.lifetimeType == lifetimeType)&&(identical(other.cycleStartUtc, cycleStartUtc) || other.cycleStartUtc == cycleStartUtc)&&(identical(other.cycleEndUtc, cycleEndUtc) || other.cycleEndUtc == cycleEndUtc)&&(identical(other.grossExpenseKopecks, grossExpenseKopecks) || other.grossExpenseKopecks == grossExpenseKopecks)&&(identical(other.refundKopecks, refundKopecks) || other.refundKopecks == refundKopecks)&&(identical(other.netExpenseKopecks, netExpenseKopecks) || other.netExpenseKopecks == netExpenseKopecks)&&(identical(other.cashbackKopecks, cashbackKopecks) || other.cashbackKopecks == cashbackKopecks)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,entryId,accountId,categoryId,categoryName,percentBps,lifetimeType,cycleStartUtc,cycleEndUtc,grossExpenseKopecks,refundKopecks,netExpenseKopecks,cashbackKopecks,currency);

@override
String toString() {
  return 'CashbackCategorySummary(entryId: $entryId, accountId: $accountId, categoryId: $categoryId, categoryName: $categoryName, percentBps: $percentBps, lifetimeType: $lifetimeType, cycleStartUtc: $cycleStartUtc, cycleEndUtc: $cycleEndUtc, grossExpenseKopecks: $grossExpenseKopecks, refundKopecks: $refundKopecks, netExpenseKopecks: $netExpenseKopecks, cashbackKopecks: $cashbackKopecks, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $CashbackCategorySummaryCopyWith<$Res>  {
  factory $CashbackCategorySummaryCopyWith(CashbackCategorySummary value, $Res Function(CashbackCategorySummary) _then) = _$CashbackCategorySummaryCopyWithImpl;
@useResult
$Res call({
 String entryId, String accountId, String? categoryId, String categoryName, int percentBps, String lifetimeType, DateTime cycleStartUtc, DateTime cycleEndUtc, int grossExpenseKopecks, int refundKopecks, int netExpenseKopecks, int cashbackKopecks, String currency
});




}
/// @nodoc
class _$CashbackCategorySummaryCopyWithImpl<$Res>
    implements $CashbackCategorySummaryCopyWith<$Res> {
  _$CashbackCategorySummaryCopyWithImpl(this._self, this._then);

  final CashbackCategorySummary _self;
  final $Res Function(CashbackCategorySummary) _then;

/// Create a copy of CashbackCategorySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryId = null,Object? accountId = null,Object? categoryId = freezed,Object? categoryName = null,Object? percentBps = null,Object? lifetimeType = null,Object? cycleStartUtc = null,Object? cycleEndUtc = null,Object? grossExpenseKopecks = null,Object? refundKopecks = null,Object? netExpenseKopecks = null,Object? cashbackKopecks = null,Object? currency = null,}) {
  return _then(_self.copyWith(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,percentBps: null == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int,lifetimeType: null == lifetimeType ? _self.lifetimeType : lifetimeType // ignore: cast_nullable_to_non_nullable
as String,cycleStartUtc: null == cycleStartUtc ? _self.cycleStartUtc : cycleStartUtc // ignore: cast_nullable_to_non_nullable
as DateTime,cycleEndUtc: null == cycleEndUtc ? _self.cycleEndUtc : cycleEndUtc // ignore: cast_nullable_to_non_nullable
as DateTime,grossExpenseKopecks: null == grossExpenseKopecks ? _self.grossExpenseKopecks : grossExpenseKopecks // ignore: cast_nullable_to_non_nullable
as int,refundKopecks: null == refundKopecks ? _self.refundKopecks : refundKopecks // ignore: cast_nullable_to_non_nullable
as int,netExpenseKopecks: null == netExpenseKopecks ? _self.netExpenseKopecks : netExpenseKopecks // ignore: cast_nullable_to_non_nullable
as int,cashbackKopecks: null == cashbackKopecks ? _self.cashbackKopecks : cashbackKopecks // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CashbackCategorySummary].
extension CashbackCategorySummaryPatterns on CashbackCategorySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashbackCategorySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashbackCategorySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashbackCategorySummary value)  $default,){
final _that = this;
switch (_that) {
case _CashbackCategorySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashbackCategorySummary value)?  $default,){
final _that = this;
switch (_that) {
case _CashbackCategorySummary() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CashbackCategorySummary implements CashbackCategorySummary {
  const _CashbackCategorySummary({required this.entryId, required this.accountId, this.categoryId, required this.categoryName, required this.percentBps, required this.lifetimeType, required this.cycleStartUtc, required this.cycleEndUtc, required this.grossExpenseKopecks, required this.refundKopecks, required this.netExpenseKopecks, required this.cashbackKopecks, required this.currency});
  

@override final  String entryId;
@override final  String accountId;
@override final  String? categoryId;
@override final  String categoryName;
@override final  int percentBps;
@override final  String lifetimeType;
@override final  DateTime cycleStartUtc;
@override final  DateTime cycleEndUtc;
@override final  int grossExpenseKopecks;
@override final  int refundKopecks;
@override final  int netExpenseKopecks;
@override final  int cashbackKopecks;
@override final  String currency;

/// Create a copy of CashbackCategorySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashbackCategorySummaryCopyWith<_CashbackCategorySummary> get copyWith => __$CashbackCategorySummaryCopyWithImpl<_CashbackCategorySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashbackCategorySummary&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps)&&(identical(other.lifetimeType, lifetimeType) || other.lifetimeType == lifetimeType)&&(identical(other.cycleStartUtc, cycleStartUtc) || other.cycleStartUtc == cycleStartUtc)&&(identical(other.cycleEndUtc, cycleEndUtc) || other.cycleEndUtc == cycleEndUtc)&&(identical(other.grossExpenseKopecks, grossExpenseKopecks) || other.grossExpenseKopecks == grossExpenseKopecks)&&(identical(other.refundKopecks, refundKopecks) || other.refundKopecks == refundKopecks)&&(identical(other.netExpenseKopecks, netExpenseKopecks) || other.netExpenseKopecks == netExpenseKopecks)&&(identical(other.cashbackKopecks, cashbackKopecks) || other.cashbackKopecks == cashbackKopecks)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,entryId,accountId,categoryId,categoryName,percentBps,lifetimeType,cycleStartUtc,cycleEndUtc,grossExpenseKopecks,refundKopecks,netExpenseKopecks,cashbackKopecks,currency);

@override
String toString() {
  return 'CashbackCategorySummary(entryId: $entryId, accountId: $accountId, categoryId: $categoryId, categoryName: $categoryName, percentBps: $percentBps, lifetimeType: $lifetimeType, cycleStartUtc: $cycleStartUtc, cycleEndUtc: $cycleEndUtc, grossExpenseKopecks: $grossExpenseKopecks, refundKopecks: $refundKopecks, netExpenseKopecks: $netExpenseKopecks, cashbackKopecks: $cashbackKopecks, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$CashbackCategorySummaryCopyWith<$Res> implements $CashbackCategorySummaryCopyWith<$Res> {
  factory _$CashbackCategorySummaryCopyWith(_CashbackCategorySummary value, $Res Function(_CashbackCategorySummary) _then) = __$CashbackCategorySummaryCopyWithImpl;
@override @useResult
$Res call({
 String entryId, String accountId, String? categoryId, String categoryName, int percentBps, String lifetimeType, DateTime cycleStartUtc, DateTime cycleEndUtc, int grossExpenseKopecks, int refundKopecks, int netExpenseKopecks, int cashbackKopecks, String currency
});




}
/// @nodoc
class __$CashbackCategorySummaryCopyWithImpl<$Res>
    implements _$CashbackCategorySummaryCopyWith<$Res> {
  __$CashbackCategorySummaryCopyWithImpl(this._self, this._then);

  final _CashbackCategorySummary _self;
  final $Res Function(_CashbackCategorySummary) _then;

/// Create a copy of CashbackCategorySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryId = null,Object? accountId = null,Object? categoryId = freezed,Object? categoryName = null,Object? percentBps = null,Object? lifetimeType = null,Object? cycleStartUtc = null,Object? cycleEndUtc = null,Object? grossExpenseKopecks = null,Object? refundKopecks = null,Object? netExpenseKopecks = null,Object? cashbackKopecks = null,Object? currency = null,}) {
  return _then(_CashbackCategorySummary(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,percentBps: null == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int,lifetimeType: null == lifetimeType ? _self.lifetimeType : lifetimeType // ignore: cast_nullable_to_non_nullable
as String,cycleStartUtc: null == cycleStartUtc ? _self.cycleStartUtc : cycleStartUtc // ignore: cast_nullable_to_non_nullable
as DateTime,cycleEndUtc: null == cycleEndUtc ? _self.cycleEndUtc : cycleEndUtc // ignore: cast_nullable_to_non_nullable
as DateTime,grossExpenseKopecks: null == grossExpenseKopecks ? _self.grossExpenseKopecks : grossExpenseKopecks // ignore: cast_nullable_to_non_nullable
as int,refundKopecks: null == refundKopecks ? _self.refundKopecks : refundKopecks // ignore: cast_nullable_to_non_nullable
as int,netExpenseKopecks: null == netExpenseKopecks ? _self.netExpenseKopecks : netExpenseKopecks // ignore: cast_nullable_to_non_nullable
as int,cashbackKopecks: null == cashbackKopecks ? _self.cashbackKopecks : cashbackKopecks // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

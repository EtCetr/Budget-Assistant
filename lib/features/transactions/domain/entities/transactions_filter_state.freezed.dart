// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionsFilterState {

 TransactionsScope get scope; TransactionTypeFilter get type; List<String> get categoryIds; List<String> get accountIds; TransactionsPeriodPreset get period; DateTime? get customFrom; DateTime? get customTo; int? get amountFromKopecks; int? get amountToKopecks; bool get onlyWithReceipt; bool get onlySplit; bool get onlyDebts; bool get excludeOwn; String get search;
/// Create a copy of TransactionsFilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionsFilterStateCopyWith<TransactionsFilterState> get copyWith => _$TransactionsFilterStateCopyWithImpl<TransactionsFilterState>(this as TransactionsFilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsFilterState&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.categoryIds, categoryIds)&&const DeepCollectionEquality().equals(other.accountIds, accountIds)&&(identical(other.period, period) || other.period == period)&&(identical(other.customFrom, customFrom) || other.customFrom == customFrom)&&(identical(other.customTo, customTo) || other.customTo == customTo)&&(identical(other.amountFromKopecks, amountFromKopecks) || other.amountFromKopecks == amountFromKopecks)&&(identical(other.amountToKopecks, amountToKopecks) || other.amountToKopecks == amountToKopecks)&&(identical(other.onlyWithReceipt, onlyWithReceipt) || other.onlyWithReceipt == onlyWithReceipt)&&(identical(other.onlySplit, onlySplit) || other.onlySplit == onlySplit)&&(identical(other.onlyDebts, onlyDebts) || other.onlyDebts == onlyDebts)&&(identical(other.excludeOwn, excludeOwn) || other.excludeOwn == excludeOwn)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,scope,type,const DeepCollectionEquality().hash(categoryIds),const DeepCollectionEquality().hash(accountIds),period,customFrom,customTo,amountFromKopecks,amountToKopecks,onlyWithReceipt,onlySplit,onlyDebts,excludeOwn,search);

@override
String toString() {
  return 'TransactionsFilterState(scope: $scope, type: $type, categoryIds: $categoryIds, accountIds: $accountIds, period: $period, customFrom: $customFrom, customTo: $customTo, amountFromKopecks: $amountFromKopecks, amountToKopecks: $amountToKopecks, onlyWithReceipt: $onlyWithReceipt, onlySplit: $onlySplit, onlyDebts: $onlyDebts, excludeOwn: $excludeOwn, search: $search)';
}


}

/// @nodoc
abstract mixin class $TransactionsFilterStateCopyWith<$Res>  {
  factory $TransactionsFilterStateCopyWith(TransactionsFilterState value, $Res Function(TransactionsFilterState) _then) = _$TransactionsFilterStateCopyWithImpl;
@useResult
$Res call({
 TransactionsScope scope, TransactionTypeFilter type, List<String> categoryIds, List<String> accountIds, TransactionsPeriodPreset period, DateTime? customFrom, DateTime? customTo, int? amountFromKopecks, int? amountToKopecks, bool onlyWithReceipt, bool onlySplit, bool onlyDebts, bool excludeOwn, String search
});




}
/// @nodoc
class _$TransactionsFilterStateCopyWithImpl<$Res>
    implements $TransactionsFilterStateCopyWith<$Res> {
  _$TransactionsFilterStateCopyWithImpl(this._self, this._then);

  final TransactionsFilterState _self;
  final $Res Function(TransactionsFilterState) _then;

/// Create a copy of TransactionsFilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = null,Object? type = null,Object? categoryIds = null,Object? accountIds = null,Object? period = null,Object? customFrom = freezed,Object? customTo = freezed,Object? amountFromKopecks = freezed,Object? amountToKopecks = freezed,Object? onlyWithReceipt = null,Object? onlySplit = null,Object? onlyDebts = null,Object? excludeOwn = null,Object? search = null,}) {
  return _then(_self.copyWith(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as TransactionsScope,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionTypeFilter,categoryIds: null == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,accountIds: null == accountIds ? _self.accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<String>,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as TransactionsPeriodPreset,customFrom: freezed == customFrom ? _self.customFrom : customFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,customTo: freezed == customTo ? _self.customTo : customTo // ignore: cast_nullable_to_non_nullable
as DateTime?,amountFromKopecks: freezed == amountFromKopecks ? _self.amountFromKopecks : amountFromKopecks // ignore: cast_nullable_to_non_nullable
as int?,amountToKopecks: freezed == amountToKopecks ? _self.amountToKopecks : amountToKopecks // ignore: cast_nullable_to_non_nullable
as int?,onlyWithReceipt: null == onlyWithReceipt ? _self.onlyWithReceipt : onlyWithReceipt // ignore: cast_nullable_to_non_nullable
as bool,onlySplit: null == onlySplit ? _self.onlySplit : onlySplit // ignore: cast_nullable_to_non_nullable
as bool,onlyDebts: null == onlyDebts ? _self.onlyDebts : onlyDebts // ignore: cast_nullable_to_non_nullable
as bool,excludeOwn: null == excludeOwn ? _self.excludeOwn : excludeOwn // ignore: cast_nullable_to_non_nullable
as bool,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionsFilterState].
extension TransactionsFilterStatePatterns on TransactionsFilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionsFilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionsFilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionsFilterState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionsFilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionsFilterState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionsFilterState() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionsFilterState implements TransactionsFilterState {
  const _TransactionsFilterState({this.scope = TransactionsScope.all, this.type = TransactionTypeFilter.all, final  List<String> categoryIds = const <String>[], final  List<String> accountIds = const <String>[], this.period = TransactionsPeriodPreset.all, this.customFrom, this.customTo, this.amountFromKopecks, this.amountToKopecks, this.onlyWithReceipt = false, this.onlySplit = false, this.onlyDebts = false, this.excludeOwn = false, this.search = ''}): _categoryIds = categoryIds,_accountIds = accountIds;
  

@override@JsonKey() final  TransactionsScope scope;
@override@JsonKey() final  TransactionTypeFilter type;
 final  List<String> _categoryIds;
@override@JsonKey() List<String> get categoryIds {
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryIds);
}

 final  List<String> _accountIds;
@override@JsonKey() List<String> get accountIds {
  if (_accountIds is EqualUnmodifiableListView) return _accountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accountIds);
}

@override@JsonKey() final  TransactionsPeriodPreset period;
@override final  DateTime? customFrom;
@override final  DateTime? customTo;
@override final  int? amountFromKopecks;
@override final  int? amountToKopecks;
@override@JsonKey() final  bool onlyWithReceipt;
@override@JsonKey() final  bool onlySplit;
@override@JsonKey() final  bool onlyDebts;
@override@JsonKey() final  bool excludeOwn;
@override@JsonKey() final  String search;

/// Create a copy of TransactionsFilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsFilterStateCopyWith<_TransactionsFilterState> get copyWith => __$TransactionsFilterStateCopyWithImpl<_TransactionsFilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsFilterState&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._categoryIds, _categoryIds)&&const DeepCollectionEquality().equals(other._accountIds, _accountIds)&&(identical(other.period, period) || other.period == period)&&(identical(other.customFrom, customFrom) || other.customFrom == customFrom)&&(identical(other.customTo, customTo) || other.customTo == customTo)&&(identical(other.amountFromKopecks, amountFromKopecks) || other.amountFromKopecks == amountFromKopecks)&&(identical(other.amountToKopecks, amountToKopecks) || other.amountToKopecks == amountToKopecks)&&(identical(other.onlyWithReceipt, onlyWithReceipt) || other.onlyWithReceipt == onlyWithReceipt)&&(identical(other.onlySplit, onlySplit) || other.onlySplit == onlySplit)&&(identical(other.onlyDebts, onlyDebts) || other.onlyDebts == onlyDebts)&&(identical(other.excludeOwn, excludeOwn) || other.excludeOwn == excludeOwn)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,scope,type,const DeepCollectionEquality().hash(_categoryIds),const DeepCollectionEquality().hash(_accountIds),period,customFrom,customTo,amountFromKopecks,amountToKopecks,onlyWithReceipt,onlySplit,onlyDebts,excludeOwn,search);

@override
String toString() {
  return 'TransactionsFilterState(scope: $scope, type: $type, categoryIds: $categoryIds, accountIds: $accountIds, period: $period, customFrom: $customFrom, customTo: $customTo, amountFromKopecks: $amountFromKopecks, amountToKopecks: $amountToKopecks, onlyWithReceipt: $onlyWithReceipt, onlySplit: $onlySplit, onlyDebts: $onlyDebts, excludeOwn: $excludeOwn, search: $search)';
}


}

/// @nodoc
abstract mixin class _$TransactionsFilterStateCopyWith<$Res> implements $TransactionsFilterStateCopyWith<$Res> {
  factory _$TransactionsFilterStateCopyWith(_TransactionsFilterState value, $Res Function(_TransactionsFilterState) _then) = __$TransactionsFilterStateCopyWithImpl;
@override @useResult
$Res call({
 TransactionsScope scope, TransactionTypeFilter type, List<String> categoryIds, List<String> accountIds, TransactionsPeriodPreset period, DateTime? customFrom, DateTime? customTo, int? amountFromKopecks, int? amountToKopecks, bool onlyWithReceipt, bool onlySplit, bool onlyDebts, bool excludeOwn, String search
});




}
/// @nodoc
class __$TransactionsFilterStateCopyWithImpl<$Res>
    implements _$TransactionsFilterStateCopyWith<$Res> {
  __$TransactionsFilterStateCopyWithImpl(this._self, this._then);

  final _TransactionsFilterState _self;
  final $Res Function(_TransactionsFilterState) _then;

/// Create a copy of TransactionsFilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = null,Object? type = null,Object? categoryIds = null,Object? accountIds = null,Object? period = null,Object? customFrom = freezed,Object? customTo = freezed,Object? amountFromKopecks = freezed,Object? amountToKopecks = freezed,Object? onlyWithReceipt = null,Object? onlySplit = null,Object? onlyDebts = null,Object? excludeOwn = null,Object? search = null,}) {
  return _then(_TransactionsFilterState(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as TransactionsScope,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionTypeFilter,categoryIds: null == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,accountIds: null == accountIds ? _self._accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<String>,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as TransactionsPeriodPreset,customFrom: freezed == customFrom ? _self.customFrom : customFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,customTo: freezed == customTo ? _self.customTo : customTo // ignore: cast_nullable_to_non_nullable
as DateTime?,amountFromKopecks: freezed == amountFromKopecks ? _self.amountFromKopecks : amountFromKopecks // ignore: cast_nullable_to_non_nullable
as int?,amountToKopecks: freezed == amountToKopecks ? _self.amountToKopecks : amountToKopecks // ignore: cast_nullable_to_non_nullable
as int?,onlyWithReceipt: null == onlyWithReceipt ? _self.onlyWithReceipt : onlyWithReceipt // ignore: cast_nullable_to_non_nullable
as bool,onlySplit: null == onlySplit ? _self.onlySplit : onlySplit // ignore: cast_nullable_to_non_nullable
as bool,onlyDebts: null == onlyDebts ? _self.onlyDebts : onlyDebts // ignore: cast_nullable_to_non_nullable
as bool,excludeOwn: null == excludeOwn ? _self.excludeOwn : excludeOwn // ignore: cast_nullable_to_non_nullable
as bool,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

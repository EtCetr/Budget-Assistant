// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_day_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DaySummaryUi {

 int get spentKopecks; int get incomeKopecks; int get operationsCount;
/// Create a copy of DaySummaryUi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DaySummaryUiCopyWith<DaySummaryUi> get copyWith => _$DaySummaryUiCopyWithImpl<DaySummaryUi>(this as DaySummaryUi, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaySummaryUi&&(identical(other.spentKopecks, spentKopecks) || other.spentKopecks == spentKopecks)&&(identical(other.incomeKopecks, incomeKopecks) || other.incomeKopecks == incomeKopecks)&&(identical(other.operationsCount, operationsCount) || other.operationsCount == operationsCount));
}


@override
int get hashCode => Object.hash(runtimeType,spentKopecks,incomeKopecks,operationsCount);

@override
String toString() {
  return 'DaySummaryUi(spentKopecks: $spentKopecks, incomeKopecks: $incomeKopecks, operationsCount: $operationsCount)';
}


}

/// @nodoc
abstract mixin class $DaySummaryUiCopyWith<$Res>  {
  factory $DaySummaryUiCopyWith(DaySummaryUi value, $Res Function(DaySummaryUi) _then) = _$DaySummaryUiCopyWithImpl;
@useResult
$Res call({
 int spentKopecks, int incomeKopecks, int operationsCount
});




}
/// @nodoc
class _$DaySummaryUiCopyWithImpl<$Res>
    implements $DaySummaryUiCopyWith<$Res> {
  _$DaySummaryUiCopyWithImpl(this._self, this._then);

  final DaySummaryUi _self;
  final $Res Function(DaySummaryUi) _then;

/// Create a copy of DaySummaryUi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spentKopecks = null,Object? incomeKopecks = null,Object? operationsCount = null,}) {
  return _then(_self.copyWith(
spentKopecks: null == spentKopecks ? _self.spentKopecks : spentKopecks // ignore: cast_nullable_to_non_nullable
as int,incomeKopecks: null == incomeKopecks ? _self.incomeKopecks : incomeKopecks // ignore: cast_nullable_to_non_nullable
as int,operationsCount: null == operationsCount ? _self.operationsCount : operationsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DaySummaryUi].
extension DaySummaryUiPatterns on DaySummaryUi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DaySummaryUi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DaySummaryUi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DaySummaryUi value)  $default,){
final _that = this;
switch (_that) {
case _DaySummaryUi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DaySummaryUi value)?  $default,){
final _that = this;
switch (_that) {
case _DaySummaryUi() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _DaySummaryUi implements DaySummaryUi {
  const _DaySummaryUi({required this.spentKopecks, required this.incomeKopecks, required this.operationsCount});
  

@override final  int spentKopecks;
@override final  int incomeKopecks;
@override final  int operationsCount;

/// Create a copy of DaySummaryUi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DaySummaryUiCopyWith<_DaySummaryUi> get copyWith => __$DaySummaryUiCopyWithImpl<_DaySummaryUi>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DaySummaryUi&&(identical(other.spentKopecks, spentKopecks) || other.spentKopecks == spentKopecks)&&(identical(other.incomeKopecks, incomeKopecks) || other.incomeKopecks == incomeKopecks)&&(identical(other.operationsCount, operationsCount) || other.operationsCount == operationsCount));
}


@override
int get hashCode => Object.hash(runtimeType,spentKopecks,incomeKopecks,operationsCount);

@override
String toString() {
  return 'DaySummaryUi(spentKopecks: $spentKopecks, incomeKopecks: $incomeKopecks, operationsCount: $operationsCount)';
}


}

/// @nodoc
abstract mixin class _$DaySummaryUiCopyWith<$Res> implements $DaySummaryUiCopyWith<$Res> {
  factory _$DaySummaryUiCopyWith(_DaySummaryUi value, $Res Function(_DaySummaryUi) _then) = __$DaySummaryUiCopyWithImpl;
@override @useResult
$Res call({
 int spentKopecks, int incomeKopecks, int operationsCount
});




}
/// @nodoc
class __$DaySummaryUiCopyWithImpl<$Res>
    implements _$DaySummaryUiCopyWith<$Res> {
  __$DaySummaryUiCopyWithImpl(this._self, this._then);

  final _DaySummaryUi _self;
  final $Res Function(_DaySummaryUi) _then;

/// Create a copy of DaySummaryUi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spentKopecks = null,Object? incomeKopecks = null,Object? operationsCount = null,}) {
  return _then(_DaySummaryUi(
spentKopecks: null == spentKopecks ? _self.spentKopecks : spentKopecks // ignore: cast_nullable_to_non_nullable
as int,incomeKopecks: null == incomeKopecks ? _self.incomeKopecks : incomeKopecks // ignore: cast_nullable_to_non_nullable
as int,operationsCount: null == operationsCount ? _self.operationsCount : operationsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TransactionDayGroupUi {

 DateTime get day; String get title; DaySummaryUi get summary; List<TransactionUiModel> get transactions;
/// Create a copy of TransactionDayGroupUi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDayGroupUiCopyWith<TransactionDayGroupUi> get copyWith => _$TransactionDayGroupUiCopyWithImpl<TransactionDayGroupUi>(this as TransactionDayGroupUi, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDayGroupUi&&(identical(other.day, day) || other.day == day)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.transactions, transactions));
}


@override
int get hashCode => Object.hash(runtimeType,day,title,summary,const DeepCollectionEquality().hash(transactions));

@override
String toString() {
  return 'TransactionDayGroupUi(day: $day, title: $title, summary: $summary, transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class $TransactionDayGroupUiCopyWith<$Res>  {
  factory $TransactionDayGroupUiCopyWith(TransactionDayGroupUi value, $Res Function(TransactionDayGroupUi) _then) = _$TransactionDayGroupUiCopyWithImpl;
@useResult
$Res call({
 DateTime day, String title, DaySummaryUi summary, List<TransactionUiModel> transactions
});


$DaySummaryUiCopyWith<$Res> get summary;

}
/// @nodoc
class _$TransactionDayGroupUiCopyWithImpl<$Res>
    implements $TransactionDayGroupUiCopyWith<$Res> {
  _$TransactionDayGroupUiCopyWithImpl(this._self, this._then);

  final TransactionDayGroupUi _self;
  final $Res Function(TransactionDayGroupUi) _then;

/// Create a copy of TransactionDayGroupUi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? title = null,Object? summary = null,Object? transactions = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DaySummaryUi,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionUiModel>,
  ));
}
/// Create a copy of TransactionDayGroupUi
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DaySummaryUiCopyWith<$Res> get summary {
  
  return $DaySummaryUiCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionDayGroupUi].
extension TransactionDayGroupUiPatterns on TransactionDayGroupUi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionDayGroupUi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionDayGroupUi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionDayGroupUi value)  $default,){
final _that = this;
switch (_that) {
case _TransactionDayGroupUi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionDayGroupUi value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionDayGroupUi() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionDayGroupUi implements TransactionDayGroupUi {
  const _TransactionDayGroupUi({required this.day, required this.title, required this.summary, required final  List<TransactionUiModel> transactions}): _transactions = transactions;
  

@override final  DateTime day;
@override final  String title;
@override final  DaySummaryUi summary;
 final  List<TransactionUiModel> _transactions;
@override List<TransactionUiModel> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of TransactionDayGroupUi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDayGroupUiCopyWith<_TransactionDayGroupUi> get copyWith => __$TransactionDayGroupUiCopyWithImpl<_TransactionDayGroupUi>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDayGroupUi&&(identical(other.day, day) || other.day == day)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._transactions, _transactions));
}


@override
int get hashCode => Object.hash(runtimeType,day,title,summary,const DeepCollectionEquality().hash(_transactions));

@override
String toString() {
  return 'TransactionDayGroupUi(day: $day, title: $title, summary: $summary, transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$TransactionDayGroupUiCopyWith<$Res> implements $TransactionDayGroupUiCopyWith<$Res> {
  factory _$TransactionDayGroupUiCopyWith(_TransactionDayGroupUi value, $Res Function(_TransactionDayGroupUi) _then) = __$TransactionDayGroupUiCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, String title, DaySummaryUi summary, List<TransactionUiModel> transactions
});


@override $DaySummaryUiCopyWith<$Res> get summary;

}
/// @nodoc
class __$TransactionDayGroupUiCopyWithImpl<$Res>
    implements _$TransactionDayGroupUiCopyWith<$Res> {
  __$TransactionDayGroupUiCopyWithImpl(this._self, this._then);

  final _TransactionDayGroupUi _self;
  final $Res Function(_TransactionDayGroupUi) _then;

/// Create a copy of TransactionDayGroupUi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? title = null,Object? summary = null,Object? transactions = null,}) {
  return _then(_TransactionDayGroupUi(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DaySummaryUi,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionUiModel>,
  ));
}

/// Create a copy of TransactionDayGroupUi
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DaySummaryUiCopyWith<$Res> get summary {
  
  return $DaySummaryUiCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc
mixin _$TransactionPageUi {

 List<TransactionUiModel> get items; bool get hasMore;
/// Create a copy of TransactionPageUi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionPageUiCopyWith<TransactionPageUi> get copyWith => _$TransactionPageUiCopyWithImpl<TransactionPageUi>(this as TransactionPageUi, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionPageUi&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),hasMore);

@override
String toString() {
  return 'TransactionPageUi(items: $items, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $TransactionPageUiCopyWith<$Res>  {
  factory $TransactionPageUiCopyWith(TransactionPageUi value, $Res Function(TransactionPageUi) _then) = _$TransactionPageUiCopyWithImpl;
@useResult
$Res call({
 List<TransactionUiModel> items, bool hasMore
});




}
/// @nodoc
class _$TransactionPageUiCopyWithImpl<$Res>
    implements $TransactionPageUiCopyWith<$Res> {
  _$TransactionPageUiCopyWithImpl(this._self, this._then);

  final TransactionPageUi _self;
  final $Res Function(TransactionPageUi) _then;

/// Create a copy of TransactionPageUi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasMore = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionUiModel>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionPageUi].
extension TransactionPageUiPatterns on TransactionPageUi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionPageUi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionPageUi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionPageUi value)  $default,){
final _that = this;
switch (_that) {
case _TransactionPageUi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionPageUi value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionPageUi() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionPageUi implements TransactionPageUi {
  const _TransactionPageUi({required final  List<TransactionUiModel> items, required this.hasMore}): _items = items;
  

 final  List<TransactionUiModel> _items;
@override List<TransactionUiModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool hasMore;

/// Create a copy of TransactionPageUi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionPageUiCopyWith<_TransactionPageUi> get copyWith => __$TransactionPageUiCopyWithImpl<_TransactionPageUi>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionPageUi&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasMore);

@override
String toString() {
  return 'TransactionPageUi(items: $items, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$TransactionPageUiCopyWith<$Res> implements $TransactionPageUiCopyWith<$Res> {
  factory _$TransactionPageUiCopyWith(_TransactionPageUi value, $Res Function(_TransactionPageUi) _then) = __$TransactionPageUiCopyWithImpl;
@override @useResult
$Res call({
 List<TransactionUiModel> items, bool hasMore
});




}
/// @nodoc
class __$TransactionPageUiCopyWithImpl<$Res>
    implements _$TransactionPageUiCopyWith<$Res> {
  __$TransactionPageUiCopyWithImpl(this._self, this._then);

  final _TransactionPageUi _self;
  final $Res Function(_TransactionPageUi) _then;

/// Create a copy of TransactionPageUi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasMore = null,}) {
  return _then(_TransactionPageUi(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionUiModel>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

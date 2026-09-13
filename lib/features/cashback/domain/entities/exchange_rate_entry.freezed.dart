// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_rate_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExchangeRateEntry {

 String get id; String get fromCurrency; String get toCurrency; DateTime get date; double get rate; String get source; DateTime get createdAt;
/// Create a copy of ExchangeRateEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeRateEntryCopyWith<ExchangeRateEntry> get copyWith => _$ExchangeRateEntryCopyWithImpl<ExchangeRateEntry>(this as ExchangeRateEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeRateEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.fromCurrency, fromCurrency) || other.fromCurrency == fromCurrency)&&(identical(other.toCurrency, toCurrency) || other.toCurrency == toCurrency)&&(identical(other.date, date) || other.date == date)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,fromCurrency,toCurrency,date,rate,source,createdAt);

@override
String toString() {
  return 'ExchangeRateEntry(id: $id, fromCurrency: $fromCurrency, toCurrency: $toCurrency, date: $date, rate: $rate, source: $source, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExchangeRateEntryCopyWith<$Res>  {
  factory $ExchangeRateEntryCopyWith(ExchangeRateEntry value, $Res Function(ExchangeRateEntry) _then) = _$ExchangeRateEntryCopyWithImpl;
@useResult
$Res call({
 String id, String fromCurrency, String toCurrency, DateTime date, double rate, String source, DateTime createdAt
});




}
/// @nodoc
class _$ExchangeRateEntryCopyWithImpl<$Res>
    implements $ExchangeRateEntryCopyWith<$Res> {
  _$ExchangeRateEntryCopyWithImpl(this._self, this._then);

  final ExchangeRateEntry _self;
  final $Res Function(ExchangeRateEntry) _then;

/// Create a copy of ExchangeRateEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromCurrency = null,Object? toCurrency = null,Object? date = null,Object? rate = null,Object? source = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromCurrency: null == fromCurrency ? _self.fromCurrency : fromCurrency // ignore: cast_nullable_to_non_nullable
as String,toCurrency: null == toCurrency ? _self.toCurrency : toCurrency // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ExchangeRateEntry].
extension ExchangeRateEntryPatterns on ExchangeRateEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExchangeRateEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExchangeRateEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExchangeRateEntry value)  $default,){
final _that = this;
switch (_that) {
case _ExchangeRateEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExchangeRateEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ExchangeRateEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ExchangeRateEntry implements ExchangeRateEntry {
  const _ExchangeRateEntry({required this.id, required this.fromCurrency, required this.toCurrency, required this.date, required this.rate, required this.source, required this.createdAt});
  

@override final  String id;
@override final  String fromCurrency;
@override final  String toCurrency;
@override final  DateTime date;
@override final  double rate;
@override final  String source;
@override final  DateTime createdAt;

/// Create a copy of ExchangeRateEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExchangeRateEntryCopyWith<_ExchangeRateEntry> get copyWith => __$ExchangeRateEntryCopyWithImpl<_ExchangeRateEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExchangeRateEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.fromCurrency, fromCurrency) || other.fromCurrency == fromCurrency)&&(identical(other.toCurrency, toCurrency) || other.toCurrency == toCurrency)&&(identical(other.date, date) || other.date == date)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,fromCurrency,toCurrency,date,rate,source,createdAt);

@override
String toString() {
  return 'ExchangeRateEntry(id: $id, fromCurrency: $fromCurrency, toCurrency: $toCurrency, date: $date, rate: $rate, source: $source, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExchangeRateEntryCopyWith<$Res> implements $ExchangeRateEntryCopyWith<$Res> {
  factory _$ExchangeRateEntryCopyWith(_ExchangeRateEntry value, $Res Function(_ExchangeRateEntry) _then) = __$ExchangeRateEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromCurrency, String toCurrency, DateTime date, double rate, String source, DateTime createdAt
});




}
/// @nodoc
class __$ExchangeRateEntryCopyWithImpl<$Res>
    implements _$ExchangeRateEntryCopyWith<$Res> {
  __$ExchangeRateEntryCopyWithImpl(this._self, this._then);

  final _ExchangeRateEntry _self;
  final $Res Function(_ExchangeRateEntry) _then;

/// Create a copy of ExchangeRateEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromCurrency = null,Object? toCurrency = null,Object? date = null,Object? rate = null,Object? source = null,Object? createdAt = null,}) {
  return _then(_ExchangeRateEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromCurrency: null == fromCurrency ? _self.fromCurrency : fromCurrency // ignore: cast_nullable_to_non_nullable
as String,toCurrency: null == toCurrency ? _self.toCurrency : toCurrency // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

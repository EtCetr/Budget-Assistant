// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fiscal_qr_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FiscalQrData {

 DateTime get dateUtc; int get totalKop; String? get fiscalDataJson; String get raw;
/// Create a copy of FiscalQrData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FiscalQrDataCopyWith<FiscalQrData> get copyWith => _$FiscalQrDataCopyWithImpl<FiscalQrData>(this as FiscalQrData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FiscalQrData&&(identical(other.dateUtc, dateUtc) || other.dateUtc == dateUtc)&&(identical(other.totalKop, totalKop) || other.totalKop == totalKop)&&(identical(other.fiscalDataJson, fiscalDataJson) || other.fiscalDataJson == fiscalDataJson)&&(identical(other.raw, raw) || other.raw == raw));
}


@override
int get hashCode => Object.hash(runtimeType,dateUtc,totalKop,fiscalDataJson,raw);

@override
String toString() {
  return 'FiscalQrData(dateUtc: $dateUtc, totalKop: $totalKop, fiscalDataJson: $fiscalDataJson, raw: $raw)';
}


}

/// @nodoc
abstract mixin class $FiscalQrDataCopyWith<$Res>  {
  factory $FiscalQrDataCopyWith(FiscalQrData value, $Res Function(FiscalQrData) _then) = _$FiscalQrDataCopyWithImpl;
@useResult
$Res call({
 DateTime dateUtc, int totalKop, String? fiscalDataJson, String raw
});




}
/// @nodoc
class _$FiscalQrDataCopyWithImpl<$Res>
    implements $FiscalQrDataCopyWith<$Res> {
  _$FiscalQrDataCopyWithImpl(this._self, this._then);

  final FiscalQrData _self;
  final $Res Function(FiscalQrData) _then;

/// Create a copy of FiscalQrData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateUtc = null,Object? totalKop = null,Object? fiscalDataJson = freezed,Object? raw = null,}) {
  return _then(_self.copyWith(
dateUtc: null == dateUtc ? _self.dateUtc : dateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,totalKop: null == totalKop ? _self.totalKop : totalKop // ignore: cast_nullable_to_non_nullable
as int,fiscalDataJson: freezed == fiscalDataJson ? _self.fiscalDataJson : fiscalDataJson // ignore: cast_nullable_to_non_nullable
as String?,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FiscalQrData].
extension FiscalQrDataPatterns on FiscalQrData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FiscalQrData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FiscalQrData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FiscalQrData value)  $default,){
final _that = this;
switch (_that) {
case _FiscalQrData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FiscalQrData value)?  $default,){
final _that = this;
switch (_that) {
case _FiscalQrData() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _FiscalQrData implements FiscalQrData {
  const _FiscalQrData({required this.dateUtc, required this.totalKop, this.fiscalDataJson, required this.raw});
  

@override final  DateTime dateUtc;
@override final  int totalKop;
@override final  String? fiscalDataJson;
@override final  String raw;

/// Create a copy of FiscalQrData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FiscalQrDataCopyWith<_FiscalQrData> get copyWith => __$FiscalQrDataCopyWithImpl<_FiscalQrData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FiscalQrData&&(identical(other.dateUtc, dateUtc) || other.dateUtc == dateUtc)&&(identical(other.totalKop, totalKop) || other.totalKop == totalKop)&&(identical(other.fiscalDataJson, fiscalDataJson) || other.fiscalDataJson == fiscalDataJson)&&(identical(other.raw, raw) || other.raw == raw));
}


@override
int get hashCode => Object.hash(runtimeType,dateUtc,totalKop,fiscalDataJson,raw);

@override
String toString() {
  return 'FiscalQrData(dateUtc: $dateUtc, totalKop: $totalKop, fiscalDataJson: $fiscalDataJson, raw: $raw)';
}


}

/// @nodoc
abstract mixin class _$FiscalQrDataCopyWith<$Res> implements $FiscalQrDataCopyWith<$Res> {
  factory _$FiscalQrDataCopyWith(_FiscalQrData value, $Res Function(_FiscalQrData) _then) = __$FiscalQrDataCopyWithImpl;
@override @useResult
$Res call({
 DateTime dateUtc, int totalKop, String? fiscalDataJson, String raw
});




}
/// @nodoc
class __$FiscalQrDataCopyWithImpl<$Res>
    implements _$FiscalQrDataCopyWith<$Res> {
  __$FiscalQrDataCopyWithImpl(this._self, this._then);

  final _FiscalQrData _self;
  final $Res Function(_FiscalQrData) _then;

/// Create a copy of FiscalQrData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateUtc = null,Object? totalKop = null,Object? fiscalDataJson = freezed,Object? raw = null,}) {
  return _then(_FiscalQrData(
dateUtc: null == dateUtc ? _self.dateUtc : dateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,totalKop: null == totalKop ? _self.totalKop : totalKop // ignore: cast_nullable_to_non_nullable
as int,fiscalDataJson: freezed == fiscalDataJson ? _self.fiscalDataJson : fiscalDataJson // ignore: cast_nullable_to_non_nullable
as String?,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

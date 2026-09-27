// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'column_mapping.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ColumnMapping {

/// Индекс колонки с датой (обязательно).
 int get dateColumnIndex;/// Индекс колонки с суммой (обязательно).
 int get amountColumnIndex;/// Индекс колонки с мерчантом (обязательно).
 int get merchantColumnIndex;/// Индекс колонки с категорией банка (опционально).
 int? get categoryColumnIndex;/// Индекс колонки с комментарием (опционально).
 int? get commentColumnIndex;/// Индекс колонки с валютой (опционально).
 int? get currencyColumnIndex;/// Формат даты: 'dd.MM.yyyy', 'dd.MM.yyyy HH:mm:ss'.
 String get dateFormat;/// Разделитель CSV.
 String get csvSeparator;/// Кодировка.
 String get encoding;/// Кол-во строк для пропуска (заголовки банка).
 int get skipRows;/// true = расход отрицательный, false = расход положительный.
 bool get expenseIsNegative;
/// Create a copy of ColumnMapping
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColumnMappingCopyWith<ColumnMapping> get copyWith => _$ColumnMappingCopyWithImpl<ColumnMapping>(this as ColumnMapping, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColumnMapping&&(identical(other.dateColumnIndex, dateColumnIndex) || other.dateColumnIndex == dateColumnIndex)&&(identical(other.amountColumnIndex, amountColumnIndex) || other.amountColumnIndex == amountColumnIndex)&&(identical(other.merchantColumnIndex, merchantColumnIndex) || other.merchantColumnIndex == merchantColumnIndex)&&(identical(other.categoryColumnIndex, categoryColumnIndex) || other.categoryColumnIndex == categoryColumnIndex)&&(identical(other.commentColumnIndex, commentColumnIndex) || other.commentColumnIndex == commentColumnIndex)&&(identical(other.currencyColumnIndex, currencyColumnIndex) || other.currencyColumnIndex == currencyColumnIndex)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.csvSeparator, csvSeparator) || other.csvSeparator == csvSeparator)&&(identical(other.encoding, encoding) || other.encoding == encoding)&&(identical(other.skipRows, skipRows) || other.skipRows == skipRows)&&(identical(other.expenseIsNegative, expenseIsNegative) || other.expenseIsNegative == expenseIsNegative));
}


@override
int get hashCode => Object.hash(runtimeType,dateColumnIndex,amountColumnIndex,merchantColumnIndex,categoryColumnIndex,commentColumnIndex,currencyColumnIndex,dateFormat,csvSeparator,encoding,skipRows,expenseIsNegative);

@override
String toString() {
  return 'ColumnMapping(dateColumnIndex: $dateColumnIndex, amountColumnIndex: $amountColumnIndex, merchantColumnIndex: $merchantColumnIndex, categoryColumnIndex: $categoryColumnIndex, commentColumnIndex: $commentColumnIndex, currencyColumnIndex: $currencyColumnIndex, dateFormat: $dateFormat, csvSeparator: $csvSeparator, encoding: $encoding, skipRows: $skipRows, expenseIsNegative: $expenseIsNegative)';
}


}

/// @nodoc
abstract mixin class $ColumnMappingCopyWith<$Res>  {
  factory $ColumnMappingCopyWith(ColumnMapping value, $Res Function(ColumnMapping) _then) = _$ColumnMappingCopyWithImpl;
@useResult
$Res call({
 int dateColumnIndex, int amountColumnIndex, int merchantColumnIndex, int? categoryColumnIndex, int? commentColumnIndex, int? currencyColumnIndex, String dateFormat, String csvSeparator, String encoding, int skipRows, bool expenseIsNegative
});




}
/// @nodoc
class _$ColumnMappingCopyWithImpl<$Res>
    implements $ColumnMappingCopyWith<$Res> {
  _$ColumnMappingCopyWithImpl(this._self, this._then);

  final ColumnMapping _self;
  final $Res Function(ColumnMapping) _then;

/// Create a copy of ColumnMapping
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateColumnIndex = null,Object? amountColumnIndex = null,Object? merchantColumnIndex = null,Object? categoryColumnIndex = freezed,Object? commentColumnIndex = freezed,Object? currencyColumnIndex = freezed,Object? dateFormat = null,Object? csvSeparator = null,Object? encoding = null,Object? skipRows = null,Object? expenseIsNegative = null,}) {
  return _then(_self.copyWith(
dateColumnIndex: null == dateColumnIndex ? _self.dateColumnIndex : dateColumnIndex // ignore: cast_nullable_to_non_nullable
as int,amountColumnIndex: null == amountColumnIndex ? _self.amountColumnIndex : amountColumnIndex // ignore: cast_nullable_to_non_nullable
as int,merchantColumnIndex: null == merchantColumnIndex ? _self.merchantColumnIndex : merchantColumnIndex // ignore: cast_nullable_to_non_nullable
as int,categoryColumnIndex: freezed == categoryColumnIndex ? _self.categoryColumnIndex : categoryColumnIndex // ignore: cast_nullable_to_non_nullable
as int?,commentColumnIndex: freezed == commentColumnIndex ? _self.commentColumnIndex : commentColumnIndex // ignore: cast_nullable_to_non_nullable
as int?,currencyColumnIndex: freezed == currencyColumnIndex ? _self.currencyColumnIndex : currencyColumnIndex // ignore: cast_nullable_to_non_nullable
as int?,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,csvSeparator: null == csvSeparator ? _self.csvSeparator : csvSeparator // ignore: cast_nullable_to_non_nullable
as String,encoding: null == encoding ? _self.encoding : encoding // ignore: cast_nullable_to_non_nullable
as String,skipRows: null == skipRows ? _self.skipRows : skipRows // ignore: cast_nullable_to_non_nullable
as int,expenseIsNegative: null == expenseIsNegative ? _self.expenseIsNegative : expenseIsNegative // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ColumnMapping].
extension ColumnMappingPatterns on ColumnMapping {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColumnMapping value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColumnMapping() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColumnMapping value)  $default,){
final _that = this;
switch (_that) {
case _ColumnMapping():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColumnMapping value)?  $default,){
final _that = this;
switch (_that) {
case _ColumnMapping() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ColumnMapping implements ColumnMapping {
  const _ColumnMapping({required this.dateColumnIndex, required this.amountColumnIndex, required this.merchantColumnIndex, this.categoryColumnIndex, this.commentColumnIndex, this.currencyColumnIndex, this.dateFormat = 'dd.MM.yyyy', this.csvSeparator = ';', this.encoding = 'UTF-8', this.skipRows = 0, this.expenseIsNegative = true});
  

/// Индекс колонки с датой (обязательно).
@override final  int dateColumnIndex;
/// Индекс колонки с суммой (обязательно).
@override final  int amountColumnIndex;
/// Индекс колонки с мерчантом (обязательно).
@override final  int merchantColumnIndex;
/// Индекс колонки с категорией банка (опционально).
@override final  int? categoryColumnIndex;
/// Индекс колонки с комментарием (опционально).
@override final  int? commentColumnIndex;
/// Индекс колонки с валютой (опционально).
@override final  int? currencyColumnIndex;
/// Формат даты: 'dd.MM.yyyy', 'dd.MM.yyyy HH:mm:ss'.
@override@JsonKey() final  String dateFormat;
/// Разделитель CSV.
@override@JsonKey() final  String csvSeparator;
/// Кодировка.
@override@JsonKey() final  String encoding;
/// Кол-во строк для пропуска (заголовки банка).
@override@JsonKey() final  int skipRows;
/// true = расход отрицательный, false = расход положительный.
@override@JsonKey() final  bool expenseIsNegative;

/// Create a copy of ColumnMapping
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColumnMappingCopyWith<_ColumnMapping> get copyWith => __$ColumnMappingCopyWithImpl<_ColumnMapping>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColumnMapping&&(identical(other.dateColumnIndex, dateColumnIndex) || other.dateColumnIndex == dateColumnIndex)&&(identical(other.amountColumnIndex, amountColumnIndex) || other.amountColumnIndex == amountColumnIndex)&&(identical(other.merchantColumnIndex, merchantColumnIndex) || other.merchantColumnIndex == merchantColumnIndex)&&(identical(other.categoryColumnIndex, categoryColumnIndex) || other.categoryColumnIndex == categoryColumnIndex)&&(identical(other.commentColumnIndex, commentColumnIndex) || other.commentColumnIndex == commentColumnIndex)&&(identical(other.currencyColumnIndex, currencyColumnIndex) || other.currencyColumnIndex == currencyColumnIndex)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.csvSeparator, csvSeparator) || other.csvSeparator == csvSeparator)&&(identical(other.encoding, encoding) || other.encoding == encoding)&&(identical(other.skipRows, skipRows) || other.skipRows == skipRows)&&(identical(other.expenseIsNegative, expenseIsNegative) || other.expenseIsNegative == expenseIsNegative));
}


@override
int get hashCode => Object.hash(runtimeType,dateColumnIndex,amountColumnIndex,merchantColumnIndex,categoryColumnIndex,commentColumnIndex,currencyColumnIndex,dateFormat,csvSeparator,encoding,skipRows,expenseIsNegative);

@override
String toString() {
  return 'ColumnMapping(dateColumnIndex: $dateColumnIndex, amountColumnIndex: $amountColumnIndex, merchantColumnIndex: $merchantColumnIndex, categoryColumnIndex: $categoryColumnIndex, commentColumnIndex: $commentColumnIndex, currencyColumnIndex: $currencyColumnIndex, dateFormat: $dateFormat, csvSeparator: $csvSeparator, encoding: $encoding, skipRows: $skipRows, expenseIsNegative: $expenseIsNegative)';
}


}

/// @nodoc
abstract mixin class _$ColumnMappingCopyWith<$Res> implements $ColumnMappingCopyWith<$Res> {
  factory _$ColumnMappingCopyWith(_ColumnMapping value, $Res Function(_ColumnMapping) _then) = __$ColumnMappingCopyWithImpl;
@override @useResult
$Res call({
 int dateColumnIndex, int amountColumnIndex, int merchantColumnIndex, int? categoryColumnIndex, int? commentColumnIndex, int? currencyColumnIndex, String dateFormat, String csvSeparator, String encoding, int skipRows, bool expenseIsNegative
});




}
/// @nodoc
class __$ColumnMappingCopyWithImpl<$Res>
    implements _$ColumnMappingCopyWith<$Res> {
  __$ColumnMappingCopyWithImpl(this._self, this._then);

  final _ColumnMapping _self;
  final $Res Function(_ColumnMapping) _then;

/// Create a copy of ColumnMapping
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateColumnIndex = null,Object? amountColumnIndex = null,Object? merchantColumnIndex = null,Object? categoryColumnIndex = freezed,Object? commentColumnIndex = freezed,Object? currencyColumnIndex = freezed,Object? dateFormat = null,Object? csvSeparator = null,Object? encoding = null,Object? skipRows = null,Object? expenseIsNegative = null,}) {
  return _then(_ColumnMapping(
dateColumnIndex: null == dateColumnIndex ? _self.dateColumnIndex : dateColumnIndex // ignore: cast_nullable_to_non_nullable
as int,amountColumnIndex: null == amountColumnIndex ? _self.amountColumnIndex : amountColumnIndex // ignore: cast_nullable_to_non_nullable
as int,merchantColumnIndex: null == merchantColumnIndex ? _self.merchantColumnIndex : merchantColumnIndex // ignore: cast_nullable_to_non_nullable
as int,categoryColumnIndex: freezed == categoryColumnIndex ? _self.categoryColumnIndex : categoryColumnIndex // ignore: cast_nullable_to_non_nullable
as int?,commentColumnIndex: freezed == commentColumnIndex ? _self.commentColumnIndex : commentColumnIndex // ignore: cast_nullable_to_non_nullable
as int?,currencyColumnIndex: freezed == currencyColumnIndex ? _self.currencyColumnIndex : currencyColumnIndex // ignore: cast_nullable_to_non_nullable
as int?,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,csvSeparator: null == csvSeparator ? _self.csvSeparator : csvSeparator // ignore: cast_nullable_to_non_nullable
as String,encoding: null == encoding ? _self.encoding : encoding // ignore: cast_nullable_to_non_nullable
as String,skipRows: null == skipRows ? _self.skipRows : skipRows // ignore: cast_nullable_to_non_nullable
as int,expenseIsNegative: null == expenseIsNegative ? _self.expenseIsNegative : expenseIsNegative // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

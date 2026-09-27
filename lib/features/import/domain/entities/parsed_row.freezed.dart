// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParsedRow {

 int get rowIndex; DateTime get date;/// Копейки. Отрицательное = расход, положительное = доход.
 int get amountKopecks; String get merchantName; String? get bankCategory; String? get comment; String? get bankTransactionId; String? get originalCurrency; int? get originalAmountKopecks;/// Категория, назначенная пользователем в UI (изначально null).
 String? get assignedCategoryId;
/// Create a copy of ParsedRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<ParsedRow> get copyWith => _$ParsedRowCopyWithImpl<ParsedRow>(this as ParsedRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsedRow&&(identical(other.rowIndex, rowIndex) || other.rowIndex == rowIndex)&&(identical(other.date, date) || other.date == date)&&(identical(other.amountKopecks, amountKopecks) || other.amountKopecks == amountKopecks)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.bankCategory, bankCategory) || other.bankCategory == bankCategory)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.bankTransactionId, bankTransactionId) || other.bankTransactionId == bankTransactionId)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmountKopecks, originalAmountKopecks) || other.originalAmountKopecks == originalAmountKopecks)&&(identical(other.assignedCategoryId, assignedCategoryId) || other.assignedCategoryId == assignedCategoryId));
}


@override
int get hashCode => Object.hash(runtimeType,rowIndex,date,amountKopecks,merchantName,bankCategory,comment,bankTransactionId,originalCurrency,originalAmountKopecks,assignedCategoryId);

@override
String toString() {
  return 'ParsedRow(rowIndex: $rowIndex, date: $date, amountKopecks: $amountKopecks, merchantName: $merchantName, bankCategory: $bankCategory, comment: $comment, bankTransactionId: $bankTransactionId, originalCurrency: $originalCurrency, originalAmountKopecks: $originalAmountKopecks, assignedCategoryId: $assignedCategoryId)';
}


}

/// @nodoc
abstract mixin class $ParsedRowCopyWith<$Res>  {
  factory $ParsedRowCopyWith(ParsedRow value, $Res Function(ParsedRow) _then) = _$ParsedRowCopyWithImpl;
@useResult
$Res call({
 int rowIndex, DateTime date, int amountKopecks, String merchantName, String? bankCategory, String? comment, String? bankTransactionId, String? originalCurrency, int? originalAmountKopecks, String? assignedCategoryId
});




}
/// @nodoc
class _$ParsedRowCopyWithImpl<$Res>
    implements $ParsedRowCopyWith<$Res> {
  _$ParsedRowCopyWithImpl(this._self, this._then);

  final ParsedRow _self;
  final $Res Function(ParsedRow) _then;

/// Create a copy of ParsedRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rowIndex = null,Object? date = null,Object? amountKopecks = null,Object? merchantName = null,Object? bankCategory = freezed,Object? comment = freezed,Object? bankTransactionId = freezed,Object? originalCurrency = freezed,Object? originalAmountKopecks = freezed,Object? assignedCategoryId = freezed,}) {
  return _then(_self.copyWith(
rowIndex: null == rowIndex ? _self.rowIndex : rowIndex // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amountKopecks: null == amountKopecks ? _self.amountKopecks : amountKopecks // ignore: cast_nullable_to_non_nullable
as int,merchantName: null == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String,bankCategory: freezed == bankCategory ? _self.bankCategory : bankCategory // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,bankTransactionId: freezed == bankTransactionId ? _self.bankTransactionId : bankTransactionId // ignore: cast_nullable_to_non_nullable
as String?,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmountKopecks: freezed == originalAmountKopecks ? _self.originalAmountKopecks : originalAmountKopecks // ignore: cast_nullable_to_non_nullable
as int?,assignedCategoryId: freezed == assignedCategoryId ? _self.assignedCategoryId : assignedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParsedRow].
extension ParsedRowPatterns on ParsedRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsedRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsedRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsedRow value)  $default,){
final _that = this;
switch (_that) {
case _ParsedRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsedRow value)?  $default,){
final _that = this;
switch (_that) {
case _ParsedRow() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ParsedRow implements ParsedRow {
  const _ParsedRow({required this.rowIndex, required this.date, required this.amountKopecks, required this.merchantName, this.bankCategory, this.comment, this.bankTransactionId, this.originalCurrency, this.originalAmountKopecks, this.assignedCategoryId});
  

@override final  int rowIndex;
@override final  DateTime date;
/// Копейки. Отрицательное = расход, положительное = доход.
@override final  int amountKopecks;
@override final  String merchantName;
@override final  String? bankCategory;
@override final  String? comment;
@override final  String? bankTransactionId;
@override final  String? originalCurrency;
@override final  int? originalAmountKopecks;
/// Категория, назначенная пользователем в UI (изначально null).
@override final  String? assignedCategoryId;

/// Create a copy of ParsedRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsedRowCopyWith<_ParsedRow> get copyWith => __$ParsedRowCopyWithImpl<_ParsedRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsedRow&&(identical(other.rowIndex, rowIndex) || other.rowIndex == rowIndex)&&(identical(other.date, date) || other.date == date)&&(identical(other.amountKopecks, amountKopecks) || other.amountKopecks == amountKopecks)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.bankCategory, bankCategory) || other.bankCategory == bankCategory)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.bankTransactionId, bankTransactionId) || other.bankTransactionId == bankTransactionId)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmountKopecks, originalAmountKopecks) || other.originalAmountKopecks == originalAmountKopecks)&&(identical(other.assignedCategoryId, assignedCategoryId) || other.assignedCategoryId == assignedCategoryId));
}


@override
int get hashCode => Object.hash(runtimeType,rowIndex,date,amountKopecks,merchantName,bankCategory,comment,bankTransactionId,originalCurrency,originalAmountKopecks,assignedCategoryId);

@override
String toString() {
  return 'ParsedRow(rowIndex: $rowIndex, date: $date, amountKopecks: $amountKopecks, merchantName: $merchantName, bankCategory: $bankCategory, comment: $comment, bankTransactionId: $bankTransactionId, originalCurrency: $originalCurrency, originalAmountKopecks: $originalAmountKopecks, assignedCategoryId: $assignedCategoryId)';
}


}

/// @nodoc
abstract mixin class _$ParsedRowCopyWith<$Res> implements $ParsedRowCopyWith<$Res> {
  factory _$ParsedRowCopyWith(_ParsedRow value, $Res Function(_ParsedRow) _then) = __$ParsedRowCopyWithImpl;
@override @useResult
$Res call({
 int rowIndex, DateTime date, int amountKopecks, String merchantName, String? bankCategory, String? comment, String? bankTransactionId, String? originalCurrency, int? originalAmountKopecks, String? assignedCategoryId
});




}
/// @nodoc
class __$ParsedRowCopyWithImpl<$Res>
    implements _$ParsedRowCopyWith<$Res> {
  __$ParsedRowCopyWithImpl(this._self, this._then);

  final _ParsedRow _self;
  final $Res Function(_ParsedRow) _then;

/// Create a copy of ParsedRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rowIndex = null,Object? date = null,Object? amountKopecks = null,Object? merchantName = null,Object? bankCategory = freezed,Object? comment = freezed,Object? bankTransactionId = freezed,Object? originalCurrency = freezed,Object? originalAmountKopecks = freezed,Object? assignedCategoryId = freezed,}) {
  return _then(_ParsedRow(
rowIndex: null == rowIndex ? _self.rowIndex : rowIndex // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amountKopecks: null == amountKopecks ? _self.amountKopecks : amountKopecks // ignore: cast_nullable_to_non_nullable
as int,merchantName: null == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String,bankCategory: freezed == bankCategory ? _self.bankCategory : bankCategory // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,bankTransactionId: freezed == bankTransactionId ? _self.bankTransactionId : bankTransactionId // ignore: cast_nullable_to_non_nullable
as String?,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmountKopecks: freezed == originalAmountKopecks ? _self.originalAmountKopecks : originalAmountKopecks // ignore: cast_nullable_to_non_nullable
as int?,assignedCategoryId: freezed == assignedCategoryId ? _self.assignedCategoryId : assignedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

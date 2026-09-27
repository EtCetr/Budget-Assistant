// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportResult {

 String get bankName; String get bankCode; String get fileName; int get totalRows; DateTime get periodStart; DateTime get periodEnd; String get targetAccountId; String? get targetSpaceId; List<ParsedRow> get rows; List<DuplicateCandidate> get duplicates; List<TransferCandidate> get transfers; List<HoldConfirmationCandidate> get holdConfirmations;
/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportResultCopyWith<ImportResult> get copyWith => _$ImportResultCopyWithImpl<ImportResult>(this as ImportResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportResult&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankCode, bankCode) || other.bankCode == bankCode)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.totalRows, totalRows) || other.totalRows == totalRows)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.targetAccountId, targetAccountId) || other.targetAccountId == targetAccountId)&&(identical(other.targetSpaceId, targetSpaceId) || other.targetSpaceId == targetSpaceId)&&const DeepCollectionEquality().equals(other.rows, rows)&&const DeepCollectionEquality().equals(other.duplicates, duplicates)&&const DeepCollectionEquality().equals(other.transfers, transfers)&&const DeepCollectionEquality().equals(other.holdConfirmations, holdConfirmations));
}


@override
int get hashCode => Object.hash(runtimeType,bankName,bankCode,fileName,totalRows,periodStart,periodEnd,targetAccountId,targetSpaceId,const DeepCollectionEquality().hash(rows),const DeepCollectionEquality().hash(duplicates),const DeepCollectionEquality().hash(transfers),const DeepCollectionEquality().hash(holdConfirmations));

@override
String toString() {
  return 'ImportResult(bankName: $bankName, bankCode: $bankCode, fileName: $fileName, totalRows: $totalRows, periodStart: $periodStart, periodEnd: $periodEnd, targetAccountId: $targetAccountId, targetSpaceId: $targetSpaceId, rows: $rows, duplicates: $duplicates, transfers: $transfers, holdConfirmations: $holdConfirmations)';
}


}

/// @nodoc
abstract mixin class $ImportResultCopyWith<$Res>  {
  factory $ImportResultCopyWith(ImportResult value, $Res Function(ImportResult) _then) = _$ImportResultCopyWithImpl;
@useResult
$Res call({
 String bankName, String bankCode, String fileName, int totalRows, DateTime periodStart, DateTime periodEnd, String targetAccountId, String? targetSpaceId, List<ParsedRow> rows, List<DuplicateCandidate> duplicates, List<TransferCandidate> transfers, List<HoldConfirmationCandidate> holdConfirmations
});




}
/// @nodoc
class _$ImportResultCopyWithImpl<$Res>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._self, this._then);

  final ImportResult _self;
  final $Res Function(ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bankName = null,Object? bankCode = null,Object? fileName = null,Object? totalRows = null,Object? periodStart = null,Object? periodEnd = null,Object? targetAccountId = null,Object? targetSpaceId = freezed,Object? rows = null,Object? duplicates = null,Object? transfers = null,Object? holdConfirmations = null,}) {
  return _then(_self.copyWith(
bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,bankCode: null == bankCode ? _self.bankCode : bankCode // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,totalRows: null == totalRows ? _self.totalRows : totalRows // ignore: cast_nullable_to_non_nullable
as int,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,targetAccountId: null == targetAccountId ? _self.targetAccountId : targetAccountId // ignore: cast_nullable_to_non_nullable
as String,targetSpaceId: freezed == targetSpaceId ? _self.targetSpaceId : targetSpaceId // ignore: cast_nullable_to_non_nullable
as String?,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<ParsedRow>,duplicates: null == duplicates ? _self.duplicates : duplicates // ignore: cast_nullable_to_non_nullable
as List<DuplicateCandidate>,transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<TransferCandidate>,holdConfirmations: null == holdConfirmations ? _self.holdConfirmations : holdConfirmations // ignore: cast_nullable_to_non_nullable
as List<HoldConfirmationCandidate>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportResult].
extension ImportResultPatterns on ImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportResult value)  $default,){
final _that = this;
switch (_that) {
case _ImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ImportResult implements ImportResult {
  const _ImportResult({required this.bankName, required this.bankCode, required this.fileName, required this.totalRows, required this.periodStart, required this.periodEnd, required this.targetAccountId, this.targetSpaceId, required final  List<ParsedRow> rows, final  List<DuplicateCandidate> duplicates = const [], final  List<TransferCandidate> transfers = const [], final  List<HoldConfirmationCandidate> holdConfirmations = const []}): _rows = rows,_duplicates = duplicates,_transfers = transfers,_holdConfirmations = holdConfirmations;
  

@override final  String bankName;
@override final  String bankCode;
@override final  String fileName;
@override final  int totalRows;
@override final  DateTime periodStart;
@override final  DateTime periodEnd;
@override final  String targetAccountId;
@override final  String? targetSpaceId;
 final  List<ParsedRow> _rows;
@override List<ParsedRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

 final  List<DuplicateCandidate> _duplicates;
@override@JsonKey() List<DuplicateCandidate> get duplicates {
  if (_duplicates is EqualUnmodifiableListView) return _duplicates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_duplicates);
}

 final  List<TransferCandidate> _transfers;
@override@JsonKey() List<TransferCandidate> get transfers {
  if (_transfers is EqualUnmodifiableListView) return _transfers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transfers);
}

 final  List<HoldConfirmationCandidate> _holdConfirmations;
@override@JsonKey() List<HoldConfirmationCandidate> get holdConfirmations {
  if (_holdConfirmations is EqualUnmodifiableListView) return _holdConfirmations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_holdConfirmations);
}


/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportResultCopyWith<_ImportResult> get copyWith => __$ImportResultCopyWithImpl<_ImportResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportResult&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankCode, bankCode) || other.bankCode == bankCode)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.totalRows, totalRows) || other.totalRows == totalRows)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.targetAccountId, targetAccountId) || other.targetAccountId == targetAccountId)&&(identical(other.targetSpaceId, targetSpaceId) || other.targetSpaceId == targetSpaceId)&&const DeepCollectionEquality().equals(other._rows, _rows)&&const DeepCollectionEquality().equals(other._duplicates, _duplicates)&&const DeepCollectionEquality().equals(other._transfers, _transfers)&&const DeepCollectionEquality().equals(other._holdConfirmations, _holdConfirmations));
}


@override
int get hashCode => Object.hash(runtimeType,bankName,bankCode,fileName,totalRows,periodStart,periodEnd,targetAccountId,targetSpaceId,const DeepCollectionEquality().hash(_rows),const DeepCollectionEquality().hash(_duplicates),const DeepCollectionEquality().hash(_transfers),const DeepCollectionEquality().hash(_holdConfirmations));

@override
String toString() {
  return 'ImportResult(bankName: $bankName, bankCode: $bankCode, fileName: $fileName, totalRows: $totalRows, periodStart: $periodStart, periodEnd: $periodEnd, targetAccountId: $targetAccountId, targetSpaceId: $targetSpaceId, rows: $rows, duplicates: $duplicates, transfers: $transfers, holdConfirmations: $holdConfirmations)';
}


}

/// @nodoc
abstract mixin class _$ImportResultCopyWith<$Res> implements $ImportResultCopyWith<$Res> {
  factory _$ImportResultCopyWith(_ImportResult value, $Res Function(_ImportResult) _then) = __$ImportResultCopyWithImpl;
@override @useResult
$Res call({
 String bankName, String bankCode, String fileName, int totalRows, DateTime periodStart, DateTime periodEnd, String targetAccountId, String? targetSpaceId, List<ParsedRow> rows, List<DuplicateCandidate> duplicates, List<TransferCandidate> transfers, List<HoldConfirmationCandidate> holdConfirmations
});




}
/// @nodoc
class __$ImportResultCopyWithImpl<$Res>
    implements _$ImportResultCopyWith<$Res> {
  __$ImportResultCopyWithImpl(this._self, this._then);

  final _ImportResult _self;
  final $Res Function(_ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bankName = null,Object? bankCode = null,Object? fileName = null,Object? totalRows = null,Object? periodStart = null,Object? periodEnd = null,Object? targetAccountId = null,Object? targetSpaceId = freezed,Object? rows = null,Object? duplicates = null,Object? transfers = null,Object? holdConfirmations = null,}) {
  return _then(_ImportResult(
bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,bankCode: null == bankCode ? _self.bankCode : bankCode // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,totalRows: null == totalRows ? _self.totalRows : totalRows // ignore: cast_nullable_to_non_nullable
as int,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,targetAccountId: null == targetAccountId ? _self.targetAccountId : targetAccountId // ignore: cast_nullable_to_non_nullable
as String,targetSpaceId: freezed == targetSpaceId ? _self.targetSpaceId : targetSpaceId // ignore: cast_nullable_to_non_nullable
as String?,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<ParsedRow>,duplicates: null == duplicates ? _self._duplicates : duplicates // ignore: cast_nullable_to_non_nullable
as List<DuplicateCandidate>,transfers: null == transfers ? _self._transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<TransferCandidate>,holdConfirmations: null == holdConfirmations ? _self._holdConfirmations : holdConfirmations // ignore: cast_nullable_to_non_nullable
as List<HoldConfirmationCandidate>,
  ));
}


}

// dart format on

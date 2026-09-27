// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'duplicate_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DuplicateCandidate {

 String get id; ParsedRow get importedRow;/// ID существующей транзакции в БД.
 String get existingTransactionId; DateTime get existingDate; int get existingAmountKopecks; String? get existingMerchantName;/// 0.0–1.0 степень совпадения.
 double get matchScore; DuplicateAction get selectedAction;
/// Create a copy of DuplicateCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuplicateCandidateCopyWith<DuplicateCandidate> get copyWith => _$DuplicateCandidateCopyWithImpl<DuplicateCandidate>(this as DuplicateCandidate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuplicateCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.importedRow, importedRow) || other.importedRow == importedRow)&&(identical(other.existingTransactionId, existingTransactionId) || other.existingTransactionId == existingTransactionId)&&(identical(other.existingDate, existingDate) || other.existingDate == existingDate)&&(identical(other.existingAmountKopecks, existingAmountKopecks) || other.existingAmountKopecks == existingAmountKopecks)&&(identical(other.existingMerchantName, existingMerchantName) || other.existingMerchantName == existingMerchantName)&&(identical(other.matchScore, matchScore) || other.matchScore == matchScore)&&(identical(other.selectedAction, selectedAction) || other.selectedAction == selectedAction));
}


@override
int get hashCode => Object.hash(runtimeType,id,importedRow,existingTransactionId,existingDate,existingAmountKopecks,existingMerchantName,matchScore,selectedAction);

@override
String toString() {
  return 'DuplicateCandidate(id: $id, importedRow: $importedRow, existingTransactionId: $existingTransactionId, existingDate: $existingDate, existingAmountKopecks: $existingAmountKopecks, existingMerchantName: $existingMerchantName, matchScore: $matchScore, selectedAction: $selectedAction)';
}


}

/// @nodoc
abstract mixin class $DuplicateCandidateCopyWith<$Res>  {
  factory $DuplicateCandidateCopyWith(DuplicateCandidate value, $Res Function(DuplicateCandidate) _then) = _$DuplicateCandidateCopyWithImpl;
@useResult
$Res call({
 String id, ParsedRow importedRow, String existingTransactionId, DateTime existingDate, int existingAmountKopecks, String? existingMerchantName, double matchScore, DuplicateAction selectedAction
});


$ParsedRowCopyWith<$Res> get importedRow;

}
/// @nodoc
class _$DuplicateCandidateCopyWithImpl<$Res>
    implements $DuplicateCandidateCopyWith<$Res> {
  _$DuplicateCandidateCopyWithImpl(this._self, this._then);

  final DuplicateCandidate _self;
  final $Res Function(DuplicateCandidate) _then;

/// Create a copy of DuplicateCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? importedRow = null,Object? existingTransactionId = null,Object? existingDate = null,Object? existingAmountKopecks = null,Object? existingMerchantName = freezed,Object? matchScore = null,Object? selectedAction = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,importedRow: null == importedRow ? _self.importedRow : importedRow // ignore: cast_nullable_to_non_nullable
as ParsedRow,existingTransactionId: null == existingTransactionId ? _self.existingTransactionId : existingTransactionId // ignore: cast_nullable_to_non_nullable
as String,existingDate: null == existingDate ? _self.existingDate : existingDate // ignore: cast_nullable_to_non_nullable
as DateTime,existingAmountKopecks: null == existingAmountKopecks ? _self.existingAmountKopecks : existingAmountKopecks // ignore: cast_nullable_to_non_nullable
as int,existingMerchantName: freezed == existingMerchantName ? _self.existingMerchantName : existingMerchantName // ignore: cast_nullable_to_non_nullable
as String?,matchScore: null == matchScore ? _self.matchScore : matchScore // ignore: cast_nullable_to_non_nullable
as double,selectedAction: null == selectedAction ? _self.selectedAction : selectedAction // ignore: cast_nullable_to_non_nullable
as DuplicateAction,
  ));
}
/// Create a copy of DuplicateCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get importedRow {
  
  return $ParsedRowCopyWith<$Res>(_self.importedRow, (value) {
    return _then(_self.copyWith(importedRow: value));
  });
}
}


/// Adds pattern-matching-related methods to [DuplicateCandidate].
extension DuplicateCandidatePatterns on DuplicateCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuplicateCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuplicateCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuplicateCandidate value)  $default,){
final _that = this;
switch (_that) {
case _DuplicateCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuplicateCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _DuplicateCandidate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _DuplicateCandidate implements DuplicateCandidate {
  const _DuplicateCandidate({required this.id, required this.importedRow, required this.existingTransactionId, required this.existingDate, required this.existingAmountKopecks, required this.existingMerchantName, required this.matchScore, this.selectedAction = DuplicateAction.skip});
  

@override final  String id;
@override final  ParsedRow importedRow;
/// ID существующей транзакции в БД.
@override final  String existingTransactionId;
@override final  DateTime existingDate;
@override final  int existingAmountKopecks;
@override final  String? existingMerchantName;
/// 0.0–1.0 степень совпадения.
@override final  double matchScore;
@override@JsonKey() final  DuplicateAction selectedAction;

/// Create a copy of DuplicateCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuplicateCandidateCopyWith<_DuplicateCandidate> get copyWith => __$DuplicateCandidateCopyWithImpl<_DuplicateCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuplicateCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.importedRow, importedRow) || other.importedRow == importedRow)&&(identical(other.existingTransactionId, existingTransactionId) || other.existingTransactionId == existingTransactionId)&&(identical(other.existingDate, existingDate) || other.existingDate == existingDate)&&(identical(other.existingAmountKopecks, existingAmountKopecks) || other.existingAmountKopecks == existingAmountKopecks)&&(identical(other.existingMerchantName, existingMerchantName) || other.existingMerchantName == existingMerchantName)&&(identical(other.matchScore, matchScore) || other.matchScore == matchScore)&&(identical(other.selectedAction, selectedAction) || other.selectedAction == selectedAction));
}


@override
int get hashCode => Object.hash(runtimeType,id,importedRow,existingTransactionId,existingDate,existingAmountKopecks,existingMerchantName,matchScore,selectedAction);

@override
String toString() {
  return 'DuplicateCandidate(id: $id, importedRow: $importedRow, existingTransactionId: $existingTransactionId, existingDate: $existingDate, existingAmountKopecks: $existingAmountKopecks, existingMerchantName: $existingMerchantName, matchScore: $matchScore, selectedAction: $selectedAction)';
}


}

/// @nodoc
abstract mixin class _$DuplicateCandidateCopyWith<$Res> implements $DuplicateCandidateCopyWith<$Res> {
  factory _$DuplicateCandidateCopyWith(_DuplicateCandidate value, $Res Function(_DuplicateCandidate) _then) = __$DuplicateCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, ParsedRow importedRow, String existingTransactionId, DateTime existingDate, int existingAmountKopecks, String? existingMerchantName, double matchScore, DuplicateAction selectedAction
});


@override $ParsedRowCopyWith<$Res> get importedRow;

}
/// @nodoc
class __$DuplicateCandidateCopyWithImpl<$Res>
    implements _$DuplicateCandidateCopyWith<$Res> {
  __$DuplicateCandidateCopyWithImpl(this._self, this._then);

  final _DuplicateCandidate _self;
  final $Res Function(_DuplicateCandidate) _then;

/// Create a copy of DuplicateCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? importedRow = null,Object? existingTransactionId = null,Object? existingDate = null,Object? existingAmountKopecks = null,Object? existingMerchantName = freezed,Object? matchScore = null,Object? selectedAction = null,}) {
  return _then(_DuplicateCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,importedRow: null == importedRow ? _self.importedRow : importedRow // ignore: cast_nullable_to_non_nullable
as ParsedRow,existingTransactionId: null == existingTransactionId ? _self.existingTransactionId : existingTransactionId // ignore: cast_nullable_to_non_nullable
as String,existingDate: null == existingDate ? _self.existingDate : existingDate // ignore: cast_nullable_to_non_nullable
as DateTime,existingAmountKopecks: null == existingAmountKopecks ? _self.existingAmountKopecks : existingAmountKopecks // ignore: cast_nullable_to_non_nullable
as int,existingMerchantName: freezed == existingMerchantName ? _self.existingMerchantName : existingMerchantName // ignore: cast_nullable_to_non_nullable
as String?,matchScore: null == matchScore ? _self.matchScore : matchScore // ignore: cast_nullable_to_non_nullable
as double,selectedAction: null == selectedAction ? _self.selectedAction : selectedAction // ignore: cast_nullable_to_non_nullable
as DuplicateAction,
  ));
}

/// Create a copy of DuplicateCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get importedRow {
  
  return $ParsedRowCopyWith<$Res>(_self.importedRow, (value) {
    return _then(_self.copyWith(importedRow: value));
  });
}
}

// dart format on

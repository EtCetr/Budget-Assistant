// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hold_confirmation_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HoldConfirmationCandidate {

 String get id; ParsedRow get importedRow; String get existingTransactionId; DateTime get existingDate; int get existingAmountKopecks; String? get existingMerchantName; HoldAction get selectedAction;
/// Create a copy of HoldConfirmationCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldConfirmationCandidateCopyWith<HoldConfirmationCandidate> get copyWith => _$HoldConfirmationCandidateCopyWithImpl<HoldConfirmationCandidate>(this as HoldConfirmationCandidate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldConfirmationCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.importedRow, importedRow) || other.importedRow == importedRow)&&(identical(other.existingTransactionId, existingTransactionId) || other.existingTransactionId == existingTransactionId)&&(identical(other.existingDate, existingDate) || other.existingDate == existingDate)&&(identical(other.existingAmountKopecks, existingAmountKopecks) || other.existingAmountKopecks == existingAmountKopecks)&&(identical(other.existingMerchantName, existingMerchantName) || other.existingMerchantName == existingMerchantName)&&(identical(other.selectedAction, selectedAction) || other.selectedAction == selectedAction));
}


@override
int get hashCode => Object.hash(runtimeType,id,importedRow,existingTransactionId,existingDate,existingAmountKopecks,existingMerchantName,selectedAction);

@override
String toString() {
  return 'HoldConfirmationCandidate(id: $id, importedRow: $importedRow, existingTransactionId: $existingTransactionId, existingDate: $existingDate, existingAmountKopecks: $existingAmountKopecks, existingMerchantName: $existingMerchantName, selectedAction: $selectedAction)';
}


}

/// @nodoc
abstract mixin class $HoldConfirmationCandidateCopyWith<$Res>  {
  factory $HoldConfirmationCandidateCopyWith(HoldConfirmationCandidate value, $Res Function(HoldConfirmationCandidate) _then) = _$HoldConfirmationCandidateCopyWithImpl;
@useResult
$Res call({
 String id, ParsedRow importedRow, String existingTransactionId, DateTime existingDate, int existingAmountKopecks, String? existingMerchantName, HoldAction selectedAction
});


$ParsedRowCopyWith<$Res> get importedRow;

}
/// @nodoc
class _$HoldConfirmationCandidateCopyWithImpl<$Res>
    implements $HoldConfirmationCandidateCopyWith<$Res> {
  _$HoldConfirmationCandidateCopyWithImpl(this._self, this._then);

  final HoldConfirmationCandidate _self;
  final $Res Function(HoldConfirmationCandidate) _then;

/// Create a copy of HoldConfirmationCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? importedRow = null,Object? existingTransactionId = null,Object? existingDate = null,Object? existingAmountKopecks = null,Object? existingMerchantName = freezed,Object? selectedAction = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,importedRow: null == importedRow ? _self.importedRow : importedRow // ignore: cast_nullable_to_non_nullable
as ParsedRow,existingTransactionId: null == existingTransactionId ? _self.existingTransactionId : existingTransactionId // ignore: cast_nullable_to_non_nullable
as String,existingDate: null == existingDate ? _self.existingDate : existingDate // ignore: cast_nullable_to_non_nullable
as DateTime,existingAmountKopecks: null == existingAmountKopecks ? _self.existingAmountKopecks : existingAmountKopecks // ignore: cast_nullable_to_non_nullable
as int,existingMerchantName: freezed == existingMerchantName ? _self.existingMerchantName : existingMerchantName // ignore: cast_nullable_to_non_nullable
as String?,selectedAction: null == selectedAction ? _self.selectedAction : selectedAction // ignore: cast_nullable_to_non_nullable
as HoldAction,
  ));
}
/// Create a copy of HoldConfirmationCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get importedRow {
  
  return $ParsedRowCopyWith<$Res>(_self.importedRow, (value) {
    return _then(_self.copyWith(importedRow: value));
  });
}
}


/// Adds pattern-matching-related methods to [HoldConfirmationCandidate].
extension HoldConfirmationCandidatePatterns on HoldConfirmationCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HoldConfirmationCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HoldConfirmationCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HoldConfirmationCandidate value)  $default,){
final _that = this;
switch (_that) {
case _HoldConfirmationCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HoldConfirmationCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _HoldConfirmationCandidate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _HoldConfirmationCandidate implements HoldConfirmationCandidate {
  const _HoldConfirmationCandidate({required this.id, required this.importedRow, required this.existingTransactionId, required this.existingDate, required this.existingAmountKopecks, required this.existingMerchantName, this.selectedAction = HoldAction.confirm});
  

@override final  String id;
@override final  ParsedRow importedRow;
@override final  String existingTransactionId;
@override final  DateTime existingDate;
@override final  int existingAmountKopecks;
@override final  String? existingMerchantName;
@override@JsonKey() final  HoldAction selectedAction;

/// Create a copy of HoldConfirmationCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldConfirmationCandidateCopyWith<_HoldConfirmationCandidate> get copyWith => __$HoldConfirmationCandidateCopyWithImpl<_HoldConfirmationCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HoldConfirmationCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.importedRow, importedRow) || other.importedRow == importedRow)&&(identical(other.existingTransactionId, existingTransactionId) || other.existingTransactionId == existingTransactionId)&&(identical(other.existingDate, existingDate) || other.existingDate == existingDate)&&(identical(other.existingAmountKopecks, existingAmountKopecks) || other.existingAmountKopecks == existingAmountKopecks)&&(identical(other.existingMerchantName, existingMerchantName) || other.existingMerchantName == existingMerchantName)&&(identical(other.selectedAction, selectedAction) || other.selectedAction == selectedAction));
}


@override
int get hashCode => Object.hash(runtimeType,id,importedRow,existingTransactionId,existingDate,existingAmountKopecks,existingMerchantName,selectedAction);

@override
String toString() {
  return 'HoldConfirmationCandidate(id: $id, importedRow: $importedRow, existingTransactionId: $existingTransactionId, existingDate: $existingDate, existingAmountKopecks: $existingAmountKopecks, existingMerchantName: $existingMerchantName, selectedAction: $selectedAction)';
}


}

/// @nodoc
abstract mixin class _$HoldConfirmationCandidateCopyWith<$Res> implements $HoldConfirmationCandidateCopyWith<$Res> {
  factory _$HoldConfirmationCandidateCopyWith(_HoldConfirmationCandidate value, $Res Function(_HoldConfirmationCandidate) _then) = __$HoldConfirmationCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, ParsedRow importedRow, String existingTransactionId, DateTime existingDate, int existingAmountKopecks, String? existingMerchantName, HoldAction selectedAction
});


@override $ParsedRowCopyWith<$Res> get importedRow;

}
/// @nodoc
class __$HoldConfirmationCandidateCopyWithImpl<$Res>
    implements _$HoldConfirmationCandidateCopyWith<$Res> {
  __$HoldConfirmationCandidateCopyWithImpl(this._self, this._then);

  final _HoldConfirmationCandidate _self;
  final $Res Function(_HoldConfirmationCandidate) _then;

/// Create a copy of HoldConfirmationCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? importedRow = null,Object? existingTransactionId = null,Object? existingDate = null,Object? existingAmountKopecks = null,Object? existingMerchantName = freezed,Object? selectedAction = null,}) {
  return _then(_HoldConfirmationCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,importedRow: null == importedRow ? _self.importedRow : importedRow // ignore: cast_nullable_to_non_nullable
as ParsedRow,existingTransactionId: null == existingTransactionId ? _self.existingTransactionId : existingTransactionId // ignore: cast_nullable_to_non_nullable
as String,existingDate: null == existingDate ? _self.existingDate : existingDate // ignore: cast_nullable_to_non_nullable
as DateTime,existingAmountKopecks: null == existingAmountKopecks ? _self.existingAmountKopecks : existingAmountKopecks // ignore: cast_nullable_to_non_nullable
as int,existingMerchantName: freezed == existingMerchantName ? _self.existingMerchantName : existingMerchantName // ignore: cast_nullable_to_non_nullable
as String?,selectedAction: null == selectedAction ? _self.selectedAction : selectedAction // ignore: cast_nullable_to_non_nullable
as HoldAction,
  ));
}

/// Create a copy of HoldConfirmationCandidate
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

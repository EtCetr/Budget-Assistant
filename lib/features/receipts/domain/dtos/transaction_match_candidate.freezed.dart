// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_match_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionMatchCandidate {

 String get id; DateTime get dateUtc; int get amountKop; String get auditStatus; bool get hasReceipt;
/// Create a copy of TransactionMatchCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionMatchCandidateCopyWith<TransactionMatchCandidate> get copyWith => _$TransactionMatchCandidateCopyWithImpl<TransactionMatchCandidate>(this as TransactionMatchCandidate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionMatchCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.dateUtc, dateUtc) || other.dateUtc == dateUtc)&&(identical(other.amountKop, amountKop) || other.amountKop == amountKop)&&(identical(other.auditStatus, auditStatus) || other.auditStatus == auditStatus)&&(identical(other.hasReceipt, hasReceipt) || other.hasReceipt == hasReceipt));
}


@override
int get hashCode => Object.hash(runtimeType,id,dateUtc,amountKop,auditStatus,hasReceipt);

@override
String toString() {
  return 'TransactionMatchCandidate(id: $id, dateUtc: $dateUtc, amountKop: $amountKop, auditStatus: $auditStatus, hasReceipt: $hasReceipt)';
}


}

/// @nodoc
abstract mixin class $TransactionMatchCandidateCopyWith<$Res>  {
  factory $TransactionMatchCandidateCopyWith(TransactionMatchCandidate value, $Res Function(TransactionMatchCandidate) _then) = _$TransactionMatchCandidateCopyWithImpl;
@useResult
$Res call({
 String id, DateTime dateUtc, int amountKop, String auditStatus, bool hasReceipt
});




}
/// @nodoc
class _$TransactionMatchCandidateCopyWithImpl<$Res>
    implements $TransactionMatchCandidateCopyWith<$Res> {
  _$TransactionMatchCandidateCopyWithImpl(this._self, this._then);

  final TransactionMatchCandidate _self;
  final $Res Function(TransactionMatchCandidate) _then;

/// Create a copy of TransactionMatchCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dateUtc = null,Object? amountKop = null,Object? auditStatus = null,Object? hasReceipt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dateUtc: null == dateUtc ? _self.dateUtc : dateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,amountKop: null == amountKop ? _self.amountKop : amountKop // ignore: cast_nullable_to_non_nullable
as int,auditStatus: null == auditStatus ? _self.auditStatus : auditStatus // ignore: cast_nullable_to_non_nullable
as String,hasReceipt: null == hasReceipt ? _self.hasReceipt : hasReceipt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionMatchCandidate].
extension TransactionMatchCandidatePatterns on TransactionMatchCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionMatchCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionMatchCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionMatchCandidate value)  $default,){
final _that = this;
switch (_that) {
case _TransactionMatchCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionMatchCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionMatchCandidate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionMatchCandidate implements TransactionMatchCandidate {
  const _TransactionMatchCandidate({required this.id, required this.dateUtc, required this.amountKop, required this.auditStatus, required this.hasReceipt});
  

@override final  String id;
@override final  DateTime dateUtc;
@override final  int amountKop;
@override final  String auditStatus;
@override final  bool hasReceipt;

/// Create a copy of TransactionMatchCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionMatchCandidateCopyWith<_TransactionMatchCandidate> get copyWith => __$TransactionMatchCandidateCopyWithImpl<_TransactionMatchCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionMatchCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.dateUtc, dateUtc) || other.dateUtc == dateUtc)&&(identical(other.amountKop, amountKop) || other.amountKop == amountKop)&&(identical(other.auditStatus, auditStatus) || other.auditStatus == auditStatus)&&(identical(other.hasReceipt, hasReceipt) || other.hasReceipt == hasReceipt));
}


@override
int get hashCode => Object.hash(runtimeType,id,dateUtc,amountKop,auditStatus,hasReceipt);

@override
String toString() {
  return 'TransactionMatchCandidate(id: $id, dateUtc: $dateUtc, amountKop: $amountKop, auditStatus: $auditStatus, hasReceipt: $hasReceipt)';
}


}

/// @nodoc
abstract mixin class _$TransactionMatchCandidateCopyWith<$Res> implements $TransactionMatchCandidateCopyWith<$Res> {
  factory _$TransactionMatchCandidateCopyWith(_TransactionMatchCandidate value, $Res Function(_TransactionMatchCandidate) _then) = __$TransactionMatchCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime dateUtc, int amountKop, String auditStatus, bool hasReceipt
});




}
/// @nodoc
class __$TransactionMatchCandidateCopyWithImpl<$Res>
    implements _$TransactionMatchCandidateCopyWith<$Res> {
  __$TransactionMatchCandidateCopyWithImpl(this._self, this._then);

  final _TransactionMatchCandidate _self;
  final $Res Function(_TransactionMatchCandidate) _then;

/// Create a copy of TransactionMatchCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dateUtc = null,Object? amountKop = null,Object? auditStatus = null,Object? hasReceipt = null,}) {
  return _then(_TransactionMatchCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dateUtc: null == dateUtc ? _self.dateUtc : dateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,amountKop: null == amountKop ? _self.amountKop : amountKop // ignore: cast_nullable_to_non_nullable
as int,auditStatus: null == auditStatus ? _self.auditStatus : auditStatus // ignore: cast_nullable_to_non_nullable
as String,hasReceipt: null == hasReceipt ? _self.hasReceipt : hasReceipt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

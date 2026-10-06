// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_match_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptMatchResult {

 MatchScenario get scenario; List<TransactionMatchCandidate> get autoCandidates; List<TransactionMatchCandidate> get pendingCandidates;
/// Create a copy of ReceiptMatchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptMatchResultCopyWith<ReceiptMatchResult> get copyWith => _$ReceiptMatchResultCopyWithImpl<ReceiptMatchResult>(this as ReceiptMatchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptMatchResult&&(identical(other.scenario, scenario) || other.scenario == scenario)&&const DeepCollectionEquality().equals(other.autoCandidates, autoCandidates)&&const DeepCollectionEquality().equals(other.pendingCandidates, pendingCandidates));
}


@override
int get hashCode => Object.hash(runtimeType,scenario,const DeepCollectionEquality().hash(autoCandidates),const DeepCollectionEquality().hash(pendingCandidates));

@override
String toString() {
  return 'ReceiptMatchResult(scenario: $scenario, autoCandidates: $autoCandidates, pendingCandidates: $pendingCandidates)';
}


}

/// @nodoc
abstract mixin class $ReceiptMatchResultCopyWith<$Res>  {
  factory $ReceiptMatchResultCopyWith(ReceiptMatchResult value, $Res Function(ReceiptMatchResult) _then) = _$ReceiptMatchResultCopyWithImpl;
@useResult
$Res call({
 MatchScenario scenario, List<TransactionMatchCandidate> autoCandidates, List<TransactionMatchCandidate> pendingCandidates
});




}
/// @nodoc
class _$ReceiptMatchResultCopyWithImpl<$Res>
    implements $ReceiptMatchResultCopyWith<$Res> {
  _$ReceiptMatchResultCopyWithImpl(this._self, this._then);

  final ReceiptMatchResult _self;
  final $Res Function(ReceiptMatchResult) _then;

/// Create a copy of ReceiptMatchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scenario = null,Object? autoCandidates = null,Object? pendingCandidates = null,}) {
  return _then(_self.copyWith(
scenario: null == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as MatchScenario,autoCandidates: null == autoCandidates ? _self.autoCandidates : autoCandidates // ignore: cast_nullable_to_non_nullable
as List<TransactionMatchCandidate>,pendingCandidates: null == pendingCandidates ? _self.pendingCandidates : pendingCandidates // ignore: cast_nullable_to_non_nullable
as List<TransactionMatchCandidate>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptMatchResult].
extension ReceiptMatchResultPatterns on ReceiptMatchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptMatchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptMatchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptMatchResult value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptMatchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptMatchResult value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptMatchResult() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptMatchResult implements ReceiptMatchResult {
  const _ReceiptMatchResult({required this.scenario, required final  List<TransactionMatchCandidate> autoCandidates, required final  List<TransactionMatchCandidate> pendingCandidates}): _autoCandidates = autoCandidates,_pendingCandidates = pendingCandidates;
  

@override final  MatchScenario scenario;
 final  List<TransactionMatchCandidate> _autoCandidates;
@override List<TransactionMatchCandidate> get autoCandidates {
  if (_autoCandidates is EqualUnmodifiableListView) return _autoCandidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_autoCandidates);
}

 final  List<TransactionMatchCandidate> _pendingCandidates;
@override List<TransactionMatchCandidate> get pendingCandidates {
  if (_pendingCandidates is EqualUnmodifiableListView) return _pendingCandidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingCandidates);
}


/// Create a copy of ReceiptMatchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptMatchResultCopyWith<_ReceiptMatchResult> get copyWith => __$ReceiptMatchResultCopyWithImpl<_ReceiptMatchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptMatchResult&&(identical(other.scenario, scenario) || other.scenario == scenario)&&const DeepCollectionEquality().equals(other._autoCandidates, _autoCandidates)&&const DeepCollectionEquality().equals(other._pendingCandidates, _pendingCandidates));
}


@override
int get hashCode => Object.hash(runtimeType,scenario,const DeepCollectionEquality().hash(_autoCandidates),const DeepCollectionEquality().hash(_pendingCandidates));

@override
String toString() {
  return 'ReceiptMatchResult(scenario: $scenario, autoCandidates: $autoCandidates, pendingCandidates: $pendingCandidates)';
}


}

/// @nodoc
abstract mixin class _$ReceiptMatchResultCopyWith<$Res> implements $ReceiptMatchResultCopyWith<$Res> {
  factory _$ReceiptMatchResultCopyWith(_ReceiptMatchResult value, $Res Function(_ReceiptMatchResult) _then) = __$ReceiptMatchResultCopyWithImpl;
@override @useResult
$Res call({
 MatchScenario scenario, List<TransactionMatchCandidate> autoCandidates, List<TransactionMatchCandidate> pendingCandidates
});




}
/// @nodoc
class __$ReceiptMatchResultCopyWithImpl<$Res>
    implements _$ReceiptMatchResultCopyWith<$Res> {
  __$ReceiptMatchResultCopyWithImpl(this._self, this._then);

  final _ReceiptMatchResult _self;
  final $Res Function(_ReceiptMatchResult) _then;

/// Create a copy of ReceiptMatchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scenario = null,Object? autoCandidates = null,Object? pendingCandidates = null,}) {
  return _then(_ReceiptMatchResult(
scenario: null == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as MatchScenario,autoCandidates: null == autoCandidates ? _self._autoCandidates : autoCandidates // ignore: cast_nullable_to_non_nullable
as List<TransactionMatchCandidate>,pendingCandidates: null == pendingCandidates ? _self._pendingCandidates : pendingCandidates // ignore: cast_nullable_to_non_nullable
as List<TransactionMatchCandidate>,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferCandidate {

 String get id; TransferScenario get scenario; ParsedRow get expenseRow; ParsedRow get incomeRow; int get amountKopecks; String get sourceAccountId; String get targetAccountId;/// Разница во времени (для отображения).
 Duration get timeDifference; TransferAction get selectedAction;
/// Create a copy of TransferCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferCandidateCopyWith<TransferCandidate> get copyWith => _$TransferCandidateCopyWithImpl<TransferCandidate>(this as TransferCandidate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.scenario, scenario) || other.scenario == scenario)&&(identical(other.expenseRow, expenseRow) || other.expenseRow == expenseRow)&&(identical(other.incomeRow, incomeRow) || other.incomeRow == incomeRow)&&(identical(other.amountKopecks, amountKopecks) || other.amountKopecks == amountKopecks)&&(identical(other.sourceAccountId, sourceAccountId) || other.sourceAccountId == sourceAccountId)&&(identical(other.targetAccountId, targetAccountId) || other.targetAccountId == targetAccountId)&&(identical(other.timeDifference, timeDifference) || other.timeDifference == timeDifference)&&(identical(other.selectedAction, selectedAction) || other.selectedAction == selectedAction));
}


@override
int get hashCode => Object.hash(runtimeType,id,scenario,expenseRow,incomeRow,amountKopecks,sourceAccountId,targetAccountId,timeDifference,selectedAction);

@override
String toString() {
  return 'TransferCandidate(id: $id, scenario: $scenario, expenseRow: $expenseRow, incomeRow: $incomeRow, amountKopecks: $amountKopecks, sourceAccountId: $sourceAccountId, targetAccountId: $targetAccountId, timeDifference: $timeDifference, selectedAction: $selectedAction)';
}


}

/// @nodoc
abstract mixin class $TransferCandidateCopyWith<$Res>  {
  factory $TransferCandidateCopyWith(TransferCandidate value, $Res Function(TransferCandidate) _then) = _$TransferCandidateCopyWithImpl;
@useResult
$Res call({
 String id, TransferScenario scenario, ParsedRow expenseRow, ParsedRow incomeRow, int amountKopecks, String sourceAccountId, String targetAccountId, Duration timeDifference, TransferAction selectedAction
});


$ParsedRowCopyWith<$Res> get expenseRow;$ParsedRowCopyWith<$Res> get incomeRow;

}
/// @nodoc
class _$TransferCandidateCopyWithImpl<$Res>
    implements $TransferCandidateCopyWith<$Res> {
  _$TransferCandidateCopyWithImpl(this._self, this._then);

  final TransferCandidate _self;
  final $Res Function(TransferCandidate) _then;

/// Create a copy of TransferCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scenario = null,Object? expenseRow = null,Object? incomeRow = null,Object? amountKopecks = null,Object? sourceAccountId = null,Object? targetAccountId = null,Object? timeDifference = null,Object? selectedAction = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scenario: null == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as TransferScenario,expenseRow: null == expenseRow ? _self.expenseRow : expenseRow // ignore: cast_nullable_to_non_nullable
as ParsedRow,incomeRow: null == incomeRow ? _self.incomeRow : incomeRow // ignore: cast_nullable_to_non_nullable
as ParsedRow,amountKopecks: null == amountKopecks ? _self.amountKopecks : amountKopecks // ignore: cast_nullable_to_non_nullable
as int,sourceAccountId: null == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String,targetAccountId: null == targetAccountId ? _self.targetAccountId : targetAccountId // ignore: cast_nullable_to_non_nullable
as String,timeDifference: null == timeDifference ? _self.timeDifference : timeDifference // ignore: cast_nullable_to_non_nullable
as Duration,selectedAction: null == selectedAction ? _self.selectedAction : selectedAction // ignore: cast_nullable_to_non_nullable
as TransferAction,
  ));
}
/// Create a copy of TransferCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get expenseRow {
  
  return $ParsedRowCopyWith<$Res>(_self.expenseRow, (value) {
    return _then(_self.copyWith(expenseRow: value));
  });
}/// Create a copy of TransferCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get incomeRow {
  
  return $ParsedRowCopyWith<$Res>(_self.incomeRow, (value) {
    return _then(_self.copyWith(incomeRow: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransferCandidate].
extension TransferCandidatePatterns on TransferCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferCandidate value)  $default,){
final _that = this;
switch (_that) {
case _TransferCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _TransferCandidate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransferCandidate implements TransferCandidate {
  const _TransferCandidate({required this.id, required this.scenario, required this.expenseRow, required this.incomeRow, required this.amountKopecks, required this.sourceAccountId, required this.targetAccountId, required this.timeDifference, this.selectedAction = TransferAction.merge});
  

@override final  String id;
@override final  TransferScenario scenario;
@override final  ParsedRow expenseRow;
@override final  ParsedRow incomeRow;
@override final  int amountKopecks;
@override final  String sourceAccountId;
@override final  String targetAccountId;
/// Разница во времени (для отображения).
@override final  Duration timeDifference;
@override@JsonKey() final  TransferAction selectedAction;

/// Create a copy of TransferCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferCandidateCopyWith<_TransferCandidate> get copyWith => __$TransferCandidateCopyWithImpl<_TransferCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.scenario, scenario) || other.scenario == scenario)&&(identical(other.expenseRow, expenseRow) || other.expenseRow == expenseRow)&&(identical(other.incomeRow, incomeRow) || other.incomeRow == incomeRow)&&(identical(other.amountKopecks, amountKopecks) || other.amountKopecks == amountKopecks)&&(identical(other.sourceAccountId, sourceAccountId) || other.sourceAccountId == sourceAccountId)&&(identical(other.targetAccountId, targetAccountId) || other.targetAccountId == targetAccountId)&&(identical(other.timeDifference, timeDifference) || other.timeDifference == timeDifference)&&(identical(other.selectedAction, selectedAction) || other.selectedAction == selectedAction));
}


@override
int get hashCode => Object.hash(runtimeType,id,scenario,expenseRow,incomeRow,amountKopecks,sourceAccountId,targetAccountId,timeDifference,selectedAction);

@override
String toString() {
  return 'TransferCandidate(id: $id, scenario: $scenario, expenseRow: $expenseRow, incomeRow: $incomeRow, amountKopecks: $amountKopecks, sourceAccountId: $sourceAccountId, targetAccountId: $targetAccountId, timeDifference: $timeDifference, selectedAction: $selectedAction)';
}


}

/// @nodoc
abstract mixin class _$TransferCandidateCopyWith<$Res> implements $TransferCandidateCopyWith<$Res> {
  factory _$TransferCandidateCopyWith(_TransferCandidate value, $Res Function(_TransferCandidate) _then) = __$TransferCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, TransferScenario scenario, ParsedRow expenseRow, ParsedRow incomeRow, int amountKopecks, String sourceAccountId, String targetAccountId, Duration timeDifference, TransferAction selectedAction
});


@override $ParsedRowCopyWith<$Res> get expenseRow;@override $ParsedRowCopyWith<$Res> get incomeRow;

}
/// @nodoc
class __$TransferCandidateCopyWithImpl<$Res>
    implements _$TransferCandidateCopyWith<$Res> {
  __$TransferCandidateCopyWithImpl(this._self, this._then);

  final _TransferCandidate _self;
  final $Res Function(_TransferCandidate) _then;

/// Create a copy of TransferCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scenario = null,Object? expenseRow = null,Object? incomeRow = null,Object? amountKopecks = null,Object? sourceAccountId = null,Object? targetAccountId = null,Object? timeDifference = null,Object? selectedAction = null,}) {
  return _then(_TransferCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scenario: null == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as TransferScenario,expenseRow: null == expenseRow ? _self.expenseRow : expenseRow // ignore: cast_nullable_to_non_nullable
as ParsedRow,incomeRow: null == incomeRow ? _self.incomeRow : incomeRow // ignore: cast_nullable_to_non_nullable
as ParsedRow,amountKopecks: null == amountKopecks ? _self.amountKopecks : amountKopecks // ignore: cast_nullable_to_non_nullable
as int,sourceAccountId: null == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String,targetAccountId: null == targetAccountId ? _self.targetAccountId : targetAccountId // ignore: cast_nullable_to_non_nullable
as String,timeDifference: null == timeDifference ? _self.timeDifference : timeDifference // ignore: cast_nullable_to_non_nullable
as Duration,selectedAction: null == selectedAction ? _self.selectedAction : selectedAction // ignore: cast_nullable_to_non_nullable
as TransferAction,
  ));
}

/// Create a copy of TransferCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get expenseRow {
  
  return $ParsedRowCopyWith<$Res>(_self.expenseRow, (value) {
    return _then(_self.copyWith(expenseRow: value));
  });
}/// Create a copy of TransferCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get incomeRow {
  
  return $ParsedRowCopyWith<$Res>(_self.incomeRow, (value) {
    return _then(_self.copyWith(incomeRow: value));
  });
}
}

// dart format on

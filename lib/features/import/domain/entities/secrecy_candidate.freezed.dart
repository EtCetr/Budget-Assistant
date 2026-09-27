// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'secrecy_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SecrecyCandidate {

 String get id; ParsedRow get transaction; String get relatedHolidayId; String get relatedHolidayName; DateTime get relatedHolidayDate;/// 0.0–1.0 от DetectGiftCandidateUseCase.
 double get confidence; bool get isSelectedByDefault;/// Категория, выбранная пользователем в UI.
 String? get selectedCategoryId;
/// Create a copy of SecrecyCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecrecyCandidateCopyWith<SecrecyCandidate> get copyWith => _$SecrecyCandidateCopyWithImpl<SecrecyCandidate>(this as SecrecyCandidate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecrecyCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.relatedHolidayId, relatedHolidayId) || other.relatedHolidayId == relatedHolidayId)&&(identical(other.relatedHolidayName, relatedHolidayName) || other.relatedHolidayName == relatedHolidayName)&&(identical(other.relatedHolidayDate, relatedHolidayDate) || other.relatedHolidayDate == relatedHolidayDate)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.isSelectedByDefault, isSelectedByDefault) || other.isSelectedByDefault == isSelectedByDefault)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId));
}


@override
int get hashCode => Object.hash(runtimeType,id,transaction,relatedHolidayId,relatedHolidayName,relatedHolidayDate,confidence,isSelectedByDefault,selectedCategoryId);

@override
String toString() {
  return 'SecrecyCandidate(id: $id, transaction: $transaction, relatedHolidayId: $relatedHolidayId, relatedHolidayName: $relatedHolidayName, relatedHolidayDate: $relatedHolidayDate, confidence: $confidence, isSelectedByDefault: $isSelectedByDefault, selectedCategoryId: $selectedCategoryId)';
}


}

/// @nodoc
abstract mixin class $SecrecyCandidateCopyWith<$Res>  {
  factory $SecrecyCandidateCopyWith(SecrecyCandidate value, $Res Function(SecrecyCandidate) _then) = _$SecrecyCandidateCopyWithImpl;
@useResult
$Res call({
 String id, ParsedRow transaction, String relatedHolidayId, String relatedHolidayName, DateTime relatedHolidayDate, double confidence, bool isSelectedByDefault, String? selectedCategoryId
});


$ParsedRowCopyWith<$Res> get transaction;

}
/// @nodoc
class _$SecrecyCandidateCopyWithImpl<$Res>
    implements $SecrecyCandidateCopyWith<$Res> {
  _$SecrecyCandidateCopyWithImpl(this._self, this._then);

  final SecrecyCandidate _self;
  final $Res Function(SecrecyCandidate) _then;

/// Create a copy of SecrecyCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transaction = null,Object? relatedHolidayId = null,Object? relatedHolidayName = null,Object? relatedHolidayDate = null,Object? confidence = null,Object? isSelectedByDefault = null,Object? selectedCategoryId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as ParsedRow,relatedHolidayId: null == relatedHolidayId ? _self.relatedHolidayId : relatedHolidayId // ignore: cast_nullable_to_non_nullable
as String,relatedHolidayName: null == relatedHolidayName ? _self.relatedHolidayName : relatedHolidayName // ignore: cast_nullable_to_non_nullable
as String,relatedHolidayDate: null == relatedHolidayDate ? _self.relatedHolidayDate : relatedHolidayDate // ignore: cast_nullable_to_non_nullable
as DateTime,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,isSelectedByDefault: null == isSelectedByDefault ? _self.isSelectedByDefault : isSelectedByDefault // ignore: cast_nullable_to_non_nullable
as bool,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SecrecyCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get transaction {
  
  return $ParsedRowCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [SecrecyCandidate].
extension SecrecyCandidatePatterns on SecrecyCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecrecyCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecrecyCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecrecyCandidate value)  $default,){
final _that = this;
switch (_that) {
case _SecrecyCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecrecyCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _SecrecyCandidate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _SecrecyCandidate implements SecrecyCandidate {
  const _SecrecyCandidate({required this.id, required this.transaction, required this.relatedHolidayId, required this.relatedHolidayName, required this.relatedHolidayDate, required this.confidence, this.isSelectedByDefault = true, this.selectedCategoryId});
  

@override final  String id;
@override final  ParsedRow transaction;
@override final  String relatedHolidayId;
@override final  String relatedHolidayName;
@override final  DateTime relatedHolidayDate;
/// 0.0–1.0 от DetectGiftCandidateUseCase.
@override final  double confidence;
@override@JsonKey() final  bool isSelectedByDefault;
/// Категория, выбранная пользователем в UI.
@override final  String? selectedCategoryId;

/// Create a copy of SecrecyCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecrecyCandidateCopyWith<_SecrecyCandidate> get copyWith => __$SecrecyCandidateCopyWithImpl<_SecrecyCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecrecyCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.relatedHolidayId, relatedHolidayId) || other.relatedHolidayId == relatedHolidayId)&&(identical(other.relatedHolidayName, relatedHolidayName) || other.relatedHolidayName == relatedHolidayName)&&(identical(other.relatedHolidayDate, relatedHolidayDate) || other.relatedHolidayDate == relatedHolidayDate)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.isSelectedByDefault, isSelectedByDefault) || other.isSelectedByDefault == isSelectedByDefault)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId));
}


@override
int get hashCode => Object.hash(runtimeType,id,transaction,relatedHolidayId,relatedHolidayName,relatedHolidayDate,confidence,isSelectedByDefault,selectedCategoryId);

@override
String toString() {
  return 'SecrecyCandidate(id: $id, transaction: $transaction, relatedHolidayId: $relatedHolidayId, relatedHolidayName: $relatedHolidayName, relatedHolidayDate: $relatedHolidayDate, confidence: $confidence, isSelectedByDefault: $isSelectedByDefault, selectedCategoryId: $selectedCategoryId)';
}


}

/// @nodoc
abstract mixin class _$SecrecyCandidateCopyWith<$Res> implements $SecrecyCandidateCopyWith<$Res> {
  factory _$SecrecyCandidateCopyWith(_SecrecyCandidate value, $Res Function(_SecrecyCandidate) _then) = __$SecrecyCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, ParsedRow transaction, String relatedHolidayId, String relatedHolidayName, DateTime relatedHolidayDate, double confidence, bool isSelectedByDefault, String? selectedCategoryId
});


@override $ParsedRowCopyWith<$Res> get transaction;

}
/// @nodoc
class __$SecrecyCandidateCopyWithImpl<$Res>
    implements _$SecrecyCandidateCopyWith<$Res> {
  __$SecrecyCandidateCopyWithImpl(this._self, this._then);

  final _SecrecyCandidate _self;
  final $Res Function(_SecrecyCandidate) _then;

/// Create a copy of SecrecyCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transaction = null,Object? relatedHolidayId = null,Object? relatedHolidayName = null,Object? relatedHolidayDate = null,Object? confidence = null,Object? isSelectedByDefault = null,Object? selectedCategoryId = freezed,}) {
  return _then(_SecrecyCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as ParsedRow,relatedHolidayId: null == relatedHolidayId ? _self.relatedHolidayId : relatedHolidayId // ignore: cast_nullable_to_non_nullable
as String,relatedHolidayName: null == relatedHolidayName ? _self.relatedHolidayName : relatedHolidayName // ignore: cast_nullable_to_non_nullable
as String,relatedHolidayDate: null == relatedHolidayDate ? _self.relatedHolidayDate : relatedHolidayDate // ignore: cast_nullable_to_non_nullable
as DateTime,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,isSelectedByDefault: null == isSelectedByDefault ? _self.isSelectedByDefault : isSelectedByDefault // ignore: cast_nullable_to_non_nullable
as bool,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SecrecyCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedRowCopyWith<$Res> get transaction {
  
  return $ParsedRowCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

// dart format on

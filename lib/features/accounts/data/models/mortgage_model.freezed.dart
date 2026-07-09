// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mortgage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MortgageModel {

 String get id; String get accountId; int get initialLoanAmount; int get propertyValue; int get interestRateBps; int get remainingTermMonths; int get monthlyPayment; DateTime? get nextPaymentDate; DateTime get createdAt; DateTime get updatedAt; String get syncStatus;
/// Create a copy of MortgageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MortgageModelCopyWith<MortgageModel> get copyWith => _$MortgageModelCopyWithImpl<MortgageModel>(this as MortgageModel, _$identity);

  /// Serializes this MortgageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MortgageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.initialLoanAmount, initialLoanAmount) || other.initialLoanAmount == initialLoanAmount)&&(identical(other.propertyValue, propertyValue) || other.propertyValue == propertyValue)&&(identical(other.interestRateBps, interestRateBps) || other.interestRateBps == interestRateBps)&&(identical(other.remainingTermMonths, remainingTermMonths) || other.remainingTermMonths == remainingTermMonths)&&(identical(other.monthlyPayment, monthlyPayment) || other.monthlyPayment == monthlyPayment)&&(identical(other.nextPaymentDate, nextPaymentDate) || other.nextPaymentDate == nextPaymentDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,initialLoanAmount,propertyValue,interestRateBps,remainingTermMonths,monthlyPayment,nextPaymentDate,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'MortgageModel(id: $id, accountId: $accountId, initialLoanAmount: $initialLoanAmount, propertyValue: $propertyValue, interestRateBps: $interestRateBps, remainingTermMonths: $remainingTermMonths, monthlyPayment: $monthlyPayment, nextPaymentDate: $nextPaymentDate, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $MortgageModelCopyWith<$Res>  {
  factory $MortgageModelCopyWith(MortgageModel value, $Res Function(MortgageModel) _then) = _$MortgageModelCopyWithImpl;
@useResult
$Res call({
 String id, String accountId, int initialLoanAmount, int propertyValue, int interestRateBps, int remainingTermMonths, int monthlyPayment, DateTime? nextPaymentDate, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class _$MortgageModelCopyWithImpl<$Res>
    implements $MortgageModelCopyWith<$Res> {
  _$MortgageModelCopyWithImpl(this._self, this._then);

  final MortgageModel _self;
  final $Res Function(MortgageModel) _then;

/// Create a copy of MortgageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? initialLoanAmount = null,Object? propertyValue = null,Object? interestRateBps = null,Object? remainingTermMonths = null,Object? monthlyPayment = null,Object? nextPaymentDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,initialLoanAmount: null == initialLoanAmount ? _self.initialLoanAmount : initialLoanAmount // ignore: cast_nullable_to_non_nullable
as int,propertyValue: null == propertyValue ? _self.propertyValue : propertyValue // ignore: cast_nullable_to_non_nullable
as int,interestRateBps: null == interestRateBps ? _self.interestRateBps : interestRateBps // ignore: cast_nullable_to_non_nullable
as int,remainingTermMonths: null == remainingTermMonths ? _self.remainingTermMonths : remainingTermMonths // ignore: cast_nullable_to_non_nullable
as int,monthlyPayment: null == monthlyPayment ? _self.monthlyPayment : monthlyPayment // ignore: cast_nullable_to_non_nullable
as int,nextPaymentDate: freezed == nextPaymentDate ? _self.nextPaymentDate : nextPaymentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MortgageModel].
extension MortgageModelPatterns on MortgageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MortgageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MortgageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MortgageModel value)  $default,){
final _that = this;
switch (_that) {
case _MortgageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MortgageModel value)?  $default,){
final _that = this;
switch (_that) {
case _MortgageModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MortgageModel implements MortgageModel {
  const _MortgageModel({required this.id, required this.accountId, required this.initialLoanAmount, required this.propertyValue, required this.interestRateBps, required this.remainingTermMonths, required this.monthlyPayment, this.nextPaymentDate, required this.createdAt, required this.updatedAt, this.syncStatus = 'pending'});
  factory _MortgageModel.fromJson(Map<String, dynamic> json) => _$MortgageModelFromJson(json);

@override final  String id;
@override final  String accountId;
@override final  int initialLoanAmount;
@override final  int propertyValue;
@override final  int interestRateBps;
@override final  int remainingTermMonths;
@override final  int monthlyPayment;
@override final  DateTime? nextPaymentDate;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String syncStatus;

/// Create a copy of MortgageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MortgageModelCopyWith<_MortgageModel> get copyWith => __$MortgageModelCopyWithImpl<_MortgageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MortgageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MortgageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.initialLoanAmount, initialLoanAmount) || other.initialLoanAmount == initialLoanAmount)&&(identical(other.propertyValue, propertyValue) || other.propertyValue == propertyValue)&&(identical(other.interestRateBps, interestRateBps) || other.interestRateBps == interestRateBps)&&(identical(other.remainingTermMonths, remainingTermMonths) || other.remainingTermMonths == remainingTermMonths)&&(identical(other.monthlyPayment, monthlyPayment) || other.monthlyPayment == monthlyPayment)&&(identical(other.nextPaymentDate, nextPaymentDate) || other.nextPaymentDate == nextPaymentDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,initialLoanAmount,propertyValue,interestRateBps,remainingTermMonths,monthlyPayment,nextPaymentDate,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'MortgageModel(id: $id, accountId: $accountId, initialLoanAmount: $initialLoanAmount, propertyValue: $propertyValue, interestRateBps: $interestRateBps, remainingTermMonths: $remainingTermMonths, monthlyPayment: $monthlyPayment, nextPaymentDate: $nextPaymentDate, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$MortgageModelCopyWith<$Res> implements $MortgageModelCopyWith<$Res> {
  factory _$MortgageModelCopyWith(_MortgageModel value, $Res Function(_MortgageModel) _then) = __$MortgageModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String accountId, int initialLoanAmount, int propertyValue, int interestRateBps, int remainingTermMonths, int monthlyPayment, DateTime? nextPaymentDate, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class __$MortgageModelCopyWithImpl<$Res>
    implements _$MortgageModelCopyWith<$Res> {
  __$MortgageModelCopyWithImpl(this._self, this._then);

  final _MortgageModel _self;
  final $Res Function(_MortgageModel) _then;

/// Create a copy of MortgageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? initialLoanAmount = null,Object? propertyValue = null,Object? interestRateBps = null,Object? remainingTermMonths = null,Object? monthlyPayment = null,Object? nextPaymentDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_MortgageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,initialLoanAmount: null == initialLoanAmount ? _self.initialLoanAmount : initialLoanAmount // ignore: cast_nullable_to_non_nullable
as int,propertyValue: null == propertyValue ? _self.propertyValue : propertyValue // ignore: cast_nullable_to_non_nullable
as int,interestRateBps: null == interestRateBps ? _self.interestRateBps : interestRateBps // ignore: cast_nullable_to_non_nullable
as int,remainingTermMonths: null == remainingTermMonths ? _self.remainingTermMonths : remainingTermMonths // ignore: cast_nullable_to_non_nullable
as int,monthlyPayment: null == monthlyPayment ? _self.monthlyPayment : monthlyPayment // ignore: cast_nullable_to_non_nullable
as int,nextPaymentDate: freezed == nextPaymentDate ? _self.nextPaymentDate : nextPaymentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

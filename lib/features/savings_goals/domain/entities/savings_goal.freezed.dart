// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavingsGoal {

 String get id; String get userId;/// NULL = личная цель, UUID = семейная (Multi-group).
 String? get spaceId; String get name;/// Копейки.
 int get targetAmount;/// Копейки. Строго read-only для UI: обновляется только через
/// UpdateSavingsGoalProgressUseCase.
 int get currentAmount; DateTime? get deadline;/// NULL = виртуальная цель.
 String? get linkedAccountId; String get currency;/// Копейки. Последняя сумма пополнения для автоподстановки.
 int? get draftAmount; bool get autoReminderEnabled; String get status; bool get isArchived;/// Момент первого достижения цели: одноразовое конфетти + дата в архиве.
 DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of SavingsGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsGoalCopyWith<SavingsGoal> get copyWith => _$SavingsGoalCopyWithImpl<SavingsGoal>(this as SavingsGoal, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.currentAmount, currentAmount) || other.currentAmount == currentAmount)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.draftAmount, draftAmount) || other.draftAmount == draftAmount)&&(identical(other.autoReminderEnabled, autoReminderEnabled) || other.autoReminderEnabled == autoReminderEnabled)&&(identical(other.status, status) || other.status == status)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,name,targetAmount,currentAmount,deadline,linkedAccountId,currency,draftAmount,autoReminderEnabled,status,isArchived,completedAt,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'SavingsGoal(id: $id, userId: $userId, spaceId: $spaceId, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, deadline: $deadline, linkedAccountId: $linkedAccountId, currency: $currency, draftAmount: $draftAmount, autoReminderEnabled: $autoReminderEnabled, status: $status, isArchived: $isArchived, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $SavingsGoalCopyWith<$Res>  {
  factory $SavingsGoalCopyWith(SavingsGoal value, $Res Function(SavingsGoal) _then) = _$SavingsGoalCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, String name, int targetAmount, int currentAmount, DateTime? deadline, String? linkedAccountId, String currency, int? draftAmount, bool autoReminderEnabled, String status, bool isArchived, DateTime? completedAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$SavingsGoalCopyWithImpl<$Res>
    implements $SavingsGoalCopyWith<$Res> {
  _$SavingsGoalCopyWithImpl(this._self, this._then);

  final SavingsGoal _self;
  final $Res Function(SavingsGoal) _then;

/// Create a copy of SavingsGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? name = null,Object? targetAmount = null,Object? currentAmount = null,Object? deadline = freezed,Object? linkedAccountId = freezed,Object? currency = null,Object? draftAmount = freezed,Object? autoReminderEnabled = null,Object? status = null,Object? isArchived = null,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,currentAmount: null == currentAmount ? _self.currentAmount : currentAmount // ignore: cast_nullable_to_non_nullable
as int,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,draftAmount: freezed == draftAmount ? _self.draftAmount : draftAmount // ignore: cast_nullable_to_non_nullable
as int?,autoReminderEnabled: null == autoReminderEnabled ? _self.autoReminderEnabled : autoReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingsGoal].
extension SavingsGoalPatterns on SavingsGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingsGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingsGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingsGoal value)  $default,){
final _that = this;
switch (_that) {
case _SavingsGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingsGoal value)?  $default,){
final _that = this;
switch (_that) {
case _SavingsGoal() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _SavingsGoal implements SavingsGoal {
  const _SavingsGoal({required this.id, required this.userId, this.spaceId, required this.name, required this.targetAmount, this.currentAmount = 0, this.deadline, this.linkedAccountId, required this.currency, this.draftAmount, this.autoReminderEnabled = true, this.status = SavingsGoalStatus.active, this.isArchived = false, this.completedAt, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  

@override final  String id;
@override final  String userId;
/// NULL = личная цель, UUID = семейная (Multi-group).
@override final  String? spaceId;
@override final  String name;
/// Копейки.
@override final  int targetAmount;
/// Копейки. Строго read-only для UI: обновляется только через
/// UpdateSavingsGoalProgressUseCase.
@override@JsonKey() final  int currentAmount;
@override final  DateTime? deadline;
/// NULL = виртуальная цель.
@override final  String? linkedAccountId;
@override final  String currency;
/// Копейки. Последняя сумма пополнения для автоподстановки.
@override final  int? draftAmount;
@override@JsonKey() final  bool autoReminderEnabled;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool isArchived;
/// Момент первого достижения цели: одноразовое конфетти + дата в архиве.
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of SavingsGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingsGoalCopyWith<_SavingsGoal> get copyWith => __$SavingsGoalCopyWithImpl<_SavingsGoal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingsGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.currentAmount, currentAmount) || other.currentAmount == currentAmount)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.draftAmount, draftAmount) || other.draftAmount == draftAmount)&&(identical(other.autoReminderEnabled, autoReminderEnabled) || other.autoReminderEnabled == autoReminderEnabled)&&(identical(other.status, status) || other.status == status)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,name,targetAmount,currentAmount,deadline,linkedAccountId,currency,draftAmount,autoReminderEnabled,status,isArchived,completedAt,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'SavingsGoal(id: $id, userId: $userId, spaceId: $spaceId, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, deadline: $deadline, linkedAccountId: $linkedAccountId, currency: $currency, draftAmount: $draftAmount, autoReminderEnabled: $autoReminderEnabled, status: $status, isArchived: $isArchived, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$SavingsGoalCopyWith<$Res> implements $SavingsGoalCopyWith<$Res> {
  factory _$SavingsGoalCopyWith(_SavingsGoal value, $Res Function(_SavingsGoal) _then) = __$SavingsGoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, String name, int targetAmount, int currentAmount, DateTime? deadline, String? linkedAccountId, String currency, int? draftAmount, bool autoReminderEnabled, String status, bool isArchived, DateTime? completedAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$SavingsGoalCopyWithImpl<$Res>
    implements _$SavingsGoalCopyWith<$Res> {
  __$SavingsGoalCopyWithImpl(this._self, this._then);

  final _SavingsGoal _self;
  final $Res Function(_SavingsGoal) _then;

/// Create a copy of SavingsGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? name = null,Object? targetAmount = null,Object? currentAmount = null,Object? deadline = freezed,Object? linkedAccountId = freezed,Object? currency = null,Object? draftAmount = freezed,Object? autoReminderEnabled = null,Object? status = null,Object? isArchived = null,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_SavingsGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,currentAmount: null == currentAmount ? _self.currentAmount : currentAmount // ignore: cast_nullable_to_non_nullable
as int,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,draftAmount: freezed == draftAmount ? _self.draftAmount : draftAmount // ignore: cast_nullable_to_non_nullable
as int?,autoReminderEnabled: null == autoReminderEnabled ? _self.autoReminderEnabled : autoReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

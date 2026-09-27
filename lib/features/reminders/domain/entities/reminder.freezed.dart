// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Reminder {

 String get id; String get userId;/// NULL = личное, UUID = семейное (Multi-group).
 String? get spaceId; String get title; String? get description;/// UTC.
 DateTime get remindAt;/// iCal RRULE строка (nullable = однократно).
 String? get recurrenceRule; bool get isCompleted;/// FK на memberships.id (НЕ users.id) — ТЗ 6.3.12.6.
 String? get assigneeId;/// Связь с регулярным платежом (без FK: циклическая ссылка).
 String? get linkedRecurringId; String? get linkedCategoryId; String? get linkedAccountId;/// Копейки.
 int? get expectedAmount; String get priority; int get snoozeCount;/// [LOCAL] JSON-массив истории откладываний, не синхронизируется.
 String? get snoozeHistory; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderCopyWith<Reminder> get copyWith => _$ReminderCopyWithImpl<Reminder>(this as Reminder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.remindAt, remindAt) || other.remindAt == remindAt)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.linkedRecurringId, linkedRecurringId) || other.linkedRecurringId == linkedRecurringId)&&(identical(other.linkedCategoryId, linkedCategoryId) || other.linkedCategoryId == linkedCategoryId)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.snoozeCount, snoozeCount) || other.snoozeCount == snoozeCount)&&(identical(other.snoozeHistory, snoozeHistory) || other.snoozeHistory == snoozeHistory)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,userId,spaceId,title,description,remindAt,recurrenceRule,isCompleted,assigneeId,linkedRecurringId,linkedCategoryId,linkedAccountId,expectedAmount,priority,snoozeCount,snoozeHistory,completedAt,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'Reminder(id: $id, userId: $userId, spaceId: $spaceId, title: $title, description: $description, remindAt: $remindAt, recurrenceRule: $recurrenceRule, isCompleted: $isCompleted, assigneeId: $assigneeId, linkedRecurringId: $linkedRecurringId, linkedCategoryId: $linkedCategoryId, linkedAccountId: $linkedAccountId, expectedAmount: $expectedAmount, priority: $priority, snoozeCount: $snoozeCount, snoozeHistory: $snoozeHistory, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $ReminderCopyWith<$Res>  {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) _then) = _$ReminderCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, String title, String? description, DateTime remindAt, String? recurrenceRule, bool isCompleted, String? assigneeId, String? linkedRecurringId, String? linkedCategoryId, String? linkedAccountId, int? expectedAmount, String priority, int snoozeCount, String? snoozeHistory, DateTime? completedAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$ReminderCopyWithImpl<$Res>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._self, this._then);

  final Reminder _self;
  final $Res Function(Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? title = null,Object? description = freezed,Object? remindAt = null,Object? recurrenceRule = freezed,Object? isCompleted = null,Object? assigneeId = freezed,Object? linkedRecurringId = freezed,Object? linkedCategoryId = freezed,Object? linkedAccountId = freezed,Object? expectedAmount = freezed,Object? priority = null,Object? snoozeCount = null,Object? snoozeHistory = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,remindAt: null == remindAt ? _self.remindAt : remindAt // ignore: cast_nullable_to_non_nullable
as DateTime,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,linkedRecurringId: freezed == linkedRecurringId ? _self.linkedRecurringId : linkedRecurringId // ignore: cast_nullable_to_non_nullable
as String?,linkedCategoryId: freezed == linkedCategoryId ? _self.linkedCategoryId : linkedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,expectedAmount: freezed == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,snoozeCount: null == snoozeCount ? _self.snoozeCount : snoozeCount // ignore: cast_nullable_to_non_nullable
as int,snoozeHistory: freezed == snoozeHistory ? _self.snoozeHistory : snoozeHistory // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Reminder].
extension ReminderPatterns on Reminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reminder value)  $default,){
final _that = this;
switch (_that) {
case _Reminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reminder value)?  $default,){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _Reminder implements Reminder {
  const _Reminder({required this.id, required this.userId, this.spaceId, required this.title, this.description, required this.remindAt, this.recurrenceRule, this.isCompleted = false, this.assigneeId, this.linkedRecurringId, this.linkedCategoryId, this.linkedAccountId, this.expectedAmount, this.priority = ReminderPriority.normal, this.snoozeCount = 0, this.snoozeHistory, this.completedAt, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  

@override final  String id;
@override final  String userId;
/// NULL = личное, UUID = семейное (Multi-group).
@override final  String? spaceId;
@override final  String title;
@override final  String? description;
/// UTC.
@override final  DateTime remindAt;
/// iCal RRULE строка (nullable = однократно).
@override final  String? recurrenceRule;
@override@JsonKey() final  bool isCompleted;
/// FK на memberships.id (НЕ users.id) — ТЗ 6.3.12.6.
@override final  String? assigneeId;
/// Связь с регулярным платежом (без FK: циклическая ссылка).
@override final  String? linkedRecurringId;
@override final  String? linkedCategoryId;
@override final  String? linkedAccountId;
/// Копейки.
@override final  int? expectedAmount;
@override@JsonKey() final  String priority;
@override@JsonKey() final  int snoozeCount;
/// [LOCAL] JSON-массив истории откладываний, не синхронизируется.
@override final  String? snoozeHistory;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderCopyWith<_Reminder> get copyWith => __$ReminderCopyWithImpl<_Reminder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.remindAt, remindAt) || other.remindAt == remindAt)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.linkedRecurringId, linkedRecurringId) || other.linkedRecurringId == linkedRecurringId)&&(identical(other.linkedCategoryId, linkedCategoryId) || other.linkedCategoryId == linkedCategoryId)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.snoozeCount, snoozeCount) || other.snoozeCount == snoozeCount)&&(identical(other.snoozeHistory, snoozeHistory) || other.snoozeHistory == snoozeHistory)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,userId,spaceId,title,description,remindAt,recurrenceRule,isCompleted,assigneeId,linkedRecurringId,linkedCategoryId,linkedAccountId,expectedAmount,priority,snoozeCount,snoozeHistory,completedAt,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'Reminder(id: $id, userId: $userId, spaceId: $spaceId, title: $title, description: $description, remindAt: $remindAt, recurrenceRule: $recurrenceRule, isCompleted: $isCompleted, assigneeId: $assigneeId, linkedRecurringId: $linkedRecurringId, linkedCategoryId: $linkedCategoryId, linkedAccountId: $linkedAccountId, expectedAmount: $expectedAmount, priority: $priority, snoozeCount: $snoozeCount, snoozeHistory: $snoozeHistory, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$ReminderCopyWith<$Res> implements $ReminderCopyWith<$Res> {
  factory _$ReminderCopyWith(_Reminder value, $Res Function(_Reminder) _then) = __$ReminderCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, String title, String? description, DateTime remindAt, String? recurrenceRule, bool isCompleted, String? assigneeId, String? linkedRecurringId, String? linkedCategoryId, String? linkedAccountId, int? expectedAmount, String priority, int snoozeCount, String? snoozeHistory, DateTime? completedAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$ReminderCopyWithImpl<$Res>
    implements _$ReminderCopyWith<$Res> {
  __$ReminderCopyWithImpl(this._self, this._then);

  final _Reminder _self;
  final $Res Function(_Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? title = null,Object? description = freezed,Object? remindAt = null,Object? recurrenceRule = freezed,Object? isCompleted = null,Object? assigneeId = freezed,Object? linkedRecurringId = freezed,Object? linkedCategoryId = freezed,Object? linkedAccountId = freezed,Object? expectedAmount = freezed,Object? priority = null,Object? snoozeCount = null,Object? snoozeHistory = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_Reminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,remindAt: null == remindAt ? _self.remindAt : remindAt // ignore: cast_nullable_to_non_nullable
as DateTime,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,linkedRecurringId: freezed == linkedRecurringId ? _self.linkedRecurringId : linkedRecurringId // ignore: cast_nullable_to_non_nullable
as String?,linkedCategoryId: freezed == linkedCategoryId ? _self.linkedCategoryId : linkedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,expectedAmount: freezed == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,snoozeCount: null == snoozeCount ? _self.snoozeCount : snoozeCount // ignore: cast_nullable_to_non_nullable
as int,snoozeHistory: freezed == snoozeHistory ? _self.snoozeHistory : snoozeHistory // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

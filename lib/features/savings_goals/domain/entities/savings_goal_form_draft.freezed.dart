// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_goal_form_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsGoalFormDraft {

/// null при создании, id цели при редактировании.
 String? get goalId; String get name;/// Эмодзи хранится отдельно в форме, в БД склеивается с названием.
 String get emoji;/// Копейки.
 int? get targetAmount; String? get currency; DateTime? get deadline;/// 'virtual' | 'linked'.
 String get goalType; String? get linkedAccountId; bool get autoReminderEnabled;/// 'personal' | 'family'.
 String get visibility; DateTime get updatedAt;
/// Create a copy of SavingsGoalFormDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsGoalFormDraftCopyWith<SavingsGoalFormDraft> get copyWith => _$SavingsGoalFormDraftCopyWithImpl<SavingsGoalFormDraft>(this as SavingsGoalFormDraft, _$identity);

  /// Serializes this SavingsGoalFormDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsGoalFormDraft&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.autoReminderEnabled, autoReminderEnabled) || other.autoReminderEnabled == autoReminderEnabled)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,goalId,name,emoji,targetAmount,currency,deadline,goalType,linkedAccountId,autoReminderEnabled,visibility,updatedAt);

@override
String toString() {
  return 'SavingsGoalFormDraft(goalId: $goalId, name: $name, emoji: $emoji, targetAmount: $targetAmount, currency: $currency, deadline: $deadline, goalType: $goalType, linkedAccountId: $linkedAccountId, autoReminderEnabled: $autoReminderEnabled, visibility: $visibility, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SavingsGoalFormDraftCopyWith<$Res>  {
  factory $SavingsGoalFormDraftCopyWith(SavingsGoalFormDraft value, $Res Function(SavingsGoalFormDraft) _then) = _$SavingsGoalFormDraftCopyWithImpl;
@useResult
$Res call({
 String? goalId, String name, String emoji, int? targetAmount, String? currency, DateTime? deadline, String goalType, String? linkedAccountId, bool autoReminderEnabled, String visibility, DateTime updatedAt
});




}
/// @nodoc
class _$SavingsGoalFormDraftCopyWithImpl<$Res>
    implements $SavingsGoalFormDraftCopyWith<$Res> {
  _$SavingsGoalFormDraftCopyWithImpl(this._self, this._then);

  final SavingsGoalFormDraft _self;
  final $Res Function(SavingsGoalFormDraft) _then;

/// Create a copy of SavingsGoalFormDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goalId = freezed,Object? name = null,Object? emoji = null,Object? targetAmount = freezed,Object? currency = freezed,Object? deadline = freezed,Object? goalType = null,Object? linkedAccountId = freezed,Object? autoReminderEnabled = null,Object? visibility = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
goalId: freezed == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,targetAmount: freezed == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,goalType: null == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,autoReminderEnabled: null == autoReminderEnabled ? _self.autoReminderEnabled : autoReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingsGoalFormDraft].
extension SavingsGoalFormDraftPatterns on SavingsGoalFormDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingsGoalFormDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingsGoalFormDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingsGoalFormDraft value)  $default,){
final _that = this;
switch (_that) {
case _SavingsGoalFormDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingsGoalFormDraft value)?  $default,){
final _that = this;
switch (_that) {
case _SavingsGoalFormDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingsGoalFormDraft implements SavingsGoalFormDraft {
  const _SavingsGoalFormDraft({this.goalId, this.name = '', this.emoji = '', this.targetAmount, this.currency, this.deadline, this.goalType = 'virtual', this.linkedAccountId, this.autoReminderEnabled = true, this.visibility = 'personal', required this.updatedAt});
  factory _SavingsGoalFormDraft.fromJson(Map<String, dynamic> json) => _$SavingsGoalFormDraftFromJson(json);

/// null при создании, id цели при редактировании.
@override final  String? goalId;
@override@JsonKey() final  String name;
/// Эмодзи хранится отдельно в форме, в БД склеивается с названием.
@override@JsonKey() final  String emoji;
/// Копейки.
@override final  int? targetAmount;
@override final  String? currency;
@override final  DateTime? deadline;
/// 'virtual' | 'linked'.
@override@JsonKey() final  String goalType;
@override final  String? linkedAccountId;
@override@JsonKey() final  bool autoReminderEnabled;
/// 'personal' | 'family'.
@override@JsonKey() final  String visibility;
@override final  DateTime updatedAt;

/// Create a copy of SavingsGoalFormDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingsGoalFormDraftCopyWith<_SavingsGoalFormDraft> get copyWith => __$SavingsGoalFormDraftCopyWithImpl<_SavingsGoalFormDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingsGoalFormDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingsGoalFormDraft&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.autoReminderEnabled, autoReminderEnabled) || other.autoReminderEnabled == autoReminderEnabled)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,goalId,name,emoji,targetAmount,currency,deadline,goalType,linkedAccountId,autoReminderEnabled,visibility,updatedAt);

@override
String toString() {
  return 'SavingsGoalFormDraft(goalId: $goalId, name: $name, emoji: $emoji, targetAmount: $targetAmount, currency: $currency, deadline: $deadline, goalType: $goalType, linkedAccountId: $linkedAccountId, autoReminderEnabled: $autoReminderEnabled, visibility: $visibility, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SavingsGoalFormDraftCopyWith<$Res> implements $SavingsGoalFormDraftCopyWith<$Res> {
  factory _$SavingsGoalFormDraftCopyWith(_SavingsGoalFormDraft value, $Res Function(_SavingsGoalFormDraft) _then) = __$SavingsGoalFormDraftCopyWithImpl;
@override @useResult
$Res call({
 String? goalId, String name, String emoji, int? targetAmount, String? currency, DateTime? deadline, String goalType, String? linkedAccountId, bool autoReminderEnabled, String visibility, DateTime updatedAt
});




}
/// @nodoc
class __$SavingsGoalFormDraftCopyWithImpl<$Res>
    implements _$SavingsGoalFormDraftCopyWith<$Res> {
  __$SavingsGoalFormDraftCopyWithImpl(this._self, this._then);

  final _SavingsGoalFormDraft _self;
  final $Res Function(_SavingsGoalFormDraft) _then;

/// Create a copy of SavingsGoalFormDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goalId = freezed,Object? name = null,Object? emoji = null,Object? targetAmount = freezed,Object? currency = freezed,Object? deadline = freezed,Object? goalType = null,Object? linkedAccountId = freezed,Object? autoReminderEnabled = null,Object? visibility = null,Object? updatedAt = null,}) {
  return _then(_SavingsGoalFormDraft(
goalId: freezed == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,targetAmount: freezed == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,goalType: null == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,autoReminderEnabled: null == autoReminderEnabled ? _self.autoReminderEnabled : autoReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

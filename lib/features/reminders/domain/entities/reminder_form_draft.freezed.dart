// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_form_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderFormDraft {

 String? get reminderId; String get title; String? get description; DateTime? get remindAt; String? get recurrenceRule; int? get expectedAmountKopecks; String get currency; String? get linkedCategoryId; String? get linkedAccountId; String? get linkedRecurringId; String get priority; String get scope; String? get assigneeId; bool get autoCompleteOnPayment;
/// Create a copy of ReminderFormDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderFormDraftCopyWith<ReminderFormDraft> get copyWith => _$ReminderFormDraftCopyWithImpl<ReminderFormDraft>(this as ReminderFormDraft, _$identity);

  /// Serializes this ReminderFormDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderFormDraft&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.remindAt, remindAt) || other.remindAt == remindAt)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.expectedAmountKopecks, expectedAmountKopecks) || other.expectedAmountKopecks == expectedAmountKopecks)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.linkedCategoryId, linkedCategoryId) || other.linkedCategoryId == linkedCategoryId)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.linkedRecurringId, linkedRecurringId) || other.linkedRecurringId == linkedRecurringId)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.autoCompleteOnPayment, autoCompleteOnPayment) || other.autoCompleteOnPayment == autoCompleteOnPayment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reminderId,title,description,remindAt,recurrenceRule,expectedAmountKopecks,currency,linkedCategoryId,linkedAccountId,linkedRecurringId,priority,scope,assigneeId,autoCompleteOnPayment);

@override
String toString() {
  return 'ReminderFormDraft(reminderId: $reminderId, title: $title, description: $description, remindAt: $remindAt, recurrenceRule: $recurrenceRule, expectedAmountKopecks: $expectedAmountKopecks, currency: $currency, linkedCategoryId: $linkedCategoryId, linkedAccountId: $linkedAccountId, linkedRecurringId: $linkedRecurringId, priority: $priority, scope: $scope, assigneeId: $assigneeId, autoCompleteOnPayment: $autoCompleteOnPayment)';
}


}

/// @nodoc
abstract mixin class $ReminderFormDraftCopyWith<$Res>  {
  factory $ReminderFormDraftCopyWith(ReminderFormDraft value, $Res Function(ReminderFormDraft) _then) = _$ReminderFormDraftCopyWithImpl;
@useResult
$Res call({
 String? reminderId, String title, String? description, DateTime? remindAt, String? recurrenceRule, int? expectedAmountKopecks, String currency, String? linkedCategoryId, String? linkedAccountId, String? linkedRecurringId, String priority, String scope, String? assigneeId, bool autoCompleteOnPayment
});




}
/// @nodoc
class _$ReminderFormDraftCopyWithImpl<$Res>
    implements $ReminderFormDraftCopyWith<$Res> {
  _$ReminderFormDraftCopyWithImpl(this._self, this._then);

  final ReminderFormDraft _self;
  final $Res Function(ReminderFormDraft) _then;

/// Create a copy of ReminderFormDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reminderId = freezed,Object? title = null,Object? description = freezed,Object? remindAt = freezed,Object? recurrenceRule = freezed,Object? expectedAmountKopecks = freezed,Object? currency = null,Object? linkedCategoryId = freezed,Object? linkedAccountId = freezed,Object? linkedRecurringId = freezed,Object? priority = null,Object? scope = null,Object? assigneeId = freezed,Object? autoCompleteOnPayment = null,}) {
  return _then(_self.copyWith(
reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,remindAt: freezed == remindAt ? _self.remindAt : remindAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,expectedAmountKopecks: freezed == expectedAmountKopecks ? _self.expectedAmountKopecks : expectedAmountKopecks // ignore: cast_nullable_to_non_nullable
as int?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,linkedCategoryId: freezed == linkedCategoryId ? _self.linkedCategoryId : linkedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,linkedRecurringId: freezed == linkedRecurringId ? _self.linkedRecurringId : linkedRecurringId // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,autoCompleteOnPayment: null == autoCompleteOnPayment ? _self.autoCompleteOnPayment : autoCompleteOnPayment // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderFormDraft].
extension ReminderFormDraftPatterns on ReminderFormDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderFormDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderFormDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderFormDraft value)  $default,){
final _that = this;
switch (_that) {
case _ReminderFormDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderFormDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderFormDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderFormDraft implements ReminderFormDraft {
  const _ReminderFormDraft({this.reminderId, this.title = '', this.description, this.remindAt, this.recurrenceRule, this.expectedAmountKopecks, this.currency = 'RUB', this.linkedCategoryId, this.linkedAccountId, this.linkedRecurringId, this.priority = 'normal', this.scope = 'personal', this.assigneeId, this.autoCompleteOnPayment = true});
  factory _ReminderFormDraft.fromJson(Map<String, dynamic> json) => _$ReminderFormDraftFromJson(json);

@override final  String? reminderId;
@override@JsonKey() final  String title;
@override final  String? description;
@override final  DateTime? remindAt;
@override final  String? recurrenceRule;
@override final  int? expectedAmountKopecks;
@override@JsonKey() final  String currency;
@override final  String? linkedCategoryId;
@override final  String? linkedAccountId;
@override final  String? linkedRecurringId;
@override@JsonKey() final  String priority;
@override@JsonKey() final  String scope;
@override final  String? assigneeId;
@override@JsonKey() final  bool autoCompleteOnPayment;

/// Create a copy of ReminderFormDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderFormDraftCopyWith<_ReminderFormDraft> get copyWith => __$ReminderFormDraftCopyWithImpl<_ReminderFormDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderFormDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderFormDraft&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.remindAt, remindAt) || other.remindAt == remindAt)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.expectedAmountKopecks, expectedAmountKopecks) || other.expectedAmountKopecks == expectedAmountKopecks)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.linkedCategoryId, linkedCategoryId) || other.linkedCategoryId == linkedCategoryId)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.linkedRecurringId, linkedRecurringId) || other.linkedRecurringId == linkedRecurringId)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.autoCompleteOnPayment, autoCompleteOnPayment) || other.autoCompleteOnPayment == autoCompleteOnPayment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reminderId,title,description,remindAt,recurrenceRule,expectedAmountKopecks,currency,linkedCategoryId,linkedAccountId,linkedRecurringId,priority,scope,assigneeId,autoCompleteOnPayment);

@override
String toString() {
  return 'ReminderFormDraft(reminderId: $reminderId, title: $title, description: $description, remindAt: $remindAt, recurrenceRule: $recurrenceRule, expectedAmountKopecks: $expectedAmountKopecks, currency: $currency, linkedCategoryId: $linkedCategoryId, linkedAccountId: $linkedAccountId, linkedRecurringId: $linkedRecurringId, priority: $priority, scope: $scope, assigneeId: $assigneeId, autoCompleteOnPayment: $autoCompleteOnPayment)';
}


}

/// @nodoc
abstract mixin class _$ReminderFormDraftCopyWith<$Res> implements $ReminderFormDraftCopyWith<$Res> {
  factory _$ReminderFormDraftCopyWith(_ReminderFormDraft value, $Res Function(_ReminderFormDraft) _then) = __$ReminderFormDraftCopyWithImpl;
@override @useResult
$Res call({
 String? reminderId, String title, String? description, DateTime? remindAt, String? recurrenceRule, int? expectedAmountKopecks, String currency, String? linkedCategoryId, String? linkedAccountId, String? linkedRecurringId, String priority, String scope, String? assigneeId, bool autoCompleteOnPayment
});




}
/// @nodoc
class __$ReminderFormDraftCopyWithImpl<$Res>
    implements _$ReminderFormDraftCopyWith<$Res> {
  __$ReminderFormDraftCopyWithImpl(this._self, this._then);

  final _ReminderFormDraft _self;
  final $Res Function(_ReminderFormDraft) _then;

/// Create a copy of ReminderFormDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reminderId = freezed,Object? title = null,Object? description = freezed,Object? remindAt = freezed,Object? recurrenceRule = freezed,Object? expectedAmountKopecks = freezed,Object? currency = null,Object? linkedCategoryId = freezed,Object? linkedAccountId = freezed,Object? linkedRecurringId = freezed,Object? priority = null,Object? scope = null,Object? assigneeId = freezed,Object? autoCompleteOnPayment = null,}) {
  return _then(_ReminderFormDraft(
reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,remindAt: freezed == remindAt ? _self.remindAt : remindAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,expectedAmountKopecks: freezed == expectedAmountKopecks ? _self.expectedAmountKopecks : expectedAmountKopecks // ignore: cast_nullable_to_non_nullable
as int?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,linkedCategoryId: freezed == linkedCategoryId ? _self.linkedCategoryId : linkedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,linkedRecurringId: freezed == linkedRecurringId ? _self.linkedRecurringId : linkedRecurringId // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,autoCompleteOnPayment: null == autoCompleteOnPayment ? _self.autoCompleteOnPayment : autoCompleteOnPayment // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

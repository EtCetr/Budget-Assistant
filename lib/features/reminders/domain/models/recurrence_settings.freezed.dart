// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurrenceSettings {

 RecurrenceFreq get freq; int get interval;/// 1..7 = Пн..Вс (DateTime.monday..sunday).
 List<int> get byWeekday;/// 1..31 для monthly/yearly.
 int? get byMonthDay;/// 1..12 для yearly.
 int? get byMonth; DateTime? get until;
/// Create a copy of RecurrenceSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurrenceSettingsCopyWith<RecurrenceSettings> get copyWith => _$RecurrenceSettingsCopyWithImpl<RecurrenceSettings>(this as RecurrenceSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurrenceSettings&&(identical(other.freq, freq) || other.freq == freq)&&(identical(other.interval, interval) || other.interval == interval)&&const DeepCollectionEquality().equals(other.byWeekday, byWeekday)&&(identical(other.byMonthDay, byMonthDay) || other.byMonthDay == byMonthDay)&&(identical(other.byMonth, byMonth) || other.byMonth == byMonth)&&(identical(other.until, until) || other.until == until));
}


@override
int get hashCode => Object.hash(runtimeType,freq,interval,const DeepCollectionEquality().hash(byWeekday),byMonthDay,byMonth,until);

@override
String toString() {
  return 'RecurrenceSettings(freq: $freq, interval: $interval, byWeekday: $byWeekday, byMonthDay: $byMonthDay, byMonth: $byMonth, until: $until)';
}


}

/// @nodoc
abstract mixin class $RecurrenceSettingsCopyWith<$Res>  {
  factory $RecurrenceSettingsCopyWith(RecurrenceSettings value, $Res Function(RecurrenceSettings) _then) = _$RecurrenceSettingsCopyWithImpl;
@useResult
$Res call({
 RecurrenceFreq freq, int interval, List<int> byWeekday, int? byMonthDay, int? byMonth, DateTime? until
});




}
/// @nodoc
class _$RecurrenceSettingsCopyWithImpl<$Res>
    implements $RecurrenceSettingsCopyWith<$Res> {
  _$RecurrenceSettingsCopyWithImpl(this._self, this._then);

  final RecurrenceSettings _self;
  final $Res Function(RecurrenceSettings) _then;

/// Create a copy of RecurrenceSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? freq = null,Object? interval = null,Object? byWeekday = null,Object? byMonthDay = freezed,Object? byMonth = freezed,Object? until = freezed,}) {
  return _then(_self.copyWith(
freq: null == freq ? _self.freq : freq // ignore: cast_nullable_to_non_nullable
as RecurrenceFreq,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,byWeekday: null == byWeekday ? _self.byWeekday : byWeekday // ignore: cast_nullable_to_non_nullable
as List<int>,byMonthDay: freezed == byMonthDay ? _self.byMonthDay : byMonthDay // ignore: cast_nullable_to_non_nullable
as int?,byMonth: freezed == byMonth ? _self.byMonth : byMonth // ignore: cast_nullable_to_non_nullable
as int?,until: freezed == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurrenceSettings].
extension RecurrenceSettingsPatterns on RecurrenceSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurrenceSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurrenceSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurrenceSettings value)  $default,){
final _that = this;
switch (_that) {
case _RecurrenceSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurrenceSettings value)?  $default,){
final _that = this;
switch (_that) {
case _RecurrenceSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _RecurrenceSettings implements RecurrenceSettings {
  const _RecurrenceSettings({this.freq = RecurrenceFreq.weekly, this.interval = 1, final  List<int> byWeekday = const <int>[], this.byMonthDay, this.byMonth, this.until}): _byWeekday = byWeekday;
  

@override@JsonKey() final  RecurrenceFreq freq;
@override@JsonKey() final  int interval;
/// 1..7 = Пн..Вс (DateTime.monday..sunday).
 final  List<int> _byWeekday;
/// 1..7 = Пн..Вс (DateTime.monday..sunday).
@override@JsonKey() List<int> get byWeekday {
  if (_byWeekday is EqualUnmodifiableListView) return _byWeekday;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byWeekday);
}

/// 1..31 для monthly/yearly.
@override final  int? byMonthDay;
/// 1..12 для yearly.
@override final  int? byMonth;
@override final  DateTime? until;

/// Create a copy of RecurrenceSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurrenceSettingsCopyWith<_RecurrenceSettings> get copyWith => __$RecurrenceSettingsCopyWithImpl<_RecurrenceSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurrenceSettings&&(identical(other.freq, freq) || other.freq == freq)&&(identical(other.interval, interval) || other.interval == interval)&&const DeepCollectionEquality().equals(other._byWeekday, _byWeekday)&&(identical(other.byMonthDay, byMonthDay) || other.byMonthDay == byMonthDay)&&(identical(other.byMonth, byMonth) || other.byMonth == byMonth)&&(identical(other.until, until) || other.until == until));
}


@override
int get hashCode => Object.hash(runtimeType,freq,interval,const DeepCollectionEquality().hash(_byWeekday),byMonthDay,byMonth,until);

@override
String toString() {
  return 'RecurrenceSettings(freq: $freq, interval: $interval, byWeekday: $byWeekday, byMonthDay: $byMonthDay, byMonth: $byMonth, until: $until)';
}


}

/// @nodoc
abstract mixin class _$RecurrenceSettingsCopyWith<$Res> implements $RecurrenceSettingsCopyWith<$Res> {
  factory _$RecurrenceSettingsCopyWith(_RecurrenceSettings value, $Res Function(_RecurrenceSettings) _then) = __$RecurrenceSettingsCopyWithImpl;
@override @useResult
$Res call({
 RecurrenceFreq freq, int interval, List<int> byWeekday, int? byMonthDay, int? byMonth, DateTime? until
});




}
/// @nodoc
class __$RecurrenceSettingsCopyWithImpl<$Res>
    implements _$RecurrenceSettingsCopyWith<$Res> {
  __$RecurrenceSettingsCopyWithImpl(this._self, this._then);

  final _RecurrenceSettings _self;
  final $Res Function(_RecurrenceSettings) _then;

/// Create a copy of RecurrenceSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? freq = null,Object? interval = null,Object? byWeekday = null,Object? byMonthDay = freezed,Object? byMonth = freezed,Object? until = freezed,}) {
  return _then(_RecurrenceSettings(
freq: null == freq ? _self.freq : freq // ignore: cast_nullable_to_non_nullable
as RecurrenceFreq,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,byWeekday: null == byWeekday ? _self._byWeekday : byWeekday // ignore: cast_nullable_to_non_nullable
as List<int>,byMonthDay: freezed == byMonthDay ? _self.byMonthDay : byMonthDay // ignore: cast_nullable_to_non_nullable
as int?,byMonth: freezed == byMonth ? _self.byMonth : byMonth // ignore: cast_nullable_to_non_nullable
as int?,until: freezed == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

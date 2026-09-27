// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snooze_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SnoozeHistoryEntry {

 DateTime get atUtc; DateTime get fromUtc; DateTime get toUtc;
/// Create a copy of SnoozeHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnoozeHistoryEntryCopyWith<SnoozeHistoryEntry> get copyWith => _$SnoozeHistoryEntryCopyWithImpl<SnoozeHistoryEntry>(this as SnoozeHistoryEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnoozeHistoryEntry&&(identical(other.atUtc, atUtc) || other.atUtc == atUtc)&&(identical(other.fromUtc, fromUtc) || other.fromUtc == fromUtc)&&(identical(other.toUtc, toUtc) || other.toUtc == toUtc));
}


@override
int get hashCode => Object.hash(runtimeType,atUtc,fromUtc,toUtc);

@override
String toString() {
  return 'SnoozeHistoryEntry(atUtc: $atUtc, fromUtc: $fromUtc, toUtc: $toUtc)';
}


}

/// @nodoc
abstract mixin class $SnoozeHistoryEntryCopyWith<$Res>  {
  factory $SnoozeHistoryEntryCopyWith(SnoozeHistoryEntry value, $Res Function(SnoozeHistoryEntry) _then) = _$SnoozeHistoryEntryCopyWithImpl;
@useResult
$Res call({
 DateTime atUtc, DateTime fromUtc, DateTime toUtc
});




}
/// @nodoc
class _$SnoozeHistoryEntryCopyWithImpl<$Res>
    implements $SnoozeHistoryEntryCopyWith<$Res> {
  _$SnoozeHistoryEntryCopyWithImpl(this._self, this._then);

  final SnoozeHistoryEntry _self;
  final $Res Function(SnoozeHistoryEntry) _then;

/// Create a copy of SnoozeHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? atUtc = null,Object? fromUtc = null,Object? toUtc = null,}) {
  return _then(_self.copyWith(
atUtc: null == atUtc ? _self.atUtc : atUtc // ignore: cast_nullable_to_non_nullable
as DateTime,fromUtc: null == fromUtc ? _self.fromUtc : fromUtc // ignore: cast_nullable_to_non_nullable
as DateTime,toUtc: null == toUtc ? _self.toUtc : toUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SnoozeHistoryEntry].
extension SnoozeHistoryEntryPatterns on SnoozeHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnoozeHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnoozeHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnoozeHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _SnoozeHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnoozeHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SnoozeHistoryEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _SnoozeHistoryEntry implements SnoozeHistoryEntry {
  const _SnoozeHistoryEntry({required this.atUtc, required this.fromUtc, required this.toUtc});
  

@override final  DateTime atUtc;
@override final  DateTime fromUtc;
@override final  DateTime toUtc;

/// Create a copy of SnoozeHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnoozeHistoryEntryCopyWith<_SnoozeHistoryEntry> get copyWith => __$SnoozeHistoryEntryCopyWithImpl<_SnoozeHistoryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnoozeHistoryEntry&&(identical(other.atUtc, atUtc) || other.atUtc == atUtc)&&(identical(other.fromUtc, fromUtc) || other.fromUtc == fromUtc)&&(identical(other.toUtc, toUtc) || other.toUtc == toUtc));
}


@override
int get hashCode => Object.hash(runtimeType,atUtc,fromUtc,toUtc);

@override
String toString() {
  return 'SnoozeHistoryEntry(atUtc: $atUtc, fromUtc: $fromUtc, toUtc: $toUtc)';
}


}

/// @nodoc
abstract mixin class _$SnoozeHistoryEntryCopyWith<$Res> implements $SnoozeHistoryEntryCopyWith<$Res> {
  factory _$SnoozeHistoryEntryCopyWith(_SnoozeHistoryEntry value, $Res Function(_SnoozeHistoryEntry) _then) = __$SnoozeHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime atUtc, DateTime fromUtc, DateTime toUtc
});




}
/// @nodoc
class __$SnoozeHistoryEntryCopyWithImpl<$Res>
    implements _$SnoozeHistoryEntryCopyWith<$Res> {
  __$SnoozeHistoryEntryCopyWithImpl(this._self, this._then);

  final _SnoozeHistoryEntry _self;
  final $Res Function(_SnoozeHistoryEntry) _then;

/// Create a copy of SnoozeHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? atUtc = null,Object? fromUtc = null,Object? toUtc = null,}) {
  return _then(_SnoozeHistoryEntry(
atUtc: null == atUtc ? _self.atUtc : atUtc // ignore: cast_nullable_to_non_nullable
as DateTime,fromUtc: null == fromUtc ? _self.fromUtc : fromUtc // ignore: cast_nullable_to_non_nullable
as DateTime,toUtc: null == toUtc ? _self.toUtc : toUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

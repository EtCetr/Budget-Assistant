// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncPendingRow {

 String get id; Map<String, Object?> get raw; DateTime? get updatedAt; String? get spaceId;
/// Create a copy of SyncPendingRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncPendingRowCopyWith<SyncPendingRow> get copyWith => _$SyncPendingRowCopyWithImpl<SyncPendingRow>(this as SyncPendingRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncPendingRow&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.raw, raw)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(raw),updatedAt,spaceId);

@override
String toString() {
  return 'SyncPendingRow(id: $id, raw: $raw, updatedAt: $updatedAt, spaceId: $spaceId)';
}


}

/// @nodoc
abstract mixin class $SyncPendingRowCopyWith<$Res>  {
  factory $SyncPendingRowCopyWith(SyncPendingRow value, $Res Function(SyncPendingRow) _then) = _$SyncPendingRowCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, Object?> raw, DateTime? updatedAt, String? spaceId
});




}
/// @nodoc
class _$SyncPendingRowCopyWithImpl<$Res>
    implements $SyncPendingRowCopyWith<$Res> {
  _$SyncPendingRowCopyWithImpl(this._self, this._then);

  final SyncPendingRow _self;
  final $Res Function(SyncPendingRow) _then;

/// Create a copy of SyncPendingRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? raw = null,Object? updatedAt = freezed,Object? spaceId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncPendingRow].
extension SyncPendingRowPatterns on SyncPendingRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncPendingRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncPendingRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncPendingRow value)  $default,){
final _that = this;
switch (_that) {
case _SyncPendingRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncPendingRow value)?  $default,){
final _that = this;
switch (_that) {
case _SyncPendingRow() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _SyncPendingRow implements SyncPendingRow {
  const _SyncPendingRow({required this.id, required final  Map<String, Object?> raw, this.updatedAt, this.spaceId}): _raw = raw;
  

@override final  String id;
 final  Map<String, Object?> _raw;
@override Map<String, Object?> get raw {
  if (_raw is EqualUnmodifiableMapView) return _raw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_raw);
}

@override final  DateTime? updatedAt;
@override final  String? spaceId;

/// Create a copy of SyncPendingRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncPendingRowCopyWith<_SyncPendingRow> get copyWith => __$SyncPendingRowCopyWithImpl<_SyncPendingRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncPendingRow&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._raw, _raw)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_raw),updatedAt,spaceId);

@override
String toString() {
  return 'SyncPendingRow(id: $id, raw: $raw, updatedAt: $updatedAt, spaceId: $spaceId)';
}


}

/// @nodoc
abstract mixin class _$SyncPendingRowCopyWith<$Res> implements $SyncPendingRowCopyWith<$Res> {
  factory _$SyncPendingRowCopyWith(_SyncPendingRow value, $Res Function(_SyncPendingRow) _then) = __$SyncPendingRowCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, Object?> raw, DateTime? updatedAt, String? spaceId
});




}
/// @nodoc
class __$SyncPendingRowCopyWithImpl<$Res>
    implements _$SyncPendingRowCopyWith<$Res> {
  __$SyncPendingRowCopyWithImpl(this._self, this._then);

  final _SyncPendingRow _self;
  final $Res Function(_SyncPendingRow) _then;

/// Create a copy of SyncPendingRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? raw = null,Object? updatedAt = freezed,Object? spaceId = freezed,}) {
  return _then(_SyncPendingRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,raw: null == raw ? _self._raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SyncBatchSummary {

 int get pushed; int get conflicts; int get resolvedByLww; int get failed; SyncTrigger get trigger;
/// Create a copy of SyncBatchSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncBatchSummaryCopyWith<SyncBatchSummary> get copyWith => _$SyncBatchSummaryCopyWithImpl<SyncBatchSummary>(this as SyncBatchSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncBatchSummary&&(identical(other.pushed, pushed) || other.pushed == pushed)&&(identical(other.conflicts, conflicts) || other.conflicts == conflicts)&&(identical(other.resolvedByLww, resolvedByLww) || other.resolvedByLww == resolvedByLww)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.trigger, trigger) || other.trigger == trigger));
}


@override
int get hashCode => Object.hash(runtimeType,pushed,conflicts,resolvedByLww,failed,trigger);

@override
String toString() {
  return 'SyncBatchSummary(pushed: $pushed, conflicts: $conflicts, resolvedByLww: $resolvedByLww, failed: $failed, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class $SyncBatchSummaryCopyWith<$Res>  {
  factory $SyncBatchSummaryCopyWith(SyncBatchSummary value, $Res Function(SyncBatchSummary) _then) = _$SyncBatchSummaryCopyWithImpl;
@useResult
$Res call({
 int pushed, int conflicts, int resolvedByLww, int failed, SyncTrigger trigger
});




}
/// @nodoc
class _$SyncBatchSummaryCopyWithImpl<$Res>
    implements $SyncBatchSummaryCopyWith<$Res> {
  _$SyncBatchSummaryCopyWithImpl(this._self, this._then);

  final SyncBatchSummary _self;
  final $Res Function(SyncBatchSummary) _then;

/// Create a copy of SyncBatchSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pushed = null,Object? conflicts = null,Object? resolvedByLww = null,Object? failed = null,Object? trigger = null,}) {
  return _then(_self.copyWith(
pushed: null == pushed ? _self.pushed : pushed // ignore: cast_nullable_to_non_nullable
as int,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as int,resolvedByLww: null == resolvedByLww ? _self.resolvedByLww : resolvedByLww // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,trigger: null == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as SyncTrigger,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncBatchSummary].
extension SyncBatchSummaryPatterns on SyncBatchSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncBatchSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncBatchSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncBatchSummary value)  $default,){
final _that = this;
switch (_that) {
case _SyncBatchSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncBatchSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SyncBatchSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _SyncBatchSummary implements SyncBatchSummary {
  const _SyncBatchSummary({required this.pushed, required this.conflicts, required this.resolvedByLww, required this.failed, required this.trigger});
  

@override final  int pushed;
@override final  int conflicts;
@override final  int resolvedByLww;
@override final  int failed;
@override final  SyncTrigger trigger;

/// Create a copy of SyncBatchSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncBatchSummaryCopyWith<_SyncBatchSummary> get copyWith => __$SyncBatchSummaryCopyWithImpl<_SyncBatchSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncBatchSummary&&(identical(other.pushed, pushed) || other.pushed == pushed)&&(identical(other.conflicts, conflicts) || other.conflicts == conflicts)&&(identical(other.resolvedByLww, resolvedByLww) || other.resolvedByLww == resolvedByLww)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.trigger, trigger) || other.trigger == trigger));
}


@override
int get hashCode => Object.hash(runtimeType,pushed,conflicts,resolvedByLww,failed,trigger);

@override
String toString() {
  return 'SyncBatchSummary(pushed: $pushed, conflicts: $conflicts, resolvedByLww: $resolvedByLww, failed: $failed, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class _$SyncBatchSummaryCopyWith<$Res> implements $SyncBatchSummaryCopyWith<$Res> {
  factory _$SyncBatchSummaryCopyWith(_SyncBatchSummary value, $Res Function(_SyncBatchSummary) _then) = __$SyncBatchSummaryCopyWithImpl;
@override @useResult
$Res call({
 int pushed, int conflicts, int resolvedByLww, int failed, SyncTrigger trigger
});




}
/// @nodoc
class __$SyncBatchSummaryCopyWithImpl<$Res>
    implements _$SyncBatchSummaryCopyWith<$Res> {
  __$SyncBatchSummaryCopyWithImpl(this._self, this._then);

  final _SyncBatchSummary _self;
  final $Res Function(_SyncBatchSummary) _then;

/// Create a copy of SyncBatchSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pushed = null,Object? conflicts = null,Object? resolvedByLww = null,Object? failed = null,Object? trigger = null,}) {
  return _then(_SyncBatchSummary(
pushed: null == pushed ? _self.pushed : pushed // ignore: cast_nullable_to_non_nullable
as int,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as int,resolvedByLww: null == resolvedByLww ? _self.resolvedByLww : resolvedByLww // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,trigger: null == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as SyncTrigger,
  ));
}


}

// dart format on

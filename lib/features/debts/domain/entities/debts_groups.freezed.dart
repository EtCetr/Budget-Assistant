// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debts_groups.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DebtsGroups {

 List<Debt> get payableActive; List<Debt> get payableClosed; List<Debt> get receivableActive; List<Debt> get receivableClosed;
/// Create a copy of DebtsGroups
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtsGroupsCopyWith<DebtsGroups> get copyWith => _$DebtsGroupsCopyWithImpl<DebtsGroups>(this as DebtsGroups, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtsGroups&&const DeepCollectionEquality().equals(other.payableActive, payableActive)&&const DeepCollectionEquality().equals(other.payableClosed, payableClosed)&&const DeepCollectionEquality().equals(other.receivableActive, receivableActive)&&const DeepCollectionEquality().equals(other.receivableClosed, receivableClosed));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(payableActive),const DeepCollectionEquality().hash(payableClosed),const DeepCollectionEquality().hash(receivableActive),const DeepCollectionEquality().hash(receivableClosed));

@override
String toString() {
  return 'DebtsGroups(payableActive: $payableActive, payableClosed: $payableClosed, receivableActive: $receivableActive, receivableClosed: $receivableClosed)';
}


}

/// @nodoc
abstract mixin class $DebtsGroupsCopyWith<$Res>  {
  factory $DebtsGroupsCopyWith(DebtsGroups value, $Res Function(DebtsGroups) _then) = _$DebtsGroupsCopyWithImpl;
@useResult
$Res call({
 List<Debt> payableActive, List<Debt> payableClosed, List<Debt> receivableActive, List<Debt> receivableClosed
});




}
/// @nodoc
class _$DebtsGroupsCopyWithImpl<$Res>
    implements $DebtsGroupsCopyWith<$Res> {
  _$DebtsGroupsCopyWithImpl(this._self, this._then);

  final DebtsGroups _self;
  final $Res Function(DebtsGroups) _then;

/// Create a copy of DebtsGroups
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payableActive = null,Object? payableClosed = null,Object? receivableActive = null,Object? receivableClosed = null,}) {
  return _then(_self.copyWith(
payableActive: null == payableActive ? _self.payableActive : payableActive // ignore: cast_nullable_to_non_nullable
as List<Debt>,payableClosed: null == payableClosed ? _self.payableClosed : payableClosed // ignore: cast_nullable_to_non_nullable
as List<Debt>,receivableActive: null == receivableActive ? _self.receivableActive : receivableActive // ignore: cast_nullable_to_non_nullable
as List<Debt>,receivableClosed: null == receivableClosed ? _self.receivableClosed : receivableClosed // ignore: cast_nullable_to_non_nullable
as List<Debt>,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtsGroups].
extension DebtsGroupsPatterns on DebtsGroups {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtsGroups value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtsGroups() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtsGroups value)  $default,){
final _that = this;
switch (_that) {
case _DebtsGroups():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtsGroups value)?  $default,){
final _that = this;
switch (_that) {
case _DebtsGroups() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _DebtsGroups implements DebtsGroups {
  const _DebtsGroups({required final  List<Debt> payableActive, required final  List<Debt> payableClosed, required final  List<Debt> receivableActive, required final  List<Debt> receivableClosed}): _payableActive = payableActive,_payableClosed = payableClosed,_receivableActive = receivableActive,_receivableClosed = receivableClosed;
  

 final  List<Debt> _payableActive;
@override List<Debt> get payableActive {
  if (_payableActive is EqualUnmodifiableListView) return _payableActive;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payableActive);
}

 final  List<Debt> _payableClosed;
@override List<Debt> get payableClosed {
  if (_payableClosed is EqualUnmodifiableListView) return _payableClosed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payableClosed);
}

 final  List<Debt> _receivableActive;
@override List<Debt> get receivableActive {
  if (_receivableActive is EqualUnmodifiableListView) return _receivableActive;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receivableActive);
}

 final  List<Debt> _receivableClosed;
@override List<Debt> get receivableClosed {
  if (_receivableClosed is EqualUnmodifiableListView) return _receivableClosed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receivableClosed);
}


/// Create a copy of DebtsGroups
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtsGroupsCopyWith<_DebtsGroups> get copyWith => __$DebtsGroupsCopyWithImpl<_DebtsGroups>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtsGroups&&const DeepCollectionEquality().equals(other._payableActive, _payableActive)&&const DeepCollectionEquality().equals(other._payableClosed, _payableClosed)&&const DeepCollectionEquality().equals(other._receivableActive, _receivableActive)&&const DeepCollectionEquality().equals(other._receivableClosed, _receivableClosed));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_payableActive),const DeepCollectionEquality().hash(_payableClosed),const DeepCollectionEquality().hash(_receivableActive),const DeepCollectionEquality().hash(_receivableClosed));

@override
String toString() {
  return 'DebtsGroups(payableActive: $payableActive, payableClosed: $payableClosed, receivableActive: $receivableActive, receivableClosed: $receivableClosed)';
}


}

/// @nodoc
abstract mixin class _$DebtsGroupsCopyWith<$Res> implements $DebtsGroupsCopyWith<$Res> {
  factory _$DebtsGroupsCopyWith(_DebtsGroups value, $Res Function(_DebtsGroups) _then) = __$DebtsGroupsCopyWithImpl;
@override @useResult
$Res call({
 List<Debt> payableActive, List<Debt> payableClosed, List<Debt> receivableActive, List<Debt> receivableClosed
});




}
/// @nodoc
class __$DebtsGroupsCopyWithImpl<$Res>
    implements _$DebtsGroupsCopyWith<$Res> {
  __$DebtsGroupsCopyWithImpl(this._self, this._then);

  final _DebtsGroups _self;
  final $Res Function(_DebtsGroups) _then;

/// Create a copy of DebtsGroups
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payableActive = null,Object? payableClosed = null,Object? receivableActive = null,Object? receivableClosed = null,}) {
  return _then(_DebtsGroups(
payableActive: null == payableActive ? _self._payableActive : payableActive // ignore: cast_nullable_to_non_nullable
as List<Debt>,payableClosed: null == payableClosed ? _self._payableClosed : payableClosed // ignore: cast_nullable_to_non_nullable
as List<Debt>,receivableActive: null == receivableActive ? _self._receivableActive : receivableActive // ignore: cast_nullable_to_non_nullable
as List<Debt>,receivableClosed: null == receivableClosed ? _self._receivableClosed : receivableClosed // ignore: cast_nullable_to_non_nullable
as List<Debt>,
  ));
}


}

// dart format on

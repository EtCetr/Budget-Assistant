// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'effective_limit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EffectiveLimit {

 String get categoryId; int get baseLimit; bool get inheritedFromPrevious; int get carriedOver; int get effectiveTotal; int get spent; int get remaining; int get percentUsed;
/// Create a copy of EffectiveLimit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EffectiveLimitCopyWith<EffectiveLimit> get copyWith => _$EffectiveLimitCopyWithImpl<EffectiveLimit>(this as EffectiveLimit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EffectiveLimit&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.baseLimit, baseLimit) || other.baseLimit == baseLimit)&&(identical(other.inheritedFromPrevious, inheritedFromPrevious) || other.inheritedFromPrevious == inheritedFromPrevious)&&(identical(other.carriedOver, carriedOver) || other.carriedOver == carriedOver)&&(identical(other.effectiveTotal, effectiveTotal) || other.effectiveTotal == effectiveTotal)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.percentUsed, percentUsed) || other.percentUsed == percentUsed));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,baseLimit,inheritedFromPrevious,carriedOver,effectiveTotal,spent,remaining,percentUsed);

@override
String toString() {
  return 'EffectiveLimit(categoryId: $categoryId, baseLimit: $baseLimit, inheritedFromPrevious: $inheritedFromPrevious, carriedOver: $carriedOver, effectiveTotal: $effectiveTotal, spent: $spent, remaining: $remaining, percentUsed: $percentUsed)';
}


}

/// @nodoc
abstract mixin class $EffectiveLimitCopyWith<$Res>  {
  factory $EffectiveLimitCopyWith(EffectiveLimit value, $Res Function(EffectiveLimit) _then) = _$EffectiveLimitCopyWithImpl;
@useResult
$Res call({
 String categoryId, int baseLimit, bool inheritedFromPrevious, int carriedOver, int effectiveTotal, int spent, int remaining, int percentUsed
});




}
/// @nodoc
class _$EffectiveLimitCopyWithImpl<$Res>
    implements $EffectiveLimitCopyWith<$Res> {
  _$EffectiveLimitCopyWithImpl(this._self, this._then);

  final EffectiveLimit _self;
  final $Res Function(EffectiveLimit) _then;

/// Create a copy of EffectiveLimit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? baseLimit = null,Object? inheritedFromPrevious = null,Object? carriedOver = null,Object? effectiveTotal = null,Object? spent = null,Object? remaining = null,Object? percentUsed = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,baseLimit: null == baseLimit ? _self.baseLimit : baseLimit // ignore: cast_nullable_to_non_nullable
as int,inheritedFromPrevious: null == inheritedFromPrevious ? _self.inheritedFromPrevious : inheritedFromPrevious // ignore: cast_nullable_to_non_nullable
as bool,carriedOver: null == carriedOver ? _self.carriedOver : carriedOver // ignore: cast_nullable_to_non_nullable
as int,effectiveTotal: null == effectiveTotal ? _self.effectiveTotal : effectiveTotal // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,percentUsed: null == percentUsed ? _self.percentUsed : percentUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EffectiveLimit].
extension EffectiveLimitPatterns on EffectiveLimit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EffectiveLimit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EffectiveLimit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EffectiveLimit value)  $default,){
final _that = this;
switch (_that) {
case _EffectiveLimit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EffectiveLimit value)?  $default,){
final _that = this;
switch (_that) {
case _EffectiveLimit() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _EffectiveLimit implements EffectiveLimit {
  const _EffectiveLimit({required this.categoryId, required this.baseLimit, required this.inheritedFromPrevious, required this.carriedOver, required this.effectiveTotal, required this.spent, required this.remaining, required this.percentUsed});
  

@override final  String categoryId;
@override final  int baseLimit;
@override final  bool inheritedFromPrevious;
@override final  int carriedOver;
@override final  int effectiveTotal;
@override final  int spent;
@override final  int remaining;
@override final  int percentUsed;

/// Create a copy of EffectiveLimit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EffectiveLimitCopyWith<_EffectiveLimit> get copyWith => __$EffectiveLimitCopyWithImpl<_EffectiveLimit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EffectiveLimit&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.baseLimit, baseLimit) || other.baseLimit == baseLimit)&&(identical(other.inheritedFromPrevious, inheritedFromPrevious) || other.inheritedFromPrevious == inheritedFromPrevious)&&(identical(other.carriedOver, carriedOver) || other.carriedOver == carriedOver)&&(identical(other.effectiveTotal, effectiveTotal) || other.effectiveTotal == effectiveTotal)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.percentUsed, percentUsed) || other.percentUsed == percentUsed));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,baseLimit,inheritedFromPrevious,carriedOver,effectiveTotal,spent,remaining,percentUsed);

@override
String toString() {
  return 'EffectiveLimit(categoryId: $categoryId, baseLimit: $baseLimit, inheritedFromPrevious: $inheritedFromPrevious, carriedOver: $carriedOver, effectiveTotal: $effectiveTotal, spent: $spent, remaining: $remaining, percentUsed: $percentUsed)';
}


}

/// @nodoc
abstract mixin class _$EffectiveLimitCopyWith<$Res> implements $EffectiveLimitCopyWith<$Res> {
  factory _$EffectiveLimitCopyWith(_EffectiveLimit value, $Res Function(_EffectiveLimit) _then) = __$EffectiveLimitCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, int baseLimit, bool inheritedFromPrevious, int carriedOver, int effectiveTotal, int spent, int remaining, int percentUsed
});




}
/// @nodoc
class __$EffectiveLimitCopyWithImpl<$Res>
    implements _$EffectiveLimitCopyWith<$Res> {
  __$EffectiveLimitCopyWithImpl(this._self, this._then);

  final _EffectiveLimit _self;
  final $Res Function(_EffectiveLimit) _then;

/// Create a copy of EffectiveLimit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? baseLimit = null,Object? inheritedFromPrevious = null,Object? carriedOver = null,Object? effectiveTotal = null,Object? spent = null,Object? remaining = null,Object? percentUsed = null,}) {
  return _then(_EffectiveLimit(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,baseLimit: null == baseLimit ? _self.baseLimit : baseLimit // ignore: cast_nullable_to_non_nullable
as int,inheritedFromPrevious: null == inheritedFromPrevious ? _self.inheritedFromPrevious : inheritedFromPrevious // ignore: cast_nullable_to_non_nullable
as bool,carriedOver: null == carriedOver ? _self.carriedOver : carriedOver // ignore: cast_nullable_to_non_nullable
as int,effectiveTotal: null == effectiveTotal ? _self.effectiveTotal : effectiveTotal // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,percentUsed: null == percentUsed ? _self.percentUsed : percentUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

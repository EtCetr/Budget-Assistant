// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_item_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParsedItemDraft {

 String get name; double get quantity; int get unitPriceKop; int get totalPriceKop;
/// Create a copy of ParsedItemDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsedItemDraftCopyWith<ParsedItemDraft> get copyWith => _$ParsedItemDraftCopyWithImpl<ParsedItemDraft>(this as ParsedItemDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsedItemDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceKop, unitPriceKop) || other.unitPriceKop == unitPriceKop)&&(identical(other.totalPriceKop, totalPriceKop) || other.totalPriceKop == totalPriceKop));
}


@override
int get hashCode => Object.hash(runtimeType,name,quantity,unitPriceKop,totalPriceKop);

@override
String toString() {
  return 'ParsedItemDraft(name: $name, quantity: $quantity, unitPriceKop: $unitPriceKop, totalPriceKop: $totalPriceKop)';
}


}

/// @nodoc
abstract mixin class $ParsedItemDraftCopyWith<$Res>  {
  factory $ParsedItemDraftCopyWith(ParsedItemDraft value, $Res Function(ParsedItemDraft) _then) = _$ParsedItemDraftCopyWithImpl;
@useResult
$Res call({
 String name, double quantity, int unitPriceKop, int totalPriceKop
});




}
/// @nodoc
class _$ParsedItemDraftCopyWithImpl<$Res>
    implements $ParsedItemDraftCopyWith<$Res> {
  _$ParsedItemDraftCopyWithImpl(this._self, this._then);

  final ParsedItemDraft _self;
  final $Res Function(ParsedItemDraft) _then;

/// Create a copy of ParsedItemDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = null,Object? unitPriceKop = null,Object? totalPriceKop = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPriceKop: null == unitPriceKop ? _self.unitPriceKop : unitPriceKop // ignore: cast_nullable_to_non_nullable
as int,totalPriceKop: null == totalPriceKop ? _self.totalPriceKop : totalPriceKop // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParsedItemDraft].
extension ParsedItemDraftPatterns on ParsedItemDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsedItemDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsedItemDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsedItemDraft value)  $default,){
final _that = this;
switch (_that) {
case _ParsedItemDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsedItemDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ParsedItemDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ParsedItemDraft implements ParsedItemDraft {
  const _ParsedItemDraft({required this.name, required this.quantity, required this.unitPriceKop, required this.totalPriceKop});
  

@override final  String name;
@override final  double quantity;
@override final  int unitPriceKop;
@override final  int totalPriceKop;

/// Create a copy of ParsedItemDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsedItemDraftCopyWith<_ParsedItemDraft> get copyWith => __$ParsedItemDraftCopyWithImpl<_ParsedItemDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsedItemDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceKop, unitPriceKop) || other.unitPriceKop == unitPriceKop)&&(identical(other.totalPriceKop, totalPriceKop) || other.totalPriceKop == totalPriceKop));
}


@override
int get hashCode => Object.hash(runtimeType,name,quantity,unitPriceKop,totalPriceKop);

@override
String toString() {
  return 'ParsedItemDraft(name: $name, quantity: $quantity, unitPriceKop: $unitPriceKop, totalPriceKop: $totalPriceKop)';
}


}

/// @nodoc
abstract mixin class _$ParsedItemDraftCopyWith<$Res> implements $ParsedItemDraftCopyWith<$Res> {
  factory _$ParsedItemDraftCopyWith(_ParsedItemDraft value, $Res Function(_ParsedItemDraft) _then) = __$ParsedItemDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, double quantity, int unitPriceKop, int totalPriceKop
});




}
/// @nodoc
class __$ParsedItemDraftCopyWithImpl<$Res>
    implements _$ParsedItemDraftCopyWith<$Res> {
  __$ParsedItemDraftCopyWithImpl(this._self, this._then);

  final _ParsedItemDraft _self;
  final $Res Function(_ParsedItemDraft) _then;

/// Create a copy of ParsedItemDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = null,Object? unitPriceKop = null,Object? totalPriceKop = null,}) {
  return _then(_ParsedItemDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPriceKop: null == unitPriceKop ? _self.unitPriceKop : unitPriceKop // ignore: cast_nullable_to_non_nullable
as int,totalPriceKop: null == totalPriceKop ? _self.totalPriceKop : totalPriceKop // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

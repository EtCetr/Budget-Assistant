// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_category_lookup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptCategoryLookup {

 String get id; String get name; String? get iconEmoji; String? get colorHex;
/// Create a copy of ReceiptCategoryLookup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptCategoryLookupCopyWith<ReceiptCategoryLookup> get copyWith => _$ReceiptCategoryLookupCopyWithImpl<ReceiptCategoryLookup>(this as ReceiptCategoryLookup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptCategoryLookup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,iconEmoji,colorHex);

@override
String toString() {
  return 'ReceiptCategoryLookup(id: $id, name: $name, iconEmoji: $iconEmoji, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class $ReceiptCategoryLookupCopyWith<$Res>  {
  factory $ReceiptCategoryLookupCopyWith(ReceiptCategoryLookup value, $Res Function(ReceiptCategoryLookup) _then) = _$ReceiptCategoryLookupCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? iconEmoji, String? colorHex
});




}
/// @nodoc
class _$ReceiptCategoryLookupCopyWithImpl<$Res>
    implements $ReceiptCategoryLookupCopyWith<$Res> {
  _$ReceiptCategoryLookupCopyWithImpl(this._self, this._then);

  final ReceiptCategoryLookup _self;
  final $Res Function(ReceiptCategoryLookup) _then;

/// Create a copy of ReceiptCategoryLookup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? iconEmoji = freezed,Object? colorHex = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptCategoryLookup].
extension ReceiptCategoryLookupPatterns on ReceiptCategoryLookup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptCategoryLookup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptCategoryLookup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptCategoryLookup value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptCategoryLookup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptCategoryLookup value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptCategoryLookup() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptCategoryLookup implements ReceiptCategoryLookup {
  const _ReceiptCategoryLookup({required this.id, required this.name, this.iconEmoji, this.colorHex});
  

@override final  String id;
@override final  String name;
@override final  String? iconEmoji;
@override final  String? colorHex;

/// Create a copy of ReceiptCategoryLookup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptCategoryLookupCopyWith<_ReceiptCategoryLookup> get copyWith => __$ReceiptCategoryLookupCopyWithImpl<_ReceiptCategoryLookup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptCategoryLookup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,iconEmoji,colorHex);

@override
String toString() {
  return 'ReceiptCategoryLookup(id: $id, name: $name, iconEmoji: $iconEmoji, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class _$ReceiptCategoryLookupCopyWith<$Res> implements $ReceiptCategoryLookupCopyWith<$Res> {
  factory _$ReceiptCategoryLookupCopyWith(_ReceiptCategoryLookup value, $Res Function(_ReceiptCategoryLookup) _then) = __$ReceiptCategoryLookupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? iconEmoji, String? colorHex
});




}
/// @nodoc
class __$ReceiptCategoryLookupCopyWithImpl<$Res>
    implements _$ReceiptCategoryLookupCopyWith<$Res> {
  __$ReceiptCategoryLookupCopyWithImpl(this._self, this._then);

  final _ReceiptCategoryLookup _self;
  final $Res Function(_ReceiptCategoryLookup) _then;

/// Create a copy of ReceiptCategoryLookup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? iconEmoji = freezed,Object? colorHex = freezed,}) {
  return _then(_ReceiptCategoryLookup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popular_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PopularStore {

 String get name; String get brandColor; String get iconEmoji; LoyaltyCardCategory get category;
/// Create a copy of PopularStore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopularStoreCopyWith<PopularStore> get copyWith => _$PopularStoreCopyWithImpl<PopularStore>(this as PopularStore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PopularStore&&(identical(other.name, name) || other.name == name)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,name,brandColor,iconEmoji,category);

@override
String toString() {
  return 'PopularStore(name: $name, brandColor: $brandColor, iconEmoji: $iconEmoji, category: $category)';
}


}

/// @nodoc
abstract mixin class $PopularStoreCopyWith<$Res>  {
  factory $PopularStoreCopyWith(PopularStore value, $Res Function(PopularStore) _then) = _$PopularStoreCopyWithImpl;
@useResult
$Res call({
 String name, String brandColor, String iconEmoji, LoyaltyCardCategory category
});




}
/// @nodoc
class _$PopularStoreCopyWithImpl<$Res>
    implements $PopularStoreCopyWith<$Res> {
  _$PopularStoreCopyWithImpl(this._self, this._then);

  final PopularStore _self;
  final $Res Function(PopularStore) _then;

/// Create a copy of PopularStore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? brandColor = null,Object? iconEmoji = null,Object? category = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brandColor: null == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: null == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LoyaltyCardCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [PopularStore].
extension PopularStorePatterns on PopularStore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PopularStore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PopularStore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PopularStore value)  $default,){
final _that = this;
switch (_that) {
case _PopularStore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PopularStore value)?  $default,){
final _that = this;
switch (_that) {
case _PopularStore() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _PopularStore implements PopularStore {
  const _PopularStore({required this.name, required this.brandColor, required this.iconEmoji, required this.category});
  

@override final  String name;
@override final  String brandColor;
@override final  String iconEmoji;
@override final  LoyaltyCardCategory category;

/// Create a copy of PopularStore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PopularStoreCopyWith<_PopularStore> get copyWith => __$PopularStoreCopyWithImpl<_PopularStore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PopularStore&&(identical(other.name, name) || other.name == name)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,name,brandColor,iconEmoji,category);

@override
String toString() {
  return 'PopularStore(name: $name, brandColor: $brandColor, iconEmoji: $iconEmoji, category: $category)';
}


}

/// @nodoc
abstract mixin class _$PopularStoreCopyWith<$Res> implements $PopularStoreCopyWith<$Res> {
  factory _$PopularStoreCopyWith(_PopularStore value, $Res Function(_PopularStore) _then) = __$PopularStoreCopyWithImpl;
@override @useResult
$Res call({
 String name, String brandColor, String iconEmoji, LoyaltyCardCategory category
});




}
/// @nodoc
class __$PopularStoreCopyWithImpl<$Res>
    implements _$PopularStoreCopyWith<$Res> {
  __$PopularStoreCopyWithImpl(this._self, this._then);

  final _PopularStore _self;
  final $Res Function(_PopularStore) _then;

/// Create a copy of PopularStore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? brandColor = null,Object? iconEmoji = null,Object? category = null,}) {
  return _then(_PopularStore(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brandColor: null == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: null == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LoyaltyCardCategory,
  ));
}


}

// dart format on

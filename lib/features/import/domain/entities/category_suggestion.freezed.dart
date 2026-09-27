// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategorySuggestion {

 String get categoryId;/// 0.0–1.0.
 double get confidence; CategorySuggestionSource get source;
/// Create a copy of CategorySuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySuggestionCopyWith<CategorySuggestion> get copyWith => _$CategorySuggestionCopyWithImpl<CategorySuggestion>(this as CategorySuggestion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySuggestion&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,confidence,source);

@override
String toString() {
  return 'CategorySuggestion(categoryId: $categoryId, confidence: $confidence, source: $source)';
}


}

/// @nodoc
abstract mixin class $CategorySuggestionCopyWith<$Res>  {
  factory $CategorySuggestionCopyWith(CategorySuggestion value, $Res Function(CategorySuggestion) _then) = _$CategorySuggestionCopyWithImpl;
@useResult
$Res call({
 String categoryId, double confidence, CategorySuggestionSource source
});




}
/// @nodoc
class _$CategorySuggestionCopyWithImpl<$Res>
    implements $CategorySuggestionCopyWith<$Res> {
  _$CategorySuggestionCopyWithImpl(this._self, this._then);

  final CategorySuggestion _self;
  final $Res Function(CategorySuggestion) _then;

/// Create a copy of CategorySuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? confidence = null,Object? source = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CategorySuggestionSource,
  ));
}

}


/// Adds pattern-matching-related methods to [CategorySuggestion].
extension CategorySuggestionPatterns on CategorySuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySuggestion value)  $default,){
final _that = this;
switch (_that) {
case _CategorySuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySuggestion() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CategorySuggestion implements CategorySuggestion {
  const _CategorySuggestion({required this.categoryId, required this.confidence, required this.source});
  

@override final  String categoryId;
/// 0.0–1.0.
@override final  double confidence;
@override final  CategorySuggestionSource source;

/// Create a copy of CategorySuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySuggestionCopyWith<_CategorySuggestion> get copyWith => __$CategorySuggestionCopyWithImpl<_CategorySuggestion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySuggestion&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,confidence,source);

@override
String toString() {
  return 'CategorySuggestion(categoryId: $categoryId, confidence: $confidence, source: $source)';
}


}

/// @nodoc
abstract mixin class _$CategorySuggestionCopyWith<$Res> implements $CategorySuggestionCopyWith<$Res> {
  factory _$CategorySuggestionCopyWith(_CategorySuggestion value, $Res Function(_CategorySuggestion) _then) = __$CategorySuggestionCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, double confidence, CategorySuggestionSource source
});




}
/// @nodoc
class __$CategorySuggestionCopyWithImpl<$Res>
    implements _$CategorySuggestionCopyWith<$Res> {
  __$CategorySuggestionCopyWithImpl(this._self, this._then);

  final _CategorySuggestion _self;
  final $Res Function(_CategorySuggestion) _then;

/// Create a copy of CategorySuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? confidence = null,Object? source = null,}) {
  return _then(_CategorySuggestion(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CategorySuggestionSource,
  ));
}


}

// dart format on

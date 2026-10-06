// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_receipt_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParsedReceiptDraft {

 String? get storeName; int? get totalKop; List<ParsedItemDraft> get items;
/// Create a copy of ParsedReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsedReceiptDraftCopyWith<ParsedReceiptDraft> get copyWith => _$ParsedReceiptDraftCopyWithImpl<ParsedReceiptDraft>(this as ParsedReceiptDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsedReceiptDraft&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.totalKop, totalKop) || other.totalKop == totalKop)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,storeName,totalKop,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ParsedReceiptDraft(storeName: $storeName, totalKop: $totalKop, items: $items)';
}


}

/// @nodoc
abstract mixin class $ParsedReceiptDraftCopyWith<$Res>  {
  factory $ParsedReceiptDraftCopyWith(ParsedReceiptDraft value, $Res Function(ParsedReceiptDraft) _then) = _$ParsedReceiptDraftCopyWithImpl;
@useResult
$Res call({
 String? storeName, int? totalKop, List<ParsedItemDraft> items
});




}
/// @nodoc
class _$ParsedReceiptDraftCopyWithImpl<$Res>
    implements $ParsedReceiptDraftCopyWith<$Res> {
  _$ParsedReceiptDraftCopyWithImpl(this._self, this._then);

  final ParsedReceiptDraft _self;
  final $Res Function(ParsedReceiptDraft) _then;

/// Create a copy of ParsedReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeName = freezed,Object? totalKop = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,totalKop: freezed == totalKop ? _self.totalKop : totalKop // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ParsedItemDraft>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParsedReceiptDraft].
extension ParsedReceiptDraftPatterns on ParsedReceiptDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsedReceiptDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsedReceiptDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsedReceiptDraft value)  $default,){
final _that = this;
switch (_that) {
case _ParsedReceiptDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsedReceiptDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ParsedReceiptDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ParsedReceiptDraft implements ParsedReceiptDraft {
  const _ParsedReceiptDraft({this.storeName, this.totalKop, required final  List<ParsedItemDraft> items}): _items = items;
  

@override final  String? storeName;
@override final  int? totalKop;
 final  List<ParsedItemDraft> _items;
@override List<ParsedItemDraft> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ParsedReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsedReceiptDraftCopyWith<_ParsedReceiptDraft> get copyWith => __$ParsedReceiptDraftCopyWithImpl<_ParsedReceiptDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsedReceiptDraft&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.totalKop, totalKop) || other.totalKop == totalKop)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,storeName,totalKop,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ParsedReceiptDraft(storeName: $storeName, totalKop: $totalKop, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ParsedReceiptDraftCopyWith<$Res> implements $ParsedReceiptDraftCopyWith<$Res> {
  factory _$ParsedReceiptDraftCopyWith(_ParsedReceiptDraft value, $Res Function(_ParsedReceiptDraft) _then) = __$ParsedReceiptDraftCopyWithImpl;
@override @useResult
$Res call({
 String? storeName, int? totalKop, List<ParsedItemDraft> items
});




}
/// @nodoc
class __$ParsedReceiptDraftCopyWithImpl<$Res>
    implements _$ParsedReceiptDraftCopyWith<$Res> {
  __$ParsedReceiptDraftCopyWithImpl(this._self, this._then);

  final _ParsedReceiptDraft _self;
  final $Res Function(_ParsedReceiptDraft) _then;

/// Create a copy of ParsedReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeName = freezed,Object? totalKop = freezed,Object? items = null,}) {
  return _then(_ParsedReceiptDraft(
storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,totalKop: freezed == totalKop ? _self.totalKop : totalKop // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ParsedItemDraft>,
  ));
}


}

// dart format on

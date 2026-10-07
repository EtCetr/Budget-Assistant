// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_bundle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptBundle {

 Receipt get receipt; List<ReceiptItem> get items;
/// Create a copy of ReceiptBundle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptBundleCopyWith<ReceiptBundle> get copyWith => _$ReceiptBundleCopyWithImpl<ReceiptBundle>(this as ReceiptBundle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptBundle&&(identical(other.receipt, receipt) || other.receipt == receipt)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,receipt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ReceiptBundle(receipt: $receipt, items: $items)';
}


}

/// @nodoc
abstract mixin class $ReceiptBundleCopyWith<$Res>  {
  factory $ReceiptBundleCopyWith(ReceiptBundle value, $Res Function(ReceiptBundle) _then) = _$ReceiptBundleCopyWithImpl;
@useResult
$Res call({
 Receipt receipt, List<ReceiptItem> items
});


$ReceiptCopyWith<$Res> get receipt;

}
/// @nodoc
class _$ReceiptBundleCopyWithImpl<$Res>
    implements $ReceiptBundleCopyWith<$Res> {
  _$ReceiptBundleCopyWithImpl(this._self, this._then);

  final ReceiptBundle _self;
  final $Res Function(ReceiptBundle) _then;

/// Create a copy of ReceiptBundle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? receipt = null,Object? items = null,}) {
  return _then(_self.copyWith(
receipt: null == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as Receipt,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,
  ));
}
/// Create a copy of ReceiptBundle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptCopyWith<$Res> get receipt {
  
  return $ReceiptCopyWith<$Res>(_self.receipt, (value) {
    return _then(_self.copyWith(receipt: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptBundle].
extension ReceiptBundlePatterns on ReceiptBundle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptBundle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptBundle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptBundle value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptBundle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptBundle value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptBundle() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptBundle implements ReceiptBundle {
  const _ReceiptBundle({required this.receipt, required final  List<ReceiptItem> items}): _items = items;
  

@override final  Receipt receipt;
 final  List<ReceiptItem> _items;
@override List<ReceiptItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ReceiptBundle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptBundleCopyWith<_ReceiptBundle> get copyWith => __$ReceiptBundleCopyWithImpl<_ReceiptBundle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptBundle&&(identical(other.receipt, receipt) || other.receipt == receipt)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,receipt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ReceiptBundle(receipt: $receipt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReceiptBundleCopyWith<$Res> implements $ReceiptBundleCopyWith<$Res> {
  factory _$ReceiptBundleCopyWith(_ReceiptBundle value, $Res Function(_ReceiptBundle) _then) = __$ReceiptBundleCopyWithImpl;
@override @useResult
$Res call({
 Receipt receipt, List<ReceiptItem> items
});


@override $ReceiptCopyWith<$Res> get receipt;

}
/// @nodoc
class __$ReceiptBundleCopyWithImpl<$Res>
    implements _$ReceiptBundleCopyWith<$Res> {
  __$ReceiptBundleCopyWithImpl(this._self, this._then);

  final _ReceiptBundle _self;
  final $Res Function(_ReceiptBundle) _then;

/// Create a copy of ReceiptBundle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receipt = null,Object? items = null,}) {
  return _then(_ReceiptBundle(
receipt: null == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as Receipt,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,
  ));
}

/// Create a copy of ReceiptBundle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptCopyWith<$Res> get receipt {
  
  return $ReceiptCopyWith<$Res>(_self.receipt, (value) {
    return _then(_self.copyWith(receipt: value));
  });
}
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_widget_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardWidgetItem {

 String get id; DashboardWidgetType get type; bool get isVisible; int get sortOrder;
/// Create a copy of DashboardWidgetItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardWidgetItemCopyWith<DashboardWidgetItem> get copyWith => _$DashboardWidgetItemCopyWithImpl<DashboardWidgetItem>(this as DashboardWidgetItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardWidgetItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,isVisible,sortOrder);

@override
String toString() {
  return 'DashboardWidgetItem(id: $id, type: $type, isVisible: $isVisible, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $DashboardWidgetItemCopyWith<$Res>  {
  factory $DashboardWidgetItemCopyWith(DashboardWidgetItem value, $Res Function(DashboardWidgetItem) _then) = _$DashboardWidgetItemCopyWithImpl;
@useResult
$Res call({
 String id, DashboardWidgetType type, bool isVisible, int sortOrder
});




}
/// @nodoc
class _$DashboardWidgetItemCopyWithImpl<$Res>
    implements $DashboardWidgetItemCopyWith<$Res> {
  _$DashboardWidgetItemCopyWithImpl(this._self, this._then);

  final DashboardWidgetItem _self;
  final $Res Function(DashboardWidgetItem) _then;

/// Create a copy of DashboardWidgetItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? isVisible = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DashboardWidgetType,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardWidgetItem].
extension DashboardWidgetItemPatterns on DashboardWidgetItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardWidgetItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardWidgetItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardWidgetItem value)  $default,){
final _that = this;
switch (_that) {
case _DashboardWidgetItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardWidgetItem value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardWidgetItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardWidgetItem implements DashboardWidgetItem {
  const _DashboardWidgetItem({required this.id, required this.type, required this.isVisible, required this.sortOrder});
  

@override final  String id;
@override final  DashboardWidgetType type;
@override final  bool isVisible;
@override final  int sortOrder;

/// Create a copy of DashboardWidgetItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardWidgetItemCopyWith<_DashboardWidgetItem> get copyWith => __$DashboardWidgetItemCopyWithImpl<_DashboardWidgetItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardWidgetItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,isVisible,sortOrder);

@override
String toString() {
  return 'DashboardWidgetItem(id: $id, type: $type, isVisible: $isVisible, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$DashboardWidgetItemCopyWith<$Res> implements $DashboardWidgetItemCopyWith<$Res> {
  factory _$DashboardWidgetItemCopyWith(_DashboardWidgetItem value, $Res Function(_DashboardWidgetItem) _then) = __$DashboardWidgetItemCopyWithImpl;
@override @useResult
$Res call({
 String id, DashboardWidgetType type, bool isVisible, int sortOrder
});




}
/// @nodoc
class __$DashboardWidgetItemCopyWithImpl<$Res>
    implements _$DashboardWidgetItemCopyWith<$Res> {
  __$DashboardWidgetItemCopyWithImpl(this._self, this._then);

  final _DashboardWidgetItem _self;
  final $Res Function(_DashboardWidgetItem) _then;

/// Create a copy of DashboardWidgetItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? isVisible = null,Object? sortOrder = null,}) {
  return _then(_DashboardWidgetItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DashboardWidgetType,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

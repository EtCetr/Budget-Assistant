// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'split_position_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SplitPositionDraft {

/// id существующего сплита при переразделении; null для новых.
 String? get id;/// Название позиции (товар из OCR или ручной ввод).
 String get name;/// Копейки, > 0.
 int get amount; String? get categoryId; String? get description;/// true — позиция из OCR (название/сумма read-only).
 bool get fromOcr;
/// Create a copy of SplitPositionDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SplitPositionDraftCopyWith<SplitPositionDraft> get copyWith => _$SplitPositionDraftCopyWithImpl<SplitPositionDraft>(this as SplitPositionDraft, _$identity);

  /// Serializes this SplitPositionDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplitPositionDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.fromOcr, fromOcr) || other.fromOcr == fromOcr));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,categoryId,description,fromOcr);

@override
String toString() {
  return 'SplitPositionDraft(id: $id, name: $name, amount: $amount, categoryId: $categoryId, description: $description, fromOcr: $fromOcr)';
}


}

/// @nodoc
abstract mixin class $SplitPositionDraftCopyWith<$Res>  {
  factory $SplitPositionDraftCopyWith(SplitPositionDraft value, $Res Function(SplitPositionDraft) _then) = _$SplitPositionDraftCopyWithImpl;
@useResult
$Res call({
 String? id, String name, int amount, String? categoryId, String? description, bool fromOcr
});




}
/// @nodoc
class _$SplitPositionDraftCopyWithImpl<$Res>
    implements $SplitPositionDraftCopyWith<$Res> {
  _$SplitPositionDraftCopyWithImpl(this._self, this._then);

  final SplitPositionDraft _self;
  final $Res Function(SplitPositionDraft) _then;

/// Create a copy of SplitPositionDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? amount = null,Object? categoryId = freezed,Object? description = freezed,Object? fromOcr = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,fromOcr: null == fromOcr ? _self.fromOcr : fromOcr // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SplitPositionDraft].
extension SplitPositionDraftPatterns on SplitPositionDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SplitPositionDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SplitPositionDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SplitPositionDraft value)  $default,){
final _that = this;
switch (_that) {
case _SplitPositionDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SplitPositionDraft value)?  $default,){
final _that = this;
switch (_that) {
case _SplitPositionDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SplitPositionDraft implements SplitPositionDraft {
  const _SplitPositionDraft({this.id, this.name = '', this.amount = 0, this.categoryId, this.description, this.fromOcr = false});
  factory _SplitPositionDraft.fromJson(Map<String, dynamic> json) => _$SplitPositionDraftFromJson(json);

/// id существующего сплита при переразделении; null для новых.
@override final  String? id;
/// Название позиции (товар из OCR или ручной ввод).
@override@JsonKey() final  String name;
/// Копейки, > 0.
@override@JsonKey() final  int amount;
@override final  String? categoryId;
@override final  String? description;
/// true — позиция из OCR (название/сумма read-only).
@override@JsonKey() final  bool fromOcr;

/// Create a copy of SplitPositionDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplitPositionDraftCopyWith<_SplitPositionDraft> get copyWith => __$SplitPositionDraftCopyWithImpl<_SplitPositionDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SplitPositionDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplitPositionDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.fromOcr, fromOcr) || other.fromOcr == fromOcr));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,categoryId,description,fromOcr);

@override
String toString() {
  return 'SplitPositionDraft(id: $id, name: $name, amount: $amount, categoryId: $categoryId, description: $description, fromOcr: $fromOcr)';
}


}

/// @nodoc
abstract mixin class _$SplitPositionDraftCopyWith<$Res> implements $SplitPositionDraftCopyWith<$Res> {
  factory _$SplitPositionDraftCopyWith(_SplitPositionDraft value, $Res Function(_SplitPositionDraft) _then) = __$SplitPositionDraftCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, int amount, String? categoryId, String? description, bool fromOcr
});




}
/// @nodoc
class __$SplitPositionDraftCopyWithImpl<$Res>
    implements _$SplitPositionDraftCopyWith<$Res> {
  __$SplitPositionDraftCopyWithImpl(this._self, this._then);

  final _SplitPositionDraft _self;
  final $Res Function(_SplitPositionDraft) _then;

/// Create a copy of SplitPositionDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? amount = null,Object? categoryId = freezed,Object? description = freezed,Object? fromOcr = null,}) {
  return _then(_SplitPositionDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,fromOcr: null == fromOcr ? _self.fromOcr : fromOcr // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_card_form_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoyaltyCardFormDraft {

/// NULL = новая карта, UUID = редактирование.
 String? get cardId; String get storeName;/// имя BarcodeType.
 String get barcodeType; String get barcodeData;/// имя LoyaltyCardCategory.
 String get category; String? get brandColor; String? get iconAsset;/// 'personal' | 'family'.
 String get visibility; DateTime get updatedAt;
/// Create a copy of LoyaltyCardFormDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyCardFormDraftCopyWith<LoyaltyCardFormDraft> get copyWith => _$LoyaltyCardFormDraftCopyWithImpl<LoyaltyCardFormDraft>(this as LoyaltyCardFormDraft, _$identity);

  /// Serializes this LoyaltyCardFormDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyCardFormDraft&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.barcodeData, barcodeData) || other.barcodeData == barcodeData)&&(identical(other.category, category) || other.category == category)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconAsset, iconAsset) || other.iconAsset == iconAsset)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cardId,storeName,barcodeType,barcodeData,category,brandColor,iconAsset,visibility,updatedAt);

@override
String toString() {
  return 'LoyaltyCardFormDraft(cardId: $cardId, storeName: $storeName, barcodeType: $barcodeType, barcodeData: $barcodeData, category: $category, brandColor: $brandColor, iconAsset: $iconAsset, visibility: $visibility, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LoyaltyCardFormDraftCopyWith<$Res>  {
  factory $LoyaltyCardFormDraftCopyWith(LoyaltyCardFormDraft value, $Res Function(LoyaltyCardFormDraft) _then) = _$LoyaltyCardFormDraftCopyWithImpl;
@useResult
$Res call({
 String? cardId, String storeName, String barcodeType, String barcodeData, String category, String? brandColor, String? iconAsset, String visibility, DateTime updatedAt
});




}
/// @nodoc
class _$LoyaltyCardFormDraftCopyWithImpl<$Res>
    implements $LoyaltyCardFormDraftCopyWith<$Res> {
  _$LoyaltyCardFormDraftCopyWithImpl(this._self, this._then);

  final LoyaltyCardFormDraft _self;
  final $Res Function(LoyaltyCardFormDraft) _then;

/// Create a copy of LoyaltyCardFormDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardId = freezed,Object? storeName = null,Object? barcodeType = null,Object? barcodeData = null,Object? category = null,Object? brandColor = freezed,Object? iconAsset = freezed,Object? visibility = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
cardId: freezed == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as String,barcodeData: null == barcodeData ? _self.barcodeData : barcodeData // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,brandColor: freezed == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String?,iconAsset: freezed == iconAsset ? _self.iconAsset : iconAsset // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyCardFormDraft].
extension LoyaltyCardFormDraftPatterns on LoyaltyCardFormDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyCardFormDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyCardFormDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyCardFormDraft value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCardFormDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyCardFormDraft value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCardFormDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoyaltyCardFormDraft implements LoyaltyCardFormDraft {
  const _LoyaltyCardFormDraft({this.cardId, this.storeName = '', this.barcodeType = 'manual', this.barcodeData = '', this.category = 'other', this.brandColor, this.iconAsset, this.visibility = 'personal', required this.updatedAt});
  factory _LoyaltyCardFormDraft.fromJson(Map<String, dynamic> json) => _$LoyaltyCardFormDraftFromJson(json);

/// NULL = новая карта, UUID = редактирование.
@override final  String? cardId;
@override@JsonKey() final  String storeName;
/// имя BarcodeType.
@override@JsonKey() final  String barcodeType;
@override@JsonKey() final  String barcodeData;
/// имя LoyaltyCardCategory.
@override@JsonKey() final  String category;
@override final  String? brandColor;
@override final  String? iconAsset;
/// 'personal' | 'family'.
@override@JsonKey() final  String visibility;
@override final  DateTime updatedAt;

/// Create a copy of LoyaltyCardFormDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyCardFormDraftCopyWith<_LoyaltyCardFormDraft> get copyWith => __$LoyaltyCardFormDraftCopyWithImpl<_LoyaltyCardFormDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoyaltyCardFormDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyCardFormDraft&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.barcodeData, barcodeData) || other.barcodeData == barcodeData)&&(identical(other.category, category) || other.category == category)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconAsset, iconAsset) || other.iconAsset == iconAsset)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cardId,storeName,barcodeType,barcodeData,category,brandColor,iconAsset,visibility,updatedAt);

@override
String toString() {
  return 'LoyaltyCardFormDraft(cardId: $cardId, storeName: $storeName, barcodeType: $barcodeType, barcodeData: $barcodeData, category: $category, brandColor: $brandColor, iconAsset: $iconAsset, visibility: $visibility, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyCardFormDraftCopyWith<$Res> implements $LoyaltyCardFormDraftCopyWith<$Res> {
  factory _$LoyaltyCardFormDraftCopyWith(_LoyaltyCardFormDraft value, $Res Function(_LoyaltyCardFormDraft) _then) = __$LoyaltyCardFormDraftCopyWithImpl;
@override @useResult
$Res call({
 String? cardId, String storeName, String barcodeType, String barcodeData, String category, String? brandColor, String? iconAsset, String visibility, DateTime updatedAt
});




}
/// @nodoc
class __$LoyaltyCardFormDraftCopyWithImpl<$Res>
    implements _$LoyaltyCardFormDraftCopyWith<$Res> {
  __$LoyaltyCardFormDraftCopyWithImpl(this._self, this._then);

  final _LoyaltyCardFormDraft _self;
  final $Res Function(_LoyaltyCardFormDraft) _then;

/// Create a copy of LoyaltyCardFormDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardId = freezed,Object? storeName = null,Object? barcodeType = null,Object? barcodeData = null,Object? category = null,Object? brandColor = freezed,Object? iconAsset = freezed,Object? visibility = null,Object? updatedAt = null,}) {
  return _then(_LoyaltyCardFormDraft(
cardId: freezed == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as String,barcodeData: null == barcodeData ? _self.barcodeData : barcodeData // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,brandColor: freezed == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String?,iconAsset: freezed == iconAsset ? _self.iconAsset : iconAsset // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

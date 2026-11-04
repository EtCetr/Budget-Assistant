// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_card_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoyaltyCardFormData {

/// NULL = создание, UUID = редактирование.
 String? get cardId; String get storeName; BarcodeType get barcodeType; String get barcodeData;/// #RRGGBB или null.
 String? get brandColor; String? get iconAsset; LoyaltyCardCategory get category;/// 'personal' | 'family'.
 String get visibility;
/// Create a copy of LoyaltyCardFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyCardFormDataCopyWith<LoyaltyCardFormData> get copyWith => _$LoyaltyCardFormDataCopyWithImpl<LoyaltyCardFormData>(this as LoyaltyCardFormData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyCardFormData&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.barcodeData, barcodeData) || other.barcodeData == barcodeData)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconAsset, iconAsset) || other.iconAsset == iconAsset)&&(identical(other.category, category) || other.category == category)&&(identical(other.visibility, visibility) || other.visibility == visibility));
}


@override
int get hashCode => Object.hash(runtimeType,cardId,storeName,barcodeType,barcodeData,brandColor,iconAsset,category,visibility);

@override
String toString() {
  return 'LoyaltyCardFormData(cardId: $cardId, storeName: $storeName, barcodeType: $barcodeType, barcodeData: $barcodeData, brandColor: $brandColor, iconAsset: $iconAsset, category: $category, visibility: $visibility)';
}


}

/// @nodoc
abstract mixin class $LoyaltyCardFormDataCopyWith<$Res>  {
  factory $LoyaltyCardFormDataCopyWith(LoyaltyCardFormData value, $Res Function(LoyaltyCardFormData) _then) = _$LoyaltyCardFormDataCopyWithImpl;
@useResult
$Res call({
 String? cardId, String storeName, BarcodeType barcodeType, String barcodeData, String? brandColor, String? iconAsset, LoyaltyCardCategory category, String visibility
});




}
/// @nodoc
class _$LoyaltyCardFormDataCopyWithImpl<$Res>
    implements $LoyaltyCardFormDataCopyWith<$Res> {
  _$LoyaltyCardFormDataCopyWithImpl(this._self, this._then);

  final LoyaltyCardFormData _self;
  final $Res Function(LoyaltyCardFormData) _then;

/// Create a copy of LoyaltyCardFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardId = freezed,Object? storeName = null,Object? barcodeType = null,Object? barcodeData = null,Object? brandColor = freezed,Object? iconAsset = freezed,Object? category = null,Object? visibility = null,}) {
  return _then(_self.copyWith(
cardId: freezed == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as BarcodeType,barcodeData: null == barcodeData ? _self.barcodeData : barcodeData // ignore: cast_nullable_to_non_nullable
as String,brandColor: freezed == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String?,iconAsset: freezed == iconAsset ? _self.iconAsset : iconAsset // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LoyaltyCardCategory,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyCardFormData].
extension LoyaltyCardFormDataPatterns on LoyaltyCardFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyCardFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyCardFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyCardFormData value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCardFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyCardFormData value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCardFormData() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _LoyaltyCardFormData implements LoyaltyCardFormData {
  const _LoyaltyCardFormData({this.cardId, this.storeName = '', this.barcodeType = BarcodeType.manual, this.barcodeData = '', this.brandColor, this.iconAsset, this.category = LoyaltyCardCategory.other, this.visibility = 'personal'});
  

/// NULL = создание, UUID = редактирование.
@override final  String? cardId;
@override@JsonKey() final  String storeName;
@override@JsonKey() final  BarcodeType barcodeType;
@override@JsonKey() final  String barcodeData;
/// #RRGGBB или null.
@override final  String? brandColor;
@override final  String? iconAsset;
@override@JsonKey() final  LoyaltyCardCategory category;
/// 'personal' | 'family'.
@override@JsonKey() final  String visibility;

/// Create a copy of LoyaltyCardFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyCardFormDataCopyWith<_LoyaltyCardFormData> get copyWith => __$LoyaltyCardFormDataCopyWithImpl<_LoyaltyCardFormData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyCardFormData&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.barcodeData, barcodeData) || other.barcodeData == barcodeData)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconAsset, iconAsset) || other.iconAsset == iconAsset)&&(identical(other.category, category) || other.category == category)&&(identical(other.visibility, visibility) || other.visibility == visibility));
}


@override
int get hashCode => Object.hash(runtimeType,cardId,storeName,barcodeType,barcodeData,brandColor,iconAsset,category,visibility);

@override
String toString() {
  return 'LoyaltyCardFormData(cardId: $cardId, storeName: $storeName, barcodeType: $barcodeType, barcodeData: $barcodeData, brandColor: $brandColor, iconAsset: $iconAsset, category: $category, visibility: $visibility)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyCardFormDataCopyWith<$Res> implements $LoyaltyCardFormDataCopyWith<$Res> {
  factory _$LoyaltyCardFormDataCopyWith(_LoyaltyCardFormData value, $Res Function(_LoyaltyCardFormData) _then) = __$LoyaltyCardFormDataCopyWithImpl;
@override @useResult
$Res call({
 String? cardId, String storeName, BarcodeType barcodeType, String barcodeData, String? brandColor, String? iconAsset, LoyaltyCardCategory category, String visibility
});




}
/// @nodoc
class __$LoyaltyCardFormDataCopyWithImpl<$Res>
    implements _$LoyaltyCardFormDataCopyWith<$Res> {
  __$LoyaltyCardFormDataCopyWithImpl(this._self, this._then);

  final _LoyaltyCardFormData _self;
  final $Res Function(_LoyaltyCardFormData) _then;

/// Create a copy of LoyaltyCardFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardId = freezed,Object? storeName = null,Object? barcodeType = null,Object? barcodeData = null,Object? brandColor = freezed,Object? iconAsset = freezed,Object? category = null,Object? visibility = null,}) {
  return _then(_LoyaltyCardFormData(
cardId: freezed == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as BarcodeType,barcodeData: null == barcodeData ? _self.barcodeData : barcodeData // ignore: cast_nullable_to_non_nullable
as String,brandColor: freezed == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String?,iconAsset: freezed == iconAsset ? _self.iconAsset : iconAsset // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LoyaltyCardCategory,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoyaltyCard {

 String get id; String get userId;/// NULL = личная, UUID = семейная.
 String? get spaceId; String get storeName; String? get cardNumber; BarcodeType get barcodeType; String get barcodeData;/// #RRGGBB или null.
 String? get brandColor;/// Эмодзи/ассет.
 String? get iconAsset; LoyaltyCardCategory get category; bool get isFavorite; bool get isShared;/// [LOCAL] не синхронизируется.
 int? get sortOrder;/// [LOCAL] 'portrait' | 'landscape' | null.
 String? get preferredOrientation; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyCardCopyWith<LoyaltyCard> get copyWith => _$LoyaltyCardCopyWithImpl<LoyaltyCard>(this as LoyaltyCard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyCard&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.barcodeData, barcodeData) || other.barcodeData == barcodeData)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconAsset, iconAsset) || other.iconAsset == iconAsset)&&(identical(other.category, category) || other.category == category)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isShared, isShared) || other.isShared == isShared)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.preferredOrientation, preferredOrientation) || other.preferredOrientation == preferredOrientation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,storeName,cardNumber,barcodeType,barcodeData,brandColor,iconAsset,category,isFavorite,isShared,sortOrder,preferredOrientation,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'LoyaltyCard(id: $id, userId: $userId, spaceId: $spaceId, storeName: $storeName, cardNumber: $cardNumber, barcodeType: $barcodeType, barcodeData: $barcodeData, brandColor: $brandColor, iconAsset: $iconAsset, category: $category, isFavorite: $isFavorite, isShared: $isShared, sortOrder: $sortOrder, preferredOrientation: $preferredOrientation, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $LoyaltyCardCopyWith<$Res>  {
  factory $LoyaltyCardCopyWith(LoyaltyCard value, $Res Function(LoyaltyCard) _then) = _$LoyaltyCardCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, String storeName, String? cardNumber, BarcodeType barcodeType, String barcodeData, String? brandColor, String? iconAsset, LoyaltyCardCategory category, bool isFavorite, bool isShared, int? sortOrder, String? preferredOrientation, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$LoyaltyCardCopyWithImpl<$Res>
    implements $LoyaltyCardCopyWith<$Res> {
  _$LoyaltyCardCopyWithImpl(this._self, this._then);

  final LoyaltyCard _self;
  final $Res Function(LoyaltyCard) _then;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? storeName = null,Object? cardNumber = freezed,Object? barcodeType = null,Object? barcodeData = null,Object? brandColor = freezed,Object? iconAsset = freezed,Object? category = null,Object? isFavorite = null,Object? isShared = null,Object? sortOrder = freezed,Object? preferredOrientation = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as BarcodeType,barcodeData: null == barcodeData ? _self.barcodeData : barcodeData // ignore: cast_nullable_to_non_nullable
as String,brandColor: freezed == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String?,iconAsset: freezed == iconAsset ? _self.iconAsset : iconAsset // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LoyaltyCardCategory,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isShared: null == isShared ? _self.isShared : isShared // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,preferredOrientation: freezed == preferredOrientation ? _self.preferredOrientation : preferredOrientation // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyCard].
extension LoyaltyCardPatterns on LoyaltyCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyCard value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyCard value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _LoyaltyCard implements LoyaltyCard {
  const _LoyaltyCard({required this.id, required this.userId, this.spaceId, required this.storeName, this.cardNumber, required this.barcodeType, required this.barcodeData, this.brandColor, this.iconAsset, this.category = LoyaltyCardCategory.other, this.isFavorite = false, this.isShared = true, this.sortOrder, this.preferredOrientation, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  

@override final  String id;
@override final  String userId;
/// NULL = личная, UUID = семейная.
@override final  String? spaceId;
@override final  String storeName;
@override final  String? cardNumber;
@override final  BarcodeType barcodeType;
@override final  String barcodeData;
/// #RRGGBB или null.
@override final  String? brandColor;
/// Эмодзи/ассет.
@override final  String? iconAsset;
@override@JsonKey() final  LoyaltyCardCategory category;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  bool isShared;
/// [LOCAL] не синхронизируется.
@override final  int? sortOrder;
/// [LOCAL] 'portrait' | 'landscape' | null.
@override final  String? preferredOrientation;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyCardCopyWith<_LoyaltyCard> get copyWith => __$LoyaltyCardCopyWithImpl<_LoyaltyCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyCard&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.barcodeData, barcodeData) || other.barcodeData == barcodeData)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconAsset, iconAsset) || other.iconAsset == iconAsset)&&(identical(other.category, category) || other.category == category)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isShared, isShared) || other.isShared == isShared)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.preferredOrientation, preferredOrientation) || other.preferredOrientation == preferredOrientation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,spaceId,storeName,cardNumber,barcodeType,barcodeData,brandColor,iconAsset,category,isFavorite,isShared,sortOrder,preferredOrientation,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'LoyaltyCard(id: $id, userId: $userId, spaceId: $spaceId, storeName: $storeName, cardNumber: $cardNumber, barcodeType: $barcodeType, barcodeData: $barcodeData, brandColor: $brandColor, iconAsset: $iconAsset, category: $category, isFavorite: $isFavorite, isShared: $isShared, sortOrder: $sortOrder, preferredOrientation: $preferredOrientation, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyCardCopyWith<$Res> implements $LoyaltyCardCopyWith<$Res> {
  factory _$LoyaltyCardCopyWith(_LoyaltyCard value, $Res Function(_LoyaltyCard) _then) = __$LoyaltyCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, String storeName, String? cardNumber, BarcodeType barcodeType, String barcodeData, String? brandColor, String? iconAsset, LoyaltyCardCategory category, bool isFavorite, bool isShared, int? sortOrder, String? preferredOrientation, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$LoyaltyCardCopyWithImpl<$Res>
    implements _$LoyaltyCardCopyWith<$Res> {
  __$LoyaltyCardCopyWithImpl(this._self, this._then);

  final _LoyaltyCard _self;
  final $Res Function(_LoyaltyCard) _then;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? storeName = null,Object? cardNumber = freezed,Object? barcodeType = null,Object? barcodeData = null,Object? brandColor = freezed,Object? iconAsset = freezed,Object? category = null,Object? isFavorite = null,Object? isShared = null,Object? sortOrder = freezed,Object? preferredOrientation = freezed,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_LoyaltyCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,barcodeType: null == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as BarcodeType,barcodeData: null == barcodeData ? _self.barcodeData : barcodeData // ignore: cast_nullable_to_non_nullable
as String,brandColor: freezed == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String?,iconAsset: freezed == iconAsset ? _self.iconAsset : iconAsset // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LoyaltyCardCategory,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isShared: null == isShared ? _self.isShared : isShared // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,preferredOrientation: freezed == preferredOrientation ? _self.preferredOrientation : preferredOrientation // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

/// @nodoc
mixin _$LoyaltyCardsStats {

 int get total; int get favorites; int get family;
/// Create a copy of LoyaltyCardsStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyCardsStatsCopyWith<LoyaltyCardsStats> get copyWith => _$LoyaltyCardsStatsCopyWithImpl<LoyaltyCardsStats>(this as LoyaltyCardsStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyCardsStats&&(identical(other.total, total) || other.total == total)&&(identical(other.favorites, favorites) || other.favorites == favorites)&&(identical(other.family, family) || other.family == family));
}


@override
int get hashCode => Object.hash(runtimeType,total,favorites,family);

@override
String toString() {
  return 'LoyaltyCardsStats(total: $total, favorites: $favorites, family: $family)';
}


}

/// @nodoc
abstract mixin class $LoyaltyCardsStatsCopyWith<$Res>  {
  factory $LoyaltyCardsStatsCopyWith(LoyaltyCardsStats value, $Res Function(LoyaltyCardsStats) _then) = _$LoyaltyCardsStatsCopyWithImpl;
@useResult
$Res call({
 int total, int favorites, int family
});




}
/// @nodoc
class _$LoyaltyCardsStatsCopyWithImpl<$Res>
    implements $LoyaltyCardsStatsCopyWith<$Res> {
  _$LoyaltyCardsStatsCopyWithImpl(this._self, this._then);

  final LoyaltyCardsStats _self;
  final $Res Function(LoyaltyCardsStats) _then;

/// Create a copy of LoyaltyCardsStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? favorites = null,Object? family = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as int,family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyCardsStats].
extension LoyaltyCardsStatsPatterns on LoyaltyCardsStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyCardsStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyCardsStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyCardsStats value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCardsStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyCardsStats value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCardsStats() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _LoyaltyCardsStats implements LoyaltyCardsStats {
  const _LoyaltyCardsStats({required this.total, required this.favorites, required this.family});
  

@override final  int total;
@override final  int favorites;
@override final  int family;

/// Create a copy of LoyaltyCardsStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyCardsStatsCopyWith<_LoyaltyCardsStats> get copyWith => __$LoyaltyCardsStatsCopyWithImpl<_LoyaltyCardsStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyCardsStats&&(identical(other.total, total) || other.total == total)&&(identical(other.favorites, favorites) || other.favorites == favorites)&&(identical(other.family, family) || other.family == family));
}


@override
int get hashCode => Object.hash(runtimeType,total,favorites,family);

@override
String toString() {
  return 'LoyaltyCardsStats(total: $total, favorites: $favorites, family: $family)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyCardsStatsCopyWith<$Res> implements $LoyaltyCardsStatsCopyWith<$Res> {
  factory _$LoyaltyCardsStatsCopyWith(_LoyaltyCardsStats value, $Res Function(_LoyaltyCardsStats) _then) = __$LoyaltyCardsStatsCopyWithImpl;
@override @useResult
$Res call({
 int total, int favorites, int family
});




}
/// @nodoc
class __$LoyaltyCardsStatsCopyWithImpl<$Res>
    implements _$LoyaltyCardsStatsCopyWith<$Res> {
  __$LoyaltyCardsStatsCopyWithImpl(this._self, this._then);

  final _LoyaltyCardsStats _self;
  final $Res Function(_LoyaltyCardsStats) _then;

/// Create a copy of LoyaltyCardsStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? favorites = null,Object? family = null,}) {
  return _then(_LoyaltyCardsStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as int,family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

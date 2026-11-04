// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_analytics_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PricePoint {

 String get day; int get priceKopecks;
/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricePointCopyWith<PricePoint> get copyWith => _$PricePointCopyWithImpl<PricePoint>(this as PricePoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricePoint&&(identical(other.day, day) || other.day == day)&&(identical(other.priceKopecks, priceKopecks) || other.priceKopecks == priceKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,day,priceKopecks);

@override
String toString() {
  return 'PricePoint(day: $day, priceKopecks: $priceKopecks)';
}


}

/// @nodoc
abstract mixin class $PricePointCopyWith<$Res>  {
  factory $PricePointCopyWith(PricePoint value, $Res Function(PricePoint) _then) = _$PricePointCopyWithImpl;
@useResult
$Res call({
 String day, int priceKopecks
});




}
/// @nodoc
class _$PricePointCopyWithImpl<$Res>
    implements $PricePointCopyWith<$Res> {
  _$PricePointCopyWithImpl(this._self, this._then);

  final PricePoint _self;
  final $Res Function(PricePoint) _then;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? priceKopecks = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,priceKopecks: null == priceKopecks ? _self.priceKopecks : priceKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PricePoint].
extension PricePointPatterns on PricePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricePoint value)  $default,){
final _that = this;
switch (_that) {
case _PricePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricePoint value)?  $default,){
final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _PricePoint implements PricePoint {
  const _PricePoint({required this.day, required this.priceKopecks});
  

@override final  String day;
@override final  int priceKopecks;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricePointCopyWith<_PricePoint> get copyWith => __$PricePointCopyWithImpl<_PricePoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricePoint&&(identical(other.day, day) || other.day == day)&&(identical(other.priceKopecks, priceKopecks) || other.priceKopecks == priceKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,day,priceKopecks);

@override
String toString() {
  return 'PricePoint(day: $day, priceKopecks: $priceKopecks)';
}


}

/// @nodoc
abstract mixin class _$PricePointCopyWith<$Res> implements $PricePointCopyWith<$Res> {
  factory _$PricePointCopyWith(_PricePoint value, $Res Function(_PricePoint) _then) = __$PricePointCopyWithImpl;
@override @useResult
$Res call({
 String day, int priceKopecks
});




}
/// @nodoc
class __$PricePointCopyWithImpl<$Res>
    implements _$PricePointCopyWith<$Res> {
  __$PricePointCopyWithImpl(this._self, this._then);

  final _PricePoint _self;
  final $Res Function(_PricePoint) _then;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? priceKopecks = null,}) {
  return _then(_PricePoint(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,priceKopecks: null == priceKopecks ? _self.priceKopecks : priceKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TopProduct {

 String get productHash; String get name; String? get categoryId; int get purchases; int get totalSpendKopecks; double get totalQuantity; int get avgPriceKopecks; PriceTrend get trend; List<PricePoint> get points; String get firstSeen; String get lastSeen;
/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopProductCopyWith<TopProduct> get copyWith => _$TopProductCopyWithImpl<TopProduct>(this as TopProduct, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopProduct&&(identical(other.productHash, productHash) || other.productHash == productHash)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.purchases, purchases) || other.purchases == purchases)&&(identical(other.totalSpendKopecks, totalSpendKopecks) || other.totalSpendKopecks == totalSpendKopecks)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.avgPriceKopecks, avgPriceKopecks) || other.avgPriceKopecks == avgPriceKopecks)&&(identical(other.trend, trend) || other.trend == trend)&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.firstSeen, firstSeen) || other.firstSeen == firstSeen)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}


@override
int get hashCode => Object.hash(runtimeType,productHash,name,categoryId,purchases,totalSpendKopecks,totalQuantity,avgPriceKopecks,trend,const DeepCollectionEquality().hash(points),firstSeen,lastSeen);

@override
String toString() {
  return 'TopProduct(productHash: $productHash, name: $name, categoryId: $categoryId, purchases: $purchases, totalSpendKopecks: $totalSpendKopecks, totalQuantity: $totalQuantity, avgPriceKopecks: $avgPriceKopecks, trend: $trend, points: $points, firstSeen: $firstSeen, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class $TopProductCopyWith<$Res>  {
  factory $TopProductCopyWith(TopProduct value, $Res Function(TopProduct) _then) = _$TopProductCopyWithImpl;
@useResult
$Res call({
 String productHash, String name, String? categoryId, int purchases, int totalSpendKopecks, double totalQuantity, int avgPriceKopecks, PriceTrend trend, List<PricePoint> points, String firstSeen, String lastSeen
});




}
/// @nodoc
class _$TopProductCopyWithImpl<$Res>
    implements $TopProductCopyWith<$Res> {
  _$TopProductCopyWithImpl(this._self, this._then);

  final TopProduct _self;
  final $Res Function(TopProduct) _then;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productHash = null,Object? name = null,Object? categoryId = freezed,Object? purchases = null,Object? totalSpendKopecks = null,Object? totalQuantity = null,Object? avgPriceKopecks = null,Object? trend = null,Object? points = null,Object? firstSeen = null,Object? lastSeen = null,}) {
  return _then(_self.copyWith(
productHash: null == productHash ? _self.productHash : productHash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as int,totalSpendKopecks: null == totalSpendKopecks ? _self.totalSpendKopecks : totalSpendKopecks // ignore: cast_nullable_to_non_nullable
as int,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as double,avgPriceKopecks: null == avgPriceKopecks ? _self.avgPriceKopecks : avgPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as PriceTrend,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,firstSeen: null == firstSeen ? _self.firstSeen : firstSeen // ignore: cast_nullable_to_non_nullable
as String,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TopProduct].
extension TopProductPatterns on TopProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopProduct value)  $default,){
final _that = this;
switch (_that) {
case _TopProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopProduct value)?  $default,){
final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TopProduct implements TopProduct {
  const _TopProduct({required this.productHash, required this.name, this.categoryId, required this.purchases, required this.totalSpendKopecks, required this.totalQuantity, required this.avgPriceKopecks, required this.trend, required final  List<PricePoint> points, required this.firstSeen, required this.lastSeen}): _points = points;
  

@override final  String productHash;
@override final  String name;
@override final  String? categoryId;
@override final  int purchases;
@override final  int totalSpendKopecks;
@override final  double totalQuantity;
@override final  int avgPriceKopecks;
@override final  PriceTrend trend;
 final  List<PricePoint> _points;
@override List<PricePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override final  String firstSeen;
@override final  String lastSeen;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopProductCopyWith<_TopProduct> get copyWith => __$TopProductCopyWithImpl<_TopProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopProduct&&(identical(other.productHash, productHash) || other.productHash == productHash)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.purchases, purchases) || other.purchases == purchases)&&(identical(other.totalSpendKopecks, totalSpendKopecks) || other.totalSpendKopecks == totalSpendKopecks)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.avgPriceKopecks, avgPriceKopecks) || other.avgPriceKopecks == avgPriceKopecks)&&(identical(other.trend, trend) || other.trend == trend)&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.firstSeen, firstSeen) || other.firstSeen == firstSeen)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}


@override
int get hashCode => Object.hash(runtimeType,productHash,name,categoryId,purchases,totalSpendKopecks,totalQuantity,avgPriceKopecks,trend,const DeepCollectionEquality().hash(_points),firstSeen,lastSeen);

@override
String toString() {
  return 'TopProduct(productHash: $productHash, name: $name, categoryId: $categoryId, purchases: $purchases, totalSpendKopecks: $totalSpendKopecks, totalQuantity: $totalQuantity, avgPriceKopecks: $avgPriceKopecks, trend: $trend, points: $points, firstSeen: $firstSeen, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class _$TopProductCopyWith<$Res> implements $TopProductCopyWith<$Res> {
  factory _$TopProductCopyWith(_TopProduct value, $Res Function(_TopProduct) _then) = __$TopProductCopyWithImpl;
@override @useResult
$Res call({
 String productHash, String name, String? categoryId, int purchases, int totalSpendKopecks, double totalQuantity, int avgPriceKopecks, PriceTrend trend, List<PricePoint> points, String firstSeen, String lastSeen
});




}
/// @nodoc
class __$TopProductCopyWithImpl<$Res>
    implements _$TopProductCopyWith<$Res> {
  __$TopProductCopyWithImpl(this._self, this._then);

  final _TopProduct _self;
  final $Res Function(_TopProduct) _then;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productHash = null,Object? name = null,Object? categoryId = freezed,Object? purchases = null,Object? totalSpendKopecks = null,Object? totalQuantity = null,Object? avgPriceKopecks = null,Object? trend = null,Object? points = null,Object? firstSeen = null,Object? lastSeen = null,}) {
  return _then(_TopProduct(
productHash: null == productHash ? _self.productHash : productHash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as int,totalSpendKopecks: null == totalSpendKopecks ? _self.totalSpendKopecks : totalSpendKopecks // ignore: cast_nullable_to_non_nullable
as int,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as double,avgPriceKopecks: null == avgPriceKopecks ? _self.avgPriceKopecks : avgPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as PriceTrend,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,firstSeen: null == firstSeen ? _self.firstSeen : firstSeen // ignore: cast_nullable_to_non_nullable
as String,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TopCategory {

 String get categoryId; int get totalSpendKopecks; int get uniqueProducts; double get avgQuantityPerPurchase; double get percent;
/// Create a copy of TopCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopCategoryCopyWith<TopCategory> get copyWith => _$TopCategoryCopyWithImpl<TopCategory>(this as TopCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.totalSpendKopecks, totalSpendKopecks) || other.totalSpendKopecks == totalSpendKopecks)&&(identical(other.uniqueProducts, uniqueProducts) || other.uniqueProducts == uniqueProducts)&&(identical(other.avgQuantityPerPurchase, avgQuantityPerPurchase) || other.avgQuantityPerPurchase == avgQuantityPerPurchase)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,totalSpendKopecks,uniqueProducts,avgQuantityPerPurchase,percent);

@override
String toString() {
  return 'TopCategory(categoryId: $categoryId, totalSpendKopecks: $totalSpendKopecks, uniqueProducts: $uniqueProducts, avgQuantityPerPurchase: $avgQuantityPerPurchase, percent: $percent)';
}


}

/// @nodoc
abstract mixin class $TopCategoryCopyWith<$Res>  {
  factory $TopCategoryCopyWith(TopCategory value, $Res Function(TopCategory) _then) = _$TopCategoryCopyWithImpl;
@useResult
$Res call({
 String categoryId, int totalSpendKopecks, int uniqueProducts, double avgQuantityPerPurchase, double percent
});




}
/// @nodoc
class _$TopCategoryCopyWithImpl<$Res>
    implements $TopCategoryCopyWith<$Res> {
  _$TopCategoryCopyWithImpl(this._self, this._then);

  final TopCategory _self;
  final $Res Function(TopCategory) _then;

/// Create a copy of TopCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? totalSpendKopecks = null,Object? uniqueProducts = null,Object? avgQuantityPerPurchase = null,Object? percent = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,totalSpendKopecks: null == totalSpendKopecks ? _self.totalSpendKopecks : totalSpendKopecks // ignore: cast_nullable_to_non_nullable
as int,uniqueProducts: null == uniqueProducts ? _self.uniqueProducts : uniqueProducts // ignore: cast_nullable_to_non_nullable
as int,avgQuantityPerPurchase: null == avgQuantityPerPurchase ? _self.avgQuantityPerPurchase : avgQuantityPerPurchase // ignore: cast_nullable_to_non_nullable
as double,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TopCategory].
extension TopCategoryPatterns on TopCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopCategory value)  $default,){
final _that = this;
switch (_that) {
case _TopCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopCategory value)?  $default,){
final _that = this;
switch (_that) {
case _TopCategory() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TopCategory implements TopCategory {
  const _TopCategory({required this.categoryId, required this.totalSpendKopecks, required this.uniqueProducts, required this.avgQuantityPerPurchase, required this.percent});
  

@override final  String categoryId;
@override final  int totalSpendKopecks;
@override final  int uniqueProducts;
@override final  double avgQuantityPerPurchase;
@override final  double percent;

/// Create a copy of TopCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopCategoryCopyWith<_TopCategory> get copyWith => __$TopCategoryCopyWithImpl<_TopCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.totalSpendKopecks, totalSpendKopecks) || other.totalSpendKopecks == totalSpendKopecks)&&(identical(other.uniqueProducts, uniqueProducts) || other.uniqueProducts == uniqueProducts)&&(identical(other.avgQuantityPerPurchase, avgQuantityPerPurchase) || other.avgQuantityPerPurchase == avgQuantityPerPurchase)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,totalSpendKopecks,uniqueProducts,avgQuantityPerPurchase,percent);

@override
String toString() {
  return 'TopCategory(categoryId: $categoryId, totalSpendKopecks: $totalSpendKopecks, uniqueProducts: $uniqueProducts, avgQuantityPerPurchase: $avgQuantityPerPurchase, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$TopCategoryCopyWith<$Res> implements $TopCategoryCopyWith<$Res> {
  factory _$TopCategoryCopyWith(_TopCategory value, $Res Function(_TopCategory) _then) = __$TopCategoryCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, int totalSpendKopecks, int uniqueProducts, double avgQuantityPerPurchase, double percent
});




}
/// @nodoc
class __$TopCategoryCopyWithImpl<$Res>
    implements _$TopCategoryCopyWith<$Res> {
  __$TopCategoryCopyWithImpl(this._self, this._then);

  final _TopCategory _self;
  final $Res Function(_TopCategory) _then;

/// Create a copy of TopCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? totalSpendKopecks = null,Object? uniqueProducts = null,Object? avgQuantityPerPurchase = null,Object? percent = null,}) {
  return _then(_TopCategory(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,totalSpendKopecks: null == totalSpendKopecks ? _self.totalSpendKopecks : totalSpendKopecks // ignore: cast_nullable_to_non_nullable
as int,uniqueProducts: null == uniqueProducts ? _self.uniqueProducts : uniqueProducts // ignore: cast_nullable_to_non_nullable
as int,avgQuantityPerPurchase: null == avgQuantityPerPurchase ? _self.avgQuantityPerPurchase : avgQuantityPerPurchase // ignore: cast_nullable_to_non_nullable
as double,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$PriceChangeEntry {

 String get productHash; String get name; String? get categoryId; String get firstMonthLabel; int get firstPriceKopecks; String get lastMonthLabel; int get lastPriceKopecks; double get changePercent; int get changeAbsKopecks; List<PricePoint> get points;
/// Create a copy of PriceChangeEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceChangeEntryCopyWith<PriceChangeEntry> get copyWith => _$PriceChangeEntryCopyWithImpl<PriceChangeEntry>(this as PriceChangeEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceChangeEntry&&(identical(other.productHash, productHash) || other.productHash == productHash)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.firstMonthLabel, firstMonthLabel) || other.firstMonthLabel == firstMonthLabel)&&(identical(other.firstPriceKopecks, firstPriceKopecks) || other.firstPriceKopecks == firstPriceKopecks)&&(identical(other.lastMonthLabel, lastMonthLabel) || other.lastMonthLabel == lastMonthLabel)&&(identical(other.lastPriceKopecks, lastPriceKopecks) || other.lastPriceKopecks == lastPriceKopecks)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent)&&(identical(other.changeAbsKopecks, changeAbsKopecks) || other.changeAbsKopecks == changeAbsKopecks)&&const DeepCollectionEquality().equals(other.points, points));
}


@override
int get hashCode => Object.hash(runtimeType,productHash,name,categoryId,firstMonthLabel,firstPriceKopecks,lastMonthLabel,lastPriceKopecks,changePercent,changeAbsKopecks,const DeepCollectionEquality().hash(points));

@override
String toString() {
  return 'PriceChangeEntry(productHash: $productHash, name: $name, categoryId: $categoryId, firstMonthLabel: $firstMonthLabel, firstPriceKopecks: $firstPriceKopecks, lastMonthLabel: $lastMonthLabel, lastPriceKopecks: $lastPriceKopecks, changePercent: $changePercent, changeAbsKopecks: $changeAbsKopecks, points: $points)';
}


}

/// @nodoc
abstract mixin class $PriceChangeEntryCopyWith<$Res>  {
  factory $PriceChangeEntryCopyWith(PriceChangeEntry value, $Res Function(PriceChangeEntry) _then) = _$PriceChangeEntryCopyWithImpl;
@useResult
$Res call({
 String productHash, String name, String? categoryId, String firstMonthLabel, int firstPriceKopecks, String lastMonthLabel, int lastPriceKopecks, double changePercent, int changeAbsKopecks, List<PricePoint> points
});




}
/// @nodoc
class _$PriceChangeEntryCopyWithImpl<$Res>
    implements $PriceChangeEntryCopyWith<$Res> {
  _$PriceChangeEntryCopyWithImpl(this._self, this._then);

  final PriceChangeEntry _self;
  final $Res Function(PriceChangeEntry) _then;

/// Create a copy of PriceChangeEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productHash = null,Object? name = null,Object? categoryId = freezed,Object? firstMonthLabel = null,Object? firstPriceKopecks = null,Object? lastMonthLabel = null,Object? lastPriceKopecks = null,Object? changePercent = null,Object? changeAbsKopecks = null,Object? points = null,}) {
  return _then(_self.copyWith(
productHash: null == productHash ? _self.productHash : productHash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,firstMonthLabel: null == firstMonthLabel ? _self.firstMonthLabel : firstMonthLabel // ignore: cast_nullable_to_non_nullable
as String,firstPriceKopecks: null == firstPriceKopecks ? _self.firstPriceKopecks : firstPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,lastMonthLabel: null == lastMonthLabel ? _self.lastMonthLabel : lastMonthLabel // ignore: cast_nullable_to_non_nullable
as String,lastPriceKopecks: null == lastPriceKopecks ? _self.lastPriceKopecks : lastPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,changePercent: null == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double,changeAbsKopecks: null == changeAbsKopecks ? _self.changeAbsKopecks : changeAbsKopecks // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceChangeEntry].
extension PriceChangeEntryPatterns on PriceChangeEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceChangeEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceChangeEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceChangeEntry value)  $default,){
final _that = this;
switch (_that) {
case _PriceChangeEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceChangeEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PriceChangeEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _PriceChangeEntry implements PriceChangeEntry {
  const _PriceChangeEntry({required this.productHash, required this.name, this.categoryId, required this.firstMonthLabel, required this.firstPriceKopecks, required this.lastMonthLabel, required this.lastPriceKopecks, required this.changePercent, required this.changeAbsKopecks, required final  List<PricePoint> points}): _points = points;
  

@override final  String productHash;
@override final  String name;
@override final  String? categoryId;
@override final  String firstMonthLabel;
@override final  int firstPriceKopecks;
@override final  String lastMonthLabel;
@override final  int lastPriceKopecks;
@override final  double changePercent;
@override final  int changeAbsKopecks;
 final  List<PricePoint> _points;
@override List<PricePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of PriceChangeEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceChangeEntryCopyWith<_PriceChangeEntry> get copyWith => __$PriceChangeEntryCopyWithImpl<_PriceChangeEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceChangeEntry&&(identical(other.productHash, productHash) || other.productHash == productHash)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.firstMonthLabel, firstMonthLabel) || other.firstMonthLabel == firstMonthLabel)&&(identical(other.firstPriceKopecks, firstPriceKopecks) || other.firstPriceKopecks == firstPriceKopecks)&&(identical(other.lastMonthLabel, lastMonthLabel) || other.lastMonthLabel == lastMonthLabel)&&(identical(other.lastPriceKopecks, lastPriceKopecks) || other.lastPriceKopecks == lastPriceKopecks)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent)&&(identical(other.changeAbsKopecks, changeAbsKopecks) || other.changeAbsKopecks == changeAbsKopecks)&&const DeepCollectionEquality().equals(other._points, _points));
}


@override
int get hashCode => Object.hash(runtimeType,productHash,name,categoryId,firstMonthLabel,firstPriceKopecks,lastMonthLabel,lastPriceKopecks,changePercent,changeAbsKopecks,const DeepCollectionEquality().hash(_points));

@override
String toString() {
  return 'PriceChangeEntry(productHash: $productHash, name: $name, categoryId: $categoryId, firstMonthLabel: $firstMonthLabel, firstPriceKopecks: $firstPriceKopecks, lastMonthLabel: $lastMonthLabel, lastPriceKopecks: $lastPriceKopecks, changePercent: $changePercent, changeAbsKopecks: $changeAbsKopecks, points: $points)';
}


}

/// @nodoc
abstract mixin class _$PriceChangeEntryCopyWith<$Res> implements $PriceChangeEntryCopyWith<$Res> {
  factory _$PriceChangeEntryCopyWith(_PriceChangeEntry value, $Res Function(_PriceChangeEntry) _then) = __$PriceChangeEntryCopyWithImpl;
@override @useResult
$Res call({
 String productHash, String name, String? categoryId, String firstMonthLabel, int firstPriceKopecks, String lastMonthLabel, int lastPriceKopecks, double changePercent, int changeAbsKopecks, List<PricePoint> points
});




}
/// @nodoc
class __$PriceChangeEntryCopyWithImpl<$Res>
    implements _$PriceChangeEntryCopyWith<$Res> {
  __$PriceChangeEntryCopyWithImpl(this._self, this._then);

  final _PriceChangeEntry _self;
  final $Res Function(_PriceChangeEntry) _then;

/// Create a copy of PriceChangeEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productHash = null,Object? name = null,Object? categoryId = freezed,Object? firstMonthLabel = null,Object? firstPriceKopecks = null,Object? lastMonthLabel = null,Object? lastPriceKopecks = null,Object? changePercent = null,Object? changeAbsKopecks = null,Object? points = null,}) {
  return _then(_PriceChangeEntry(
productHash: null == productHash ? _self.productHash : productHash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,firstMonthLabel: null == firstMonthLabel ? _self.firstMonthLabel : firstMonthLabel // ignore: cast_nullable_to_non_nullable
as String,firstPriceKopecks: null == firstPriceKopecks ? _self.firstPriceKopecks : firstPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,lastMonthLabel: null == lastMonthLabel ? _self.lastMonthLabel : lastMonthLabel // ignore: cast_nullable_to_non_nullable
as String,lastPriceKopecks: null == lastPriceKopecks ? _self.lastPriceKopecks : lastPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,changePercent: null == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double,changeAbsKopecks: null == changeAbsKopecks ? _self.changeAbsKopecks : changeAbsKopecks // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,
  ));
}


}

/// @nodoc
mixin _$StoreBreakdown {

 String get storeName; int get purchases; int get avgPriceKopecks;
/// Create a copy of StoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreBreakdownCopyWith<StoreBreakdown> get copyWith => _$StoreBreakdownCopyWithImpl<StoreBreakdown>(this as StoreBreakdown, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreBreakdown&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.purchases, purchases) || other.purchases == purchases)&&(identical(other.avgPriceKopecks, avgPriceKopecks) || other.avgPriceKopecks == avgPriceKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,storeName,purchases,avgPriceKopecks);

@override
String toString() {
  return 'StoreBreakdown(storeName: $storeName, purchases: $purchases, avgPriceKopecks: $avgPriceKopecks)';
}


}

/// @nodoc
abstract mixin class $StoreBreakdownCopyWith<$Res>  {
  factory $StoreBreakdownCopyWith(StoreBreakdown value, $Res Function(StoreBreakdown) _then) = _$StoreBreakdownCopyWithImpl;
@useResult
$Res call({
 String storeName, int purchases, int avgPriceKopecks
});




}
/// @nodoc
class _$StoreBreakdownCopyWithImpl<$Res>
    implements $StoreBreakdownCopyWith<$Res> {
  _$StoreBreakdownCopyWithImpl(this._self, this._then);

  final StoreBreakdown _self;
  final $Res Function(StoreBreakdown) _then;

/// Create a copy of StoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeName = null,Object? purchases = null,Object? avgPriceKopecks = null,}) {
  return _then(_self.copyWith(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as int,avgPriceKopecks: null == avgPriceKopecks ? _self.avgPriceKopecks : avgPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreBreakdown].
extension StoreBreakdownPatterns on StoreBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _StoreBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _StoreBreakdown() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _StoreBreakdown implements StoreBreakdown {
  const _StoreBreakdown({required this.storeName, required this.purchases, required this.avgPriceKopecks});
  

@override final  String storeName;
@override final  int purchases;
@override final  int avgPriceKopecks;

/// Create a copy of StoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreBreakdownCopyWith<_StoreBreakdown> get copyWith => __$StoreBreakdownCopyWithImpl<_StoreBreakdown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreBreakdown&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.purchases, purchases) || other.purchases == purchases)&&(identical(other.avgPriceKopecks, avgPriceKopecks) || other.avgPriceKopecks == avgPriceKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,storeName,purchases,avgPriceKopecks);

@override
String toString() {
  return 'StoreBreakdown(storeName: $storeName, purchases: $purchases, avgPriceKopecks: $avgPriceKopecks)';
}


}

/// @nodoc
abstract mixin class _$StoreBreakdownCopyWith<$Res> implements $StoreBreakdownCopyWith<$Res> {
  factory _$StoreBreakdownCopyWith(_StoreBreakdown value, $Res Function(_StoreBreakdown) _then) = __$StoreBreakdownCopyWithImpl;
@override @useResult
$Res call({
 String storeName, int purchases, int avgPriceKopecks
});




}
/// @nodoc
class __$StoreBreakdownCopyWithImpl<$Res>
    implements _$StoreBreakdownCopyWith<$Res> {
  __$StoreBreakdownCopyWithImpl(this._self, this._then);

  final _StoreBreakdown _self;
  final $Res Function(_StoreBreakdown) _then;

/// Create a copy of StoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeName = null,Object? purchases = null,Object? avgPriceKopecks = null,}) {
  return _then(_StoreBreakdown(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as int,avgPriceKopecks: null == avgPriceKopecks ? _self.avgPriceKopecks : avgPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ProductDetails {

 String get productHash; String get name; String? get categoryId; int get purchases; int get totalSpendKopecks; List<PricePoint> get points; int get minPriceKopecks; String get minDay; int get maxPriceKopecks; String get maxDay; int get avgPriceKopecks; PriceTrend get trend; double get volatilityKopecks; List<StoreBreakdown> get stores;
/// Create a copy of ProductDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailsCopyWith<ProductDetails> get copyWith => _$ProductDetailsCopyWithImpl<ProductDetails>(this as ProductDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetails&&(identical(other.productHash, productHash) || other.productHash == productHash)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.purchases, purchases) || other.purchases == purchases)&&(identical(other.totalSpendKopecks, totalSpendKopecks) || other.totalSpendKopecks == totalSpendKopecks)&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.minPriceKopecks, minPriceKopecks) || other.minPriceKopecks == minPriceKopecks)&&(identical(other.minDay, minDay) || other.minDay == minDay)&&(identical(other.maxPriceKopecks, maxPriceKopecks) || other.maxPriceKopecks == maxPriceKopecks)&&(identical(other.maxDay, maxDay) || other.maxDay == maxDay)&&(identical(other.avgPriceKopecks, avgPriceKopecks) || other.avgPriceKopecks == avgPriceKopecks)&&(identical(other.trend, trend) || other.trend == trend)&&(identical(other.volatilityKopecks, volatilityKopecks) || other.volatilityKopecks == volatilityKopecks)&&const DeepCollectionEquality().equals(other.stores, stores));
}


@override
int get hashCode => Object.hash(runtimeType,productHash,name,categoryId,purchases,totalSpendKopecks,const DeepCollectionEquality().hash(points),minPriceKopecks,minDay,maxPriceKopecks,maxDay,avgPriceKopecks,trend,volatilityKopecks,const DeepCollectionEquality().hash(stores));

@override
String toString() {
  return 'ProductDetails(productHash: $productHash, name: $name, categoryId: $categoryId, purchases: $purchases, totalSpendKopecks: $totalSpendKopecks, points: $points, minPriceKopecks: $minPriceKopecks, minDay: $minDay, maxPriceKopecks: $maxPriceKopecks, maxDay: $maxDay, avgPriceKopecks: $avgPriceKopecks, trend: $trend, volatilityKopecks: $volatilityKopecks, stores: $stores)';
}


}

/// @nodoc
abstract mixin class $ProductDetailsCopyWith<$Res>  {
  factory $ProductDetailsCopyWith(ProductDetails value, $Res Function(ProductDetails) _then) = _$ProductDetailsCopyWithImpl;
@useResult
$Res call({
 String productHash, String name, String? categoryId, int purchases, int totalSpendKopecks, List<PricePoint> points, int minPriceKopecks, String minDay, int maxPriceKopecks, String maxDay, int avgPriceKopecks, PriceTrend trend, double volatilityKopecks, List<StoreBreakdown> stores
});




}
/// @nodoc
class _$ProductDetailsCopyWithImpl<$Res>
    implements $ProductDetailsCopyWith<$Res> {
  _$ProductDetailsCopyWithImpl(this._self, this._then);

  final ProductDetails _self;
  final $Res Function(ProductDetails) _then;

/// Create a copy of ProductDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productHash = null,Object? name = null,Object? categoryId = freezed,Object? purchases = null,Object? totalSpendKopecks = null,Object? points = null,Object? minPriceKopecks = null,Object? minDay = null,Object? maxPriceKopecks = null,Object? maxDay = null,Object? avgPriceKopecks = null,Object? trend = null,Object? volatilityKopecks = null,Object? stores = null,}) {
  return _then(_self.copyWith(
productHash: null == productHash ? _self.productHash : productHash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as int,totalSpendKopecks: null == totalSpendKopecks ? _self.totalSpendKopecks : totalSpendKopecks // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,minPriceKopecks: null == minPriceKopecks ? _self.minPriceKopecks : minPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,minDay: null == minDay ? _self.minDay : minDay // ignore: cast_nullable_to_non_nullable
as String,maxPriceKopecks: null == maxPriceKopecks ? _self.maxPriceKopecks : maxPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,maxDay: null == maxDay ? _self.maxDay : maxDay // ignore: cast_nullable_to_non_nullable
as String,avgPriceKopecks: null == avgPriceKopecks ? _self.avgPriceKopecks : avgPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as PriceTrend,volatilityKopecks: null == volatilityKopecks ? _self.volatilityKopecks : volatilityKopecks // ignore: cast_nullable_to_non_nullable
as double,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as List<StoreBreakdown>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductDetails].
extension ProductDetailsPatterns on ProductDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetails value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetails value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetails() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ProductDetails implements ProductDetails {
  const _ProductDetails({required this.productHash, required this.name, this.categoryId, required this.purchases, required this.totalSpendKopecks, required final  List<PricePoint> points, required this.minPriceKopecks, required this.minDay, required this.maxPriceKopecks, required this.maxDay, required this.avgPriceKopecks, required this.trend, required this.volatilityKopecks, required final  List<StoreBreakdown> stores}): _points = points,_stores = stores;
  

@override final  String productHash;
@override final  String name;
@override final  String? categoryId;
@override final  int purchases;
@override final  int totalSpendKopecks;
 final  List<PricePoint> _points;
@override List<PricePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override final  int minPriceKopecks;
@override final  String minDay;
@override final  int maxPriceKopecks;
@override final  String maxDay;
@override final  int avgPriceKopecks;
@override final  PriceTrend trend;
@override final  double volatilityKopecks;
 final  List<StoreBreakdown> _stores;
@override List<StoreBreakdown> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}


/// Create a copy of ProductDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailsCopyWith<_ProductDetails> get copyWith => __$ProductDetailsCopyWithImpl<_ProductDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetails&&(identical(other.productHash, productHash) || other.productHash == productHash)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.purchases, purchases) || other.purchases == purchases)&&(identical(other.totalSpendKopecks, totalSpendKopecks) || other.totalSpendKopecks == totalSpendKopecks)&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.minPriceKopecks, minPriceKopecks) || other.minPriceKopecks == minPriceKopecks)&&(identical(other.minDay, minDay) || other.minDay == minDay)&&(identical(other.maxPriceKopecks, maxPriceKopecks) || other.maxPriceKopecks == maxPriceKopecks)&&(identical(other.maxDay, maxDay) || other.maxDay == maxDay)&&(identical(other.avgPriceKopecks, avgPriceKopecks) || other.avgPriceKopecks == avgPriceKopecks)&&(identical(other.trend, trend) || other.trend == trend)&&(identical(other.volatilityKopecks, volatilityKopecks) || other.volatilityKopecks == volatilityKopecks)&&const DeepCollectionEquality().equals(other._stores, _stores));
}


@override
int get hashCode => Object.hash(runtimeType,productHash,name,categoryId,purchases,totalSpendKopecks,const DeepCollectionEquality().hash(_points),minPriceKopecks,minDay,maxPriceKopecks,maxDay,avgPriceKopecks,trend,volatilityKopecks,const DeepCollectionEquality().hash(_stores));

@override
String toString() {
  return 'ProductDetails(productHash: $productHash, name: $name, categoryId: $categoryId, purchases: $purchases, totalSpendKopecks: $totalSpendKopecks, points: $points, minPriceKopecks: $minPriceKopecks, minDay: $minDay, maxPriceKopecks: $maxPriceKopecks, maxDay: $maxDay, avgPriceKopecks: $avgPriceKopecks, trend: $trend, volatilityKopecks: $volatilityKopecks, stores: $stores)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailsCopyWith<$Res> implements $ProductDetailsCopyWith<$Res> {
  factory _$ProductDetailsCopyWith(_ProductDetails value, $Res Function(_ProductDetails) _then) = __$ProductDetailsCopyWithImpl;
@override @useResult
$Res call({
 String productHash, String name, String? categoryId, int purchases, int totalSpendKopecks, List<PricePoint> points, int minPriceKopecks, String minDay, int maxPriceKopecks, String maxDay, int avgPriceKopecks, PriceTrend trend, double volatilityKopecks, List<StoreBreakdown> stores
});




}
/// @nodoc
class __$ProductDetailsCopyWithImpl<$Res>
    implements _$ProductDetailsCopyWith<$Res> {
  __$ProductDetailsCopyWithImpl(this._self, this._then);

  final _ProductDetails _self;
  final $Res Function(_ProductDetails) _then;

/// Create a copy of ProductDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productHash = null,Object? name = null,Object? categoryId = freezed,Object? purchases = null,Object? totalSpendKopecks = null,Object? points = null,Object? minPriceKopecks = null,Object? minDay = null,Object? maxPriceKopecks = null,Object? maxDay = null,Object? avgPriceKopecks = null,Object? trend = null,Object? volatilityKopecks = null,Object? stores = null,}) {
  return _then(_ProductDetails(
productHash: null == productHash ? _self.productHash : productHash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as int,totalSpendKopecks: null == totalSpendKopecks ? _self.totalSpendKopecks : totalSpendKopecks // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,minPriceKopecks: null == minPriceKopecks ? _self.minPriceKopecks : minPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,minDay: null == minDay ? _self.minDay : minDay // ignore: cast_nullable_to_non_nullable
as String,maxPriceKopecks: null == maxPriceKopecks ? _self.maxPriceKopecks : maxPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,maxDay: null == maxDay ? _self.maxDay : maxDay // ignore: cast_nullable_to_non_nullable
as String,avgPriceKopecks: null == avgPriceKopecks ? _self.avgPriceKopecks : avgPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as PriceTrend,volatilityKopecks: null == volatilityKopecks ? _self.volatilityKopecks : volatilityKopecks // ignore: cast_nullable_to_non_nullable
as double,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<StoreBreakdown>,
  ));
}


}

/// @nodoc
mixin _$ProductAnalyticsSummary {

 int get uniqueProducts; double get avgItemsPerCheck; int get checksCount;
/// Create a copy of ProductAnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductAnalyticsSummaryCopyWith<ProductAnalyticsSummary> get copyWith => _$ProductAnalyticsSummaryCopyWithImpl<ProductAnalyticsSummary>(this as ProductAnalyticsSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductAnalyticsSummary&&(identical(other.uniqueProducts, uniqueProducts) || other.uniqueProducts == uniqueProducts)&&(identical(other.avgItemsPerCheck, avgItemsPerCheck) || other.avgItemsPerCheck == avgItemsPerCheck)&&(identical(other.checksCount, checksCount) || other.checksCount == checksCount));
}


@override
int get hashCode => Object.hash(runtimeType,uniqueProducts,avgItemsPerCheck,checksCount);

@override
String toString() {
  return 'ProductAnalyticsSummary(uniqueProducts: $uniqueProducts, avgItemsPerCheck: $avgItemsPerCheck, checksCount: $checksCount)';
}


}

/// @nodoc
abstract mixin class $ProductAnalyticsSummaryCopyWith<$Res>  {
  factory $ProductAnalyticsSummaryCopyWith(ProductAnalyticsSummary value, $Res Function(ProductAnalyticsSummary) _then) = _$ProductAnalyticsSummaryCopyWithImpl;
@useResult
$Res call({
 int uniqueProducts, double avgItemsPerCheck, int checksCount
});




}
/// @nodoc
class _$ProductAnalyticsSummaryCopyWithImpl<$Res>
    implements $ProductAnalyticsSummaryCopyWith<$Res> {
  _$ProductAnalyticsSummaryCopyWithImpl(this._self, this._then);

  final ProductAnalyticsSummary _self;
  final $Res Function(ProductAnalyticsSummary) _then;

/// Create a copy of ProductAnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uniqueProducts = null,Object? avgItemsPerCheck = null,Object? checksCount = null,}) {
  return _then(_self.copyWith(
uniqueProducts: null == uniqueProducts ? _self.uniqueProducts : uniqueProducts // ignore: cast_nullable_to_non_nullable
as int,avgItemsPerCheck: null == avgItemsPerCheck ? _self.avgItemsPerCheck : avgItemsPerCheck // ignore: cast_nullable_to_non_nullable
as double,checksCount: null == checksCount ? _self.checksCount : checksCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductAnalyticsSummary].
extension ProductAnalyticsSummaryPatterns on ProductAnalyticsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductAnalyticsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductAnalyticsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductAnalyticsSummary value)  $default,){
final _that = this;
switch (_that) {
case _ProductAnalyticsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductAnalyticsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ProductAnalyticsSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ProductAnalyticsSummary implements ProductAnalyticsSummary {
  const _ProductAnalyticsSummary({required this.uniqueProducts, required this.avgItemsPerCheck, required this.checksCount});
  

@override final  int uniqueProducts;
@override final  double avgItemsPerCheck;
@override final  int checksCount;

/// Create a copy of ProductAnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductAnalyticsSummaryCopyWith<_ProductAnalyticsSummary> get copyWith => __$ProductAnalyticsSummaryCopyWithImpl<_ProductAnalyticsSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductAnalyticsSummary&&(identical(other.uniqueProducts, uniqueProducts) || other.uniqueProducts == uniqueProducts)&&(identical(other.avgItemsPerCheck, avgItemsPerCheck) || other.avgItemsPerCheck == avgItemsPerCheck)&&(identical(other.checksCount, checksCount) || other.checksCount == checksCount));
}


@override
int get hashCode => Object.hash(runtimeType,uniqueProducts,avgItemsPerCheck,checksCount);

@override
String toString() {
  return 'ProductAnalyticsSummary(uniqueProducts: $uniqueProducts, avgItemsPerCheck: $avgItemsPerCheck, checksCount: $checksCount)';
}


}

/// @nodoc
abstract mixin class _$ProductAnalyticsSummaryCopyWith<$Res> implements $ProductAnalyticsSummaryCopyWith<$Res> {
  factory _$ProductAnalyticsSummaryCopyWith(_ProductAnalyticsSummary value, $Res Function(_ProductAnalyticsSummary) _then) = __$ProductAnalyticsSummaryCopyWithImpl;
@override @useResult
$Res call({
 int uniqueProducts, double avgItemsPerCheck, int checksCount
});




}
/// @nodoc
class __$ProductAnalyticsSummaryCopyWithImpl<$Res>
    implements _$ProductAnalyticsSummaryCopyWith<$Res> {
  __$ProductAnalyticsSummaryCopyWithImpl(this._self, this._then);

  final _ProductAnalyticsSummary _self;
  final $Res Function(_ProductAnalyticsSummary) _then;

/// Create a copy of ProductAnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueProducts = null,Object? avgItemsPerCheck = null,Object? checksCount = null,}) {
  return _then(_ProductAnalyticsSummary(
uniqueProducts: null == uniqueProducts ? _self.uniqueProducts : uniqueProducts // ignore: cast_nullable_to_non_nullable
as int,avgItemsPerCheck: null == avgItemsPerCheck ? _self.avgItemsPerCheck : avgItemsPerCheck // ignore: cast_nullable_to_non_nullable
as double,checksCount: null == checksCount ? _self.checksCount : checksCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

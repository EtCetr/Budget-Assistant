// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'year_budget_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$YearCatMonthSum {

 String get categoryId; int get month; int get totalKopecks;
/// Create a copy of YearCatMonthSum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearCatMonthSumCopyWith<YearCatMonthSum> get copyWith => _$YearCatMonthSumCopyWithImpl<YearCatMonthSum>(this as YearCatMonthSum, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearCatMonthSum&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalKopecks, totalKopecks) || other.totalKopecks == totalKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,month,totalKopecks);

@override
String toString() {
  return 'YearCatMonthSum(categoryId: $categoryId, month: $month, totalKopecks: $totalKopecks)';
}


}

/// @nodoc
abstract mixin class $YearCatMonthSumCopyWith<$Res>  {
  factory $YearCatMonthSumCopyWith(YearCatMonthSum value, $Res Function(YearCatMonthSum) _then) = _$YearCatMonthSumCopyWithImpl;
@useResult
$Res call({
 String categoryId, int month, int totalKopecks
});




}
/// @nodoc
class _$YearCatMonthSumCopyWithImpl<$Res>
    implements $YearCatMonthSumCopyWith<$Res> {
  _$YearCatMonthSumCopyWithImpl(this._self, this._then);

  final YearCatMonthSum _self;
  final $Res Function(YearCatMonthSum) _then;

/// Create a copy of YearCatMonthSum
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? month = null,Object? totalKopecks = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [YearCatMonthSum].
extension YearCatMonthSumPatterns on YearCatMonthSum {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearCatMonthSum value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearCatMonthSum() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearCatMonthSum value)  $default,){
final _that = this;
switch (_that) {
case _YearCatMonthSum():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearCatMonthSum value)?  $default,){
final _that = this;
switch (_that) {
case _YearCatMonthSum() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _YearCatMonthSum implements YearCatMonthSum {
  const _YearCatMonthSum({required this.categoryId, required this.month, required this.totalKopecks});
  

@override final  String categoryId;
@override final  int month;
@override final  int totalKopecks;

/// Create a copy of YearCatMonthSum
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearCatMonthSumCopyWith<_YearCatMonthSum> get copyWith => __$YearCatMonthSumCopyWithImpl<_YearCatMonthSum>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearCatMonthSum&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalKopecks, totalKopecks) || other.totalKopecks == totalKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,month,totalKopecks);

@override
String toString() {
  return 'YearCatMonthSum(categoryId: $categoryId, month: $month, totalKopecks: $totalKopecks)';
}


}

/// @nodoc
abstract mixin class _$YearCatMonthSumCopyWith<$Res> implements $YearCatMonthSumCopyWith<$Res> {
  factory _$YearCatMonthSumCopyWith(_YearCatMonthSum value, $Res Function(_YearCatMonthSum) _then) = __$YearCatMonthSumCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, int month, int totalKopecks
});




}
/// @nodoc
class __$YearCatMonthSumCopyWithImpl<$Res>
    implements _$YearCatMonthSumCopyWith<$Res> {
  __$YearCatMonthSumCopyWithImpl(this._self, this._then);

  final _YearCatMonthSum _self;
  final $Res Function(_YearCatMonthSum) _then;

/// Create a copy of YearCatMonthSum
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? month = null,Object? totalKopecks = null,}) {
  return _then(_YearCatMonthSum(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CategoryInfo {

 String get id; String get name; String get type; String? get colorHex; String? get emoji;
/// Create a copy of CategoryInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryInfoCopyWith<CategoryInfo> get copyWith => _$CategoryInfoCopyWithImpl<CategoryInfo>(this as CategoryInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,colorHex,emoji);

@override
String toString() {
  return 'CategoryInfo(id: $id, name: $name, type: $type, colorHex: $colorHex, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $CategoryInfoCopyWith<$Res>  {
  factory $CategoryInfoCopyWith(CategoryInfo value, $Res Function(CategoryInfo) _then) = _$CategoryInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String type, String? colorHex, String? emoji
});




}
/// @nodoc
class _$CategoryInfoCopyWithImpl<$Res>
    implements $CategoryInfoCopyWith<$Res> {
  _$CategoryInfoCopyWithImpl(this._self, this._then);

  final CategoryInfo _self;
  final $Res Function(CategoryInfo) _then;

/// Create a copy of CategoryInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? colorHex = freezed,Object? emoji = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryInfo].
extension CategoryInfoPatterns on CategoryInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryInfo value)  $default,){
final _that = this;
switch (_that) {
case _CategoryInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryInfo implements CategoryInfo {
  const _CategoryInfo({required this.id, required this.name, required this.type, this.colorHex, this.emoji});
  

@override final  String id;
@override final  String name;
@override final  String type;
@override final  String? colorHex;
@override final  String? emoji;

/// Create a copy of CategoryInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryInfoCopyWith<_CategoryInfo> get copyWith => __$CategoryInfoCopyWithImpl<_CategoryInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,colorHex,emoji);

@override
String toString() {
  return 'CategoryInfo(id: $id, name: $name, type: $type, colorHex: $colorHex, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$CategoryInfoCopyWith<$Res> implements $CategoryInfoCopyWith<$Res> {
  factory _$CategoryInfoCopyWith(_CategoryInfo value, $Res Function(_CategoryInfo) _then) = __$CategoryInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String type, String? colorHex, String? emoji
});




}
/// @nodoc
class __$CategoryInfoCopyWithImpl<$Res>
    implements _$CategoryInfoCopyWith<$Res> {
  __$CategoryInfoCopyWithImpl(this._self, this._then);

  final _CategoryInfo _self;
  final $Res Function(_CategoryInfo) _then;

/// Create a copy of CategoryInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? colorHex = freezed,Object? emoji = freezed,}) {
  return _then(_CategoryInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$YearCategoryRow {

 String get categoryId; String get name; String? get colorHex; String? get emoji; List<int?> get months; int get sumKopecks; int get avgKopecks; int get percentBps;
/// Create a copy of YearCategoryRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearCategoryRowCopyWith<YearCategoryRow> get copyWith => _$YearCategoryRowCopyWithImpl<YearCategoryRow>(this as YearCategoryRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearCategoryRow&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&const DeepCollectionEquality().equals(other.months, months)&&(identical(other.sumKopecks, sumKopecks) || other.sumKopecks == sumKopecks)&&(identical(other.avgKopecks, avgKopecks) || other.avgKopecks == avgKopecks)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,colorHex,emoji,const DeepCollectionEquality().hash(months),sumKopecks,avgKopecks,percentBps);

@override
String toString() {
  return 'YearCategoryRow(categoryId: $categoryId, name: $name, colorHex: $colorHex, emoji: $emoji, months: $months, sumKopecks: $sumKopecks, avgKopecks: $avgKopecks, percentBps: $percentBps)';
}


}

/// @nodoc
abstract mixin class $YearCategoryRowCopyWith<$Res>  {
  factory $YearCategoryRowCopyWith(YearCategoryRow value, $Res Function(YearCategoryRow) _then) = _$YearCategoryRowCopyWithImpl;
@useResult
$Res call({
 String categoryId, String name, String? colorHex, String? emoji, List<int?> months, int sumKopecks, int avgKopecks, int percentBps
});




}
/// @nodoc
class _$YearCategoryRowCopyWithImpl<$Res>
    implements $YearCategoryRowCopyWith<$Res> {
  _$YearCategoryRowCopyWithImpl(this._self, this._then);

  final YearCategoryRow _self;
  final $Res Function(YearCategoryRow) _then;

/// Create a copy of YearCategoryRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? name = null,Object? colorHex = freezed,Object? emoji = freezed,Object? months = null,Object? sumKopecks = null,Object? avgKopecks = null,Object? percentBps = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as List<int?>,sumKopecks: null == sumKopecks ? _self.sumKopecks : sumKopecks // ignore: cast_nullable_to_non_nullable
as int,avgKopecks: null == avgKopecks ? _self.avgKopecks : avgKopecks // ignore: cast_nullable_to_non_nullable
as int,percentBps: null == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [YearCategoryRow].
extension YearCategoryRowPatterns on YearCategoryRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearCategoryRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearCategoryRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearCategoryRow value)  $default,){
final _that = this;
switch (_that) {
case _YearCategoryRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearCategoryRow value)?  $default,){
final _that = this;
switch (_that) {
case _YearCategoryRow() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _YearCategoryRow implements YearCategoryRow {
  const _YearCategoryRow({required this.categoryId, required this.name, this.colorHex, this.emoji, required final  List<int?> months, required this.sumKopecks, required this.avgKopecks, required this.percentBps}): _months = months;
  

@override final  String categoryId;
@override final  String name;
@override final  String? colorHex;
@override final  String? emoji;
 final  List<int?> _months;
@override List<int?> get months {
  if (_months is EqualUnmodifiableListView) return _months;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_months);
}

@override final  int sumKopecks;
@override final  int avgKopecks;
@override final  int percentBps;

/// Create a copy of YearCategoryRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearCategoryRowCopyWith<_YearCategoryRow> get copyWith => __$YearCategoryRowCopyWithImpl<_YearCategoryRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearCategoryRow&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&const DeepCollectionEquality().equals(other._months, _months)&&(identical(other.sumKopecks, sumKopecks) || other.sumKopecks == sumKopecks)&&(identical(other.avgKopecks, avgKopecks) || other.avgKopecks == avgKopecks)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,colorHex,emoji,const DeepCollectionEquality().hash(_months),sumKopecks,avgKopecks,percentBps);

@override
String toString() {
  return 'YearCategoryRow(categoryId: $categoryId, name: $name, colorHex: $colorHex, emoji: $emoji, months: $months, sumKopecks: $sumKopecks, avgKopecks: $avgKopecks, percentBps: $percentBps)';
}


}

/// @nodoc
abstract mixin class _$YearCategoryRowCopyWith<$Res> implements $YearCategoryRowCopyWith<$Res> {
  factory _$YearCategoryRowCopyWith(_YearCategoryRow value, $Res Function(_YearCategoryRow) _then) = __$YearCategoryRowCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String name, String? colorHex, String? emoji, List<int?> months, int sumKopecks, int avgKopecks, int percentBps
});




}
/// @nodoc
class __$YearCategoryRowCopyWithImpl<$Res>
    implements _$YearCategoryRowCopyWith<$Res> {
  __$YearCategoryRowCopyWithImpl(this._self, this._then);

  final _YearCategoryRow _self;
  final $Res Function(_YearCategoryRow) _then;

/// Create a copy of YearCategoryRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? name = null,Object? colorHex = freezed,Object? emoji = freezed,Object? months = null,Object? sumKopecks = null,Object? avgKopecks = null,Object? percentBps = null,}) {
  return _then(_YearCategoryRow(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,months: null == months ? _self._months : months // ignore: cast_nullable_to_non_nullable
as List<int?>,sumKopecks: null == sumKopecks ? _self.sumKopecks : sumKopecks // ignore: cast_nullable_to_non_nullable
as int,avgKopecks: null == avgKopecks ? _self.avgKopecks : avgKopecks // ignore: cast_nullable_to_non_nullable
as int,percentBps: null == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$YearCashflowMonth {

 int get month; int? get incomeKopecks; int? get expenseKopecks; int get surplusKopecks; int? get percentBps;
/// Create a copy of YearCashflowMonth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearCashflowMonthCopyWith<YearCashflowMonth> get copyWith => _$YearCashflowMonthCopyWithImpl<YearCashflowMonth>(this as YearCashflowMonth, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearCashflowMonth&&(identical(other.month, month) || other.month == month)&&(identical(other.incomeKopecks, incomeKopecks) || other.incomeKopecks == incomeKopecks)&&(identical(other.expenseKopecks, expenseKopecks) || other.expenseKopecks == expenseKopecks)&&(identical(other.surplusKopecks, surplusKopecks) || other.surplusKopecks == surplusKopecks)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps));
}


@override
int get hashCode => Object.hash(runtimeType,month,incomeKopecks,expenseKopecks,surplusKopecks,percentBps);

@override
String toString() {
  return 'YearCashflowMonth(month: $month, incomeKopecks: $incomeKopecks, expenseKopecks: $expenseKopecks, surplusKopecks: $surplusKopecks, percentBps: $percentBps)';
}


}

/// @nodoc
abstract mixin class $YearCashflowMonthCopyWith<$Res>  {
  factory $YearCashflowMonthCopyWith(YearCashflowMonth value, $Res Function(YearCashflowMonth) _then) = _$YearCashflowMonthCopyWithImpl;
@useResult
$Res call({
 int month, int? incomeKopecks, int? expenseKopecks, int surplusKopecks, int? percentBps
});




}
/// @nodoc
class _$YearCashflowMonthCopyWithImpl<$Res>
    implements $YearCashflowMonthCopyWith<$Res> {
  _$YearCashflowMonthCopyWithImpl(this._self, this._then);

  final YearCashflowMonth _self;
  final $Res Function(YearCashflowMonth) _then;

/// Create a copy of YearCashflowMonth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? incomeKopecks = freezed,Object? expenseKopecks = freezed,Object? surplusKopecks = null,Object? percentBps = freezed,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,incomeKopecks: freezed == incomeKopecks ? _self.incomeKopecks : incomeKopecks // ignore: cast_nullable_to_non_nullable
as int?,expenseKopecks: freezed == expenseKopecks ? _self.expenseKopecks : expenseKopecks // ignore: cast_nullable_to_non_nullable
as int?,surplusKopecks: null == surplusKopecks ? _self.surplusKopecks : surplusKopecks // ignore: cast_nullable_to_non_nullable
as int,percentBps: freezed == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearCashflowMonth].
extension YearCashflowMonthPatterns on YearCashflowMonth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearCashflowMonth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearCashflowMonth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearCashflowMonth value)  $default,){
final _that = this;
switch (_that) {
case _YearCashflowMonth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearCashflowMonth value)?  $default,){
final _that = this;
switch (_that) {
case _YearCashflowMonth() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _YearCashflowMonth implements YearCashflowMonth {
  const _YearCashflowMonth({required this.month, required this.incomeKopecks, required this.expenseKopecks, required this.surplusKopecks, required this.percentBps});
  

@override final  int month;
@override final  int? incomeKopecks;
@override final  int? expenseKopecks;
@override final  int surplusKopecks;
@override final  int? percentBps;

/// Create a copy of YearCashflowMonth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearCashflowMonthCopyWith<_YearCashflowMonth> get copyWith => __$YearCashflowMonthCopyWithImpl<_YearCashflowMonth>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearCashflowMonth&&(identical(other.month, month) || other.month == month)&&(identical(other.incomeKopecks, incomeKopecks) || other.incomeKopecks == incomeKopecks)&&(identical(other.expenseKopecks, expenseKopecks) || other.expenseKopecks == expenseKopecks)&&(identical(other.surplusKopecks, surplusKopecks) || other.surplusKopecks == surplusKopecks)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps));
}


@override
int get hashCode => Object.hash(runtimeType,month,incomeKopecks,expenseKopecks,surplusKopecks,percentBps);

@override
String toString() {
  return 'YearCashflowMonth(month: $month, incomeKopecks: $incomeKopecks, expenseKopecks: $expenseKopecks, surplusKopecks: $surplusKopecks, percentBps: $percentBps)';
}


}

/// @nodoc
abstract mixin class _$YearCashflowMonthCopyWith<$Res> implements $YearCashflowMonthCopyWith<$Res> {
  factory _$YearCashflowMonthCopyWith(_YearCashflowMonth value, $Res Function(_YearCashflowMonth) _then) = __$YearCashflowMonthCopyWithImpl;
@override @useResult
$Res call({
 int month, int? incomeKopecks, int? expenseKopecks, int surplusKopecks, int? percentBps
});




}
/// @nodoc
class __$YearCashflowMonthCopyWithImpl<$Res>
    implements _$YearCashflowMonthCopyWith<$Res> {
  __$YearCashflowMonthCopyWithImpl(this._self, this._then);

  final _YearCashflowMonth _self;
  final $Res Function(_YearCashflowMonth) _then;

/// Create a copy of YearCashflowMonth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? incomeKopecks = freezed,Object? expenseKopecks = freezed,Object? surplusKopecks = null,Object? percentBps = freezed,}) {
  return _then(_YearCashflowMonth(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,incomeKopecks: freezed == incomeKopecks ? _self.incomeKopecks : incomeKopecks // ignore: cast_nullable_to_non_nullable
as int?,expenseKopecks: freezed == expenseKopecks ? _self.expenseKopecks : expenseKopecks // ignore: cast_nullable_to_non_nullable
as int?,surplusKopecks: null == surplusKopecks ? _self.surplusKopecks : surplusKopecks // ignore: cast_nullable_to_non_nullable
as int,percentBps: freezed == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$YearBudgetData {

 List<YearCategoryRow> get limitRows; List<YearCategoryRow> get expenseRows; List<YearCategoryRow> get incomeRows; List<YearCashflowMonth> get cashflow; int get totalLimitKopecks; int get totalExpenseKopecks; int get totalIncomeKopecks; int get totalSurplusKopecks; int? get surplusPercentBps; List<int> get monthsWithData;
/// Create a copy of YearBudgetData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearBudgetDataCopyWith<YearBudgetData> get copyWith => _$YearBudgetDataCopyWithImpl<YearBudgetData>(this as YearBudgetData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearBudgetData&&const DeepCollectionEquality().equals(other.limitRows, limitRows)&&const DeepCollectionEquality().equals(other.expenseRows, expenseRows)&&const DeepCollectionEquality().equals(other.incomeRows, incomeRows)&&const DeepCollectionEquality().equals(other.cashflow, cashflow)&&(identical(other.totalLimitKopecks, totalLimitKopecks) || other.totalLimitKopecks == totalLimitKopecks)&&(identical(other.totalExpenseKopecks, totalExpenseKopecks) || other.totalExpenseKopecks == totalExpenseKopecks)&&(identical(other.totalIncomeKopecks, totalIncomeKopecks) || other.totalIncomeKopecks == totalIncomeKopecks)&&(identical(other.totalSurplusKopecks, totalSurplusKopecks) || other.totalSurplusKopecks == totalSurplusKopecks)&&(identical(other.surplusPercentBps, surplusPercentBps) || other.surplusPercentBps == surplusPercentBps)&&const DeepCollectionEquality().equals(other.monthsWithData, monthsWithData));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(limitRows),const DeepCollectionEquality().hash(expenseRows),const DeepCollectionEquality().hash(incomeRows),const DeepCollectionEquality().hash(cashflow),totalLimitKopecks,totalExpenseKopecks,totalIncomeKopecks,totalSurplusKopecks,surplusPercentBps,const DeepCollectionEquality().hash(monthsWithData));

@override
String toString() {
  return 'YearBudgetData(limitRows: $limitRows, expenseRows: $expenseRows, incomeRows: $incomeRows, cashflow: $cashflow, totalLimitKopecks: $totalLimitKopecks, totalExpenseKopecks: $totalExpenseKopecks, totalIncomeKopecks: $totalIncomeKopecks, totalSurplusKopecks: $totalSurplusKopecks, surplusPercentBps: $surplusPercentBps, monthsWithData: $monthsWithData)';
}


}

/// @nodoc
abstract mixin class $YearBudgetDataCopyWith<$Res>  {
  factory $YearBudgetDataCopyWith(YearBudgetData value, $Res Function(YearBudgetData) _then) = _$YearBudgetDataCopyWithImpl;
@useResult
$Res call({
 List<YearCategoryRow> limitRows, List<YearCategoryRow> expenseRows, List<YearCategoryRow> incomeRows, List<YearCashflowMonth> cashflow, int totalLimitKopecks, int totalExpenseKopecks, int totalIncomeKopecks, int totalSurplusKopecks, int? surplusPercentBps, List<int> monthsWithData
});




}
/// @nodoc
class _$YearBudgetDataCopyWithImpl<$Res>
    implements $YearBudgetDataCopyWith<$Res> {
  _$YearBudgetDataCopyWithImpl(this._self, this._then);

  final YearBudgetData _self;
  final $Res Function(YearBudgetData) _then;

/// Create a copy of YearBudgetData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limitRows = null,Object? expenseRows = null,Object? incomeRows = null,Object? cashflow = null,Object? totalLimitKopecks = null,Object? totalExpenseKopecks = null,Object? totalIncomeKopecks = null,Object? totalSurplusKopecks = null,Object? surplusPercentBps = freezed,Object? monthsWithData = null,}) {
  return _then(_self.copyWith(
limitRows: null == limitRows ? _self.limitRows : limitRows // ignore: cast_nullable_to_non_nullable
as List<YearCategoryRow>,expenseRows: null == expenseRows ? _self.expenseRows : expenseRows // ignore: cast_nullable_to_non_nullable
as List<YearCategoryRow>,incomeRows: null == incomeRows ? _self.incomeRows : incomeRows // ignore: cast_nullable_to_non_nullable
as List<YearCategoryRow>,cashflow: null == cashflow ? _self.cashflow : cashflow // ignore: cast_nullable_to_non_nullable
as List<YearCashflowMonth>,totalLimitKopecks: null == totalLimitKopecks ? _self.totalLimitKopecks : totalLimitKopecks // ignore: cast_nullable_to_non_nullable
as int,totalExpenseKopecks: null == totalExpenseKopecks ? _self.totalExpenseKopecks : totalExpenseKopecks // ignore: cast_nullable_to_non_nullable
as int,totalIncomeKopecks: null == totalIncomeKopecks ? _self.totalIncomeKopecks : totalIncomeKopecks // ignore: cast_nullable_to_non_nullable
as int,totalSurplusKopecks: null == totalSurplusKopecks ? _self.totalSurplusKopecks : totalSurplusKopecks // ignore: cast_nullable_to_non_nullable
as int,surplusPercentBps: freezed == surplusPercentBps ? _self.surplusPercentBps : surplusPercentBps // ignore: cast_nullable_to_non_nullable
as int?,monthsWithData: null == monthsWithData ? _self.monthsWithData : monthsWithData // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearBudgetData].
extension YearBudgetDataPatterns on YearBudgetData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearBudgetData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearBudgetData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearBudgetData value)  $default,){
final _that = this;
switch (_that) {
case _YearBudgetData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearBudgetData value)?  $default,){
final _that = this;
switch (_that) {
case _YearBudgetData() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _YearBudgetData implements YearBudgetData {
  const _YearBudgetData({required final  List<YearCategoryRow> limitRows, required final  List<YearCategoryRow> expenseRows, required final  List<YearCategoryRow> incomeRows, required final  List<YearCashflowMonth> cashflow, required this.totalLimitKopecks, required this.totalExpenseKopecks, required this.totalIncomeKopecks, required this.totalSurplusKopecks, required this.surplusPercentBps, required final  List<int> monthsWithData}): _limitRows = limitRows,_expenseRows = expenseRows,_incomeRows = incomeRows,_cashflow = cashflow,_monthsWithData = monthsWithData;
  

 final  List<YearCategoryRow> _limitRows;
@override List<YearCategoryRow> get limitRows {
  if (_limitRows is EqualUnmodifiableListView) return _limitRows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_limitRows);
}

 final  List<YearCategoryRow> _expenseRows;
@override List<YearCategoryRow> get expenseRows {
  if (_expenseRows is EqualUnmodifiableListView) return _expenseRows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenseRows);
}

 final  List<YearCategoryRow> _incomeRows;
@override List<YearCategoryRow> get incomeRows {
  if (_incomeRows is EqualUnmodifiableListView) return _incomeRows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomeRows);
}

 final  List<YearCashflowMonth> _cashflow;
@override List<YearCashflowMonth> get cashflow {
  if (_cashflow is EqualUnmodifiableListView) return _cashflow;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cashflow);
}

@override final  int totalLimitKopecks;
@override final  int totalExpenseKopecks;
@override final  int totalIncomeKopecks;
@override final  int totalSurplusKopecks;
@override final  int? surplusPercentBps;
 final  List<int> _monthsWithData;
@override List<int> get monthsWithData {
  if (_monthsWithData is EqualUnmodifiableListView) return _monthsWithData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthsWithData);
}


/// Create a copy of YearBudgetData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearBudgetDataCopyWith<_YearBudgetData> get copyWith => __$YearBudgetDataCopyWithImpl<_YearBudgetData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearBudgetData&&const DeepCollectionEquality().equals(other._limitRows, _limitRows)&&const DeepCollectionEquality().equals(other._expenseRows, _expenseRows)&&const DeepCollectionEquality().equals(other._incomeRows, _incomeRows)&&const DeepCollectionEquality().equals(other._cashflow, _cashflow)&&(identical(other.totalLimitKopecks, totalLimitKopecks) || other.totalLimitKopecks == totalLimitKopecks)&&(identical(other.totalExpenseKopecks, totalExpenseKopecks) || other.totalExpenseKopecks == totalExpenseKopecks)&&(identical(other.totalIncomeKopecks, totalIncomeKopecks) || other.totalIncomeKopecks == totalIncomeKopecks)&&(identical(other.totalSurplusKopecks, totalSurplusKopecks) || other.totalSurplusKopecks == totalSurplusKopecks)&&(identical(other.surplusPercentBps, surplusPercentBps) || other.surplusPercentBps == surplusPercentBps)&&const DeepCollectionEquality().equals(other._monthsWithData, _monthsWithData));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_limitRows),const DeepCollectionEquality().hash(_expenseRows),const DeepCollectionEquality().hash(_incomeRows),const DeepCollectionEquality().hash(_cashflow),totalLimitKopecks,totalExpenseKopecks,totalIncomeKopecks,totalSurplusKopecks,surplusPercentBps,const DeepCollectionEquality().hash(_monthsWithData));

@override
String toString() {
  return 'YearBudgetData(limitRows: $limitRows, expenseRows: $expenseRows, incomeRows: $incomeRows, cashflow: $cashflow, totalLimitKopecks: $totalLimitKopecks, totalExpenseKopecks: $totalExpenseKopecks, totalIncomeKopecks: $totalIncomeKopecks, totalSurplusKopecks: $totalSurplusKopecks, surplusPercentBps: $surplusPercentBps, monthsWithData: $monthsWithData)';
}


}

/// @nodoc
abstract mixin class _$YearBudgetDataCopyWith<$Res> implements $YearBudgetDataCopyWith<$Res> {
  factory _$YearBudgetDataCopyWith(_YearBudgetData value, $Res Function(_YearBudgetData) _then) = __$YearBudgetDataCopyWithImpl;
@override @useResult
$Res call({
 List<YearCategoryRow> limitRows, List<YearCategoryRow> expenseRows, List<YearCategoryRow> incomeRows, List<YearCashflowMonth> cashflow, int totalLimitKopecks, int totalExpenseKopecks, int totalIncomeKopecks, int totalSurplusKopecks, int? surplusPercentBps, List<int> monthsWithData
});




}
/// @nodoc
class __$YearBudgetDataCopyWithImpl<$Res>
    implements _$YearBudgetDataCopyWith<$Res> {
  __$YearBudgetDataCopyWithImpl(this._self, this._then);

  final _YearBudgetData _self;
  final $Res Function(_YearBudgetData) _then;

/// Create a copy of YearBudgetData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? limitRows = null,Object? expenseRows = null,Object? incomeRows = null,Object? cashflow = null,Object? totalLimitKopecks = null,Object? totalExpenseKopecks = null,Object? totalIncomeKopecks = null,Object? totalSurplusKopecks = null,Object? surplusPercentBps = freezed,Object? monthsWithData = null,}) {
  return _then(_YearBudgetData(
limitRows: null == limitRows ? _self._limitRows : limitRows // ignore: cast_nullable_to_non_nullable
as List<YearCategoryRow>,expenseRows: null == expenseRows ? _self._expenseRows : expenseRows // ignore: cast_nullable_to_non_nullable
as List<YearCategoryRow>,incomeRows: null == incomeRows ? _self._incomeRows : incomeRows // ignore: cast_nullable_to_non_nullable
as List<YearCategoryRow>,cashflow: null == cashflow ? _self._cashflow : cashflow // ignore: cast_nullable_to_non_nullable
as List<YearCashflowMonth>,totalLimitKopecks: null == totalLimitKopecks ? _self.totalLimitKopecks : totalLimitKopecks // ignore: cast_nullable_to_non_nullable
as int,totalExpenseKopecks: null == totalExpenseKopecks ? _self.totalExpenseKopecks : totalExpenseKopecks // ignore: cast_nullable_to_non_nullable
as int,totalIncomeKopecks: null == totalIncomeKopecks ? _self.totalIncomeKopecks : totalIncomeKopecks // ignore: cast_nullable_to_non_nullable
as int,totalSurplusKopecks: null == totalSurplusKopecks ? _self.totalSurplusKopecks : totalSurplusKopecks // ignore: cast_nullable_to_non_nullable
as int,surplusPercentBps: freezed == surplusPercentBps ? _self.surplusPercentBps : surplusPercentBps // ignore: cast_nullable_to_non_nullable
as int?,monthsWithData: null == monthsWithData ? _self._monthsWithData : monthsWithData // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
mixin _$MonthTxRow {

 String get id; DateTime get dateUtc; String get accountName; String get categoryName; int get amountKopecks; String? get comment; bool get isSplitPosition;
/// Create a copy of MonthTxRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthTxRowCopyWith<MonthTxRow> get copyWith => _$MonthTxRowCopyWithImpl<MonthTxRow>(this as MonthTxRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthTxRow&&(identical(other.id, id) || other.id == id)&&(identical(other.dateUtc, dateUtc) || other.dateUtc == dateUtc)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amountKopecks, amountKopecks) || other.amountKopecks == amountKopecks)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isSplitPosition, isSplitPosition) || other.isSplitPosition == isSplitPosition));
}


@override
int get hashCode => Object.hash(runtimeType,id,dateUtc,accountName,categoryName,amountKopecks,comment,isSplitPosition);

@override
String toString() {
  return 'MonthTxRow(id: $id, dateUtc: $dateUtc, accountName: $accountName, categoryName: $categoryName, amountKopecks: $amountKopecks, comment: $comment, isSplitPosition: $isSplitPosition)';
}


}

/// @nodoc
abstract mixin class $MonthTxRowCopyWith<$Res>  {
  factory $MonthTxRowCopyWith(MonthTxRow value, $Res Function(MonthTxRow) _then) = _$MonthTxRowCopyWithImpl;
@useResult
$Res call({
 String id, DateTime dateUtc, String accountName, String categoryName, int amountKopecks, String? comment, bool isSplitPosition
});




}
/// @nodoc
class _$MonthTxRowCopyWithImpl<$Res>
    implements $MonthTxRowCopyWith<$Res> {
  _$MonthTxRowCopyWithImpl(this._self, this._then);

  final MonthTxRow _self;
  final $Res Function(MonthTxRow) _then;

/// Create a copy of MonthTxRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dateUtc = null,Object? accountName = null,Object? categoryName = null,Object? amountKopecks = null,Object? comment = freezed,Object? isSplitPosition = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dateUtc: null == dateUtc ? _self.dateUtc : dateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amountKopecks: null == amountKopecks ? _self.amountKopecks : amountKopecks // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,isSplitPosition: null == isSplitPosition ? _self.isSplitPosition : isSplitPosition // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthTxRow].
extension MonthTxRowPatterns on MonthTxRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthTxRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthTxRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthTxRow value)  $default,){
final _that = this;
switch (_that) {
case _MonthTxRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthTxRow value)?  $default,){
final _that = this;
switch (_that) {
case _MonthTxRow() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _MonthTxRow implements MonthTxRow {
  const _MonthTxRow({required this.id, required this.dateUtc, required this.accountName, required this.categoryName, required this.amountKopecks, this.comment, required this.isSplitPosition});
  

@override final  String id;
@override final  DateTime dateUtc;
@override final  String accountName;
@override final  String categoryName;
@override final  int amountKopecks;
@override final  String? comment;
@override final  bool isSplitPosition;

/// Create a copy of MonthTxRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthTxRowCopyWith<_MonthTxRow> get copyWith => __$MonthTxRowCopyWithImpl<_MonthTxRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthTxRow&&(identical(other.id, id) || other.id == id)&&(identical(other.dateUtc, dateUtc) || other.dateUtc == dateUtc)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amountKopecks, amountKopecks) || other.amountKopecks == amountKopecks)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isSplitPosition, isSplitPosition) || other.isSplitPosition == isSplitPosition));
}


@override
int get hashCode => Object.hash(runtimeType,id,dateUtc,accountName,categoryName,amountKopecks,comment,isSplitPosition);

@override
String toString() {
  return 'MonthTxRow(id: $id, dateUtc: $dateUtc, accountName: $accountName, categoryName: $categoryName, amountKopecks: $amountKopecks, comment: $comment, isSplitPosition: $isSplitPosition)';
}


}

/// @nodoc
abstract mixin class _$MonthTxRowCopyWith<$Res> implements $MonthTxRowCopyWith<$Res> {
  factory _$MonthTxRowCopyWith(_MonthTxRow value, $Res Function(_MonthTxRow) _then) = __$MonthTxRowCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime dateUtc, String accountName, String categoryName, int amountKopecks, String? comment, bool isSplitPosition
});




}
/// @nodoc
class __$MonthTxRowCopyWithImpl<$Res>
    implements _$MonthTxRowCopyWith<$Res> {
  __$MonthTxRowCopyWithImpl(this._self, this._then);

  final _MonthTxRow _self;
  final $Res Function(_MonthTxRow) _then;

/// Create a copy of MonthTxRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dateUtc = null,Object? accountName = null,Object? categoryName = null,Object? amountKopecks = null,Object? comment = freezed,Object? isSplitPosition = null,}) {
  return _then(_MonthTxRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dateUtc: null == dateUtc ? _self.dateUtc : dateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amountKopecks: null == amountKopecks ? _self.amountKopecks : amountKopecks // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,isSplitPosition: null == isSplitPosition ? _self.isSplitPosition : isSplitPosition // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$MonthCategoryRow {

 String get categoryId; String get name; String? get colorHex; String? get emoji; int get sumKopecks; int? get limitKopecks; int get remainingKopecks;
/// Create a copy of MonthCategoryRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthCategoryRowCopyWith<MonthCategoryRow> get copyWith => _$MonthCategoryRowCopyWithImpl<MonthCategoryRow>(this as MonthCategoryRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthCategoryRow&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.sumKopecks, sumKopecks) || other.sumKopecks == sumKopecks)&&(identical(other.limitKopecks, limitKopecks) || other.limitKopecks == limitKopecks)&&(identical(other.remainingKopecks, remainingKopecks) || other.remainingKopecks == remainingKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,colorHex,emoji,sumKopecks,limitKopecks,remainingKopecks);

@override
String toString() {
  return 'MonthCategoryRow(categoryId: $categoryId, name: $name, colorHex: $colorHex, emoji: $emoji, sumKopecks: $sumKopecks, limitKopecks: $limitKopecks, remainingKopecks: $remainingKopecks)';
}


}

/// @nodoc
abstract mixin class $MonthCategoryRowCopyWith<$Res>  {
  factory $MonthCategoryRowCopyWith(MonthCategoryRow value, $Res Function(MonthCategoryRow) _then) = _$MonthCategoryRowCopyWithImpl;
@useResult
$Res call({
 String categoryId, String name, String? colorHex, String? emoji, int sumKopecks, int? limitKopecks, int remainingKopecks
});




}
/// @nodoc
class _$MonthCategoryRowCopyWithImpl<$Res>
    implements $MonthCategoryRowCopyWith<$Res> {
  _$MonthCategoryRowCopyWithImpl(this._self, this._then);

  final MonthCategoryRow _self;
  final $Res Function(MonthCategoryRow) _then;

/// Create a copy of MonthCategoryRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? name = null,Object? colorHex = freezed,Object? emoji = freezed,Object? sumKopecks = null,Object? limitKopecks = freezed,Object? remainingKopecks = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,sumKopecks: null == sumKopecks ? _self.sumKopecks : sumKopecks // ignore: cast_nullable_to_non_nullable
as int,limitKopecks: freezed == limitKopecks ? _self.limitKopecks : limitKopecks // ignore: cast_nullable_to_non_nullable
as int?,remainingKopecks: null == remainingKopecks ? _self.remainingKopecks : remainingKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthCategoryRow].
extension MonthCategoryRowPatterns on MonthCategoryRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthCategoryRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthCategoryRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthCategoryRow value)  $default,){
final _that = this;
switch (_that) {
case _MonthCategoryRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthCategoryRow value)?  $default,){
final _that = this;
switch (_that) {
case _MonthCategoryRow() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _MonthCategoryRow implements MonthCategoryRow {
  const _MonthCategoryRow({required this.categoryId, required this.name, this.colorHex, this.emoji, required this.sumKopecks, required this.limitKopecks, required this.remainingKopecks});
  

@override final  String categoryId;
@override final  String name;
@override final  String? colorHex;
@override final  String? emoji;
@override final  int sumKopecks;
@override final  int? limitKopecks;
@override final  int remainingKopecks;

/// Create a copy of MonthCategoryRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthCategoryRowCopyWith<_MonthCategoryRow> get copyWith => __$MonthCategoryRowCopyWithImpl<_MonthCategoryRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthCategoryRow&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.sumKopecks, sumKopecks) || other.sumKopecks == sumKopecks)&&(identical(other.limitKopecks, limitKopecks) || other.limitKopecks == limitKopecks)&&(identical(other.remainingKopecks, remainingKopecks) || other.remainingKopecks == remainingKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,colorHex,emoji,sumKopecks,limitKopecks,remainingKopecks);

@override
String toString() {
  return 'MonthCategoryRow(categoryId: $categoryId, name: $name, colorHex: $colorHex, emoji: $emoji, sumKopecks: $sumKopecks, limitKopecks: $limitKopecks, remainingKopecks: $remainingKopecks)';
}


}

/// @nodoc
abstract mixin class _$MonthCategoryRowCopyWith<$Res> implements $MonthCategoryRowCopyWith<$Res> {
  factory _$MonthCategoryRowCopyWith(_MonthCategoryRow value, $Res Function(_MonthCategoryRow) _then) = __$MonthCategoryRowCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String name, String? colorHex, String? emoji, int sumKopecks, int? limitKopecks, int remainingKopecks
});




}
/// @nodoc
class __$MonthCategoryRowCopyWithImpl<$Res>
    implements _$MonthCategoryRowCopyWith<$Res> {
  __$MonthCategoryRowCopyWithImpl(this._self, this._then);

  final _MonthCategoryRow _self;
  final $Res Function(_MonthCategoryRow) _then;

/// Create a copy of MonthCategoryRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? name = null,Object? colorHex = freezed,Object? emoji = freezed,Object? sumKopecks = null,Object? limitKopecks = freezed,Object? remainingKopecks = null,}) {
  return _then(_MonthCategoryRow(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,sumKopecks: null == sumKopecks ? _self.sumKopecks : sumKopecks // ignore: cast_nullable_to_non_nullable
as int,limitKopecks: freezed == limitKopecks ? _self.limitKopecks : limitKopecks // ignore: cast_nullable_to_non_nullable
as int?,remainingKopecks: null == remainingKopecks ? _self.remainingKopecks : remainingKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MonthStatsKey {

 int get year; int get month; String? get spaceId;
/// Create a copy of MonthStatsKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthStatsKeyCopyWith<MonthStatsKey> get copyWith => _$MonthStatsKeyCopyWithImpl<MonthStatsKey>(this as MonthStatsKey, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthStatsKey&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,spaceId);

@override
String toString() {
  return 'MonthStatsKey(year: $year, month: $month, spaceId: $spaceId)';
}


}

/// @nodoc
abstract mixin class $MonthStatsKeyCopyWith<$Res>  {
  factory $MonthStatsKeyCopyWith(MonthStatsKey value, $Res Function(MonthStatsKey) _then) = _$MonthStatsKeyCopyWithImpl;
@useResult
$Res call({
 int year, int month, String? spaceId
});




}
/// @nodoc
class _$MonthStatsKeyCopyWithImpl<$Res>
    implements $MonthStatsKeyCopyWith<$Res> {
  _$MonthStatsKeyCopyWithImpl(this._self, this._then);

  final MonthStatsKey _self;
  final $Res Function(MonthStatsKey) _then;

/// Create a copy of MonthStatsKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? spaceId = freezed,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthStatsKey].
extension MonthStatsKeyPatterns on MonthStatsKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthStatsKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthStatsKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthStatsKey value)  $default,){
final _that = this;
switch (_that) {
case _MonthStatsKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthStatsKey value)?  $default,){
final _that = this;
switch (_that) {
case _MonthStatsKey() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _MonthStatsKey implements MonthStatsKey {
  const _MonthStatsKey({required this.year, required this.month, this.spaceId});
  

@override final  int year;
@override final  int month;
@override final  String? spaceId;

/// Create a copy of MonthStatsKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthStatsKeyCopyWith<_MonthStatsKey> get copyWith => __$MonthStatsKeyCopyWithImpl<_MonthStatsKey>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthStatsKey&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,spaceId);

@override
String toString() {
  return 'MonthStatsKey(year: $year, month: $month, spaceId: $spaceId)';
}


}

/// @nodoc
abstract mixin class _$MonthStatsKeyCopyWith<$Res> implements $MonthStatsKeyCopyWith<$Res> {
  factory _$MonthStatsKeyCopyWith(_MonthStatsKey value, $Res Function(_MonthStatsKey) _then) = __$MonthStatsKeyCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, String? spaceId
});




}
/// @nodoc
class __$MonthStatsKeyCopyWithImpl<$Res>
    implements _$MonthStatsKeyCopyWith<$Res> {
  __$MonthStatsKeyCopyWithImpl(this._self, this._then);

  final _MonthStatsKey _self;
  final $Res Function(_MonthStatsKey) _then;

/// Create a copy of MonthStatsKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? spaceId = freezed,}) {
  return _then(_MonthStatsKey(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$MonthStatsData {

 int get year; int get month; int? get allocatedKopecks; int? get unallocatedKopecks; List<MonthCategoryRow> get categories; List<MonthTxRow> get expenses; List<MonthTxRow> get incomes; int get sumExpensesKopecks; int get sumIncomesKopecks; int get sumLimitsKopecks; int? get carryFromYear; int? get carryFromMonth;
/// Create a copy of MonthStatsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthStatsDataCopyWith<MonthStatsData> get copyWith => _$MonthStatsDataCopyWithImpl<MonthStatsData>(this as MonthStatsData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthStatsData&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.allocatedKopecks, allocatedKopecks) || other.allocatedKopecks == allocatedKopecks)&&(identical(other.unallocatedKopecks, unallocatedKopecks) || other.unallocatedKopecks == unallocatedKopecks)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.expenses, expenses)&&const DeepCollectionEquality().equals(other.incomes, incomes)&&(identical(other.sumExpensesKopecks, sumExpensesKopecks) || other.sumExpensesKopecks == sumExpensesKopecks)&&(identical(other.sumIncomesKopecks, sumIncomesKopecks) || other.sumIncomesKopecks == sumIncomesKopecks)&&(identical(other.sumLimitsKopecks, sumLimitsKopecks) || other.sumLimitsKopecks == sumLimitsKopecks)&&(identical(other.carryFromYear, carryFromYear) || other.carryFromYear == carryFromYear)&&(identical(other.carryFromMonth, carryFromMonth) || other.carryFromMonth == carryFromMonth));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,allocatedKopecks,unallocatedKopecks,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(expenses),const DeepCollectionEquality().hash(incomes),sumExpensesKopecks,sumIncomesKopecks,sumLimitsKopecks,carryFromYear,carryFromMonth);

@override
String toString() {
  return 'MonthStatsData(year: $year, month: $month, allocatedKopecks: $allocatedKopecks, unallocatedKopecks: $unallocatedKopecks, categories: $categories, expenses: $expenses, incomes: $incomes, sumExpensesKopecks: $sumExpensesKopecks, sumIncomesKopecks: $sumIncomesKopecks, sumLimitsKopecks: $sumLimitsKopecks, carryFromYear: $carryFromYear, carryFromMonth: $carryFromMonth)';
}


}

/// @nodoc
abstract mixin class $MonthStatsDataCopyWith<$Res>  {
  factory $MonthStatsDataCopyWith(MonthStatsData value, $Res Function(MonthStatsData) _then) = _$MonthStatsDataCopyWithImpl;
@useResult
$Res call({
 int year, int month, int? allocatedKopecks, int? unallocatedKopecks, List<MonthCategoryRow> categories, List<MonthTxRow> expenses, List<MonthTxRow> incomes, int sumExpensesKopecks, int sumIncomesKopecks, int sumLimitsKopecks, int? carryFromYear, int? carryFromMonth
});




}
/// @nodoc
class _$MonthStatsDataCopyWithImpl<$Res>
    implements $MonthStatsDataCopyWith<$Res> {
  _$MonthStatsDataCopyWithImpl(this._self, this._then);

  final MonthStatsData _self;
  final $Res Function(MonthStatsData) _then;

/// Create a copy of MonthStatsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? allocatedKopecks = freezed,Object? unallocatedKopecks = freezed,Object? categories = null,Object? expenses = null,Object? incomes = null,Object? sumExpensesKopecks = null,Object? sumIncomesKopecks = null,Object? sumLimitsKopecks = null,Object? carryFromYear = freezed,Object? carryFromMonth = freezed,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,allocatedKopecks: freezed == allocatedKopecks ? _self.allocatedKopecks : allocatedKopecks // ignore: cast_nullable_to_non_nullable
as int?,unallocatedKopecks: freezed == unallocatedKopecks ? _self.unallocatedKopecks : unallocatedKopecks // ignore: cast_nullable_to_non_nullable
as int?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<MonthCategoryRow>,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<MonthTxRow>,incomes: null == incomes ? _self.incomes : incomes // ignore: cast_nullable_to_non_nullable
as List<MonthTxRow>,sumExpensesKopecks: null == sumExpensesKopecks ? _self.sumExpensesKopecks : sumExpensesKopecks // ignore: cast_nullable_to_non_nullable
as int,sumIncomesKopecks: null == sumIncomesKopecks ? _self.sumIncomesKopecks : sumIncomesKopecks // ignore: cast_nullable_to_non_nullable
as int,sumLimitsKopecks: null == sumLimitsKopecks ? _self.sumLimitsKopecks : sumLimitsKopecks // ignore: cast_nullable_to_non_nullable
as int,carryFromYear: freezed == carryFromYear ? _self.carryFromYear : carryFromYear // ignore: cast_nullable_to_non_nullable
as int?,carryFromMonth: freezed == carryFromMonth ? _self.carryFromMonth : carryFromMonth // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthStatsData].
extension MonthStatsDataPatterns on MonthStatsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthStatsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthStatsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthStatsData value)  $default,){
final _that = this;
switch (_that) {
case _MonthStatsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthStatsData value)?  $default,){
final _that = this;
switch (_that) {
case _MonthStatsData() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _MonthStatsData implements MonthStatsData {
  const _MonthStatsData({required this.year, required this.month, required this.allocatedKopecks, required this.unallocatedKopecks, required final  List<MonthCategoryRow> categories, required final  List<MonthTxRow> expenses, required final  List<MonthTxRow> incomes, required this.sumExpensesKopecks, required this.sumIncomesKopecks, required this.sumLimitsKopecks, required this.carryFromYear, required this.carryFromMonth}): _categories = categories,_expenses = expenses,_incomes = incomes;
  

@override final  int year;
@override final  int month;
@override final  int? allocatedKopecks;
@override final  int? unallocatedKopecks;
 final  List<MonthCategoryRow> _categories;
@override List<MonthCategoryRow> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<MonthTxRow> _expenses;
@override List<MonthTxRow> get expenses {
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenses);
}

 final  List<MonthTxRow> _incomes;
@override List<MonthTxRow> get incomes {
  if (_incomes is EqualUnmodifiableListView) return _incomes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomes);
}

@override final  int sumExpensesKopecks;
@override final  int sumIncomesKopecks;
@override final  int sumLimitsKopecks;
@override final  int? carryFromYear;
@override final  int? carryFromMonth;

/// Create a copy of MonthStatsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthStatsDataCopyWith<_MonthStatsData> get copyWith => __$MonthStatsDataCopyWithImpl<_MonthStatsData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthStatsData&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.allocatedKopecks, allocatedKopecks) || other.allocatedKopecks == allocatedKopecks)&&(identical(other.unallocatedKopecks, unallocatedKopecks) || other.unallocatedKopecks == unallocatedKopecks)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._expenses, _expenses)&&const DeepCollectionEquality().equals(other._incomes, _incomes)&&(identical(other.sumExpensesKopecks, sumExpensesKopecks) || other.sumExpensesKopecks == sumExpensesKopecks)&&(identical(other.sumIncomesKopecks, sumIncomesKopecks) || other.sumIncomesKopecks == sumIncomesKopecks)&&(identical(other.sumLimitsKopecks, sumLimitsKopecks) || other.sumLimitsKopecks == sumLimitsKopecks)&&(identical(other.carryFromYear, carryFromYear) || other.carryFromYear == carryFromYear)&&(identical(other.carryFromMonth, carryFromMonth) || other.carryFromMonth == carryFromMonth));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,allocatedKopecks,unallocatedKopecks,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_expenses),const DeepCollectionEquality().hash(_incomes),sumExpensesKopecks,sumIncomesKopecks,sumLimitsKopecks,carryFromYear,carryFromMonth);

@override
String toString() {
  return 'MonthStatsData(year: $year, month: $month, allocatedKopecks: $allocatedKopecks, unallocatedKopecks: $unallocatedKopecks, categories: $categories, expenses: $expenses, incomes: $incomes, sumExpensesKopecks: $sumExpensesKopecks, sumIncomesKopecks: $sumIncomesKopecks, sumLimitsKopecks: $sumLimitsKopecks, carryFromYear: $carryFromYear, carryFromMonth: $carryFromMonth)';
}


}

/// @nodoc
abstract mixin class _$MonthStatsDataCopyWith<$Res> implements $MonthStatsDataCopyWith<$Res> {
  factory _$MonthStatsDataCopyWith(_MonthStatsData value, $Res Function(_MonthStatsData) _then) = __$MonthStatsDataCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, int? allocatedKopecks, int? unallocatedKopecks, List<MonthCategoryRow> categories, List<MonthTxRow> expenses, List<MonthTxRow> incomes, int sumExpensesKopecks, int sumIncomesKopecks, int sumLimitsKopecks, int? carryFromYear, int? carryFromMonth
});




}
/// @nodoc
class __$MonthStatsDataCopyWithImpl<$Res>
    implements _$MonthStatsDataCopyWith<$Res> {
  __$MonthStatsDataCopyWithImpl(this._self, this._then);

  final _MonthStatsData _self;
  final $Res Function(_MonthStatsData) _then;

/// Create a copy of MonthStatsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? allocatedKopecks = freezed,Object? unallocatedKopecks = freezed,Object? categories = null,Object? expenses = null,Object? incomes = null,Object? sumExpensesKopecks = null,Object? sumIncomesKopecks = null,Object? sumLimitsKopecks = null,Object? carryFromYear = freezed,Object? carryFromMonth = freezed,}) {
  return _then(_MonthStatsData(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,allocatedKopecks: freezed == allocatedKopecks ? _self.allocatedKopecks : allocatedKopecks // ignore: cast_nullable_to_non_nullable
as int?,unallocatedKopecks: freezed == unallocatedKopecks ? _self.unallocatedKopecks : unallocatedKopecks // ignore: cast_nullable_to_non_nullable
as int?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<MonthCategoryRow>,expenses: null == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<MonthTxRow>,incomes: null == incomes ? _self._incomes : incomes // ignore: cast_nullable_to_non_nullable
as List<MonthTxRow>,sumExpensesKopecks: null == sumExpensesKopecks ? _self.sumExpensesKopecks : sumExpensesKopecks // ignore: cast_nullable_to_non_nullable
as int,sumIncomesKopecks: null == sumIncomesKopecks ? _self.sumIncomesKopecks : sumIncomesKopecks // ignore: cast_nullable_to_non_nullable
as int,sumLimitsKopecks: null == sumLimitsKopecks ? _self.sumLimitsKopecks : sumLimitsKopecks // ignore: cast_nullable_to_non_nullable
as int,carryFromYear: freezed == carryFromYear ? _self.carryFromYear : carryFromYear // ignore: cast_nullable_to_non_nullable
as int?,carryFromMonth: freezed == carryFromMonth ? _self.carryFromMonth : carryFromMonth // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

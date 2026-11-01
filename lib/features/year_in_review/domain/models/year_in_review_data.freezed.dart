// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'year_in_review_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YearCategoryStat {

 String get name; int get amount; int get percent; String? get color; String? get emoji;
/// Create a copy of YearCategoryStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearCategoryStatCopyWith<YearCategoryStat> get copyWith => _$YearCategoryStatCopyWithImpl<YearCategoryStat>(this as YearCategoryStat, _$identity);

  /// Serializes this YearCategoryStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearCategoryStat&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.color, color) || other.color == color)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,amount,percent,color,emoji);

@override
String toString() {
  return 'YearCategoryStat(name: $name, amount: $amount, percent: $percent, color: $color, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $YearCategoryStatCopyWith<$Res>  {
  factory $YearCategoryStatCopyWith(YearCategoryStat value, $Res Function(YearCategoryStat) _then) = _$YearCategoryStatCopyWithImpl;
@useResult
$Res call({
 String name, int amount, int percent, String? color, String? emoji
});




}
/// @nodoc
class _$YearCategoryStatCopyWithImpl<$Res>
    implements $YearCategoryStatCopyWith<$Res> {
  _$YearCategoryStatCopyWithImpl(this._self, this._then);

  final YearCategoryStat _self;
  final $Res Function(YearCategoryStat) _then;

/// Create a copy of YearCategoryStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? amount = null,Object? percent = null,Object? color = freezed,Object? emoji = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearCategoryStat].
extension YearCategoryStatPatterns on YearCategoryStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearCategoryStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearCategoryStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearCategoryStat value)  $default,){
final _that = this;
switch (_that) {
case _YearCategoryStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearCategoryStat value)?  $default,){
final _that = this;
switch (_that) {
case _YearCategoryStat() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearCategoryStat implements YearCategoryStat {
  const _YearCategoryStat({required this.name, this.amount = 0, this.percent = 0, this.color, this.emoji});
  factory _YearCategoryStat.fromJson(Map<String, dynamic> json) => _$YearCategoryStatFromJson(json);

@override final  String name;
@override@JsonKey() final  int amount;
@override@JsonKey() final  int percent;
@override final  String? color;
@override final  String? emoji;

/// Create a copy of YearCategoryStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearCategoryStatCopyWith<_YearCategoryStat> get copyWith => __$YearCategoryStatCopyWithImpl<_YearCategoryStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearCategoryStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearCategoryStat&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.color, color) || other.color == color)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,amount,percent,color,emoji);

@override
String toString() {
  return 'YearCategoryStat(name: $name, amount: $amount, percent: $percent, color: $color, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$YearCategoryStatCopyWith<$Res> implements $YearCategoryStatCopyWith<$Res> {
  factory _$YearCategoryStatCopyWith(_YearCategoryStat value, $Res Function(_YearCategoryStat) _then) = __$YearCategoryStatCopyWithImpl;
@override @useResult
$Res call({
 String name, int amount, int percent, String? color, String? emoji
});




}
/// @nodoc
class __$YearCategoryStatCopyWithImpl<$Res>
    implements _$YearCategoryStatCopyWith<$Res> {
  __$YearCategoryStatCopyWithImpl(this._self, this._then);

  final _YearCategoryStat _self;
  final $Res Function(_YearCategoryStat) _then;

/// Create a copy of YearCategoryStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? amount = null,Object? percent = null,Object? color = freezed,Object? emoji = freezed,}) {
  return _then(_YearCategoryStat(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$YearInReviewData {

 int get year; bool get isFamily; String get baseCurrency; int get totalIncome; int get totalExpense;/// null = нет данных за прошлый год («первый год»).
 int? get incomeGrowthPercent; int? get mostGenerousMonth; String? get mostGenerousDay; int get mostGenerousDayAmount; List<YearCategoryStat> get topCategories;/// Нет точного курса хотя бы по одной операции.
 bool get hasStaleRates;/// Нетто-переводы на инвест-счета (тип 'investment_broker').
 int get netInvested; int get totalSaved; int get goalsCompleted; int get goalsTotal; int get cashbackTotal; String? get cashbackBestCategory; List<YearCategoryStat> get cashbackTop; int get familyTotalExpense; int get familyMyPercent;/// Секретные траты в семье: общей строкой, без детализации (6.3.37.8).
 int get familySecretTotal; int get subscriptionsTotal; String? get subscriptionsMostExpensive; int get savingsRate; int get transactionCount;/// Месяц первой транзакции (для слайда «мало данных»).
 int? get firstBudgetMonth;
/// Create a copy of YearInReviewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearInReviewDataCopyWith<YearInReviewData> get copyWith => _$YearInReviewDataCopyWithImpl<YearInReviewData>(this as YearInReviewData, _$identity);

  /// Serializes this YearInReviewData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearInReviewData&&(identical(other.year, year) || other.year == year)&&(identical(other.isFamily, isFamily) || other.isFamily == isFamily)&&(identical(other.baseCurrency, baseCurrency) || other.baseCurrency == baseCurrency)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.incomeGrowthPercent, incomeGrowthPercent) || other.incomeGrowthPercent == incomeGrowthPercent)&&(identical(other.mostGenerousMonth, mostGenerousMonth) || other.mostGenerousMonth == mostGenerousMonth)&&(identical(other.mostGenerousDay, mostGenerousDay) || other.mostGenerousDay == mostGenerousDay)&&(identical(other.mostGenerousDayAmount, mostGenerousDayAmount) || other.mostGenerousDayAmount == mostGenerousDayAmount)&&const DeepCollectionEquality().equals(other.topCategories, topCategories)&&(identical(other.hasStaleRates, hasStaleRates) || other.hasStaleRates == hasStaleRates)&&(identical(other.netInvested, netInvested) || other.netInvested == netInvested)&&(identical(other.totalSaved, totalSaved) || other.totalSaved == totalSaved)&&(identical(other.goalsCompleted, goalsCompleted) || other.goalsCompleted == goalsCompleted)&&(identical(other.goalsTotal, goalsTotal) || other.goalsTotal == goalsTotal)&&(identical(other.cashbackTotal, cashbackTotal) || other.cashbackTotal == cashbackTotal)&&(identical(other.cashbackBestCategory, cashbackBestCategory) || other.cashbackBestCategory == cashbackBestCategory)&&const DeepCollectionEquality().equals(other.cashbackTop, cashbackTop)&&(identical(other.familyTotalExpense, familyTotalExpense) || other.familyTotalExpense == familyTotalExpense)&&(identical(other.familyMyPercent, familyMyPercent) || other.familyMyPercent == familyMyPercent)&&(identical(other.familySecretTotal, familySecretTotal) || other.familySecretTotal == familySecretTotal)&&(identical(other.subscriptionsTotal, subscriptionsTotal) || other.subscriptionsTotal == subscriptionsTotal)&&(identical(other.subscriptionsMostExpensive, subscriptionsMostExpensive) || other.subscriptionsMostExpensive == subscriptionsMostExpensive)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.firstBudgetMonth, firstBudgetMonth) || other.firstBudgetMonth == firstBudgetMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,year,isFamily,baseCurrency,totalIncome,totalExpense,incomeGrowthPercent,mostGenerousMonth,mostGenerousDay,mostGenerousDayAmount,const DeepCollectionEquality().hash(topCategories),hasStaleRates,netInvested,totalSaved,goalsCompleted,goalsTotal,cashbackTotal,cashbackBestCategory,const DeepCollectionEquality().hash(cashbackTop),familyTotalExpense,familyMyPercent,familySecretTotal,subscriptionsTotal,subscriptionsMostExpensive,savingsRate,transactionCount,firstBudgetMonth]);

@override
String toString() {
  return 'YearInReviewData(year: $year, isFamily: $isFamily, baseCurrency: $baseCurrency, totalIncome: $totalIncome, totalExpense: $totalExpense, incomeGrowthPercent: $incomeGrowthPercent, mostGenerousMonth: $mostGenerousMonth, mostGenerousDay: $mostGenerousDay, mostGenerousDayAmount: $mostGenerousDayAmount, topCategories: $topCategories, hasStaleRates: $hasStaleRates, netInvested: $netInvested, totalSaved: $totalSaved, goalsCompleted: $goalsCompleted, goalsTotal: $goalsTotal, cashbackTotal: $cashbackTotal, cashbackBestCategory: $cashbackBestCategory, cashbackTop: $cashbackTop, familyTotalExpense: $familyTotalExpense, familyMyPercent: $familyMyPercent, familySecretTotal: $familySecretTotal, subscriptionsTotal: $subscriptionsTotal, subscriptionsMostExpensive: $subscriptionsMostExpensive, savingsRate: $savingsRate, transactionCount: $transactionCount, firstBudgetMonth: $firstBudgetMonth)';
}


}

/// @nodoc
abstract mixin class $YearInReviewDataCopyWith<$Res>  {
  factory $YearInReviewDataCopyWith(YearInReviewData value, $Res Function(YearInReviewData) _then) = _$YearInReviewDataCopyWithImpl;
@useResult
$Res call({
 int year, bool isFamily, String baseCurrency, int totalIncome, int totalExpense, int? incomeGrowthPercent, int? mostGenerousMonth, String? mostGenerousDay, int mostGenerousDayAmount, List<YearCategoryStat> topCategories, bool hasStaleRates, int netInvested, int totalSaved, int goalsCompleted, int goalsTotal, int cashbackTotal, String? cashbackBestCategory, List<YearCategoryStat> cashbackTop, int familyTotalExpense, int familyMyPercent, int familySecretTotal, int subscriptionsTotal, String? subscriptionsMostExpensive, int savingsRate, int transactionCount, int? firstBudgetMonth
});




}
/// @nodoc
class _$YearInReviewDataCopyWithImpl<$Res>
    implements $YearInReviewDataCopyWith<$Res> {
  _$YearInReviewDataCopyWithImpl(this._self, this._then);

  final YearInReviewData _self;
  final $Res Function(YearInReviewData) _then;

/// Create a copy of YearInReviewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? isFamily = null,Object? baseCurrency = null,Object? totalIncome = null,Object? totalExpense = null,Object? incomeGrowthPercent = freezed,Object? mostGenerousMonth = freezed,Object? mostGenerousDay = freezed,Object? mostGenerousDayAmount = null,Object? topCategories = null,Object? hasStaleRates = null,Object? netInvested = null,Object? totalSaved = null,Object? goalsCompleted = null,Object? goalsTotal = null,Object? cashbackTotal = null,Object? cashbackBestCategory = freezed,Object? cashbackTop = null,Object? familyTotalExpense = null,Object? familyMyPercent = null,Object? familySecretTotal = null,Object? subscriptionsTotal = null,Object? subscriptionsMostExpensive = freezed,Object? savingsRate = null,Object? transactionCount = null,Object? firstBudgetMonth = freezed,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,isFamily: null == isFamily ? _self.isFamily : isFamily // ignore: cast_nullable_to_non_nullable
as bool,baseCurrency: null == baseCurrency ? _self.baseCurrency : baseCurrency // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,incomeGrowthPercent: freezed == incomeGrowthPercent ? _self.incomeGrowthPercent : incomeGrowthPercent // ignore: cast_nullable_to_non_nullable
as int?,mostGenerousMonth: freezed == mostGenerousMonth ? _self.mostGenerousMonth : mostGenerousMonth // ignore: cast_nullable_to_non_nullable
as int?,mostGenerousDay: freezed == mostGenerousDay ? _self.mostGenerousDay : mostGenerousDay // ignore: cast_nullable_to_non_nullable
as String?,mostGenerousDayAmount: null == mostGenerousDayAmount ? _self.mostGenerousDayAmount : mostGenerousDayAmount // ignore: cast_nullable_to_non_nullable
as int,topCategories: null == topCategories ? _self.topCategories : topCategories // ignore: cast_nullable_to_non_nullable
as List<YearCategoryStat>,hasStaleRates: null == hasStaleRates ? _self.hasStaleRates : hasStaleRates // ignore: cast_nullable_to_non_nullable
as bool,netInvested: null == netInvested ? _self.netInvested : netInvested // ignore: cast_nullable_to_non_nullable
as int,totalSaved: null == totalSaved ? _self.totalSaved : totalSaved // ignore: cast_nullable_to_non_nullable
as int,goalsCompleted: null == goalsCompleted ? _self.goalsCompleted : goalsCompleted // ignore: cast_nullable_to_non_nullable
as int,goalsTotal: null == goalsTotal ? _self.goalsTotal : goalsTotal // ignore: cast_nullable_to_non_nullable
as int,cashbackTotal: null == cashbackTotal ? _self.cashbackTotal : cashbackTotal // ignore: cast_nullable_to_non_nullable
as int,cashbackBestCategory: freezed == cashbackBestCategory ? _self.cashbackBestCategory : cashbackBestCategory // ignore: cast_nullable_to_non_nullable
as String?,cashbackTop: null == cashbackTop ? _self.cashbackTop : cashbackTop // ignore: cast_nullable_to_non_nullable
as List<YearCategoryStat>,familyTotalExpense: null == familyTotalExpense ? _self.familyTotalExpense : familyTotalExpense // ignore: cast_nullable_to_non_nullable
as int,familyMyPercent: null == familyMyPercent ? _self.familyMyPercent : familyMyPercent // ignore: cast_nullable_to_non_nullable
as int,familySecretTotal: null == familySecretTotal ? _self.familySecretTotal : familySecretTotal // ignore: cast_nullable_to_non_nullable
as int,subscriptionsTotal: null == subscriptionsTotal ? _self.subscriptionsTotal : subscriptionsTotal // ignore: cast_nullable_to_non_nullable
as int,subscriptionsMostExpensive: freezed == subscriptionsMostExpensive ? _self.subscriptionsMostExpensive : subscriptionsMostExpensive // ignore: cast_nullable_to_non_nullable
as String?,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as int,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,firstBudgetMonth: freezed == firstBudgetMonth ? _self.firstBudgetMonth : firstBudgetMonth // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearInReviewData].
extension YearInReviewDataPatterns on YearInReviewData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearInReviewData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearInReviewData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearInReviewData value)  $default,){
final _that = this;
switch (_that) {
case _YearInReviewData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearInReviewData value)?  $default,){
final _that = this;
switch (_that) {
case _YearInReviewData() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearInReviewData implements YearInReviewData {
  const _YearInReviewData({this.year = 0, this.isFamily = false, this.baseCurrency = '', this.totalIncome = 0, this.totalExpense = 0, this.incomeGrowthPercent, this.mostGenerousMonth, this.mostGenerousDay, this.mostGenerousDayAmount = 0, final  List<YearCategoryStat> topCategories = const [], this.hasStaleRates = false, this.netInvested = 0, this.totalSaved = 0, this.goalsCompleted = 0, this.goalsTotal = 0, this.cashbackTotal = 0, this.cashbackBestCategory, final  List<YearCategoryStat> cashbackTop = const [], this.familyTotalExpense = 0, this.familyMyPercent = 0, this.familySecretTotal = 0, this.subscriptionsTotal = 0, this.subscriptionsMostExpensive, this.savingsRate = 0, this.transactionCount = 0, this.firstBudgetMonth}): _topCategories = topCategories,_cashbackTop = cashbackTop;
  factory _YearInReviewData.fromJson(Map<String, dynamic> json) => _$YearInReviewDataFromJson(json);

@override@JsonKey() final  int year;
@override@JsonKey() final  bool isFamily;
@override@JsonKey() final  String baseCurrency;
@override@JsonKey() final  int totalIncome;
@override@JsonKey() final  int totalExpense;
/// null = нет данных за прошлый год («первый год»).
@override final  int? incomeGrowthPercent;
@override final  int? mostGenerousMonth;
@override final  String? mostGenerousDay;
@override@JsonKey() final  int mostGenerousDayAmount;
 final  List<YearCategoryStat> _topCategories;
@override@JsonKey() List<YearCategoryStat> get topCategories {
  if (_topCategories is EqualUnmodifiableListView) return _topCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topCategories);
}

/// Нет точного курса хотя бы по одной операции.
@override@JsonKey() final  bool hasStaleRates;
/// Нетто-переводы на инвест-счета (тип 'investment_broker').
@override@JsonKey() final  int netInvested;
@override@JsonKey() final  int totalSaved;
@override@JsonKey() final  int goalsCompleted;
@override@JsonKey() final  int goalsTotal;
@override@JsonKey() final  int cashbackTotal;
@override final  String? cashbackBestCategory;
 final  List<YearCategoryStat> _cashbackTop;
@override@JsonKey() List<YearCategoryStat> get cashbackTop {
  if (_cashbackTop is EqualUnmodifiableListView) return _cashbackTop;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cashbackTop);
}

@override@JsonKey() final  int familyTotalExpense;
@override@JsonKey() final  int familyMyPercent;
/// Секретные траты в семье: общей строкой, без детализации (6.3.37.8).
@override@JsonKey() final  int familySecretTotal;
@override@JsonKey() final  int subscriptionsTotal;
@override final  String? subscriptionsMostExpensive;
@override@JsonKey() final  int savingsRate;
@override@JsonKey() final  int transactionCount;
/// Месяц первой транзакции (для слайда «мало данных»).
@override final  int? firstBudgetMonth;

/// Create a copy of YearInReviewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearInReviewDataCopyWith<_YearInReviewData> get copyWith => __$YearInReviewDataCopyWithImpl<_YearInReviewData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearInReviewDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearInReviewData&&(identical(other.year, year) || other.year == year)&&(identical(other.isFamily, isFamily) || other.isFamily == isFamily)&&(identical(other.baseCurrency, baseCurrency) || other.baseCurrency == baseCurrency)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.incomeGrowthPercent, incomeGrowthPercent) || other.incomeGrowthPercent == incomeGrowthPercent)&&(identical(other.mostGenerousMonth, mostGenerousMonth) || other.mostGenerousMonth == mostGenerousMonth)&&(identical(other.mostGenerousDay, mostGenerousDay) || other.mostGenerousDay == mostGenerousDay)&&(identical(other.mostGenerousDayAmount, mostGenerousDayAmount) || other.mostGenerousDayAmount == mostGenerousDayAmount)&&const DeepCollectionEquality().equals(other._topCategories, _topCategories)&&(identical(other.hasStaleRates, hasStaleRates) || other.hasStaleRates == hasStaleRates)&&(identical(other.netInvested, netInvested) || other.netInvested == netInvested)&&(identical(other.totalSaved, totalSaved) || other.totalSaved == totalSaved)&&(identical(other.goalsCompleted, goalsCompleted) || other.goalsCompleted == goalsCompleted)&&(identical(other.goalsTotal, goalsTotal) || other.goalsTotal == goalsTotal)&&(identical(other.cashbackTotal, cashbackTotal) || other.cashbackTotal == cashbackTotal)&&(identical(other.cashbackBestCategory, cashbackBestCategory) || other.cashbackBestCategory == cashbackBestCategory)&&const DeepCollectionEquality().equals(other._cashbackTop, _cashbackTop)&&(identical(other.familyTotalExpense, familyTotalExpense) || other.familyTotalExpense == familyTotalExpense)&&(identical(other.familyMyPercent, familyMyPercent) || other.familyMyPercent == familyMyPercent)&&(identical(other.familySecretTotal, familySecretTotal) || other.familySecretTotal == familySecretTotal)&&(identical(other.subscriptionsTotal, subscriptionsTotal) || other.subscriptionsTotal == subscriptionsTotal)&&(identical(other.subscriptionsMostExpensive, subscriptionsMostExpensive) || other.subscriptionsMostExpensive == subscriptionsMostExpensive)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.firstBudgetMonth, firstBudgetMonth) || other.firstBudgetMonth == firstBudgetMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,year,isFamily,baseCurrency,totalIncome,totalExpense,incomeGrowthPercent,mostGenerousMonth,mostGenerousDay,mostGenerousDayAmount,const DeepCollectionEquality().hash(_topCategories),hasStaleRates,netInvested,totalSaved,goalsCompleted,goalsTotal,cashbackTotal,cashbackBestCategory,const DeepCollectionEquality().hash(_cashbackTop),familyTotalExpense,familyMyPercent,familySecretTotal,subscriptionsTotal,subscriptionsMostExpensive,savingsRate,transactionCount,firstBudgetMonth]);

@override
String toString() {
  return 'YearInReviewData(year: $year, isFamily: $isFamily, baseCurrency: $baseCurrency, totalIncome: $totalIncome, totalExpense: $totalExpense, incomeGrowthPercent: $incomeGrowthPercent, mostGenerousMonth: $mostGenerousMonth, mostGenerousDay: $mostGenerousDay, mostGenerousDayAmount: $mostGenerousDayAmount, topCategories: $topCategories, hasStaleRates: $hasStaleRates, netInvested: $netInvested, totalSaved: $totalSaved, goalsCompleted: $goalsCompleted, goalsTotal: $goalsTotal, cashbackTotal: $cashbackTotal, cashbackBestCategory: $cashbackBestCategory, cashbackTop: $cashbackTop, familyTotalExpense: $familyTotalExpense, familyMyPercent: $familyMyPercent, familySecretTotal: $familySecretTotal, subscriptionsTotal: $subscriptionsTotal, subscriptionsMostExpensive: $subscriptionsMostExpensive, savingsRate: $savingsRate, transactionCount: $transactionCount, firstBudgetMonth: $firstBudgetMonth)';
}


}

/// @nodoc
abstract mixin class _$YearInReviewDataCopyWith<$Res> implements $YearInReviewDataCopyWith<$Res> {
  factory _$YearInReviewDataCopyWith(_YearInReviewData value, $Res Function(_YearInReviewData) _then) = __$YearInReviewDataCopyWithImpl;
@override @useResult
$Res call({
 int year, bool isFamily, String baseCurrency, int totalIncome, int totalExpense, int? incomeGrowthPercent, int? mostGenerousMonth, String? mostGenerousDay, int mostGenerousDayAmount, List<YearCategoryStat> topCategories, bool hasStaleRates, int netInvested, int totalSaved, int goalsCompleted, int goalsTotal, int cashbackTotal, String? cashbackBestCategory, List<YearCategoryStat> cashbackTop, int familyTotalExpense, int familyMyPercent, int familySecretTotal, int subscriptionsTotal, String? subscriptionsMostExpensive, int savingsRate, int transactionCount, int? firstBudgetMonth
});




}
/// @nodoc
class __$YearInReviewDataCopyWithImpl<$Res>
    implements _$YearInReviewDataCopyWith<$Res> {
  __$YearInReviewDataCopyWithImpl(this._self, this._then);

  final _YearInReviewData _self;
  final $Res Function(_YearInReviewData) _then;

/// Create a copy of YearInReviewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? isFamily = null,Object? baseCurrency = null,Object? totalIncome = null,Object? totalExpense = null,Object? incomeGrowthPercent = freezed,Object? mostGenerousMonth = freezed,Object? mostGenerousDay = freezed,Object? mostGenerousDayAmount = null,Object? topCategories = null,Object? hasStaleRates = null,Object? netInvested = null,Object? totalSaved = null,Object? goalsCompleted = null,Object? goalsTotal = null,Object? cashbackTotal = null,Object? cashbackBestCategory = freezed,Object? cashbackTop = null,Object? familyTotalExpense = null,Object? familyMyPercent = null,Object? familySecretTotal = null,Object? subscriptionsTotal = null,Object? subscriptionsMostExpensive = freezed,Object? savingsRate = null,Object? transactionCount = null,Object? firstBudgetMonth = freezed,}) {
  return _then(_YearInReviewData(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,isFamily: null == isFamily ? _self.isFamily : isFamily // ignore: cast_nullable_to_non_nullable
as bool,baseCurrency: null == baseCurrency ? _self.baseCurrency : baseCurrency // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,incomeGrowthPercent: freezed == incomeGrowthPercent ? _self.incomeGrowthPercent : incomeGrowthPercent // ignore: cast_nullable_to_non_nullable
as int?,mostGenerousMonth: freezed == mostGenerousMonth ? _self.mostGenerousMonth : mostGenerousMonth // ignore: cast_nullable_to_non_nullable
as int?,mostGenerousDay: freezed == mostGenerousDay ? _self.mostGenerousDay : mostGenerousDay // ignore: cast_nullable_to_non_nullable
as String?,mostGenerousDayAmount: null == mostGenerousDayAmount ? _self.mostGenerousDayAmount : mostGenerousDayAmount // ignore: cast_nullable_to_non_nullable
as int,topCategories: null == topCategories ? _self._topCategories : topCategories // ignore: cast_nullable_to_non_nullable
as List<YearCategoryStat>,hasStaleRates: null == hasStaleRates ? _self.hasStaleRates : hasStaleRates // ignore: cast_nullable_to_non_nullable
as bool,netInvested: null == netInvested ? _self.netInvested : netInvested // ignore: cast_nullable_to_non_nullable
as int,totalSaved: null == totalSaved ? _self.totalSaved : totalSaved // ignore: cast_nullable_to_non_nullable
as int,goalsCompleted: null == goalsCompleted ? _self.goalsCompleted : goalsCompleted // ignore: cast_nullable_to_non_nullable
as int,goalsTotal: null == goalsTotal ? _self.goalsTotal : goalsTotal // ignore: cast_nullable_to_non_nullable
as int,cashbackTotal: null == cashbackTotal ? _self.cashbackTotal : cashbackTotal // ignore: cast_nullable_to_non_nullable
as int,cashbackBestCategory: freezed == cashbackBestCategory ? _self.cashbackBestCategory : cashbackBestCategory // ignore: cast_nullable_to_non_nullable
as String?,cashbackTop: null == cashbackTop ? _self._cashbackTop : cashbackTop // ignore: cast_nullable_to_non_nullable
as List<YearCategoryStat>,familyTotalExpense: null == familyTotalExpense ? _self.familyTotalExpense : familyTotalExpense // ignore: cast_nullable_to_non_nullable
as int,familyMyPercent: null == familyMyPercent ? _self.familyMyPercent : familyMyPercent // ignore: cast_nullable_to_non_nullable
as int,familySecretTotal: null == familySecretTotal ? _self.familySecretTotal : familySecretTotal // ignore: cast_nullable_to_non_nullable
as int,subscriptionsTotal: null == subscriptionsTotal ? _self.subscriptionsTotal : subscriptionsTotal // ignore: cast_nullable_to_non_nullable
as int,subscriptionsMostExpensive: freezed == subscriptionsMostExpensive ? _self.subscriptionsMostExpensive : subscriptionsMostExpensive // ignore: cast_nullable_to_non_nullable
as String?,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as int,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,firstBudgetMonth: freezed == firstBudgetMonth ? _self.firstBudgetMonth : firstBudgetMonth // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

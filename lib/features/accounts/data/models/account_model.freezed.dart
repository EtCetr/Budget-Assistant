// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountModel {

 String get id; String get userId; String? get spaceId; String get bankName; String get customName; String? get cardNumberMask; String get accountType; String get currency; int get currentBalance; int? get creditLimit; DateTime? get gracePeriodEnd; int? get minPaymentAmount; bool get includeInPersonalBalance; bool get includeInFamilyBalance; bool get isSharedBalance; bool get isSharedExpenses; String get expenseDetailLevel; bool get isSharedIncomes; String get incomeDetailLevel; int? get sortOrder; bool get isArchived; bool get isSystem; DateTime get createdAt; DateTime get updatedAt; String get syncStatus;
/// Create a copy of AccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountModelCopyWith<AccountModel> get copyWith => _$AccountModelCopyWithImpl<AccountModel>(this as AccountModel, _$identity);

  /// Serializes this AccountModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.customName, customName) || other.customName == customName)&&(identical(other.cardNumberMask, cardNumberMask) || other.cardNumberMask == cardNumberMask)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit)&&(identical(other.gracePeriodEnd, gracePeriodEnd) || other.gracePeriodEnd == gracePeriodEnd)&&(identical(other.minPaymentAmount, minPaymentAmount) || other.minPaymentAmount == minPaymentAmount)&&(identical(other.includeInPersonalBalance, includeInPersonalBalance) || other.includeInPersonalBalance == includeInPersonalBalance)&&(identical(other.includeInFamilyBalance, includeInFamilyBalance) || other.includeInFamilyBalance == includeInFamilyBalance)&&(identical(other.isSharedBalance, isSharedBalance) || other.isSharedBalance == isSharedBalance)&&(identical(other.isSharedExpenses, isSharedExpenses) || other.isSharedExpenses == isSharedExpenses)&&(identical(other.expenseDetailLevel, expenseDetailLevel) || other.expenseDetailLevel == expenseDetailLevel)&&(identical(other.isSharedIncomes, isSharedIncomes) || other.isSharedIncomes == isSharedIncomes)&&(identical(other.incomeDetailLevel, incomeDetailLevel) || other.incomeDetailLevel == incomeDetailLevel)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,spaceId,bankName,customName,cardNumberMask,accountType,currency,currentBalance,creditLimit,gracePeriodEnd,minPaymentAmount,includeInPersonalBalance,includeInFamilyBalance,isSharedBalance,isSharedExpenses,expenseDetailLevel,isSharedIncomes,incomeDetailLevel,sortOrder,isArchived,isSystem,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'AccountModel(id: $id, userId: $userId, spaceId: $spaceId, bankName: $bankName, customName: $customName, cardNumberMask: $cardNumberMask, accountType: $accountType, currency: $currency, currentBalance: $currentBalance, creditLimit: $creditLimit, gracePeriodEnd: $gracePeriodEnd, minPaymentAmount: $minPaymentAmount, includeInPersonalBalance: $includeInPersonalBalance, includeInFamilyBalance: $includeInFamilyBalance, isSharedBalance: $isSharedBalance, isSharedExpenses: $isSharedExpenses, expenseDetailLevel: $expenseDetailLevel, isSharedIncomes: $isSharedIncomes, incomeDetailLevel: $incomeDetailLevel, sortOrder: $sortOrder, isArchived: $isArchived, isSystem: $isSystem, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $AccountModelCopyWith<$Res>  {
  factory $AccountModelCopyWith(AccountModel value, $Res Function(AccountModel) _then) = _$AccountModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? spaceId, String bankName, String customName, String? cardNumberMask, String accountType, String currency, int currentBalance, int? creditLimit, DateTime? gracePeriodEnd, int? minPaymentAmount, bool includeInPersonalBalance, bool includeInFamilyBalance, bool isSharedBalance, bool isSharedExpenses, String expenseDetailLevel, bool isSharedIncomes, String incomeDetailLevel, int? sortOrder, bool isArchived, bool isSystem, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class _$AccountModelCopyWithImpl<$Res>
    implements $AccountModelCopyWith<$Res> {
  _$AccountModelCopyWithImpl(this._self, this._then);

  final AccountModel _self;
  final $Res Function(AccountModel) _then;

/// Create a copy of AccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? bankName = null,Object? customName = null,Object? cardNumberMask = freezed,Object? accountType = null,Object? currency = null,Object? currentBalance = null,Object? creditLimit = freezed,Object? gracePeriodEnd = freezed,Object? minPaymentAmount = freezed,Object? includeInPersonalBalance = null,Object? includeInFamilyBalance = null,Object? isSharedBalance = null,Object? isSharedExpenses = null,Object? expenseDetailLevel = null,Object? isSharedIncomes = null,Object? incomeDetailLevel = null,Object? sortOrder = freezed,Object? isArchived = null,Object? isSystem = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,customName: null == customName ? _self.customName : customName // ignore: cast_nullable_to_non_nullable
as String,cardNumberMask: freezed == cardNumberMask ? _self.cardNumberMask : cardNumberMask // ignore: cast_nullable_to_non_nullable
as String?,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as int?,gracePeriodEnd: freezed == gracePeriodEnd ? _self.gracePeriodEnd : gracePeriodEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,minPaymentAmount: freezed == minPaymentAmount ? _self.minPaymentAmount : minPaymentAmount // ignore: cast_nullable_to_non_nullable
as int?,includeInPersonalBalance: null == includeInPersonalBalance ? _self.includeInPersonalBalance : includeInPersonalBalance // ignore: cast_nullable_to_non_nullable
as bool,includeInFamilyBalance: null == includeInFamilyBalance ? _self.includeInFamilyBalance : includeInFamilyBalance // ignore: cast_nullable_to_non_nullable
as bool,isSharedBalance: null == isSharedBalance ? _self.isSharedBalance : isSharedBalance // ignore: cast_nullable_to_non_nullable
as bool,isSharedExpenses: null == isSharedExpenses ? _self.isSharedExpenses : isSharedExpenses // ignore: cast_nullable_to_non_nullable
as bool,expenseDetailLevel: null == expenseDetailLevel ? _self.expenseDetailLevel : expenseDetailLevel // ignore: cast_nullable_to_non_nullable
as String,isSharedIncomes: null == isSharedIncomes ? _self.isSharedIncomes : isSharedIncomes // ignore: cast_nullable_to_non_nullable
as bool,incomeDetailLevel: null == incomeDetailLevel ? _self.incomeDetailLevel : incomeDetailLevel // ignore: cast_nullable_to_non_nullable
as String,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountModel].
extension AccountModelPatterns on AccountModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountModel value)  $default,){
final _that = this;
switch (_that) {
case _AccountModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccountModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountModel implements AccountModel {
  const _AccountModel({required this.id, required this.userId, this.spaceId, required this.bankName, required this.customName, this.cardNumberMask, required this.accountType, required this.currency, required this.currentBalance, this.creditLimit, this.gracePeriodEnd, this.minPaymentAmount, this.includeInPersonalBalance = true, this.includeInFamilyBalance = false, this.isSharedBalance = false, this.isSharedExpenses = false, this.expenseDetailLevel = 'total_only', this.isSharedIncomes = false, this.incomeDetailLevel = 'total_only', this.sortOrder, this.isArchived = false, this.isSystem = false, required this.createdAt, required this.updatedAt, this.syncStatus = 'pending'});
  factory _AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? spaceId;
@override final  String bankName;
@override final  String customName;
@override final  String? cardNumberMask;
@override final  String accountType;
@override final  String currency;
@override final  int currentBalance;
@override final  int? creditLimit;
@override final  DateTime? gracePeriodEnd;
@override final  int? minPaymentAmount;
@override@JsonKey() final  bool includeInPersonalBalance;
@override@JsonKey() final  bool includeInFamilyBalance;
@override@JsonKey() final  bool isSharedBalance;
@override@JsonKey() final  bool isSharedExpenses;
@override@JsonKey() final  String expenseDetailLevel;
@override@JsonKey() final  bool isSharedIncomes;
@override@JsonKey() final  String incomeDetailLevel;
@override final  int? sortOrder;
@override@JsonKey() final  bool isArchived;
@override@JsonKey() final  bool isSystem;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String syncStatus;

/// Create a copy of AccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountModelCopyWith<_AccountModel> get copyWith => __$AccountModelCopyWithImpl<_AccountModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.customName, customName) || other.customName == customName)&&(identical(other.cardNumberMask, cardNumberMask) || other.cardNumberMask == cardNumberMask)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit)&&(identical(other.gracePeriodEnd, gracePeriodEnd) || other.gracePeriodEnd == gracePeriodEnd)&&(identical(other.minPaymentAmount, minPaymentAmount) || other.minPaymentAmount == minPaymentAmount)&&(identical(other.includeInPersonalBalance, includeInPersonalBalance) || other.includeInPersonalBalance == includeInPersonalBalance)&&(identical(other.includeInFamilyBalance, includeInFamilyBalance) || other.includeInFamilyBalance == includeInFamilyBalance)&&(identical(other.isSharedBalance, isSharedBalance) || other.isSharedBalance == isSharedBalance)&&(identical(other.isSharedExpenses, isSharedExpenses) || other.isSharedExpenses == isSharedExpenses)&&(identical(other.expenseDetailLevel, expenseDetailLevel) || other.expenseDetailLevel == expenseDetailLevel)&&(identical(other.isSharedIncomes, isSharedIncomes) || other.isSharedIncomes == isSharedIncomes)&&(identical(other.incomeDetailLevel, incomeDetailLevel) || other.incomeDetailLevel == incomeDetailLevel)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,spaceId,bankName,customName,cardNumberMask,accountType,currency,currentBalance,creditLimit,gracePeriodEnd,minPaymentAmount,includeInPersonalBalance,includeInFamilyBalance,isSharedBalance,isSharedExpenses,expenseDetailLevel,isSharedIncomes,incomeDetailLevel,sortOrder,isArchived,isSystem,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'AccountModel(id: $id, userId: $userId, spaceId: $spaceId, bankName: $bankName, customName: $customName, cardNumberMask: $cardNumberMask, accountType: $accountType, currency: $currency, currentBalance: $currentBalance, creditLimit: $creditLimit, gracePeriodEnd: $gracePeriodEnd, minPaymentAmount: $minPaymentAmount, includeInPersonalBalance: $includeInPersonalBalance, includeInFamilyBalance: $includeInFamilyBalance, isSharedBalance: $isSharedBalance, isSharedExpenses: $isSharedExpenses, expenseDetailLevel: $expenseDetailLevel, isSharedIncomes: $isSharedIncomes, incomeDetailLevel: $incomeDetailLevel, sortOrder: $sortOrder, isArchived: $isArchived, isSystem: $isSystem, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$AccountModelCopyWith<$Res> implements $AccountModelCopyWith<$Res> {
  factory _$AccountModelCopyWith(_AccountModel value, $Res Function(_AccountModel) _then) = __$AccountModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? spaceId, String bankName, String customName, String? cardNumberMask, String accountType, String currency, int currentBalance, int? creditLimit, DateTime? gracePeriodEnd, int? minPaymentAmount, bool includeInPersonalBalance, bool includeInFamilyBalance, bool isSharedBalance, bool isSharedExpenses, String expenseDetailLevel, bool isSharedIncomes, String incomeDetailLevel, int? sortOrder, bool isArchived, bool isSystem, DateTime createdAt, DateTime updatedAt, String syncStatus
});




}
/// @nodoc
class __$AccountModelCopyWithImpl<$Res>
    implements _$AccountModelCopyWith<$Res> {
  __$AccountModelCopyWithImpl(this._self, this._then);

  final _AccountModel _self;
  final $Res Function(_AccountModel) _then;

/// Create a copy of AccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? spaceId = freezed,Object? bankName = null,Object? customName = null,Object? cardNumberMask = freezed,Object? accountType = null,Object? currency = null,Object? currentBalance = null,Object? creditLimit = freezed,Object? gracePeriodEnd = freezed,Object? minPaymentAmount = freezed,Object? includeInPersonalBalance = null,Object? includeInFamilyBalance = null,Object? isSharedBalance = null,Object? isSharedExpenses = null,Object? expenseDetailLevel = null,Object? isSharedIncomes = null,Object? incomeDetailLevel = null,Object? sortOrder = freezed,Object? isArchived = null,Object? isSystem = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_AccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,customName: null == customName ? _self.customName : customName // ignore: cast_nullable_to_non_nullable
as String,cardNumberMask: freezed == cardNumberMask ? _self.cardNumberMask : cardNumberMask // ignore: cast_nullable_to_non_nullable
as String?,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as int?,gracePeriodEnd: freezed == gracePeriodEnd ? _self.gracePeriodEnd : gracePeriodEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,minPaymentAmount: freezed == minPaymentAmount ? _self.minPaymentAmount : minPaymentAmount // ignore: cast_nullable_to_non_nullable
as int?,includeInPersonalBalance: null == includeInPersonalBalance ? _self.includeInPersonalBalance : includeInPersonalBalance // ignore: cast_nullable_to_non_nullable
as bool,includeInFamilyBalance: null == includeInFamilyBalance ? _self.includeInFamilyBalance : includeInFamilyBalance // ignore: cast_nullable_to_non_nullable
as bool,isSharedBalance: null == isSharedBalance ? _self.isSharedBalance : isSharedBalance // ignore: cast_nullable_to_non_nullable
as bool,isSharedExpenses: null == isSharedExpenses ? _self.isSharedExpenses : isSharedExpenses // ignore: cast_nullable_to_non_nullable
as bool,expenseDetailLevel: null == expenseDetailLevel ? _self.expenseDetailLevel : expenseDetailLevel // ignore: cast_nullable_to_non_nullable
as String,isSharedIncomes: null == isSharedIncomes ? _self.isSharedIncomes : isSharedIncomes // ignore: cast_nullable_to_non_nullable
as bool,incomeDetailLevel: null == incomeDetailLevel ? _self.incomeDetailLevel : incomeDetailLevel // ignore: cast_nullable_to_non_nullable
as String,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Debt {

 String get id;/// Кому должны (кредитор).
 String? get creditorId;/// Кто должен (должник). NULL = внешний контрагент.
 String? get debtorId;/// Семейный долг — пространство; NULL = личный/внешний.
 String? get spaceId;/// Категория исходной траты (для компенсирующих транзакций).
 String? get categoryId;/// Копейки, всегда > 0.
 int get amount; String get currency;/// «За что» [E2E].
 String? get description;/// Имя внешнего контрагента в дательном падеже [E2E].
 String? get counterpartyNameDative;/// Транзакция, породившая долг.
 String? get originalTransactionId;/// Связь с частью сплит-чека (transaction_splits.id).
 String? get splitId;/// Срок погашения (UTC).
 DateTime? get dueDate;/// Дата закрытия.
 DateTime? get resolvedAt; String get resolutionStatus; bool get isExMemberDebt;/// Создатель (только он может редактировать/удалять).
 String get createdBy; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtCopyWith<Debt> get copyWith => _$DebtCopyWithImpl<Debt>(this as Debt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.creditorId, creditorId) || other.creditorId == creditorId)&&(identical(other.debtorId, debtorId) || other.debtorId == debtorId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.description, description) || other.description == description)&&(identical(other.counterpartyNameDative, counterpartyNameDative) || other.counterpartyNameDative == counterpartyNameDative)&&(identical(other.originalTransactionId, originalTransactionId) || other.originalTransactionId == originalTransactionId)&&(identical(other.splitId, splitId) || other.splitId == splitId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.resolutionStatus, resolutionStatus) || other.resolutionStatus == resolutionStatus)&&(identical(other.isExMemberDebt, isExMemberDebt) || other.isExMemberDebt == isExMemberDebt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,creditorId,debtorId,spaceId,categoryId,amount,currency,description,counterpartyNameDative,originalTransactionId,splitId,dueDate,resolvedAt,resolutionStatus,isExMemberDebt,createdBy,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'Debt(id: $id, creditorId: $creditorId, debtorId: $debtorId, spaceId: $spaceId, categoryId: $categoryId, amount: $amount, currency: $currency, description: $description, counterpartyNameDative: $counterpartyNameDative, originalTransactionId: $originalTransactionId, splitId: $splitId, dueDate: $dueDate, resolvedAt: $resolvedAt, resolutionStatus: $resolutionStatus, isExMemberDebt: $isExMemberDebt, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $DebtCopyWith<$Res>  {
  factory $DebtCopyWith(Debt value, $Res Function(Debt) _then) = _$DebtCopyWithImpl;
@useResult
$Res call({
 String id, String? creditorId, String? debtorId, String? spaceId, String? categoryId, int amount, String currency, String? description, String? counterpartyNameDative, String? originalTransactionId, String? splitId, DateTime? dueDate, DateTime? resolvedAt, String resolutionStatus, bool isExMemberDebt, String createdBy, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$DebtCopyWithImpl<$Res>
    implements $DebtCopyWith<$Res> {
  _$DebtCopyWithImpl(this._self, this._then);

  final Debt _self;
  final $Res Function(Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? creditorId = freezed,Object? debtorId = freezed,Object? spaceId = freezed,Object? categoryId = freezed,Object? amount = null,Object? currency = null,Object? description = freezed,Object? counterpartyNameDative = freezed,Object? originalTransactionId = freezed,Object? splitId = freezed,Object? dueDate = freezed,Object? resolvedAt = freezed,Object? resolutionStatus = null,Object? isExMemberDebt = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,creditorId: freezed == creditorId ? _self.creditorId : creditorId // ignore: cast_nullable_to_non_nullable
as String?,debtorId: freezed == debtorId ? _self.debtorId : debtorId // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,counterpartyNameDative: freezed == counterpartyNameDative ? _self.counterpartyNameDative : counterpartyNameDative // ignore: cast_nullable_to_non_nullable
as String?,originalTransactionId: freezed == originalTransactionId ? _self.originalTransactionId : originalTransactionId // ignore: cast_nullable_to_non_nullable
as String?,splitId: freezed == splitId ? _self.splitId : splitId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolutionStatus: null == resolutionStatus ? _self.resolutionStatus : resolutionStatus // ignore: cast_nullable_to_non_nullable
as String,isExMemberDebt: null == isExMemberDebt ? _self.isExMemberDebt : isExMemberDebt // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Debt].
extension DebtPatterns on Debt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Debt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Debt value)  $default,){
final _that = this;
switch (_that) {
case _Debt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Debt value)?  $default,){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _Debt implements Debt {
  const _Debt({required this.id, this.creditorId, this.debtorId, this.spaceId, this.categoryId, required this.amount, this.currency = 'RUB', this.description, this.counterpartyNameDative, this.originalTransactionId, this.splitId, this.dueDate, this.resolvedAt, this.resolutionStatus = DebtResolutionStatus.active, this.isExMemberDebt = false, required this.createdBy, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  

@override final  String id;
/// Кому должны (кредитор).
@override final  String? creditorId;
/// Кто должен (должник). NULL = внешний контрагент.
@override final  String? debtorId;
/// Семейный долг — пространство; NULL = личный/внешний.
@override final  String? spaceId;
/// Категория исходной траты (для компенсирующих транзакций).
@override final  String? categoryId;
/// Копейки, всегда > 0.
@override final  int amount;
@override@JsonKey() final  String currency;
/// «За что» [E2E].
@override final  String? description;
/// Имя внешнего контрагента в дательном падеже [E2E].
@override final  String? counterpartyNameDative;
/// Транзакция, породившая долг.
@override final  String? originalTransactionId;
/// Связь с частью сплит-чека (transaction_splits.id).
@override final  String? splitId;
/// Срок погашения (UTC).
@override final  DateTime? dueDate;
/// Дата закрытия.
@override final  DateTime? resolvedAt;
@override@JsonKey() final  String resolutionStatus;
@override@JsonKey() final  bool isExMemberDebt;
/// Создатель (только он может редактировать/удалять).
@override final  String createdBy;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtCopyWith<_Debt> get copyWith => __$DebtCopyWithImpl<_Debt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.creditorId, creditorId) || other.creditorId == creditorId)&&(identical(other.debtorId, debtorId) || other.debtorId == debtorId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.description, description) || other.description == description)&&(identical(other.counterpartyNameDative, counterpartyNameDative) || other.counterpartyNameDative == counterpartyNameDative)&&(identical(other.originalTransactionId, originalTransactionId) || other.originalTransactionId == originalTransactionId)&&(identical(other.splitId, splitId) || other.splitId == splitId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.resolutionStatus, resolutionStatus) || other.resolutionStatus == resolutionStatus)&&(identical(other.isExMemberDebt, isExMemberDebt) || other.isExMemberDebt == isExMemberDebt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,creditorId,debtorId,spaceId,categoryId,amount,currency,description,counterpartyNameDative,originalTransactionId,splitId,dueDate,resolvedAt,resolutionStatus,isExMemberDebt,createdBy,createdAt,updatedAt,syncStatus]);

@override
String toString() {
  return 'Debt(id: $id, creditorId: $creditorId, debtorId: $debtorId, spaceId: $spaceId, categoryId: $categoryId, amount: $amount, currency: $currency, description: $description, counterpartyNameDative: $counterpartyNameDative, originalTransactionId: $originalTransactionId, splitId: $splitId, dueDate: $dueDate, resolvedAt: $resolvedAt, resolutionStatus: $resolutionStatus, isExMemberDebt: $isExMemberDebt, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$DebtCopyWith<$Res> implements $DebtCopyWith<$Res> {
  factory _$DebtCopyWith(_Debt value, $Res Function(_Debt) _then) = __$DebtCopyWithImpl;
@override @useResult
$Res call({
 String id, String? creditorId, String? debtorId, String? spaceId, String? categoryId, int amount, String currency, String? description, String? counterpartyNameDative, String? originalTransactionId, String? splitId, DateTime? dueDate, DateTime? resolvedAt, String resolutionStatus, bool isExMemberDebt, String createdBy, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$DebtCopyWithImpl<$Res>
    implements _$DebtCopyWith<$Res> {
  __$DebtCopyWithImpl(this._self, this._then);

  final _Debt _self;
  final $Res Function(_Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? creditorId = freezed,Object? debtorId = freezed,Object? spaceId = freezed,Object? categoryId = freezed,Object? amount = null,Object? currency = null,Object? description = freezed,Object? counterpartyNameDative = freezed,Object? originalTransactionId = freezed,Object? splitId = freezed,Object? dueDate = freezed,Object? resolvedAt = freezed,Object? resolutionStatus = null,Object? isExMemberDebt = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_Debt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,creditorId: freezed == creditorId ? _self.creditorId : creditorId // ignore: cast_nullable_to_non_nullable
as String?,debtorId: freezed == debtorId ? _self.debtorId : debtorId // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,counterpartyNameDative: freezed == counterpartyNameDative ? _self.counterpartyNameDative : counterpartyNameDative // ignore: cast_nullable_to_non_nullable
as String?,originalTransactionId: freezed == originalTransactionId ? _self.originalTransactionId : originalTransactionId // ignore: cast_nullable_to_non_nullable
as String?,splitId: freezed == splitId ? _self.splitId : splitId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolutionStatus: null == resolutionStatus ? _self.resolutionStatus : resolutionStatus // ignore: cast_nullable_to_non_nullable
as String,isExMemberDebt: null == isExMemberDebt ? _self.isExMemberDebt : isExMemberDebt // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on

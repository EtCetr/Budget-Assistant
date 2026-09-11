// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionDraft {

/// Для создания null.
/// Для обновления обязателен.
 String? get id; String get accountId; String? get linkedAccountId; DateTime get date;/// Копейки.
 int get amount; String? get originalCurrency; int? get originalAmount; TransactionType get type; String? get spaceId; String? get bankCategory; String? get customCategoryId; String? get merchantName; String? get comment; String? get savingsGoalId; bool? get isWithdrawal; List<TransactionSplitDraft>? get splits;
/// Create a copy of TransactionDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDraftCopyWith<TransactionDraft> get copyWith => _$TransactionDraftCopyWithImpl<TransactionDraft>(this as TransactionDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.type, type) || other.type == type)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.bankCategory, bankCategory) || other.bankCategory == bankCategory)&&(identical(other.customCategoryId, customCategoryId) || other.customCategoryId == customCategoryId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.savingsGoalId, savingsGoalId) || other.savingsGoalId == savingsGoalId)&&(identical(other.isWithdrawal, isWithdrawal) || other.isWithdrawal == isWithdrawal)&&const DeepCollectionEquality().equals(other.splits, splits));
}


@override
int get hashCode => Object.hash(runtimeType,id,accountId,linkedAccountId,date,amount,originalCurrency,originalAmount,type,spaceId,bankCategory,customCategoryId,merchantName,comment,savingsGoalId,isWithdrawal,const DeepCollectionEquality().hash(splits));

@override
String toString() {
  return 'TransactionDraft(id: $id, accountId: $accountId, linkedAccountId: $linkedAccountId, date: $date, amount: $amount, originalCurrency: $originalCurrency, originalAmount: $originalAmount, type: $type, spaceId: $spaceId, bankCategory: $bankCategory, customCategoryId: $customCategoryId, merchantName: $merchantName, comment: $comment, savingsGoalId: $savingsGoalId, isWithdrawal: $isWithdrawal, splits: $splits)';
}


}

/// @nodoc
abstract mixin class $TransactionDraftCopyWith<$Res>  {
  factory $TransactionDraftCopyWith(TransactionDraft value, $Res Function(TransactionDraft) _then) = _$TransactionDraftCopyWithImpl;
@useResult
$Res call({
 String? id, String accountId, String? linkedAccountId, DateTime date, int amount, String? originalCurrency, int? originalAmount, TransactionType type, String? spaceId, String? bankCategory, String? customCategoryId, String? merchantName, String? comment, String? savingsGoalId, bool? isWithdrawal, List<TransactionSplitDraft>? splits
});




}
/// @nodoc
class _$TransactionDraftCopyWithImpl<$Res>
    implements $TransactionDraftCopyWith<$Res> {
  _$TransactionDraftCopyWithImpl(this._self, this._then);

  final TransactionDraft _self;
  final $Res Function(TransactionDraft) _then;

/// Create a copy of TransactionDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? accountId = null,Object? linkedAccountId = freezed,Object? date = null,Object? amount = null,Object? originalCurrency = freezed,Object? originalAmount = freezed,Object? type = null,Object? spaceId = freezed,Object? bankCategory = freezed,Object? customCategoryId = freezed,Object? merchantName = freezed,Object? comment = freezed,Object? savingsGoalId = freezed,Object? isWithdrawal = freezed,Object? splits = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: freezed == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,bankCategory: freezed == bankCategory ? _self.bankCategory : bankCategory // ignore: cast_nullable_to_non_nullable
as String?,customCategoryId: freezed == customCategoryId ? _self.customCategoryId : customCategoryId // ignore: cast_nullable_to_non_nullable
as String?,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,savingsGoalId: freezed == savingsGoalId ? _self.savingsGoalId : savingsGoalId // ignore: cast_nullable_to_non_nullable
as String?,isWithdrawal: freezed == isWithdrawal ? _self.isWithdrawal : isWithdrawal // ignore: cast_nullable_to_non_nullable
as bool?,splits: freezed == splits ? _self.splits : splits // ignore: cast_nullable_to_non_nullable
as List<TransactionSplitDraft>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionDraft].
extension TransactionDraftPatterns on TransactionDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionDraft value)  $default,){
final _that = this;
switch (_that) {
case _TransactionDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionDraft implements TransactionDraft {
  const _TransactionDraft({this.id, required this.accountId, this.linkedAccountId, required this.date, required this.amount, this.originalCurrency, this.originalAmount, required this.type, this.spaceId, this.bankCategory, this.customCategoryId, this.merchantName, this.comment, this.savingsGoalId, this.isWithdrawal, final  List<TransactionSplitDraft>? splits}): _splits = splits;
  

/// Для создания null.
/// Для обновления обязателен.
@override final  String? id;
@override final  String accountId;
@override final  String? linkedAccountId;
@override final  DateTime date;
/// Копейки.
@override final  int amount;
@override final  String? originalCurrency;
@override final  int? originalAmount;
@override final  TransactionType type;
@override final  String? spaceId;
@override final  String? bankCategory;
@override final  String? customCategoryId;
@override final  String? merchantName;
@override final  String? comment;
@override final  String? savingsGoalId;
@override final  bool? isWithdrawal;
 final  List<TransactionSplitDraft>? _splits;
@override List<TransactionSplitDraft>? get splits {
  final value = _splits;
  if (value == null) return null;
  if (_splits is EqualUnmodifiableListView) return _splits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TransactionDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDraftCopyWith<_TransactionDraft> get copyWith => __$TransactionDraftCopyWithImpl<_TransactionDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.linkedAccountId, linkedAccountId) || other.linkedAccountId == linkedAccountId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.type, type) || other.type == type)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.bankCategory, bankCategory) || other.bankCategory == bankCategory)&&(identical(other.customCategoryId, customCategoryId) || other.customCategoryId == customCategoryId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.savingsGoalId, savingsGoalId) || other.savingsGoalId == savingsGoalId)&&(identical(other.isWithdrawal, isWithdrawal) || other.isWithdrawal == isWithdrawal)&&const DeepCollectionEquality().equals(other._splits, _splits));
}


@override
int get hashCode => Object.hash(runtimeType,id,accountId,linkedAccountId,date,amount,originalCurrency,originalAmount,type,spaceId,bankCategory,customCategoryId,merchantName,comment,savingsGoalId,isWithdrawal,const DeepCollectionEquality().hash(_splits));

@override
String toString() {
  return 'TransactionDraft(id: $id, accountId: $accountId, linkedAccountId: $linkedAccountId, date: $date, amount: $amount, originalCurrency: $originalCurrency, originalAmount: $originalAmount, type: $type, spaceId: $spaceId, bankCategory: $bankCategory, customCategoryId: $customCategoryId, merchantName: $merchantName, comment: $comment, savingsGoalId: $savingsGoalId, isWithdrawal: $isWithdrawal, splits: $splits)';
}


}

/// @nodoc
abstract mixin class _$TransactionDraftCopyWith<$Res> implements $TransactionDraftCopyWith<$Res> {
  factory _$TransactionDraftCopyWith(_TransactionDraft value, $Res Function(_TransactionDraft) _then) = __$TransactionDraftCopyWithImpl;
@override @useResult
$Res call({
 String? id, String accountId, String? linkedAccountId, DateTime date, int amount, String? originalCurrency, int? originalAmount, TransactionType type, String? spaceId, String? bankCategory, String? customCategoryId, String? merchantName, String? comment, String? savingsGoalId, bool? isWithdrawal, List<TransactionSplitDraft>? splits
});




}
/// @nodoc
class __$TransactionDraftCopyWithImpl<$Res>
    implements _$TransactionDraftCopyWith<$Res> {
  __$TransactionDraftCopyWithImpl(this._self, this._then);

  final _TransactionDraft _self;
  final $Res Function(_TransactionDraft) _then;

/// Create a copy of TransactionDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? accountId = null,Object? linkedAccountId = freezed,Object? date = null,Object? amount = null,Object? originalCurrency = freezed,Object? originalAmount = freezed,Object? type = null,Object? spaceId = freezed,Object? bankCategory = freezed,Object? customCategoryId = freezed,Object? merchantName = freezed,Object? comment = freezed,Object? savingsGoalId = freezed,Object? isWithdrawal = freezed,Object? splits = freezed,}) {
  return _then(_TransactionDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,linkedAccountId: freezed == linkedAccountId ? _self.linkedAccountId : linkedAccountId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: freezed == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,bankCategory: freezed == bankCategory ? _self.bankCategory : bankCategory // ignore: cast_nullable_to_non_nullable
as String?,customCategoryId: freezed == customCategoryId ? _self.customCategoryId : customCategoryId // ignore: cast_nullable_to_non_nullable
as String?,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,savingsGoalId: freezed == savingsGoalId ? _self.savingsGoalId : savingsGoalId // ignore: cast_nullable_to_non_nullable
as String?,isWithdrawal: freezed == isWithdrawal ? _self.isWithdrawal : isWithdrawal // ignore: cast_nullable_to_non_nullable
as bool?,splits: freezed == splits ? _self._splits : splits // ignore: cast_nullable_to_non_nullable
as List<TransactionSplitDraft>?,
  ));
}


}

/// @nodoc
mixin _$TransactionSplitDraft {

/// Для нового сплита может быть null.
 String? get id; String get categoryId;/// Копейки.
 int get amount; String? get description;/// Для сохранения существующего createdAt при редактировании.
 DateTime? get createdAt;
/// Create a copy of TransactionSplitDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionSplitDraftCopyWith<TransactionSplitDraft> get copyWith => _$TransactionSplitDraftCopyWithImpl<TransactionSplitDraft>(this as TransactionSplitDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSplitDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,amount,description,createdAt);

@override
String toString() {
  return 'TransactionSplitDraft(id: $id, categoryId: $categoryId, amount: $amount, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TransactionSplitDraftCopyWith<$Res>  {
  factory $TransactionSplitDraftCopyWith(TransactionSplitDraft value, $Res Function(TransactionSplitDraft) _then) = _$TransactionSplitDraftCopyWithImpl;
@useResult
$Res call({
 String? id, String categoryId, int amount, String? description, DateTime? createdAt
});




}
/// @nodoc
class _$TransactionSplitDraftCopyWithImpl<$Res>
    implements $TransactionSplitDraftCopyWith<$Res> {
  _$TransactionSplitDraftCopyWithImpl(this._self, this._then);

  final TransactionSplitDraft _self;
  final $Res Function(TransactionSplitDraft) _then;

/// Create a copy of TransactionSplitDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? categoryId = null,Object? amount = null,Object? description = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionSplitDraft].
extension TransactionSplitDraftPatterns on TransactionSplitDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionSplitDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionSplitDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionSplitDraft value)  $default,){
final _that = this;
switch (_that) {
case _TransactionSplitDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionSplitDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionSplitDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionSplitDraft implements TransactionSplitDraft {
  const _TransactionSplitDraft({this.id, required this.categoryId, required this.amount, this.description, this.createdAt});
  

/// Для нового сплита может быть null.
@override final  String? id;
@override final  String categoryId;
/// Копейки.
@override final  int amount;
@override final  String? description;
/// Для сохранения существующего createdAt при редактировании.
@override final  DateTime? createdAt;

/// Create a copy of TransactionSplitDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionSplitDraftCopyWith<_TransactionSplitDraft> get copyWith => __$TransactionSplitDraftCopyWithImpl<_TransactionSplitDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionSplitDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,amount,description,createdAt);

@override
String toString() {
  return 'TransactionSplitDraft(id: $id, categoryId: $categoryId, amount: $amount, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionSplitDraftCopyWith<$Res> implements $TransactionSplitDraftCopyWith<$Res> {
  factory _$TransactionSplitDraftCopyWith(_TransactionSplitDraft value, $Res Function(_TransactionSplitDraft) _then) = __$TransactionSplitDraftCopyWithImpl;
@override @useResult
$Res call({
 String? id, String categoryId, int amount, String? description, DateTime? createdAt
});




}
/// @nodoc
class __$TransactionSplitDraftCopyWithImpl<$Res>
    implements _$TransactionSplitDraftCopyWith<$Res> {
  __$TransactionSplitDraftCopyWithImpl(this._self, this._then);

  final _TransactionSplitDraft _self;
  final $Res Function(_TransactionSplitDraft) _then;

/// Create a copy of TransactionSplitDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? categoryId = null,Object? amount = null,Object? description = freezed,Object? createdAt = freezed,}) {
  return _then(_TransactionSplitDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

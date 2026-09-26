// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_form_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtFormDraft {

/// null при создании, id долга при редактировании.
 String? get debtId;/// 'payable' | 'receivable'.
 String get debtType;/// 'family_member' | 'external'.
 String get counterpartyType;/// user_id выбранных членов семьи (множественный выбор).
 List<String> get selectedMemberIds;/// Имя внешнего контрагента в дательном (как ввёл пользователь).
 String get externalNameDative;/// Копейки.
 int? get amount; String get currency; String? get categoryId; String get description; DateTime? get dueDate; String? get originalTransactionId; String? get splitId;/// Авто-закрытие долга при появлении связанной транзакции.
 bool get autoResolveOnLink; DateTime get updatedAt;
/// Create a copy of DebtFormDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtFormDraftCopyWith<DebtFormDraft> get copyWith => _$DebtFormDraftCopyWithImpl<DebtFormDraft>(this as DebtFormDraft, _$identity);

  /// Serializes this DebtFormDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtFormDraft&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.debtType, debtType) || other.debtType == debtType)&&(identical(other.counterpartyType, counterpartyType) || other.counterpartyType == counterpartyType)&&const DeepCollectionEquality().equals(other.selectedMemberIds, selectedMemberIds)&&(identical(other.externalNameDative, externalNameDative) || other.externalNameDative == externalNameDative)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.originalTransactionId, originalTransactionId) || other.originalTransactionId == originalTransactionId)&&(identical(other.splitId, splitId) || other.splitId == splitId)&&(identical(other.autoResolveOnLink, autoResolveOnLink) || other.autoResolveOnLink == autoResolveOnLink)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,debtId,debtType,counterpartyType,const DeepCollectionEquality().hash(selectedMemberIds),externalNameDative,amount,currency,categoryId,description,dueDate,originalTransactionId,splitId,autoResolveOnLink,updatedAt);

@override
String toString() {
  return 'DebtFormDraft(debtId: $debtId, debtType: $debtType, counterpartyType: $counterpartyType, selectedMemberIds: $selectedMemberIds, externalNameDative: $externalNameDative, amount: $amount, currency: $currency, categoryId: $categoryId, description: $description, dueDate: $dueDate, originalTransactionId: $originalTransactionId, splitId: $splitId, autoResolveOnLink: $autoResolveOnLink, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DebtFormDraftCopyWith<$Res>  {
  factory $DebtFormDraftCopyWith(DebtFormDraft value, $Res Function(DebtFormDraft) _then) = _$DebtFormDraftCopyWithImpl;
@useResult
$Res call({
 String? debtId, String debtType, String counterpartyType, List<String> selectedMemberIds, String externalNameDative, int? amount, String currency, String? categoryId, String description, DateTime? dueDate, String? originalTransactionId, String? splitId, bool autoResolveOnLink, DateTime updatedAt
});




}
/// @nodoc
class _$DebtFormDraftCopyWithImpl<$Res>
    implements $DebtFormDraftCopyWith<$Res> {
  _$DebtFormDraftCopyWithImpl(this._self, this._then);

  final DebtFormDraft _self;
  final $Res Function(DebtFormDraft) _then;

/// Create a copy of DebtFormDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? debtId = freezed,Object? debtType = null,Object? counterpartyType = null,Object? selectedMemberIds = null,Object? externalNameDative = null,Object? amount = freezed,Object? currency = null,Object? categoryId = freezed,Object? description = null,Object? dueDate = freezed,Object? originalTransactionId = freezed,Object? splitId = freezed,Object? autoResolveOnLink = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
debtId: freezed == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String?,debtType: null == debtType ? _self.debtType : debtType // ignore: cast_nullable_to_non_nullable
as String,counterpartyType: null == counterpartyType ? _self.counterpartyType : counterpartyType // ignore: cast_nullable_to_non_nullable
as String,selectedMemberIds: null == selectedMemberIds ? _self.selectedMemberIds : selectedMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,externalNameDative: null == externalNameDative ? _self.externalNameDative : externalNameDative // ignore: cast_nullable_to_non_nullable
as String,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,originalTransactionId: freezed == originalTransactionId ? _self.originalTransactionId : originalTransactionId // ignore: cast_nullable_to_non_nullable
as String?,splitId: freezed == splitId ? _self.splitId : splitId // ignore: cast_nullable_to_non_nullable
as String?,autoResolveOnLink: null == autoResolveOnLink ? _self.autoResolveOnLink : autoResolveOnLink // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtFormDraft].
extension DebtFormDraftPatterns on DebtFormDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtFormDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtFormDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtFormDraft value)  $default,){
final _that = this;
switch (_that) {
case _DebtFormDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtFormDraft value)?  $default,){
final _that = this;
switch (_that) {
case _DebtFormDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtFormDraft implements DebtFormDraft {
  const _DebtFormDraft({this.debtId, this.debtType = 'payable', this.counterpartyType = 'family_member', final  List<String> selectedMemberIds = const <String>[], this.externalNameDative = '', this.amount, this.currency = 'RUB', this.categoryId, this.description = '', this.dueDate, this.originalTransactionId, this.splitId, this.autoResolveOnLink = true, required this.updatedAt}): _selectedMemberIds = selectedMemberIds;
  factory _DebtFormDraft.fromJson(Map<String, dynamic> json) => _$DebtFormDraftFromJson(json);

/// null при создании, id долга при редактировании.
@override final  String? debtId;
/// 'payable' | 'receivable'.
@override@JsonKey() final  String debtType;
/// 'family_member' | 'external'.
@override@JsonKey() final  String counterpartyType;
/// user_id выбранных членов семьи (множественный выбор).
 final  List<String> _selectedMemberIds;
/// user_id выбранных членов семьи (множественный выбор).
@override@JsonKey() List<String> get selectedMemberIds {
  if (_selectedMemberIds is EqualUnmodifiableListView) return _selectedMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedMemberIds);
}

/// Имя внешнего контрагента в дательном (как ввёл пользователь).
@override@JsonKey() final  String externalNameDative;
/// Копейки.
@override final  int? amount;
@override@JsonKey() final  String currency;
@override final  String? categoryId;
@override@JsonKey() final  String description;
@override final  DateTime? dueDate;
@override final  String? originalTransactionId;
@override final  String? splitId;
/// Авто-закрытие долга при появлении связанной транзакции.
@override@JsonKey() final  bool autoResolveOnLink;
@override final  DateTime updatedAt;

/// Create a copy of DebtFormDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtFormDraftCopyWith<_DebtFormDraft> get copyWith => __$DebtFormDraftCopyWithImpl<_DebtFormDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtFormDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtFormDraft&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.debtType, debtType) || other.debtType == debtType)&&(identical(other.counterpartyType, counterpartyType) || other.counterpartyType == counterpartyType)&&const DeepCollectionEquality().equals(other._selectedMemberIds, _selectedMemberIds)&&(identical(other.externalNameDative, externalNameDative) || other.externalNameDative == externalNameDative)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.originalTransactionId, originalTransactionId) || other.originalTransactionId == originalTransactionId)&&(identical(other.splitId, splitId) || other.splitId == splitId)&&(identical(other.autoResolveOnLink, autoResolveOnLink) || other.autoResolveOnLink == autoResolveOnLink)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,debtId,debtType,counterpartyType,const DeepCollectionEquality().hash(_selectedMemberIds),externalNameDative,amount,currency,categoryId,description,dueDate,originalTransactionId,splitId,autoResolveOnLink,updatedAt);

@override
String toString() {
  return 'DebtFormDraft(debtId: $debtId, debtType: $debtType, counterpartyType: $counterpartyType, selectedMemberIds: $selectedMemberIds, externalNameDative: $externalNameDative, amount: $amount, currency: $currency, categoryId: $categoryId, description: $description, dueDate: $dueDate, originalTransactionId: $originalTransactionId, splitId: $splitId, autoResolveOnLink: $autoResolveOnLink, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DebtFormDraftCopyWith<$Res> implements $DebtFormDraftCopyWith<$Res> {
  factory _$DebtFormDraftCopyWith(_DebtFormDraft value, $Res Function(_DebtFormDraft) _then) = __$DebtFormDraftCopyWithImpl;
@override @useResult
$Res call({
 String? debtId, String debtType, String counterpartyType, List<String> selectedMemberIds, String externalNameDative, int? amount, String currency, String? categoryId, String description, DateTime? dueDate, String? originalTransactionId, String? splitId, bool autoResolveOnLink, DateTime updatedAt
});




}
/// @nodoc
class __$DebtFormDraftCopyWithImpl<$Res>
    implements _$DebtFormDraftCopyWith<$Res> {
  __$DebtFormDraftCopyWithImpl(this._self, this._then);

  final _DebtFormDraft _self;
  final $Res Function(_DebtFormDraft) _then;

/// Create a copy of DebtFormDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? debtId = freezed,Object? debtType = null,Object? counterpartyType = null,Object? selectedMemberIds = null,Object? externalNameDative = null,Object? amount = freezed,Object? currency = null,Object? categoryId = freezed,Object? description = null,Object? dueDate = freezed,Object? originalTransactionId = freezed,Object? splitId = freezed,Object? autoResolveOnLink = null,Object? updatedAt = null,}) {
  return _then(_DebtFormDraft(
debtId: freezed == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String?,debtType: null == debtType ? _self.debtType : debtType // ignore: cast_nullable_to_non_nullable
as String,counterpartyType: null == counterpartyType ? _self.counterpartyType : counterpartyType // ignore: cast_nullable_to_non_nullable
as String,selectedMemberIds: null == selectedMemberIds ? _self._selectedMemberIds : selectedMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,externalNameDative: null == externalNameDative ? _self.externalNameDative : externalNameDative // ignore: cast_nullable_to_non_nullable
as String,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,originalTransactionId: freezed == originalTransactionId ? _self.originalTransactionId : originalTransactionId // ignore: cast_nullable_to_non_nullable
as String?,splitId: freezed == splitId ? _self.splitId : splitId // ignore: cast_nullable_to_non_nullable
as String?,autoResolveOnLink: null == autoResolveOnLink ? _self.autoResolveOnLink : autoResolveOnLink // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

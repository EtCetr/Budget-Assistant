// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cashback_matrix_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashbackMatrixCell {

 String get accountId; String get accountName; String get currency; String? get entryId; String? get status; String? get lifetimeType; int? get percentBps; int? get netKopecks; int? get cashbackKopecks;
/// Create a copy of CashbackMatrixCell
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashbackMatrixCellCopyWith<CashbackMatrixCell> get copyWith => _$CashbackMatrixCellCopyWithImpl<CashbackMatrixCell>(this as CashbackMatrixCell, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashbackMatrixCell&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.status, status) || other.status == status)&&(identical(other.lifetimeType, lifetimeType) || other.lifetimeType == lifetimeType)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps)&&(identical(other.netKopecks, netKopecks) || other.netKopecks == netKopecks)&&(identical(other.cashbackKopecks, cashbackKopecks) || other.cashbackKopecks == cashbackKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,accountId,accountName,currency,entryId,status,lifetimeType,percentBps,netKopecks,cashbackKopecks);

@override
String toString() {
  return 'CashbackMatrixCell(accountId: $accountId, accountName: $accountName, currency: $currency, entryId: $entryId, status: $status, lifetimeType: $lifetimeType, percentBps: $percentBps, netKopecks: $netKopecks, cashbackKopecks: $cashbackKopecks)';
}


}

/// @nodoc
abstract mixin class $CashbackMatrixCellCopyWith<$Res>  {
  factory $CashbackMatrixCellCopyWith(CashbackMatrixCell value, $Res Function(CashbackMatrixCell) _then) = _$CashbackMatrixCellCopyWithImpl;
@useResult
$Res call({
 String accountId, String accountName, String currency, String? entryId, String? status, String? lifetimeType, int? percentBps, int? netKopecks, int? cashbackKopecks
});




}
/// @nodoc
class _$CashbackMatrixCellCopyWithImpl<$Res>
    implements $CashbackMatrixCellCopyWith<$Res> {
  _$CashbackMatrixCellCopyWithImpl(this._self, this._then);

  final CashbackMatrixCell _self;
  final $Res Function(CashbackMatrixCell) _then;

/// Create a copy of CashbackMatrixCell
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? accountName = null,Object? currency = null,Object? entryId = freezed,Object? status = freezed,Object? lifetimeType = freezed,Object? percentBps = freezed,Object? netKopecks = freezed,Object? cashbackKopecks = freezed,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,lifetimeType: freezed == lifetimeType ? _self.lifetimeType : lifetimeType // ignore: cast_nullable_to_non_nullable
as String?,percentBps: freezed == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int?,netKopecks: freezed == netKopecks ? _self.netKopecks : netKopecks // ignore: cast_nullable_to_non_nullable
as int?,cashbackKopecks: freezed == cashbackKopecks ? _self.cashbackKopecks : cashbackKopecks // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashbackMatrixCell].
extension CashbackMatrixCellPatterns on CashbackMatrixCell {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashbackMatrixCell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashbackMatrixCell() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashbackMatrixCell value)  $default,){
final _that = this;
switch (_that) {
case _CashbackMatrixCell():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashbackMatrixCell value)?  $default,){
final _that = this;
switch (_that) {
case _CashbackMatrixCell() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CashbackMatrixCell implements CashbackMatrixCell {
  const _CashbackMatrixCell({required this.accountId, required this.accountName, required this.currency, this.entryId, this.status, this.lifetimeType, this.percentBps, this.netKopecks, this.cashbackKopecks});
  

@override final  String accountId;
@override final  String accountName;
@override final  String currency;
@override final  String? entryId;
@override final  String? status;
@override final  String? lifetimeType;
@override final  int? percentBps;
@override final  int? netKopecks;
@override final  int? cashbackKopecks;

/// Create a copy of CashbackMatrixCell
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashbackMatrixCellCopyWith<_CashbackMatrixCell> get copyWith => __$CashbackMatrixCellCopyWithImpl<_CashbackMatrixCell>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashbackMatrixCell&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.status, status) || other.status == status)&&(identical(other.lifetimeType, lifetimeType) || other.lifetimeType == lifetimeType)&&(identical(other.percentBps, percentBps) || other.percentBps == percentBps)&&(identical(other.netKopecks, netKopecks) || other.netKopecks == netKopecks)&&(identical(other.cashbackKopecks, cashbackKopecks) || other.cashbackKopecks == cashbackKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,accountId,accountName,currency,entryId,status,lifetimeType,percentBps,netKopecks,cashbackKopecks);

@override
String toString() {
  return 'CashbackMatrixCell(accountId: $accountId, accountName: $accountName, currency: $currency, entryId: $entryId, status: $status, lifetimeType: $lifetimeType, percentBps: $percentBps, netKopecks: $netKopecks, cashbackKopecks: $cashbackKopecks)';
}


}

/// @nodoc
abstract mixin class _$CashbackMatrixCellCopyWith<$Res> implements $CashbackMatrixCellCopyWith<$Res> {
  factory _$CashbackMatrixCellCopyWith(_CashbackMatrixCell value, $Res Function(_CashbackMatrixCell) _then) = __$CashbackMatrixCellCopyWithImpl;
@override @useResult
$Res call({
 String accountId, String accountName, String currency, String? entryId, String? status, String? lifetimeType, int? percentBps, int? netKopecks, int? cashbackKopecks
});




}
/// @nodoc
class __$CashbackMatrixCellCopyWithImpl<$Res>
    implements _$CashbackMatrixCellCopyWith<$Res> {
  __$CashbackMatrixCellCopyWithImpl(this._self, this._then);

  final _CashbackMatrixCell _self;
  final $Res Function(_CashbackMatrixCell) _then;

/// Create a copy of CashbackMatrixCell
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? accountName = null,Object? currency = null,Object? entryId = freezed,Object? status = freezed,Object? lifetimeType = freezed,Object? percentBps = freezed,Object? netKopecks = freezed,Object? cashbackKopecks = freezed,}) {
  return _then(_CashbackMatrixCell(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,lifetimeType: freezed == lifetimeType ? _self.lifetimeType : lifetimeType // ignore: cast_nullable_to_non_nullable
as String?,percentBps: freezed == percentBps ? _self.percentBps : percentBps // ignore: cast_nullable_to_non_nullable
as int?,netKopecks: freezed == netKopecks ? _self.netKopecks : netKopecks // ignore: cast_nullable_to_non_nullable
as int?,cashbackKopecks: freezed == cashbackKopecks ? _self.cashbackKopecks : cashbackKopecks // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$CashbackMatrixRow {

 String get categoryId; String get categoryName; List<CashbackMatrixCell> get cells; String? get bestAccountId; int get bestPercentBps;
/// Create a copy of CashbackMatrixRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashbackMatrixRowCopyWith<CashbackMatrixRow> get copyWith => _$CashbackMatrixRowCopyWithImpl<CashbackMatrixRow>(this as CashbackMatrixRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashbackMatrixRow&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other.cells, cells)&&(identical(other.bestAccountId, bestAccountId) || other.bestAccountId == bestAccountId)&&(identical(other.bestPercentBps, bestPercentBps) || other.bestPercentBps == bestPercentBps));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,const DeepCollectionEquality().hash(cells),bestAccountId,bestPercentBps);

@override
String toString() {
  return 'CashbackMatrixRow(categoryId: $categoryId, categoryName: $categoryName, cells: $cells, bestAccountId: $bestAccountId, bestPercentBps: $bestPercentBps)';
}


}

/// @nodoc
abstract mixin class $CashbackMatrixRowCopyWith<$Res>  {
  factory $CashbackMatrixRowCopyWith(CashbackMatrixRow value, $Res Function(CashbackMatrixRow) _then) = _$CashbackMatrixRowCopyWithImpl;
@useResult
$Res call({
 String categoryId, String categoryName, List<CashbackMatrixCell> cells, String? bestAccountId, int bestPercentBps
});




}
/// @nodoc
class _$CashbackMatrixRowCopyWithImpl<$Res>
    implements $CashbackMatrixRowCopyWith<$Res> {
  _$CashbackMatrixRowCopyWithImpl(this._self, this._then);

  final CashbackMatrixRow _self;
  final $Res Function(CashbackMatrixRow) _then;

/// Create a copy of CashbackMatrixRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryName = null,Object? cells = null,Object? bestAccountId = freezed,Object? bestPercentBps = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<CashbackMatrixCell>,bestAccountId: freezed == bestAccountId ? _self.bestAccountId : bestAccountId // ignore: cast_nullable_to_non_nullable
as String?,bestPercentBps: null == bestPercentBps ? _self.bestPercentBps : bestPercentBps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CashbackMatrixRow].
extension CashbackMatrixRowPatterns on CashbackMatrixRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashbackMatrixRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashbackMatrixRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashbackMatrixRow value)  $default,){
final _that = this;
switch (_that) {
case _CashbackMatrixRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashbackMatrixRow value)?  $default,){
final _that = this;
switch (_that) {
case _CashbackMatrixRow() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CashbackMatrixRow implements CashbackMatrixRow {
  const _CashbackMatrixRow({required this.categoryId, required this.categoryName, required final  List<CashbackMatrixCell> cells, required this.bestAccountId, required this.bestPercentBps}): _cells = cells;
  

@override final  String categoryId;
@override final  String categoryName;
 final  List<CashbackMatrixCell> _cells;
@override List<CashbackMatrixCell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}

@override final  String? bestAccountId;
@override final  int bestPercentBps;

/// Create a copy of CashbackMatrixRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashbackMatrixRowCopyWith<_CashbackMatrixRow> get copyWith => __$CashbackMatrixRowCopyWithImpl<_CashbackMatrixRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashbackMatrixRow&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other._cells, _cells)&&(identical(other.bestAccountId, bestAccountId) || other.bestAccountId == bestAccountId)&&(identical(other.bestPercentBps, bestPercentBps) || other.bestPercentBps == bestPercentBps));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,const DeepCollectionEquality().hash(_cells),bestAccountId,bestPercentBps);

@override
String toString() {
  return 'CashbackMatrixRow(categoryId: $categoryId, categoryName: $categoryName, cells: $cells, bestAccountId: $bestAccountId, bestPercentBps: $bestPercentBps)';
}


}

/// @nodoc
abstract mixin class _$CashbackMatrixRowCopyWith<$Res> implements $CashbackMatrixRowCopyWith<$Res> {
  factory _$CashbackMatrixRowCopyWith(_CashbackMatrixRow value, $Res Function(_CashbackMatrixRow) _then) = __$CashbackMatrixRowCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String categoryName, List<CashbackMatrixCell> cells, String? bestAccountId, int bestPercentBps
});




}
/// @nodoc
class __$CashbackMatrixRowCopyWithImpl<$Res>
    implements _$CashbackMatrixRowCopyWith<$Res> {
  __$CashbackMatrixRowCopyWithImpl(this._self, this._then);

  final _CashbackMatrixRow _self;
  final $Res Function(_CashbackMatrixRow) _then;

/// Create a copy of CashbackMatrixRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,Object? cells = null,Object? bestAccountId = freezed,Object? bestPercentBps = null,}) {
  return _then(_CashbackMatrixRow(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<CashbackMatrixCell>,bestAccountId: freezed == bestAccountId ? _self.bestAccountId : bestAccountId // ignore: cast_nullable_to_non_nullable
as String?,bestPercentBps: null == bestPercentBps ? _self.bestPercentBps : bestPercentBps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

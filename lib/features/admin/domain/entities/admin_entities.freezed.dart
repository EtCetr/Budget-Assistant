// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemberInfo {

 String get id; String get spaceId; String get userId; String get displayName; String? get email; MemberRole get role; MemberStatus get status; DateTime get joinedAt; DateTime? get lastActiveAt; int get openDebtsCount; int get openDebtsAmountKopecks; int get tx30d;
/// Create a copy of MemberInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberInfoCopyWith<MemberInfo> get copyWith => _$MemberInfoCopyWithImpl<MemberInfo>(this as MemberInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.openDebtsCount, openDebtsCount) || other.openDebtsCount == openDebtsCount)&&(identical(other.openDebtsAmountKopecks, openDebtsAmountKopecks) || other.openDebtsAmountKopecks == openDebtsAmountKopecks)&&(identical(other.tx30d, tx30d) || other.tx30d == tx30d));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,displayName,email,role,status,joinedAt,lastActiveAt,openDebtsCount,openDebtsAmountKopecks,tx30d);

@override
String toString() {
  return 'MemberInfo(id: $id, spaceId: $spaceId, userId: $userId, displayName: $displayName, email: $email, role: $role, status: $status, joinedAt: $joinedAt, lastActiveAt: $lastActiveAt, openDebtsCount: $openDebtsCount, openDebtsAmountKopecks: $openDebtsAmountKopecks, tx30d: $tx30d)';
}


}

/// @nodoc
abstract mixin class $MemberInfoCopyWith<$Res>  {
  factory $MemberInfoCopyWith(MemberInfo value, $Res Function(MemberInfo) _then) = _$MemberInfoCopyWithImpl;
@useResult
$Res call({
 String id, String spaceId, String userId, String displayName, String? email, MemberRole role, MemberStatus status, DateTime joinedAt, DateTime? lastActiveAt, int openDebtsCount, int openDebtsAmountKopecks, int tx30d
});




}
/// @nodoc
class _$MemberInfoCopyWithImpl<$Res>
    implements $MemberInfoCopyWith<$Res> {
  _$MemberInfoCopyWithImpl(this._self, this._then);

  final MemberInfo _self;
  final $Res Function(MemberInfo) _then;

/// Create a copy of MemberInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? userId = null,Object? displayName = null,Object? email = freezed,Object? role = null,Object? status = null,Object? joinedAt = null,Object? lastActiveAt = freezed,Object? openDebtsCount = null,Object? openDebtsAmountKopecks = null,Object? tx30d = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,openDebtsCount: null == openDebtsCount ? _self.openDebtsCount : openDebtsCount // ignore: cast_nullable_to_non_nullable
as int,openDebtsAmountKopecks: null == openDebtsAmountKopecks ? _self.openDebtsAmountKopecks : openDebtsAmountKopecks // ignore: cast_nullable_to_non_nullable
as int,tx30d: null == tx30d ? _self.tx30d : tx30d // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberInfo].
extension MemberInfoPatterns on MemberInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberInfo value)  $default,){
final _that = this;
switch (_that) {
case _MemberInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MemberInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _MemberInfo implements MemberInfo {
  const _MemberInfo({required this.id, required this.spaceId, required this.userId, required this.displayName, this.email, required this.role, required this.status, required this.joinedAt, this.lastActiveAt, required this.openDebtsCount, required this.openDebtsAmountKopecks, required this.tx30d});
  

@override final  String id;
@override final  String spaceId;
@override final  String userId;
@override final  String displayName;
@override final  String? email;
@override final  MemberRole role;
@override final  MemberStatus status;
@override final  DateTime joinedAt;
@override final  DateTime? lastActiveAt;
@override final  int openDebtsCount;
@override final  int openDebtsAmountKopecks;
@override final  int tx30d;

/// Create a copy of MemberInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberInfoCopyWith<_MemberInfo> get copyWith => __$MemberInfoCopyWithImpl<_MemberInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.openDebtsCount, openDebtsCount) || other.openDebtsCount == openDebtsCount)&&(identical(other.openDebtsAmountKopecks, openDebtsAmountKopecks) || other.openDebtsAmountKopecks == openDebtsAmountKopecks)&&(identical(other.tx30d, tx30d) || other.tx30d == tx30d));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,displayName,email,role,status,joinedAt,lastActiveAt,openDebtsCount,openDebtsAmountKopecks,tx30d);

@override
String toString() {
  return 'MemberInfo(id: $id, spaceId: $spaceId, userId: $userId, displayName: $displayName, email: $email, role: $role, status: $status, joinedAt: $joinedAt, lastActiveAt: $lastActiveAt, openDebtsCount: $openDebtsCount, openDebtsAmountKopecks: $openDebtsAmountKopecks, tx30d: $tx30d)';
}


}

/// @nodoc
abstract mixin class _$MemberInfoCopyWith<$Res> implements $MemberInfoCopyWith<$Res> {
  factory _$MemberInfoCopyWith(_MemberInfo value, $Res Function(_MemberInfo) _then) = __$MemberInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String spaceId, String userId, String displayName, String? email, MemberRole role, MemberStatus status, DateTime joinedAt, DateTime? lastActiveAt, int openDebtsCount, int openDebtsAmountKopecks, int tx30d
});




}
/// @nodoc
class __$MemberInfoCopyWithImpl<$Res>
    implements _$MemberInfoCopyWith<$Res> {
  __$MemberInfoCopyWithImpl(this._self, this._then);

  final _MemberInfo _self;
  final $Res Function(_MemberInfo) _then;

/// Create a copy of MemberInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? userId = null,Object? displayName = null,Object? email = freezed,Object? role = null,Object? status = null,Object? joinedAt = null,Object? lastActiveAt = freezed,Object? openDebtsCount = null,Object? openDebtsAmountKopecks = null,Object? tx30d = null,}) {
  return _then(_MemberInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,openDebtsCount: null == openDebtsCount ? _self.openDebtsCount : openDebtsCount // ignore: cast_nullable_to_non_nullable
as int,openDebtsAmountKopecks: null == openDebtsAmountKopecks ? _self.openDebtsAmountKopecks : openDebtsAmountKopecks // ignore: cast_nullable_to_non_nullable
as int,tx30d: null == tx30d ? _self.tx30d : tx30d // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MemberStats {

 int get total; int get admins; int get suspended; int get inactive30d; int get pendingInvites;
/// Create a copy of MemberStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberStatsCopyWith<MemberStats> get copyWith => _$MemberStatsCopyWithImpl<MemberStats>(this as MemberStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberStats&&(identical(other.total, total) || other.total == total)&&(identical(other.admins, admins) || other.admins == admins)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.inactive30d, inactive30d) || other.inactive30d == inactive30d)&&(identical(other.pendingInvites, pendingInvites) || other.pendingInvites == pendingInvites));
}


@override
int get hashCode => Object.hash(runtimeType,total,admins,suspended,inactive30d,pendingInvites);

@override
String toString() {
  return 'MemberStats(total: $total, admins: $admins, suspended: $suspended, inactive30d: $inactive30d, pendingInvites: $pendingInvites)';
}


}

/// @nodoc
abstract mixin class $MemberStatsCopyWith<$Res>  {
  factory $MemberStatsCopyWith(MemberStats value, $Res Function(MemberStats) _then) = _$MemberStatsCopyWithImpl;
@useResult
$Res call({
 int total, int admins, int suspended, int inactive30d, int pendingInvites
});




}
/// @nodoc
class _$MemberStatsCopyWithImpl<$Res>
    implements $MemberStatsCopyWith<$Res> {
  _$MemberStatsCopyWithImpl(this._self, this._then);

  final MemberStats _self;
  final $Res Function(MemberStats) _then;

/// Create a copy of MemberStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? admins = null,Object? suspended = null,Object? inactive30d = null,Object? pendingInvites = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,admins: null == admins ? _self.admins : admins // ignore: cast_nullable_to_non_nullable
as int,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as int,inactive30d: null == inactive30d ? _self.inactive30d : inactive30d // ignore: cast_nullable_to_non_nullable
as int,pendingInvites: null == pendingInvites ? _self.pendingInvites : pendingInvites // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberStats].
extension MemberStatsPatterns on MemberStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberStats value)  $default,){
final _that = this;
switch (_that) {
case _MemberStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberStats value)?  $default,){
final _that = this;
switch (_that) {
case _MemberStats() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _MemberStats implements MemberStats {
  const _MemberStats({required this.total, required this.admins, required this.suspended, required this.inactive30d, required this.pendingInvites});
  

@override final  int total;
@override final  int admins;
@override final  int suspended;
@override final  int inactive30d;
@override final  int pendingInvites;

/// Create a copy of MemberStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberStatsCopyWith<_MemberStats> get copyWith => __$MemberStatsCopyWithImpl<_MemberStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberStats&&(identical(other.total, total) || other.total == total)&&(identical(other.admins, admins) || other.admins == admins)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.inactive30d, inactive30d) || other.inactive30d == inactive30d)&&(identical(other.pendingInvites, pendingInvites) || other.pendingInvites == pendingInvites));
}


@override
int get hashCode => Object.hash(runtimeType,total,admins,suspended,inactive30d,pendingInvites);

@override
String toString() {
  return 'MemberStats(total: $total, admins: $admins, suspended: $suspended, inactive30d: $inactive30d, pendingInvites: $pendingInvites)';
}


}

/// @nodoc
abstract mixin class _$MemberStatsCopyWith<$Res> implements $MemberStatsCopyWith<$Res> {
  factory _$MemberStatsCopyWith(_MemberStats value, $Res Function(_MemberStats) _then) = __$MemberStatsCopyWithImpl;
@override @useResult
$Res call({
 int total, int admins, int suspended, int inactive30d, int pendingInvites
});




}
/// @nodoc
class __$MemberStatsCopyWithImpl<$Res>
    implements _$MemberStatsCopyWith<$Res> {
  __$MemberStatsCopyWithImpl(this._self, this._then);

  final _MemberStats _self;
  final $Res Function(_MemberStats) _then;

/// Create a copy of MemberStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? admins = null,Object? suspended = null,Object? inactive30d = null,Object? pendingInvites = null,}) {
  return _then(_MemberStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,admins: null == admins ? _self.admins : admins // ignore: cast_nullable_to_non_nullable
as int,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as int,inactive30d: null == inactive30d ? _self.inactive30d : inactive30d // ignore: cast_nullable_to_non_nullable
as int,pendingInvites: null == pendingInvites ? _self.pendingInvites : pendingInvites // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ActivityStats {

 int get tx7d; int get tx30d; DateTime? get lastTxAt; int get monthExpenseKopecks; int get monthIncomeKopecks;
/// Create a copy of ActivityStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityStatsCopyWith<ActivityStats> get copyWith => _$ActivityStatsCopyWithImpl<ActivityStats>(this as ActivityStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityStats&&(identical(other.tx7d, tx7d) || other.tx7d == tx7d)&&(identical(other.tx30d, tx30d) || other.tx30d == tx30d)&&(identical(other.lastTxAt, lastTxAt) || other.lastTxAt == lastTxAt)&&(identical(other.monthExpenseKopecks, monthExpenseKopecks) || other.monthExpenseKopecks == monthExpenseKopecks)&&(identical(other.monthIncomeKopecks, monthIncomeKopecks) || other.monthIncomeKopecks == monthIncomeKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,tx7d,tx30d,lastTxAt,monthExpenseKopecks,monthIncomeKopecks);

@override
String toString() {
  return 'ActivityStats(tx7d: $tx7d, tx30d: $tx30d, lastTxAt: $lastTxAt, monthExpenseKopecks: $monthExpenseKopecks, monthIncomeKopecks: $monthIncomeKopecks)';
}


}

/// @nodoc
abstract mixin class $ActivityStatsCopyWith<$Res>  {
  factory $ActivityStatsCopyWith(ActivityStats value, $Res Function(ActivityStats) _then) = _$ActivityStatsCopyWithImpl;
@useResult
$Res call({
 int tx7d, int tx30d, DateTime? lastTxAt, int monthExpenseKopecks, int monthIncomeKopecks
});




}
/// @nodoc
class _$ActivityStatsCopyWithImpl<$Res>
    implements $ActivityStatsCopyWith<$Res> {
  _$ActivityStatsCopyWithImpl(this._self, this._then);

  final ActivityStats _self;
  final $Res Function(ActivityStats) _then;

/// Create a copy of ActivityStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tx7d = null,Object? tx30d = null,Object? lastTxAt = freezed,Object? monthExpenseKopecks = null,Object? monthIncomeKopecks = null,}) {
  return _then(_self.copyWith(
tx7d: null == tx7d ? _self.tx7d : tx7d // ignore: cast_nullable_to_non_nullable
as int,tx30d: null == tx30d ? _self.tx30d : tx30d // ignore: cast_nullable_to_non_nullable
as int,lastTxAt: freezed == lastTxAt ? _self.lastTxAt : lastTxAt // ignore: cast_nullable_to_non_nullable
as DateTime?,monthExpenseKopecks: null == monthExpenseKopecks ? _self.monthExpenseKopecks : monthExpenseKopecks // ignore: cast_nullable_to_non_nullable
as int,monthIncomeKopecks: null == monthIncomeKopecks ? _self.monthIncomeKopecks : monthIncomeKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityStats].
extension ActivityStatsPatterns on ActivityStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityStats value)  $default,){
final _that = this;
switch (_that) {
case _ActivityStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityStats value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityStats() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityStats implements ActivityStats {
  const _ActivityStats({required this.tx7d, required this.tx30d, this.lastTxAt, required this.monthExpenseKopecks, required this.monthIncomeKopecks});
  

@override final  int tx7d;
@override final  int tx30d;
@override final  DateTime? lastTxAt;
@override final  int monthExpenseKopecks;
@override final  int monthIncomeKopecks;

/// Create a copy of ActivityStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityStatsCopyWith<_ActivityStats> get copyWith => __$ActivityStatsCopyWithImpl<_ActivityStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityStats&&(identical(other.tx7d, tx7d) || other.tx7d == tx7d)&&(identical(other.tx30d, tx30d) || other.tx30d == tx30d)&&(identical(other.lastTxAt, lastTxAt) || other.lastTxAt == lastTxAt)&&(identical(other.monthExpenseKopecks, monthExpenseKopecks) || other.monthExpenseKopecks == monthExpenseKopecks)&&(identical(other.monthIncomeKopecks, monthIncomeKopecks) || other.monthIncomeKopecks == monthIncomeKopecks));
}


@override
int get hashCode => Object.hash(runtimeType,tx7d,tx30d,lastTxAt,monthExpenseKopecks,monthIncomeKopecks);

@override
String toString() {
  return 'ActivityStats(tx7d: $tx7d, tx30d: $tx30d, lastTxAt: $lastTxAt, monthExpenseKopecks: $monthExpenseKopecks, monthIncomeKopecks: $monthIncomeKopecks)';
}


}

/// @nodoc
abstract mixin class _$ActivityStatsCopyWith<$Res> implements $ActivityStatsCopyWith<$Res> {
  factory _$ActivityStatsCopyWith(_ActivityStats value, $Res Function(_ActivityStats) _then) = __$ActivityStatsCopyWithImpl;
@override @useResult
$Res call({
 int tx7d, int tx30d, DateTime? lastTxAt, int monthExpenseKopecks, int monthIncomeKopecks
});




}
/// @nodoc
class __$ActivityStatsCopyWithImpl<$Res>
    implements _$ActivityStatsCopyWith<$Res> {
  __$ActivityStatsCopyWithImpl(this._self, this._then);

  final _ActivityStats _self;
  final $Res Function(_ActivityStats) _then;

/// Create a copy of ActivityStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tx7d = null,Object? tx30d = null,Object? lastTxAt = freezed,Object? monthExpenseKopecks = null,Object? monthIncomeKopecks = null,}) {
  return _then(_ActivityStats(
tx7d: null == tx7d ? _self.tx7d : tx7d // ignore: cast_nullable_to_non_nullable
as int,tx30d: null == tx30d ? _self.tx30d : tx30d // ignore: cast_nullable_to_non_nullable
as int,lastTxAt: freezed == lastTxAt ? _self.lastTxAt : lastTxAt // ignore: cast_nullable_to_non_nullable
as DateTime?,monthExpenseKopecks: null == monthExpenseKopecks ? _self.monthExpenseKopecks : monthExpenseKopecks // ignore: cast_nullable_to_non_nullable
as int,monthIncomeKopecks: null == monthIncomeKopecks ? _self.monthIncomeKopecks : monthIncomeKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SpaceInfo {

 String get id; String get name; DateTime get createdAt; int get membersCount;
/// Create a copy of SpaceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceInfoCopyWith<SpaceInfo> get copyWith => _$SpaceInfoCopyWithImpl<SpaceInfo>(this as SpaceInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,membersCount);

@override
String toString() {
  return 'SpaceInfo(id: $id, name: $name, createdAt: $createdAt, membersCount: $membersCount)';
}


}

/// @nodoc
abstract mixin class $SpaceInfoCopyWith<$Res>  {
  factory $SpaceInfoCopyWith(SpaceInfo value, $Res Function(SpaceInfo) _then) = _$SpaceInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime createdAt, int membersCount
});




}
/// @nodoc
class _$SpaceInfoCopyWithImpl<$Res>
    implements $SpaceInfoCopyWith<$Res> {
  _$SpaceInfoCopyWithImpl(this._self, this._then);

  final SpaceInfo _self;
  final $Res Function(SpaceInfo) _then;

/// Create a copy of SpaceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? membersCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,membersCount: null == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceInfo].
extension SpaceInfoPatterns on SpaceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceInfo value)  $default,){
final _that = this;
switch (_that) {
case _SpaceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _SpaceInfo implements SpaceInfo {
  const _SpaceInfo({required this.id, required this.name, required this.createdAt, required this.membersCount});
  

@override final  String id;
@override final  String name;
@override final  DateTime createdAt;
@override final  int membersCount;

/// Create a copy of SpaceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceInfoCopyWith<_SpaceInfo> get copyWith => __$SpaceInfoCopyWithImpl<_SpaceInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,membersCount);

@override
String toString() {
  return 'SpaceInfo(id: $id, name: $name, createdAt: $createdAt, membersCount: $membersCount)';
}


}

/// @nodoc
abstract mixin class _$SpaceInfoCopyWith<$Res> implements $SpaceInfoCopyWith<$Res> {
  factory _$SpaceInfoCopyWith(_SpaceInfo value, $Res Function(_SpaceInfo) _then) = __$SpaceInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime createdAt, int membersCount
});




}
/// @nodoc
class __$SpaceInfoCopyWithImpl<$Res>
    implements _$SpaceInfoCopyWith<$Res> {
  __$SpaceInfoCopyWithImpl(this._self, this._then);

  final _SpaceInfo _self;
  final $Res Function(_SpaceInfo) _then;

/// Create a copy of SpaceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? membersCount = null,}) {
  return _then(_SpaceInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,membersCount: null == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CriticalAlert {

 CriticalAlertType get type; String get message; int get affectedCount;
/// Create a copy of CriticalAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CriticalAlertCopyWith<CriticalAlert> get copyWith => _$CriticalAlertCopyWithImpl<CriticalAlert>(this as CriticalAlert, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CriticalAlert&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.affectedCount, affectedCount) || other.affectedCount == affectedCount));
}


@override
int get hashCode => Object.hash(runtimeType,type,message,affectedCount);

@override
String toString() {
  return 'CriticalAlert(type: $type, message: $message, affectedCount: $affectedCount)';
}


}

/// @nodoc
abstract mixin class $CriticalAlertCopyWith<$Res>  {
  factory $CriticalAlertCopyWith(CriticalAlert value, $Res Function(CriticalAlert) _then) = _$CriticalAlertCopyWithImpl;
@useResult
$Res call({
 CriticalAlertType type, String message, int affectedCount
});




}
/// @nodoc
class _$CriticalAlertCopyWithImpl<$Res>
    implements $CriticalAlertCopyWith<$Res> {
  _$CriticalAlertCopyWithImpl(this._self, this._then);

  final CriticalAlert _self;
  final $Res Function(CriticalAlert) _then;

/// Create a copy of CriticalAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? message = null,Object? affectedCount = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CriticalAlertType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,affectedCount: null == affectedCount ? _self.affectedCount : affectedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CriticalAlert].
extension CriticalAlertPatterns on CriticalAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CriticalAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CriticalAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CriticalAlert value)  $default,){
final _that = this;
switch (_that) {
case _CriticalAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CriticalAlert value)?  $default,){
final _that = this;
switch (_that) {
case _CriticalAlert() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _CriticalAlert implements CriticalAlert {
  const _CriticalAlert({required this.type, required this.message, required this.affectedCount});
  

@override final  CriticalAlertType type;
@override final  String message;
@override final  int affectedCount;

/// Create a copy of CriticalAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CriticalAlertCopyWith<_CriticalAlert> get copyWith => __$CriticalAlertCopyWithImpl<_CriticalAlert>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CriticalAlert&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.affectedCount, affectedCount) || other.affectedCount == affectedCount));
}


@override
int get hashCode => Object.hash(runtimeType,type,message,affectedCount);

@override
String toString() {
  return 'CriticalAlert(type: $type, message: $message, affectedCount: $affectedCount)';
}


}

/// @nodoc
abstract mixin class _$CriticalAlertCopyWith<$Res> implements $CriticalAlertCopyWith<$Res> {
  factory _$CriticalAlertCopyWith(_CriticalAlert value, $Res Function(_CriticalAlert) _then) = __$CriticalAlertCopyWithImpl;
@override @useResult
$Res call({
 CriticalAlertType type, String message, int affectedCount
});




}
/// @nodoc
class __$CriticalAlertCopyWithImpl<$Res>
    implements _$CriticalAlertCopyWith<$Res> {
  __$CriticalAlertCopyWithImpl(this._self, this._then);

  final _CriticalAlert _self;
  final $Res Function(_CriticalAlert) _then;

/// Create a copy of CriticalAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? message = null,Object? affectedCount = null,}) {
  return _then(_CriticalAlert(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CriticalAlertType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,affectedCount: null == affectedCount ? _self.affectedCount : affectedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$InvitationInfo {

 String get id; String get spaceId; MemberRole get role; String get status; DateTime get expiresAt; DateTime get createdAt; String get deepLink;
/// Create a copy of InvitationInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationInfoCopyWith<InvitationInfo> get copyWith => _$InvitationInfoCopyWithImpl<InvitationInfo>(this as InvitationInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitationInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,role,status,expiresAt,createdAt,deepLink);

@override
String toString() {
  return 'InvitationInfo(id: $id, spaceId: $spaceId, role: $role, status: $status, expiresAt: $expiresAt, createdAt: $createdAt, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $InvitationInfoCopyWith<$Res>  {
  factory $InvitationInfoCopyWith(InvitationInfo value, $Res Function(InvitationInfo) _then) = _$InvitationInfoCopyWithImpl;
@useResult
$Res call({
 String id, String spaceId, MemberRole role, String status, DateTime expiresAt, DateTime createdAt, String deepLink
});




}
/// @nodoc
class _$InvitationInfoCopyWithImpl<$Res>
    implements $InvitationInfoCopyWith<$Res> {
  _$InvitationInfoCopyWithImpl(this._self, this._then);

  final InvitationInfo _self;
  final $Res Function(InvitationInfo) _then;

/// Create a copy of InvitationInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? role = null,Object? status = null,Object? expiresAt = null,Object? createdAt = null,Object? deepLink = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitationInfo].
extension InvitationInfoPatterns on InvitationInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitationInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitationInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitationInfo value)  $default,){
final _that = this;
switch (_that) {
case _InvitationInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitationInfo value)?  $default,){
final _that = this;
switch (_that) {
case _InvitationInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _InvitationInfo implements InvitationInfo {
  const _InvitationInfo({required this.id, required this.spaceId, required this.role, required this.status, required this.expiresAt, required this.createdAt, required this.deepLink});
  

@override final  String id;
@override final  String spaceId;
@override final  MemberRole role;
@override final  String status;
@override final  DateTime expiresAt;
@override final  DateTime createdAt;
@override final  String deepLink;

/// Create a copy of InvitationInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationInfoCopyWith<_InvitationInfo> get copyWith => __$InvitationInfoCopyWithImpl<_InvitationInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitationInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,role,status,expiresAt,createdAt,deepLink);

@override
String toString() {
  return 'InvitationInfo(id: $id, spaceId: $spaceId, role: $role, status: $status, expiresAt: $expiresAt, createdAt: $createdAt, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$InvitationInfoCopyWith<$Res> implements $InvitationInfoCopyWith<$Res> {
  factory _$InvitationInfoCopyWith(_InvitationInfo value, $Res Function(_InvitationInfo) _then) = __$InvitationInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String spaceId, MemberRole role, String status, DateTime expiresAt, DateTime createdAt, String deepLink
});




}
/// @nodoc
class __$InvitationInfoCopyWithImpl<$Res>
    implements _$InvitationInfoCopyWith<$Res> {
  __$InvitationInfoCopyWithImpl(this._self, this._then);

  final _InvitationInfo _self;
  final $Res Function(_InvitationInfo) _then;

/// Create a copy of InvitationInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? role = null,Object? status = null,Object? expiresAt = null,Object? createdAt = null,Object? deepLink = null,}) {
  return _then(_InvitationInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AuditEntry {

 String get id; AuditAction get action; String get actorUserId; String? get targetId; String get metadataJson; DateTime get createdAt; String get syncStatus;
/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryCopyWith<AuditEntry> get copyWith => _$AuditEntryCopyWithImpl<AuditEntry>(this as AuditEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.metadataJson, metadataJson) || other.metadataJson == metadataJson)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,action,actorUserId,targetId,metadataJson,createdAt,syncStatus);

@override
String toString() {
  return 'AuditEntry(id: $id, action: $action, actorUserId: $actorUserId, targetId: $targetId, metadataJson: $metadataJson, createdAt: $createdAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $AuditEntryCopyWith<$Res>  {
  factory $AuditEntryCopyWith(AuditEntry value, $Res Function(AuditEntry) _then) = _$AuditEntryCopyWithImpl;
@useResult
$Res call({
 String id, AuditAction action, String actorUserId, String? targetId, String metadataJson, DateTime createdAt, String syncStatus
});




}
/// @nodoc
class _$AuditEntryCopyWithImpl<$Res>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._self, this._then);

  final AuditEntry _self;
  final $Res Function(AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? action = null,Object? actorUserId = null,Object? targetId = freezed,Object? metadataJson = null,Object? createdAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,actorUserId: null == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,metadataJson: null == metadataJson ? _self.metadataJson : metadataJson // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntry].
extension AuditEntryPatterns on AuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _AuditEntry implements AuditEntry {
  const _AuditEntry({required this.id, required this.action, required this.actorUserId, this.targetId, required this.metadataJson, required this.createdAt, required this.syncStatus});
  

@override final  String id;
@override final  AuditAction action;
@override final  String actorUserId;
@override final  String? targetId;
@override final  String metadataJson;
@override final  DateTime createdAt;
@override final  String syncStatus;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryCopyWith<_AuditEntry> get copyWith => __$AuditEntryCopyWithImpl<_AuditEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.metadataJson, metadataJson) || other.metadataJson == metadataJson)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,action,actorUserId,targetId,metadataJson,createdAt,syncStatus);

@override
String toString() {
  return 'AuditEntry(id: $id, action: $action, actorUserId: $actorUserId, targetId: $targetId, metadataJson: $metadataJson, createdAt: $createdAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryCopyWith<$Res> implements $AuditEntryCopyWith<$Res> {
  factory _$AuditEntryCopyWith(_AuditEntry value, $Res Function(_AuditEntry) _then) = __$AuditEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, AuditAction action, String actorUserId, String? targetId, String metadataJson, DateTime createdAt, String syncStatus
});




}
/// @nodoc
class __$AuditEntryCopyWithImpl<$Res>
    implements _$AuditEntryCopyWith<$Res> {
  __$AuditEntryCopyWithImpl(this._self, this._then);

  final _AuditEntry _self;
  final $Res Function(_AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? action = null,Object? actorUserId = null,Object? targetId = freezed,Object? metadataJson = null,Object? createdAt = null,Object? syncStatus = null,}) {
  return _then(_AuditEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,actorUserId: null == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,metadataJson: null == metadataJson ? _self.metadataJson : metadataJson // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$InviteBundle {

 String get t; String get s; String get e; String get r; int get x;
/// Create a copy of InviteBundle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteBundleCopyWith<InviteBundle> get copyWith => _$InviteBundleCopyWithImpl<InviteBundle>(this as InviteBundle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteBundle&&(identical(other.t, t) || other.t == t)&&(identical(other.s, s) || other.s == s)&&(identical(other.e, e) || other.e == e)&&(identical(other.r, r) || other.r == r)&&(identical(other.x, x) || other.x == x));
}


@override
int get hashCode => Object.hash(runtimeType,t,s,e,r,x);

@override
String toString() {
  return 'InviteBundle(t: $t, s: $s, e: $e, r: $r, x: $x)';
}


}

/// @nodoc
abstract mixin class $InviteBundleCopyWith<$Res>  {
  factory $InviteBundleCopyWith(InviteBundle value, $Res Function(InviteBundle) _then) = _$InviteBundleCopyWithImpl;
@useResult
$Res call({
 String t, String s, String e, String r, int x
});




}
/// @nodoc
class _$InviteBundleCopyWithImpl<$Res>
    implements $InviteBundleCopyWith<$Res> {
  _$InviteBundleCopyWithImpl(this._self, this._then);

  final InviteBundle _self;
  final $Res Function(InviteBundle) _then;

/// Create a copy of InviteBundle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? t = null,Object? s = null,Object? e = null,Object? r = null,Object? x = null,}) {
  return _then(_self.copyWith(
t: null == t ? _self.t : t // ignore: cast_nullable_to_non_nullable
as String,s: null == s ? _self.s : s // ignore: cast_nullable_to_non_nullable
as String,e: null == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String,r: null == r ? _self.r : r // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteBundle].
extension InviteBundlePatterns on InviteBundle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteBundle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteBundle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteBundle value)  $default,){
final _that = this;
switch (_that) {
case _InviteBundle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteBundle value)?  $default,){
final _that = this;
switch (_that) {
case _InviteBundle() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _InviteBundle implements InviteBundle {
  const _InviteBundle({required this.t, required this.s, required this.e, required this.r, required this.x});
  

@override final  String t;
@override final  String s;
@override final  String e;
@override final  String r;
@override final  int x;

/// Create a copy of InviteBundle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteBundleCopyWith<_InviteBundle> get copyWith => __$InviteBundleCopyWithImpl<_InviteBundle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteBundle&&(identical(other.t, t) || other.t == t)&&(identical(other.s, s) || other.s == s)&&(identical(other.e, e) || other.e == e)&&(identical(other.r, r) || other.r == r)&&(identical(other.x, x) || other.x == x));
}


@override
int get hashCode => Object.hash(runtimeType,t,s,e,r,x);

@override
String toString() {
  return 'InviteBundle(t: $t, s: $s, e: $e, r: $r, x: $x)';
}


}

/// @nodoc
abstract mixin class _$InviteBundleCopyWith<$Res> implements $InviteBundleCopyWith<$Res> {
  factory _$InviteBundleCopyWith(_InviteBundle value, $Res Function(_InviteBundle) _then) = __$InviteBundleCopyWithImpl;
@override @useResult
$Res call({
 String t, String s, String e, String r, int x
});




}
/// @nodoc
class __$InviteBundleCopyWithImpl<$Res>
    implements _$InviteBundleCopyWith<$Res> {
  __$InviteBundleCopyWithImpl(this._self, this._then);

  final _InviteBundle _self;
  final $Res Function(_InviteBundle) _then;

/// Create a copy of InviteBundle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? t = null,Object? s = null,Object? e = null,Object? r = null,Object? x = null,}) {
  return _then(_InviteBundle(
t: null == t ? _self.t : t // ignore: cast_nullable_to_non_nullable
as String,s: null == s ? _self.s : s // ignore: cast_nullable_to_non_nullable
as String,e: null == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String,r: null == r ? _self.r : r // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

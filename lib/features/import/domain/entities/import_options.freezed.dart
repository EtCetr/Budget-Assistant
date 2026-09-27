// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportOptions {

 bool get detectDuplicates; bool get detectTransfers; bool get checkSecrecy; bool get autoCategorize; bool get detectRecurring;
/// Create a copy of ImportOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportOptionsCopyWith<ImportOptions> get copyWith => _$ImportOptionsCopyWithImpl<ImportOptions>(this as ImportOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportOptions&&(identical(other.detectDuplicates, detectDuplicates) || other.detectDuplicates == detectDuplicates)&&(identical(other.detectTransfers, detectTransfers) || other.detectTransfers == detectTransfers)&&(identical(other.checkSecrecy, checkSecrecy) || other.checkSecrecy == checkSecrecy)&&(identical(other.autoCategorize, autoCategorize) || other.autoCategorize == autoCategorize)&&(identical(other.detectRecurring, detectRecurring) || other.detectRecurring == detectRecurring));
}


@override
int get hashCode => Object.hash(runtimeType,detectDuplicates,detectTransfers,checkSecrecy,autoCategorize,detectRecurring);

@override
String toString() {
  return 'ImportOptions(detectDuplicates: $detectDuplicates, detectTransfers: $detectTransfers, checkSecrecy: $checkSecrecy, autoCategorize: $autoCategorize, detectRecurring: $detectRecurring)';
}


}

/// @nodoc
abstract mixin class $ImportOptionsCopyWith<$Res>  {
  factory $ImportOptionsCopyWith(ImportOptions value, $Res Function(ImportOptions) _then) = _$ImportOptionsCopyWithImpl;
@useResult
$Res call({
 bool detectDuplicates, bool detectTransfers, bool checkSecrecy, bool autoCategorize, bool detectRecurring
});




}
/// @nodoc
class _$ImportOptionsCopyWithImpl<$Res>
    implements $ImportOptionsCopyWith<$Res> {
  _$ImportOptionsCopyWithImpl(this._self, this._then);

  final ImportOptions _self;
  final $Res Function(ImportOptions) _then;

/// Create a copy of ImportOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? detectDuplicates = null,Object? detectTransfers = null,Object? checkSecrecy = null,Object? autoCategorize = null,Object? detectRecurring = null,}) {
  return _then(_self.copyWith(
detectDuplicates: null == detectDuplicates ? _self.detectDuplicates : detectDuplicates // ignore: cast_nullable_to_non_nullable
as bool,detectTransfers: null == detectTransfers ? _self.detectTransfers : detectTransfers // ignore: cast_nullable_to_non_nullable
as bool,checkSecrecy: null == checkSecrecy ? _self.checkSecrecy : checkSecrecy // ignore: cast_nullable_to_non_nullable
as bool,autoCategorize: null == autoCategorize ? _self.autoCategorize : autoCategorize // ignore: cast_nullable_to_non_nullable
as bool,detectRecurring: null == detectRecurring ? _self.detectRecurring : detectRecurring // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportOptions].
extension ImportOptionsPatterns on ImportOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportOptions value)  $default,){
final _that = this;
switch (_that) {
case _ImportOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportOptions value)?  $default,){
final _that = this;
switch (_that) {
case _ImportOptions() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ImportOptions implements ImportOptions {
  const _ImportOptions({this.detectDuplicates = true, this.detectTransfers = true, this.checkSecrecy = true, this.autoCategorize = true, this.detectRecurring = true});
  

@override@JsonKey() final  bool detectDuplicates;
@override@JsonKey() final  bool detectTransfers;
@override@JsonKey() final  bool checkSecrecy;
@override@JsonKey() final  bool autoCategorize;
@override@JsonKey() final  bool detectRecurring;

/// Create a copy of ImportOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportOptionsCopyWith<_ImportOptions> get copyWith => __$ImportOptionsCopyWithImpl<_ImportOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportOptions&&(identical(other.detectDuplicates, detectDuplicates) || other.detectDuplicates == detectDuplicates)&&(identical(other.detectTransfers, detectTransfers) || other.detectTransfers == detectTransfers)&&(identical(other.checkSecrecy, checkSecrecy) || other.checkSecrecy == checkSecrecy)&&(identical(other.autoCategorize, autoCategorize) || other.autoCategorize == autoCategorize)&&(identical(other.detectRecurring, detectRecurring) || other.detectRecurring == detectRecurring));
}


@override
int get hashCode => Object.hash(runtimeType,detectDuplicates,detectTransfers,checkSecrecy,autoCategorize,detectRecurring);

@override
String toString() {
  return 'ImportOptions(detectDuplicates: $detectDuplicates, detectTransfers: $detectTransfers, checkSecrecy: $checkSecrecy, autoCategorize: $autoCategorize, detectRecurring: $detectRecurring)';
}


}

/// @nodoc
abstract mixin class _$ImportOptionsCopyWith<$Res> implements $ImportOptionsCopyWith<$Res> {
  factory _$ImportOptionsCopyWith(_ImportOptions value, $Res Function(_ImportOptions) _then) = __$ImportOptionsCopyWithImpl;
@override @useResult
$Res call({
 bool detectDuplicates, bool detectTransfers, bool checkSecrecy, bool autoCategorize, bool detectRecurring
});




}
/// @nodoc
class __$ImportOptionsCopyWithImpl<$Res>
    implements _$ImportOptionsCopyWith<$Res> {
  __$ImportOptionsCopyWithImpl(this._self, this._then);

  final _ImportOptions _self;
  final $Res Function(_ImportOptions) _then;

/// Create a copy of ImportOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? detectDuplicates = null,Object? detectTransfers = null,Object? checkSecrecy = null,Object? autoCategorize = null,Object? detectRecurring = null,}) {
  return _then(_ImportOptions(
detectDuplicates: null == detectDuplicates ? _self.detectDuplicates : detectDuplicates // ignore: cast_nullable_to_non_nullable
as bool,detectTransfers: null == detectTransfers ? _self.detectTransfers : detectTransfers // ignore: cast_nullable_to_non_nullable
as bool,checkSecrecy: null == checkSecrecy ? _self.checkSecrecy : checkSecrecy // ignore: cast_nullable_to_non_nullable
as bool,autoCategorize: null == autoCategorize ? _self.autoCategorize : autoCategorize // ignore: cast_nullable_to_non_nullable
as bool,detectRecurring: null == detectRecurring ? _self.detectRecurring : detectRecurring // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

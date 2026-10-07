// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_offer_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptOfferSettings {

 bool get autoOfferNaming; int get offerNamingCount; bool get autoOfferSplit; int get offerSplitCount; bool get syncImagesToCloud;
/// Create a copy of ReceiptOfferSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptOfferSettingsCopyWith<ReceiptOfferSettings> get copyWith => _$ReceiptOfferSettingsCopyWithImpl<ReceiptOfferSettings>(this as ReceiptOfferSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptOfferSettings&&(identical(other.autoOfferNaming, autoOfferNaming) || other.autoOfferNaming == autoOfferNaming)&&(identical(other.offerNamingCount, offerNamingCount) || other.offerNamingCount == offerNamingCount)&&(identical(other.autoOfferSplit, autoOfferSplit) || other.autoOfferSplit == autoOfferSplit)&&(identical(other.offerSplitCount, offerSplitCount) || other.offerSplitCount == offerSplitCount)&&(identical(other.syncImagesToCloud, syncImagesToCloud) || other.syncImagesToCloud == syncImagesToCloud));
}


@override
int get hashCode => Object.hash(runtimeType,autoOfferNaming,offerNamingCount,autoOfferSplit,offerSplitCount,syncImagesToCloud);

@override
String toString() {
  return 'ReceiptOfferSettings(autoOfferNaming: $autoOfferNaming, offerNamingCount: $offerNamingCount, autoOfferSplit: $autoOfferSplit, offerSplitCount: $offerSplitCount, syncImagesToCloud: $syncImagesToCloud)';
}


}

/// @nodoc
abstract mixin class $ReceiptOfferSettingsCopyWith<$Res>  {
  factory $ReceiptOfferSettingsCopyWith(ReceiptOfferSettings value, $Res Function(ReceiptOfferSettings) _then) = _$ReceiptOfferSettingsCopyWithImpl;
@useResult
$Res call({
 bool autoOfferNaming, int offerNamingCount, bool autoOfferSplit, int offerSplitCount, bool syncImagesToCloud
});




}
/// @nodoc
class _$ReceiptOfferSettingsCopyWithImpl<$Res>
    implements $ReceiptOfferSettingsCopyWith<$Res> {
  _$ReceiptOfferSettingsCopyWithImpl(this._self, this._then);

  final ReceiptOfferSettings _self;
  final $Res Function(ReceiptOfferSettings) _then;

/// Create a copy of ReceiptOfferSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? autoOfferNaming = null,Object? offerNamingCount = null,Object? autoOfferSplit = null,Object? offerSplitCount = null,Object? syncImagesToCloud = null,}) {
  return _then(_self.copyWith(
autoOfferNaming: null == autoOfferNaming ? _self.autoOfferNaming : autoOfferNaming // ignore: cast_nullable_to_non_nullable
as bool,offerNamingCount: null == offerNamingCount ? _self.offerNamingCount : offerNamingCount // ignore: cast_nullable_to_non_nullable
as int,autoOfferSplit: null == autoOfferSplit ? _self.autoOfferSplit : autoOfferSplit // ignore: cast_nullable_to_non_nullable
as bool,offerSplitCount: null == offerSplitCount ? _self.offerSplitCount : offerSplitCount // ignore: cast_nullable_to_non_nullable
as int,syncImagesToCloud: null == syncImagesToCloud ? _self.syncImagesToCloud : syncImagesToCloud // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptOfferSettings].
extension ReceiptOfferSettingsPatterns on ReceiptOfferSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptOfferSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptOfferSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptOfferSettings value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptOfferSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptOfferSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptOfferSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptOfferSettings implements ReceiptOfferSettings {
  const _ReceiptOfferSettings({required this.autoOfferNaming, required this.offerNamingCount, required this.autoOfferSplit, required this.offerSplitCount, required this.syncImagesToCloud});
  

@override final  bool autoOfferNaming;
@override final  int offerNamingCount;
@override final  bool autoOfferSplit;
@override final  int offerSplitCount;
@override final  bool syncImagesToCloud;

/// Create a copy of ReceiptOfferSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptOfferSettingsCopyWith<_ReceiptOfferSettings> get copyWith => __$ReceiptOfferSettingsCopyWithImpl<_ReceiptOfferSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptOfferSettings&&(identical(other.autoOfferNaming, autoOfferNaming) || other.autoOfferNaming == autoOfferNaming)&&(identical(other.offerNamingCount, offerNamingCount) || other.offerNamingCount == offerNamingCount)&&(identical(other.autoOfferSplit, autoOfferSplit) || other.autoOfferSplit == autoOfferSplit)&&(identical(other.offerSplitCount, offerSplitCount) || other.offerSplitCount == offerSplitCount)&&(identical(other.syncImagesToCloud, syncImagesToCloud) || other.syncImagesToCloud == syncImagesToCloud));
}


@override
int get hashCode => Object.hash(runtimeType,autoOfferNaming,offerNamingCount,autoOfferSplit,offerSplitCount,syncImagesToCloud);

@override
String toString() {
  return 'ReceiptOfferSettings(autoOfferNaming: $autoOfferNaming, offerNamingCount: $offerNamingCount, autoOfferSplit: $autoOfferSplit, offerSplitCount: $offerSplitCount, syncImagesToCloud: $syncImagesToCloud)';
}


}

/// @nodoc
abstract mixin class _$ReceiptOfferSettingsCopyWith<$Res> implements $ReceiptOfferSettingsCopyWith<$Res> {
  factory _$ReceiptOfferSettingsCopyWith(_ReceiptOfferSettings value, $Res Function(_ReceiptOfferSettings) _then) = __$ReceiptOfferSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool autoOfferNaming, int offerNamingCount, bool autoOfferSplit, int offerSplitCount, bool syncImagesToCloud
});




}
/// @nodoc
class __$ReceiptOfferSettingsCopyWithImpl<$Res>
    implements _$ReceiptOfferSettingsCopyWith<$Res> {
  __$ReceiptOfferSettingsCopyWithImpl(this._self, this._then);

  final _ReceiptOfferSettings _self;
  final $Res Function(_ReceiptOfferSettings) _then;

/// Create a copy of ReceiptOfferSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? autoOfferNaming = null,Object? offerNamingCount = null,Object? autoOfferSplit = null,Object? offerSplitCount = null,Object? syncImagesToCloud = null,}) {
  return _then(_ReceiptOfferSettings(
autoOfferNaming: null == autoOfferNaming ? _self.autoOfferNaming : autoOfferNaming // ignore: cast_nullable_to_non_nullable
as bool,offerNamingCount: null == offerNamingCount ? _self.offerNamingCount : offerNamingCount // ignore: cast_nullable_to_non_nullable
as int,autoOfferSplit: null == autoOfferSplit ? _self.autoOfferSplit : autoOfferSplit // ignore: cast_nullable_to_non_nullable
as bool,offerSplitCount: null == offerSplitCount ? _self.offerSplitCount : offerSplitCount // ignore: cast_nullable_to_non_nullable
as int,syncImagesToCloud: null == syncImagesToCloud ? _self.syncImagesToCloud : syncImagesToCloud // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

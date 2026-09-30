// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parser_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParserConfig {

 String get id; String get bankName; String get bankCode; bool get isPopular; int get usageCount; List<String> get supportedFormats; String get configJson; String? get instructionText; String? get webExportUrl; String? get brandColor; String? get iconAsset;/// JSON с паттернами для автоопределения банка.
/// Формат: {"keywords": ["Т-Банк"], "headers": ["Дата операции"]}
 String? get detectionPatterns; int get version; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ParserConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParserConfigCopyWith<ParserConfig> get copyWith => _$ParserConfigCopyWithImpl<ParserConfig>(this as ParserConfig, _$identity);

  /// Serializes this ParserConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParserConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankCode, bankCode) || other.bankCode == bankCode)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&const DeepCollectionEquality().equals(other.supportedFormats, supportedFormats)&&(identical(other.configJson, configJson) || other.configJson == configJson)&&(identical(other.instructionText, instructionText) || other.instructionText == instructionText)&&(identical(other.webExportUrl, webExportUrl) || other.webExportUrl == webExportUrl)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconAsset, iconAsset) || other.iconAsset == iconAsset)&&(identical(other.detectionPatterns, detectionPatterns) || other.detectionPatterns == detectionPatterns)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bankName,bankCode,isPopular,usageCount,const DeepCollectionEquality().hash(supportedFormats),configJson,instructionText,webExportUrl,brandColor,iconAsset,detectionPatterns,version,createdAt,updatedAt);

@override
String toString() {
  return 'ParserConfig(id: $id, bankName: $bankName, bankCode: $bankCode, isPopular: $isPopular, usageCount: $usageCount, supportedFormats: $supportedFormats, configJson: $configJson, instructionText: $instructionText, webExportUrl: $webExportUrl, brandColor: $brandColor, iconAsset: $iconAsset, detectionPatterns: $detectionPatterns, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ParserConfigCopyWith<$Res>  {
  factory $ParserConfigCopyWith(ParserConfig value, $Res Function(ParserConfig) _then) = _$ParserConfigCopyWithImpl;
@useResult
$Res call({
 String id, String bankName, String bankCode, bool isPopular, int usageCount, List<String> supportedFormats, String configJson, String? instructionText, String? webExportUrl, String? brandColor, String? iconAsset, String? detectionPatterns, int version, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ParserConfigCopyWithImpl<$Res>
    implements $ParserConfigCopyWith<$Res> {
  _$ParserConfigCopyWithImpl(this._self, this._then);

  final ParserConfig _self;
  final $Res Function(ParserConfig) _then;

/// Create a copy of ParserConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bankName = null,Object? bankCode = null,Object? isPopular = null,Object? usageCount = null,Object? supportedFormats = null,Object? configJson = null,Object? instructionText = freezed,Object? webExportUrl = freezed,Object? brandColor = freezed,Object? iconAsset = freezed,Object? detectionPatterns = freezed,Object? version = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,bankCode: null == bankCode ? _self.bankCode : bankCode // ignore: cast_nullable_to_non_nullable
as String,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,supportedFormats: null == supportedFormats ? _self.supportedFormats : supportedFormats // ignore: cast_nullable_to_non_nullable
as List<String>,configJson: null == configJson ? _self.configJson : configJson // ignore: cast_nullable_to_non_nullable
as String,instructionText: freezed == instructionText ? _self.instructionText : instructionText // ignore: cast_nullable_to_non_nullable
as String?,webExportUrl: freezed == webExportUrl ? _self.webExportUrl : webExportUrl // ignore: cast_nullable_to_non_nullable
as String?,brandColor: freezed == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String?,iconAsset: freezed == iconAsset ? _self.iconAsset : iconAsset // ignore: cast_nullable_to_non_nullable
as String?,detectionPatterns: freezed == detectionPatterns ? _self.detectionPatterns : detectionPatterns // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ParserConfig].
extension ParserConfigPatterns on ParserConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParserConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParserConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParserConfig value)  $default,){
final _that = this;
switch (_that) {
case _ParserConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParserConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ParserConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParserConfig implements ParserConfig {
  const _ParserConfig({required this.id, required this.bankName, required this.bankCode, this.isPopular = false, this.usageCount = 0, required final  List<String> supportedFormats, required this.configJson, this.instructionText, this.webExportUrl, this.brandColor, this.iconAsset, this.detectionPatterns, this.version = 1, required this.createdAt, required this.updatedAt}): _supportedFormats = supportedFormats;
  factory _ParserConfig.fromJson(Map<String, dynamic> json) => _$ParserConfigFromJson(json);

@override final  String id;
@override final  String bankName;
@override final  String bankCode;
@override@JsonKey() final  bool isPopular;
@override@JsonKey() final  int usageCount;
 final  List<String> _supportedFormats;
@override List<String> get supportedFormats {
  if (_supportedFormats is EqualUnmodifiableListView) return _supportedFormats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportedFormats);
}

@override final  String configJson;
@override final  String? instructionText;
@override final  String? webExportUrl;
@override final  String? brandColor;
@override final  String? iconAsset;
/// JSON с паттернами для автоопределения банка.
/// Формат: {"keywords": ["Т-Банк"], "headers": ["Дата операции"]}
@override final  String? detectionPatterns;
@override@JsonKey() final  int version;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ParserConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParserConfigCopyWith<_ParserConfig> get copyWith => __$ParserConfigCopyWithImpl<_ParserConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParserConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParserConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankCode, bankCode) || other.bankCode == bankCode)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&const DeepCollectionEquality().equals(other._supportedFormats, _supportedFormats)&&(identical(other.configJson, configJson) || other.configJson == configJson)&&(identical(other.instructionText, instructionText) || other.instructionText == instructionText)&&(identical(other.webExportUrl, webExportUrl) || other.webExportUrl == webExportUrl)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.iconAsset, iconAsset) || other.iconAsset == iconAsset)&&(identical(other.detectionPatterns, detectionPatterns) || other.detectionPatterns == detectionPatterns)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bankName,bankCode,isPopular,usageCount,const DeepCollectionEquality().hash(_supportedFormats),configJson,instructionText,webExportUrl,brandColor,iconAsset,detectionPatterns,version,createdAt,updatedAt);

@override
String toString() {
  return 'ParserConfig(id: $id, bankName: $bankName, bankCode: $bankCode, isPopular: $isPopular, usageCount: $usageCount, supportedFormats: $supportedFormats, configJson: $configJson, instructionText: $instructionText, webExportUrl: $webExportUrl, brandColor: $brandColor, iconAsset: $iconAsset, detectionPatterns: $detectionPatterns, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ParserConfigCopyWith<$Res> implements $ParserConfigCopyWith<$Res> {
  factory _$ParserConfigCopyWith(_ParserConfig value, $Res Function(_ParserConfig) _then) = __$ParserConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String bankName, String bankCode, bool isPopular, int usageCount, List<String> supportedFormats, String configJson, String? instructionText, String? webExportUrl, String? brandColor, String? iconAsset, String? detectionPatterns, int version, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ParserConfigCopyWithImpl<$Res>
    implements _$ParserConfigCopyWith<$Res> {
  __$ParserConfigCopyWithImpl(this._self, this._then);

  final _ParserConfig _self;
  final $Res Function(_ParserConfig) _then;

/// Create a copy of ParserConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bankName = null,Object? bankCode = null,Object? isPopular = null,Object? usageCount = null,Object? supportedFormats = null,Object? configJson = null,Object? instructionText = freezed,Object? webExportUrl = freezed,Object? brandColor = freezed,Object? iconAsset = freezed,Object? detectionPatterns = freezed,Object? version = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ParserConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,bankCode: null == bankCode ? _self.bankCode : bankCode // ignore: cast_nullable_to_non_nullable
as String,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,supportedFormats: null == supportedFormats ? _self._supportedFormats : supportedFormats // ignore: cast_nullable_to_non_nullable
as List<String>,configJson: null == configJson ? _self.configJson : configJson // ignore: cast_nullable_to_non_nullable
as String,instructionText: freezed == instructionText ? _self.instructionText : instructionText // ignore: cast_nullable_to_non_nullable
as String?,webExportUrl: freezed == webExportUrl ? _self.webExportUrl : webExportUrl // ignore: cast_nullable_to_non_nullable
as String?,brandColor: freezed == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String?,iconAsset: freezed == iconAsset ? _self.iconAsset : iconAsset // ignore: cast_nullable_to_non_nullable
as String?,detectionPatterns: freezed == detectionPatterns ? _self.detectionPatterns : detectionPatterns // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

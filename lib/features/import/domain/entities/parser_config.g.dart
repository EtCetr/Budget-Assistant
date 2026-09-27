// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parser_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParserConfig _$ParserConfigFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ParserConfig', json, ($checkedConvert) {
  final val = _ParserConfig(
    id: $checkedConvert('id', (v) => v as String),
    bankName: $checkedConvert('bankName', (v) => v as String),
    bankCode: $checkedConvert('bankCode', (v) => v as String),
    isPopular: $checkedConvert('isPopular', (v) => v as bool? ?? false),
    usageCount: $checkedConvert('usageCount', (v) => (v as num?)?.toInt() ?? 0),
    supportedFormats: $checkedConvert(
      'supportedFormats',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    configJson: $checkedConvert('configJson', (v) => v as String),
    instructionText: $checkedConvert('instructionText', (v) => v as String?),
    webExportUrl: $checkedConvert('webExportUrl', (v) => v as String?),
    brandColor: $checkedConvert('brandColor', (v) => v as String?),
    iconAsset: $checkedConvert('iconAsset', (v) => v as String?),
    version: $checkedConvert('version', (v) => (v as num?)?.toInt() ?? 1),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$ParserConfigToJson(_ParserConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bankName': instance.bankName,
      'bankCode': instance.bankCode,
      'isPopular': instance.isPopular,
      'usageCount': instance.usageCount,
      'supportedFormats': instance.supportedFormats,
      'configJson': instance.configJson,
      'instructionText': instance.instructionText,
      'webExportUrl': instance.webExportUrl,
      'brandColor': instance.brandColor,
      'iconAsset': instance.iconAsset,
      'version': instance.version,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

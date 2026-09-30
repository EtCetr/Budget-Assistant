import 'package:freezed_annotation/freezed_annotation.dart';
part 'parser_config.freezed.dart';
part 'parser_config.g.dart';

/// Конфигурация парсера для конкретного банка.
/// configJson — публичные метаданные, НЕ шифруются.
/// detectionPatterns — JSON с паттернами для автоопределения банка.
@freezed
abstract class ParserConfig with _$ParserConfig {
  const factory ParserConfig({
    required String id,
    required String bankName,
    required String bankCode,
    @Default(false) bool isPopular,
    @Default(0) int usageCount,
    required List<String> supportedFormats,
    required String configJson,
    String? instructionText,
    String? webExportUrl,
    String? brandColor,
    String? iconAsset,
    /// JSON с паттернами для автоопределения банка.
    /// Формат: {"keywords": ["Т-Банк"], "headers": ["Дата операции"]}
    String? detectionPatterns,
    @Default(1) int version,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ParserConfig;

  factory ParserConfig.fromJson(Map<String, dynamic> json) =>
      _$ParserConfigFromJson(json);
}
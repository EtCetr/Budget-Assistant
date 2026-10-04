import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../data/parsers/csv_parser.dart';
import '../../data/parsers/import_file_parser.dart';
import '../../data/parsers/pdf_parser.dart';
import '../../data/parsers/xlsx_parser.dart';
import '../entities/column_mapping.dart';
import '../entities/column_detection_result.dart';
import '../entities/parse_import_outcome.dart';
import '../entities/parsed_file.dart';
import '../entities/parser_config.dart';
import 'auto_detect_columns_usecase.dart';

/// Р—Р°РіСЂСѓР·РєР° С„Р°Р№Р»Р° РёРјРїРѕСЂС‚Р°: РєРѕРїРёСЏ РІ documents/imports/, РїРµСЂРІРёС‡РЅС‹Р№ РїР°СЂСЃРёРЅРі,
/// Р°РІС‚РѕРѕРїСЂРµРґРµР»РµРЅРёРµ РєРѕР»РѕРЅРѕРє (РµСЃР»Рё РєРѕРЅС„РёРі РЅРµ Р·Р°РїСЂРµС‰Р°РµС‚), РїРѕРІС‚РѕСЂРЅС‹Р№ РїР°СЂСЃРёРЅРі.
class ParseImportFileUseCase {
  final AutoDetectColumnsUseCase _autoDetect;
  final Logger _logger;
  static const int _maxFileBytes = 50 * 1024 * 1024;

  ParseImportFileUseCase({
    required AutoDetectColumnsUseCase autoDetect,
    required Logger logger,
  })  : _autoDetect = autoDetect,
        _logger = logger;

  Future<ParseImportOutcome> call({
    required String sourcePath,
    required ParserConfig config,
  }) async {
    try {
      final src = File(sourcePath);
      if (!await src.exists()) {
        return const ParseImportOutcome(errorCode: 'not_found');
      }
      final size = await src.length();
      if (size > _maxFileBytes) {
        _logger.w('РРјРїРѕСЂС‚: С„Р°Р№Р» Р±РѕР»СЊС€Рµ 50 РњР‘ ($size Р±Р°Р№С‚)');
        return const ParseImportOutcome(errorCode: 'too_large');
      }
      final ext = p.extension(sourcePath).replaceFirst('.', '').toLowerCase();
      final format = (ext == 'csv' || ext == 'xlsx' || ext == 'pdf') ? ext : 'csv';
      final dir = await getApplicationDocumentsDirectory();
      final importsDir = Directory(p.join(dir.path, 'imports'));
      if (!await importsDir.exists()) {
        await importsDir.create(recursive: true);
      }
      final storedPath = p.join(importsDir.path, '${const Uuid().v4()}.$format');
      await src.copy(storedPath);
      final section = _section(config.configJson, format);
      final base = _mappingFromSection(section);
      final firstPass = await _parserFor(format, config.configJson)
          .parse(filePath: storedPath, mapping: base);
      final noAutodetect = format == 'pdf' || section['no_autodetect'] == true;
      final detection = noAutodetect
          ? ColumnDetectionResult(mapping: base, confidence: 0)
          : _autoDetect.call(rawRows: firstPass.rawRows, base: base);
      final ParseResult finalPass = detection.confidence > 0
          ? await _parserFor(format, config.configJson)
              .parse(filePath: storedPath, mapping: detection.mapping)
          : firstPass;
      return ParseImportOutcome.success(ParsedFile(
        storedPath: storedPath,
        fileName: p.basename(sourcePath),
        fileSizeBytes: size,
        format: format,
        rawRows: firstPass.rawRows,
        detectedMapping: detection.mapping,
        detectionConfidence: detection.confidence,
        parseResult: finalPass,
      ));
    } catch (e, st) {
      _logger.e('ParseImportFileUseCase failed', error: e, stackTrace: st);
      return const ParseImportOutcome(errorCode: 'parse_error');
    }
  }

  /// РџРµСЂРµРїР°СЂСЃРёРЅРі СЃ С„РёРЅР°Р»СЊРЅС‹Рј РјР°РїРїРёРЅРіРѕРј РїРѕР»СЊР·РѕРІР°С‚РµР»СЏ (STEP 3 в†’ STEP 4).
  Future<ParseResult> reparse({
    required String storedPath,
    required String format,
    required String configJson,
    required ColumnMapping mapping,
  }) async {
    try {
      return await _parserFor(format, configJson)
          .parse(filePath: storedPath, mapping: mapping);
    } catch (e, st) {
      _logger.e('ParseImportFileUseCase.reparse failed', error: e, stackTrace: st);
      return ParseResult(
        rows: const [],
        rawRows: const [],
        totalRows: 0,
        error: 'РћС€РёР±РєР° РїРѕРІС‚РѕСЂРЅРѕРіРѕ РїР°СЂСЃРёРЅРіР°: $e',
      );
    }
  }

  Map<String, dynamic> _section(String configJson, String format) {
    try {
      final cfg = jsonDecode(configJson);
      if (cfg is Map<String, dynamic>) {
        final s = cfg[format];
        if (s is Map<String, dynamic>) return s;
      }
    } catch (_) {}
    return {};
  }

  ImportFileParser _parserFor(String format, String configJson) {
    switch (format) {
      case 'xlsx':
        return XlsxParser(logger: _logger);
      case 'pdf':
        return PdfParser(logger: _logger, configJson: configJson);
      case 'csv':
      default:
        return CsvParser(logger: _logger);
    }
  }

  ColumnMapping _mappingFromSection(Map<String, dynamic> s) {
    final separator = (s['separator'] as String?) ?? ';';
    final encoding = (s['encoding'] as String?) ?? 'UTF-8';
    final skipRows = (s['skip_rows'] as int?) ?? 0;
    final dateFormat = (s['date_format'] as String?) ?? 'dd.MM.yyyy';
    return ColumnMapping(
      dateColumnIndex: (s['date_column'] as int?) ?? 0,
      amountColumnIndex: (s['amount_column'] as int?) ?? 1,
      merchantColumnIndex: (s['merchant_column'] as int?) ?? 2,
      categoryColumnIndex: s['category_column'] as int?,
      commentColumnIndex: s['comment_column'] as int?,
      currencyColumnIndex: s['currency_column'] as int?,
      holdColumnIndex: s['hold_column'] as int?,
      holdMarker: (s['hold_marker'] as String?) ?? 'HOLD',
      dateFormat: dateFormat,
      csvSeparator: separator,
      encoding: encoding,
      skipRows: skipRows,
    );
  }
}
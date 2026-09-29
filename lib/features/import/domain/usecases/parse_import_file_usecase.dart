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
import '../entities/parse_import_outcome.dart';
import '../entities/parsed_file.dart';
import '../entities/parser_config.dart';
import 'auto_detect_columns_usecase.dart';

/// Загрузка файла импорта: копия в documents/imports/, первичный парсинг,
/// автоопределение колонок, повторный парсинг с найденным маппингом
/// (ТЗ 6.3.25.10).
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
        _logger.w('Импорт: файл больше 50 МБ ($size байт)');
        return const ParseImportOutcome(errorCode: 'too_large');
      }

      final ext = p.extension(sourcePath).replaceFirst('.', '').toLowerCase();
      final format =
          (ext == 'csv' || ext == 'xlsx' || ext == 'pdf') ? ext : 'csv';

      final dir = await getApplicationDocumentsDirectory();
      final importsDir = Directory(p.join(dir.path, 'imports'));
      if (!await importsDir.exists()) {
        await importsDir.create(recursive: true);
      }
      final storedPath =
          p.join(importsDir.path, '${const Uuid().v4()}.$format');
      await src.copy(storedPath);

      final base = _baseMappingFromConfig(config.configJson, format);
      final firstPass = await _parserFor(format, config.configJson)
          .parse(filePath: storedPath, mapping: base);

      final detection =
          _autoDetect.call(rawRows: firstPass.rawRows, base: base);

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

  /// Перепарсинг с финальным маппингом пользователя (STEP 3 → STEP 4).
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
      _logger.e('ParseImportFileUseCase.reparse failed',
          error: e, stackTrace: st);
      return ParseResult(
        rows: const [],
        rawRows: const [],
        totalRows: 0,
        error: 'Ошибка повторного парсинга: $e',
      );
    }
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

  ColumnMapping _baseMappingFromConfig(String configJson, String format) {
    var separator = ';';
    var encoding = 'UTF-8';
    var skipRows = 0;
    var dateFormat = 'dd.MM.yyyy';
    try {
      final cfg = jsonDecode(configJson);
      if (cfg is Map<String, dynamic>) {
        final section = cfg[format];
        if (section is Map<String, dynamic>) {
          separator = (section['separator'] as String?) ?? separator;
          encoding = (section['encoding'] as String?) ?? encoding;
          skipRows = (section['skip_rows'] as int?) ?? skipRows;
          dateFormat = (section['date_format'] as String?) ?? dateFormat;
        }
      }
    } catch (_) {}
    return ColumnMapping(
      dateColumnIndex: 0,
      amountColumnIndex: 1,
      merchantColumnIndex: 2,
      dateFormat: dateFormat,
      csvSeparator: separator,
      encoding: encoding,
      skipRows: skipRows,
    );
  }
}
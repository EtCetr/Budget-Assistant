import 'column_mapping.dart';
import 'parse_result.dart';

/// Загруженный и распарсенный файл импорта (до подтверждения).
class ParsedFile {
  const ParsedFile({
    required this.storedPath,
    required this.fileName,
    required this.fileSizeBytes,
    required this.format,
    required this.rawRows,
    required this.detectedMapping,
    required this.detectionConfidence,
    required this.parseResult,
  });

  /// Путь к копии файла в documents/imports/{uuid}.{ext}.
  final String storedPath;
  final String fileName;
  final int fileSizeBytes;

  /// 'csv' | 'xlsx' | 'pdf'.
  final String format;
  final List<List<String>> rawRows;
  final ColumnMapping detectedMapping;

  /// 0.0–1.0 уверенность автоопределения колонок.
  final double detectionConfidence;
  final ParseResult parseResult;
}
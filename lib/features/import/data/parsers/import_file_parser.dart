import '../../domain/entities/parsed_row.dart';
import '../../domain/entities/column_mapping.dart';

/// Результат парсинга файла.
class ParseResult {
  final List<ParsedRow> rows;
  final List<List<String>> rawRows;
  final int totalRows;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final String? error;

  const ParseResult({
    required this.rows,
    required this.rawRows,
    required this.totalRows,
    this.periodStart,
    this.periodEnd,
    this.error,
  });

  bool get isSuccess => error == null && rows.isNotEmpty;
}

/// Общий интерфейс для всех парсеров (CSV/XLSX/PDF).
abstract class ImportFileParser {
  Future<ParseResult> parse({
    required String filePath,
    required ColumnMapping mapping,
  });
}
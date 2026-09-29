import '../../domain/entities/column_mapping.dart';
import '../../domain/entities/parse_result.dart';

export '../../domain/entities/parse_result.dart';

/// Общий интерфейс для всех парсеров (CSV/XLSX/PDF).
abstract class ImportFileParser {
  Future<ParseResult> parse({
    required String filePath,
    required ColumnMapping mapping,
  });
}
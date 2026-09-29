import 'dart:math' as math;

import '../entities/preview_table_data.dart';

/// Матрица предпросмотра: первые N строк + буквенные заголовки колонок
/// (ТЗ 6.3.25.12).
class PreviewImportDataUseCase {
  PreviewTableData call(List<List<String>> rawRows, {int limit = 10}) {
    try {
      final rows = rawRows.take(limit).toList();
      if (rows.isEmpty) return const PreviewTableData(columnLabels: [], rows: []);
      final colCount = rows.map((r) => r.length).reduce(math.max);
      final labels = List.generate(colCount, _columnLabel);
      return PreviewTableData(columnLabels: labels, rows: rows);
    } catch (_) {
      return const PreviewTableData(columnLabels: [], rows: []);
    }
  }

  String _columnLabel(int i) {
    final letters = StringBuffer();
    var idx = i;
    while (idx >= 0) {
      letters.write(String.fromCharCode(65 + (idx % 26)));
      idx = (idx ~/ 26) - 1;
    }
    return letters.toString();
  }
}
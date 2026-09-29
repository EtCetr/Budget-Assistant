/// Матрица предпросмотра (первые N строк) с буквенными заголовками колонок.
class PreviewTableData {
  const PreviewTableData({
    required this.columnLabels,
    required this.rows,
  });

  /// 'A', 'B', 'C', ... как в Excel.
  final List<String> columnLabels;
  final List<List<String>> rows;
}
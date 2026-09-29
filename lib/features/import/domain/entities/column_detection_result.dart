import 'column_mapping.dart';

/// Результат автоопределения колонок (ТЗ 6.3.25.13).
class ColumnDetectionResult {
  const ColumnDetectionResult({
    required this.mapping,
    required this.confidence,
  });

  final ColumnMapping mapping;

  /// 0.0–1.0; >= 0.8 → автозаполнение + Snackbar.
  final double confidence;
}
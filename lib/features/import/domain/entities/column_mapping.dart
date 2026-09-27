import 'package:freezed_annotation/freezed_annotation.dart';

part 'column_mapping.freezed.dart';

/// Маппинг колонок файла на поля транзакции.
@freezed
abstract class ColumnMapping with _$ColumnMapping {
  const factory ColumnMapping({
    /// Индекс колонки с датой (обязательно).
    required int dateColumnIndex,
    /// Индекс колонки с суммой (обязательно).
    required int amountColumnIndex,
    /// Индекс колонки с мерчантом (обязательно).
    required int merchantColumnIndex,
    /// Индекс колонки с категорией банка (опционально).
    int? categoryColumnIndex,
    /// Индекс колонки с комментарием (опционально).
    int? commentColumnIndex,
    /// Индекс колонки с валютой (опционально).
    int? currencyColumnIndex,
    /// Формат даты: 'dd.MM.yyyy', 'dd.MM.yyyy HH:mm:ss'.
    @Default('dd.MM.yyyy') String dateFormat,
    /// Разделитель CSV.
    @Default(';') String csvSeparator,
    /// Кодировка.
    @Default('UTF-8') String encoding,
    /// Кол-во строк для пропуска (заголовки банка).
    @Default(0) int skipRows,
    /// true = расход отрицательный, false = расход положительный.
    @Default(true) bool expenseIsNegative,
  }) = _ColumnMapping;
}
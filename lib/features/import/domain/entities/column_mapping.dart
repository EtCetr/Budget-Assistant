import 'package:freezed_annotation/freezed_annotation.dart';
part 'column_mapping.freezed.dart';

/// Маппинг колонок файла на поля транзакции.
@freezed
abstract class ColumnMapping with _$ColumnMapping {
  const factory ColumnMapping({
    required int dateColumnIndex,
    required int amountColumnIndex,
    required int merchantColumnIndex,
    int? categoryColumnIndex,
    int? commentColumnIndex,
    int? currencyColumnIndex,
    /// Колонка со статусом операции; значение holdMarker => isHold.
    int? holdColumnIndex,
    @Default('HOLD') String holdMarker,
    @Default('dd.MM.yyyy') String dateFormat,
    @Default(';') String csvSeparator,
    @Default('UTF-8') String encoding,
    @Default(0) int skipRows,
    @Default(true) bool expenseIsNegative,
  }) = _ColumnMapping;
}
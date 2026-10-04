import 'package:freezed_annotation/freezed_annotation.dart';
part 'parsed_row.freezed.dart';

/// Одна строка из распарсенного файла импорта.
/// Деньги — копейки (отрицательные = расход).
@freezed
abstract class ParsedRow with _$ParsedRow {
  const factory ParsedRow({
    required int rowIndex,
    required DateTime date,
    /// Копейки. Отрицательное = расход, положительное = доход.
    required int amountKopecks,
    required String merchantName,
    String? bankCategory,
    String? comment,
    String? bankTransactionId,
    String? originalCurrency,
    int? originalAmountKopecks,
    /// true = операция ещё не подтверждена банком (HOLD) -> audit_status='pending'.
    @Default(false) bool isHold,
    /// Категория, назначенная пользователем в UI (изначально null).
    String? assignedCategoryId,
  }) = _ParsedRow;
}
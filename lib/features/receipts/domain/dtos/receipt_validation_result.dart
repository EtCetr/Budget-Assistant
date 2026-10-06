import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_validation_result.freezed.dart';

/// Результат валидации формы чека перед confirm.
@freezed
abstract class ReceiptValidationResult with _$ReceiptValidationResult {
  const factory ReceiptValidationResult({
    required List<String> errorCodes,
  }) = _ReceiptValidationResult;
}

extension ReceiptValidationX on ReceiptValidationResult {
  bool get isValid => errorCodes.isEmpty;
}
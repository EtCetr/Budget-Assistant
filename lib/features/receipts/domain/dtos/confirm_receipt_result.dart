import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_receipt_result.freezed.dart';

/// Результат подтверждения чека (ТЗ 6.3.23.8).
@freezed
abstract class ConfirmReceiptResult with _$ConfirmReceiptResult {
  const factory ConfirmReceiptResult({
    required bool success,
    @Default(<String>[]) List<String> errorCodes,
  }) = _ConfirmReceiptResult;
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fiscal_qr_data.freezed.dart';

/// Результат разбора фискального QR (ФН/ФП/дата/сумма).
@freezed
abstract class FiscalQrData with _$FiscalQrData {
  const factory FiscalQrData({
    required DateTime dateUtc,
    required int totalKop,
    String? fiscalDataJson,
    required String raw,
  }) = _FiscalQrData;
}
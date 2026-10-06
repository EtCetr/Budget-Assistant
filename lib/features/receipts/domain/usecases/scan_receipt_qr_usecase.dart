import 'package:logger/logger.dart';
import 'create_draft_receipt_usecase.dart';
import 'parse_fiscal_qr_usecase.dart';

/// QR ФНС -> метаданные (дата/сумма/фискальные признаки) -> черновик чека.
/// QR не содержит позиций: items пустые (ТЗ 6.3.22.12 п.2.d).
/// null = QR не разобрался; ошибки сохранения пробрасываются наверх.
class ScanReceiptQrUseCase {
  final ParseFiscalQrUseCase _parseQr;
  final CreateDraftReceiptUseCase _createDraft;
  final Logger _logger;

  ScanReceiptQrUseCase({
    required ParseFiscalQrUseCase parseQr,
    required CreateDraftReceiptUseCase createDraft,
    required Logger logger,
  })  : _parseQr = parseQr,
        _createDraft = createDraft,
        _logger = logger;

  Future<String?> call({
    required String raw,
    required String userId,
    String? spaceId,
    String? transactionId,
  }) async {
    final data = _parseQr(raw);
    if (data == null) {
      _logger.w('ScanReceiptQr: raw not parsed');
      return null;
    }
    return await _createDraft(
      userId: userId,
      spaceId: spaceId,
      transactionId: transactionId,
      storeName: 'QR-чек',
      totalKop: data.totalKop,
      dateUtc: data.dateUtc,
      fiscalDataJson: data.fiscalDataJson,
      rawOcrText: null,
      imagePath: null,
      items: const [],
    );
  }
}
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'create_draft_receipt_usecase.dart';
import 'parse_receipt_text_usecase.dart';
import 'save_receipt_image_usecase.dart';

/// Фото чека -> локальное сохранение -> OCR (ML Kit, latin-модель покрывает
/// кириллицу) -> парсинг -> черновик. Отклонение от ТЗ: плагин ML Kit не
/// работает в Isolate (platform channels) — распознавание в основном изоляте.
/// null = OCR не отработал; ошибки сохранения пробрасываются наверх.
class ScanReceiptOcrUseCase {
  final SaveReceiptImageUseCase _saveImage;
  final ParseReceiptTextUseCase _parseText;
  final CreateDraftReceiptUseCase _createDraft;
  final Logger _logger;

  ScanReceiptOcrUseCase({
    required SaveReceiptImageUseCase saveImage,
    required ParseReceiptTextUseCase parseText,
    required CreateDraftReceiptUseCase createDraft,
    required Logger logger,
  })  : _saveImage = saveImage,
        _parseText = parseText,
        _createDraft = createDraft,
        _logger = logger;

  Future<String?> call({
    required String sourcePath,
    required String userId,
    String? spaceId,
    String? transactionId,
  }) async {
    final receiptId = const Uuid().v4();
    final savedPath = await _saveImage(sourcePath, receiptId);
    final path = savedPath ?? sourcePath;
    final recognizer = TextRecognizer();
    RecognizedText? result;
    try {
      result = await recognizer.processImage(InputImage.fromFilePath(path));
    } catch (e, st) {
      _logger.e('ScanReceiptOcr: recognition failed', error: e, stackTrace: st);
    } finally {
      await recognizer.close();
    }
    if (result == null) return null;
    final draft = _parseText(result.text);
    return await _createDraft(
      userId: userId,
      spaceId: spaceId,
      transactionId: transactionId,
      storeName: draft.storeName ?? 'Чек (OCR)',
      totalKop: draft.totalKop ?? 0,
      dateUtc: DateTime.now().toUtc(),
      fiscalDataJson: null,
      rawOcrText: result.text,
      imagePath: savedPath,
      items: draft.items,
    );
  }
}
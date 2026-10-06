import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../dtos/parsed_item_draft.dart';
import '../entities/receipt.dart';
import '../entities/receipt_item.dart';
import '../repositories/receipts_repository.dart';

/// Создаёт чек со status='draft' + позиции (Offline-First: sync_status=pending).
class CreateDraftReceiptUseCase {
  final ReceiptsRepository _repository;
  final Logger _logger;
  static const _uuid = Uuid();

  CreateDraftReceiptUseCase({
    required ReceiptsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<String> call({
    required String userId,
    String? spaceId,
    String? transactionId,
    required String storeName,
    required int totalKop,
    required DateTime dateUtc,
    String? fiscalDataJson,
    String? rawOcrText,
    String? imagePath,
    required List<ParsedItemDraft> items,
  }) async {
    try {
      final safeTransactionId =
          (transactionId == null || transactionId.isEmpty)
              ? null
              : transactionId;
      final safeSpaceId =
          (spaceId == null || spaceId.isEmpty) ? null : spaceId;
      final now = DateTime.now().toUtc();
      final receiptId = _uuid.v4();
      final receipt = Receipt(
        id: receiptId,
        userId: userId,
        spaceId: safeSpaceId,
        transactionId: safeTransactionId,
        storeName: storeName,
        totalAmount: totalKop,
        receiptDate: dateUtc,
        fiscalData: fiscalDataJson,
        rawOcrText: rawOcrText,
        imagePath: imagePath,
        status: 'draft',
        currency: 'RUB',
        createdAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
      final entities = items
          .map((i) => ReceiptItem(
                id: _uuid.v4(),
                receiptId: receiptId,
                originalName: i.name,
                normalizedName: null,
                quantity: i.quantity,
                unitPrice: i.unitPriceKop,
                totalPrice: i.totalPriceKop,
                categoryId: null,
                isExcluded: false,
                createdAt: now,
                updatedAt: now,
                syncStatus: SyncStatus.pending,
              ))
          .toList();
      await _repository.createReceipt(receipt, entities);
      return receiptId;
    } catch (e, st) {
      _logger.e('CreateDraftReceipt failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
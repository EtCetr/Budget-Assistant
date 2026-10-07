import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../dtos/confirm_receipt_result.dart';
import '../dtos/parsed_item_draft.dart';
import '../entities/receipt.dart';
import '../entities/receipt_item.dart';
import '../repositories/receipts_repository.dart';
import 'validate_receipt_form_usecase.dart';
import '../dtos/receipt_validation_result.dart';

/// Подтверждение чека (ТЗ 6.3.23.8): валидация -> позиции -> status=confirmed
/// -> привязка к транзакции (если выбрана).
class ConfirmReceiptUseCase {
  final ReceiptsRepository _repo;
  final ValidateReceiptFormUseCase _validate;
  final Logger _logger;

  ConfirmReceiptUseCase({
    required ReceiptsRepository repo,
    required ValidateReceiptFormUseCase validate,
    required Logger logger,
  })  : _repo = repo,
        _validate = validate,
        _logger = logger;

  Future<ConfirmReceiptResult> call({
    required Receipt receipt,
    required List<ReceiptItem> items,
    String? transactionId,
  }) async {
    try {
      final validation = _validate(
        storeName: receipt.storeName,
        dateUtc: receipt.receiptDate,
        totalKop: receipt.totalAmount,
        items: items
            .map((i) => ParsedItemDraft(
                  name: i.originalName,
                  quantity: i.quantity,
                  unitPriceKop: i.unitPrice,
                  totalPriceKop: i.totalPrice,
                ))
            .toList(),
      );
      if (!validation.isValid) {
        return ConfirmReceiptResult(
          success: false,
          errorCodes: validation.errorCodes,
        );
      }
      final now = DateTime.now().toUtc();
      await _repo.saveItems(receipt.id, items);
      final confirmed = receipt.copyWith(
        status: 'confirmed',
        transactionId: _nonEmpty(transactionId) ?? _nonEmpty(receipt.transactionId),
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
      await _repo.saveReceipt(confirmed);
      final linkTo = _nonEmpty(transactionId) ?? _nonEmpty(receipt.transactionId);
      if (linkTo != null) {
        await _repo.linkReceiptToTransaction(
          receiptId: receipt.id,
          transactionId: linkTo,
        );
      }
      return const ConfirmReceiptResult(success: true);
    } catch (e, st) {
      _logger.e('ConfirmReceipt failed', error: e, stackTrace: st);
      return const ConfirmReceiptResult(
        success: false,
        errorCodes: ['save_failed'],
      );
    }
  }
}

String? _nonEmpty(String? s) => (s == null || s.isEmpty) ? null : s;
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/transactions/domain/entities/split_position_draft.dart';
import '../repositories/receipts_repository.dart';

/// Валидация + применение разделения чека (ТЗ 6.3.48.7).
/// Ошибки — FormatException с кодом для снекбара:
/// MIN_TWO_POSITIONS / NON_POSITIVE_AMOUNT / MISSING_CATEGORY / SUM_MISMATCH.
class SplitReceiptUseCase {
  final ReceiptsRepository _repo;
  final Logger _logger;

  SplitReceiptUseCase({
    required ReceiptsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  Future<void> call({
    required String receiptId,
    required List<SplitPositionDraft> positions,
    required String actorUserId,
  }) async {
    try {
      final receipt = await _repo.getReceiptById(receiptId);
      if (receipt == null) {
        throw StateError('Receipt not found: $receiptId');
      }
      final txId = receipt.transactionId;
      if (txId == null) {
        throw StateError('Receipt $receiptId is not linked to a transaction');
      }
      if (positions.length < 2) {
        throw const FormatException('MIN_TWO_POSITIONS');
      }
      var sum = 0;
      for (final p in positions) {
        if (p.amount <= 0) {
          throw const FormatException('NON_POSITIVE_AMOUNT');
        }
        if (p.categoryId == null) {
          throw const FormatException('MISSING_CATEGORY');
        }
        sum += p.amount;
      }
      if (sum != receipt.totalAmount) {
        throw const FormatException('SUM_MISMATCH');
      }
      await _repo.applyReceiptSplit(
        receiptId: receiptId,
        transactionId: txId,
        actorUserId: actorUserId,
        positions: positions,
      );
    } catch (e, st) {
      _logger.e('SplitReceiptUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
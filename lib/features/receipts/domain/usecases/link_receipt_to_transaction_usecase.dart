import 'package:logger/logger.dart';
import '../repositories/receipts_repository.dart';

/// Привязка чека к транзакции (ТЗ 6.3.23.5).
/// Блокировка pending-транзакций enforced в репозитории.
class LinkReceiptToTransactionUseCase {
  final ReceiptsRepository _repo;
  final Logger _logger;

  LinkReceiptToTransactionUseCase({
    required ReceiptsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  Future<bool> call({
    required String receiptId,
    required String transactionId,
  }) async {
    try {
      await _repo.linkReceiptToTransaction(
        receiptId: receiptId,
        transactionId: transactionId,
      );
      return true;
    } catch (e, st) {
      _logger.e('LinkReceiptToTransaction failed', error: e, stackTrace: st);
      return false;
    }
  }
}
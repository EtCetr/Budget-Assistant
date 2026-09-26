import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/split_position_draft.dart';
import '../models/transaction_split.dart';
import '../repositories/split_drafts_repository.dart';
import '../repositories/transactions_repository.dart';

/// Сохранение разделения транзакции (ТЗ 6.3.15.7):
/// 1) исходная транзакция получает is_split = TRUE (исключение из P&L);
/// 2) позиции пишутся в transaction_splits (атомарно: updateTransaction
///    удаляет старые сплиты и вставляет новые в одной Drift-транзакции);
/// 3) локальный черновик split_drafts удаляется.
class CreateTransactionSplitUseCase {
  CreateTransactionSplitUseCase({
    required TransactionsRepository repository,
    required SplitDraftsRepository drafts,
    required Logger logger,
  })  : _repository = repository,
        _drafts = drafts,
        _logger = logger;

  final TransactionsRepository _repository;
  final SplitDraftsRepository _drafts;
  final Logger _logger;

  Future<List<TransactionSplit>> call({
    required String transactionId,
    required List<SplitPositionDraft> positions,
    required String actorUserId,
  }) async {
    try {
      final tx = await _repository.getTransactionById(transactionId);
      if (tx == null) {
        throw StateError('Transaction not found: $transactionId');
      }
      if (tx.userId != actorUserId) {
        throw StateError('Only owner can split transaction: $transactionId');
      }
      final now = DateTime.now().toUtc();
      final splits = positions
          .map(
            (p) => TransactionSplit(
              id: p.id ?? const Uuid().v4(),
              transactionId: transactionId,
              categoryId: p.categoryId!,
              amount: p.amount,
              description: (p.description?.trim().isEmpty ?? true)
                  ? null
                  : p.description!.trim(),
              createdAt: now,
              updatedAt: now,
              syncStatus: SyncStatus.pending,
            ),
          )
          .toList();
      final updated = tx.copyWith(
        isSplit: true,
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
      await _repository.updateTransaction(updated, splits);
      await _drafts.deleteByTransaction(transactionId);
      return splits;
    } catch (e, st) {
      _logger.e('CreateTransactionSplitUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
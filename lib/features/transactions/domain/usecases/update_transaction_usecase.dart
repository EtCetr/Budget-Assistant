// TODO(24): unit-тесты propagation правки на копии группы (включая сплиты).
// TODO(23.8): сторно/возврат (markAsRefund) пока НЕ пропагируется на копии группы.
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/features/transactions/domain/models/secrecy_config.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_split.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:budget_assistant/features/transactions/domain/validation/transaction_validator.dart';

class UpdateTransactionUseCase {
  final TransactionsRepository _repository;
  final Logger _logger;
  final ClockPort _clock;

  UpdateTransactionUseCase({
    required TransactionsRepository repository,
    required Logger logger,
    required ClockPort clock,
  })  : _repository = repository,
        _logger = logger,
        _clock = clock;

  Future<Result<Transaction>> call({
    required TransactionDraft draft,
    required String userId,
    SecrecyConfig? secrecyConfig,
  }) async {
    try {
      final id = draft.id;
      if (id == null) {
        return const Error(
          Failure.validation('Transaction id is required for update'),
        );
      }
      final validationError = TransactionValidator.validate(draft);
      if (validationError != null) {
        return Error(Failure.validation(validationError));
      }
      final existing = await _repository.getTransactionById(id);
      if (existing == null || existing.userId != userId) {
        return const Error(Failure.notFound('Transaction not found'));
      }
      final nowUtc = DateTime.now().toUtc();
      final splits = (draft.splits ?? [])
          .map(
            (splitDraft) => TransactionSplit(
              id: splitDraft.id ?? const Uuid().v4(),
              transactionId: id,
              categoryId: splitDraft.categoryId,
              amount: splitDraft.amount,
              description: splitDraft.description,
              createdAt: splitDraft.createdAt ?? nowUtc,
              updatedAt: nowUtc,
              syncStatus: SyncStatus.pending,
            ),
          )
          .toList();
      var updated = existing.copyWith(
        accountId: draft.accountId,
        linkedAccountId: draft.linkedAccountId,
        spaceId: draft.spaceId,
        date: draft.date.toUtc(),
        amount: draft.amount,
        originalCurrency: draft.originalCurrency,
        originalAmount: draft.originalAmount,
        type: draft.type,
        bankCategory: draft.bankCategory,
        customCategoryId: draft.customCategoryId,
        merchantName: draft.merchantName,
        comment: draft.comment,
        savingsGoalId: draft.savingsGoalId,
        isWithdrawal: draft.isWithdrawal ?? false,
        isUserEdited: true,
        isSplit: splits.isNotEmpty,
        updatedAt: nowUtc,
        syncStatus: SyncStatus.pending,
      );
      if (_shouldLockSync(draft.type, draft.amount, secrecyConfig)) {
        final elapsed = await _clock.elapsedRealtimeMs();
        updated = updated.copyWith(
          syncLockedStartedAt: elapsed,
          syncLockedDurationMs: secrecyConfig!.timeoutSeconds * 1000,
        );
      } else {
        updated = updated.copyWith(
          syncLockedStartedAt: null,
          syncLockedDurationMs: null,
        );
      }
      await _repository.updateTransaction(updated, splits);
      // Этап 23.6 (D23.6-2): правка применяется ко всем копиям группы.
      await _propagateToCopies(id, updated, splits, nowUtc);
      return Success(updated);
    } catch (e, stack) {
      _logger.e('UpdateTransactionUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString()));
    }
  }

  Future<void> _propagateToCopies(
    String sourceId,
    Transaction updated,
    List<TransactionSplit> splits,
    DateTime nowUtc,
  ) async {
    try {
      final db = AppDatabase();
      final row = await (db.select(db.transactions)
            ..where((t) => t.id.equals(sourceId)))
          .getSingleOrNull();
      final gid = row?.copyGroupId;
      if (gid == null) return;
      final copies = await (db.select(db.transactions)
            ..where((t) => t.copyGroupId.equals(gid) & t.id.equals(sourceId).not()))
          .get();
      for (final c in copies) {
        await (db.update(db.transactions)
              ..where((t) => t.id.equals(c.id)))
            .write(TransactionsCompanion(
          accountId: Value(updated.accountId),
          linkedAccountId: Value(updated.linkedAccountId),
          date: Value(updated.date),
          amount: Value(updated.amount),
          originalCurrency: Value(updated.originalCurrency),
          originalAmount: Value(updated.originalAmount),
          type: Value(updated.type),
          bankCategory: Value(updated.bankCategory),
          customCategoryId: Value(updated.customCategoryId),
          merchantName: Value(updated.merchantName),
          comment: Value(updated.comment),
          savingsGoalId: Value(updated.savingsGoalId),
          isWithdrawal: Value(updated.isWithdrawal),
          isSplit: Value(updated.isSplit),
          updatedAt: Value(nowUtc),
          syncStatus: const Value(SyncStatus.pending),
        ));
        await (db.delete(db.transactionSplits)
              ..where((s) => s.transactionId.equals(c.id)))
            .go();
        for (final s in splits) {
          await db.into(db.transactionSplits).insert(
                TransactionSplitsCompanion.insert(
                  id: const Uuid().v4(),
                  transactionId: c.id,
                  categoryId: s.categoryId,
                  amount: s.amount,
                  description: Value(s.description),
                  createdAt: nowUtc,
                  updatedAt: nowUtc,
                  syncStatus: const Value(SyncStatus.pending),
                ),
              );
        }
      }
    } catch (e, st) {
      _logger.e('Propagate update to copies failed', error: e, stackTrace: st);
    }
  }

  bool _shouldLockSync(
    TransactionType type,
    int amount,
    SecrecyConfig? config,
  ) {
    if (config == null || !config.enabled) return false;
    return type == TransactionType.expense && amount >= config.threshold;
  }
}
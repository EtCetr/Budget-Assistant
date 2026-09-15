import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/core/ports/savings_goal_progress_port.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/features/transactions/domain/models/secrecy_config.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_split.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:budget_assistant/features/transactions/domain/validation/transaction_validator.dart';

class CreateTransactionUseCase {
  final TransactionsRepository _repository;
  final Logger _logger;
  final ClockPort _clock;
  final SavingsGoalProgressPort? _savingsGoalProgressPort;

  const CreateTransactionUseCase({
    required TransactionsRepository repository,
    required Logger logger,
    required ClockPort clock,
    SavingsGoalProgressPort? savingsGoalProgressPort,
  })  : _repository = repository,
        _logger = logger,
        _clock = clock,
        _savingsGoalProgressPort = savingsGoalProgressPort;

  Future<Result<Transaction>> call({
    required TransactionDraft draft,
    required String userId,
    SecrecyConfig? secrecyConfig,
  }) async {
    try {
      final validationError = TransactionValidator.validate(draft);
      if (validationError != null) {
        return Error(Failure.validation(validationError));
      }

      final nowUtc = DateTime.now().toUtc();
      final transactionId = const Uuid().v4();

      final splits = (draft.splits ?? [])
          .map(
            (splitDraft) => TransactionSplit(
              id: splitDraft.id ?? const Uuid().v4(),
              transactionId: transactionId,
              categoryId: splitDraft.categoryId,
              amount: splitDraft.amount,
              description: splitDraft.description,
              createdAt: nowUtc,
              updatedAt: nowUtc,
              syncStatus: SyncStatus.pending,
            ),
          )
          .toList();

      var transaction = Transaction(
        id: transactionId,
        accountId: draft.accountId,
        linkedAccountId: draft.linkedAccountId,
        userId: userId,
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
        isUserEdited:
            draft.customCategoryId != null ||
            draft.merchantName != null ||
            draft.comment != null,
        auditStatus: AuditStatus.verified,
        isSplit: splits.isNotEmpty,
        savingsGoalId: draft.savingsGoalId,
        isWithdrawal: draft.isWithdrawal ?? false,
        createdAt: nowUtc,
        updatedAt: nowUtc,
        syncStatus: SyncStatus.pending,
      );

      if (_shouldLockSync(draft.type, draft.amount, secrecyConfig)) {
        final elapsed = await _clock.elapsedRealtimeMs();
        transaction = transaction.copyWith(
          syncLockedStartedAt: elapsed,
          syncLockedDurationMs: secrecyConfig!.timeoutSeconds * 1000,
        );
      }

      await _repository.createTransaction(transaction, splits);

      // Этап 12: транзакция привязана к цели накопления —
      // обновляем прогресс и черновую сумму (ТЗ 6.3.16.14.12).
      await _syncSavingsGoalProgress(transaction);

      return Success(transaction);
    } catch (e, stack) {
      _logger.e('CreateTransactionUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString()));
    }
  }

  /// Обновляет current_amount и draft_amount цели накопления.
  ///
  /// Ошибка обновления прогресса логируется, но НЕ отменяет
  /// уже созданную транзакцию.
  Future<void> _syncSavingsGoalProgress(Transaction transaction) async {
    final port = _savingsGoalProgressPort;
    final goalId = transaction.savingsGoalId;
    if (port == null || goalId == null) return;
    try {
      final delta =
          transaction.isWithdrawal ? -transaction.amount : transaction.amount;
      await port.updateProgress(
        goalId: goalId,
        deltaKopecks: delta,
        draftAmountKopecks:
            transaction.isWithdrawal ? null : transaction.amount,
      );
    } catch (e, stack) {
      _logger.e(
        'Failed to update savings goal progress',
        error: e,
        stackTrace: stack,
      );
    }
  }

  bool _shouldLockSync(
    TransactionType type,
    int amount,
    SecrecyConfig? config,
  ) {
    if (config == null || !config.enabled) {
      return false;
    }
    return type == TransactionType.expense && amount >= config.threshold;
  }
}
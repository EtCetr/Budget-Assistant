import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/create_transaction_usecase.dart';
import '../entities/savings_goal.dart';

/// Пополнение цели накопления.
///
/// Создаёт транзакцию type='expense' с savings_goal_id != null.
/// Прогресс (current_amount) обновляет сам CreateTransactionUseCase
/// через SavingsGoalProgressPort — единственная точка изменения.
class ContributeToSavingsGoalUseCase {
  ContributeToSavingsGoalUseCase({
    required CreateTransactionUseCase createTransaction,
    required Logger logger,
  })  : _createTransaction = createTransaction,
        _logger = logger;

  final CreateTransactionUseCase _createTransaction;
  final Logger _logger;

  Future<Result<Transaction>> call({
    required SavingsGoal goal,
    required String accountId,
    required int amountKopecks,
    String? comment,
    required String userId,
  }) async {
    try {
      if (amountKopecks <= 0) {
        return const Error(Failure.validation('Amount must be positive'));
      }

      final draft = TransactionDraft(
        accountId: accountId,
        date: DateTime.now(),
        amount: amountKopecks,
        type: TransactionType.expense,
        spaceId: goal.spaceId,
        savingsGoalId: goal.id,
        isWithdrawal: false,
        comment: comment ?? 'Пополнение цели "${goal.name}"',
      );

      return await _createTransaction(draft: draft, userId: userId);
    } catch (e, st) {
      _logger.e('ContributeToSavingsGoalUseCase failed', error: e, stackTrace: st);
      return Error(Failure.unexpected(e.toString(), st));
    }
  }
}
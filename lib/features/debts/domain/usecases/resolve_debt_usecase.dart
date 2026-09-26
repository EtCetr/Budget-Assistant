import 'package:budget_assistant/core/logger.dart';
import '../repositories/debts_repository.dart';

/// Закрытие долга БЕЗ компенсирующих транзакций:
/// forgiven / paid_offline / resolved (6.3.13.9).
/// Компенсирующие транзакции — CloseDebtUseCase (13.3, ТОМ 4 §6).
/// Право закрытия — только создатель долга.
class ResolveDebtUseCase {
  ResolveDebtUseCase({required DebtsRepository repository})
      : _repository = repository;

  final DebtsRepository _repository;

  Future<void> call({
    required String debtId,
    required String status,
    required String actorUserId,
  }) async {
    try {
      final debt = await _repository.getById(debtId);
      if (debt == null) throw StateError('Debt not found: $debtId');
      if (debt.createdBy != actorUserId) {
        throw StateError('Only debt creator can resolve it: $debtId');
      }
      await _repository.resolve(debtId: debtId, status: status);
    } catch (e, st) {
      AppLogger.e('ResolveDebtUseCase failed: $e', e, st);
      rethrow;
    }
  }
}
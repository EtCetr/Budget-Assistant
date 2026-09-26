import 'package:budget_assistant/core/logger.dart';
import '../repositories/debts_repository.dart';

/// Удаление долга (6.3.13.9): только создатель. Мягкое закрытие
/// (resolved/forgiven) предпочтительнее — см. ResolveDebtUseCase.
class DeleteDebtUseCase {
  DeleteDebtUseCase({required DebtsRepository repository})
      : _repository = repository;

  final DebtsRepository _repository;

  Future<void> call({
    required String debtId,
    required String actorUserId,
  }) async {
    try {
      final existing = await _repository.getById(debtId);
      if (existing == null) throw StateError('Debt not found: $debtId');
      if (existing.createdBy != actorUserId) {
        throw StateError('Only debt creator can delete it: $debtId');
      }
      await _repository.delete(debtId);
    } catch (e, st) {
      AppLogger.e('DeleteDebtUseCase failed: $e', e, st);
      rethrow;
    }
  }
}
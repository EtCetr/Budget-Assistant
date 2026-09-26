import 'package:budget_assistant/core/logger.dart';
import '../repositories/debts_repository.dart';

/// Выход члена семьи (6.3.13.8): активные долги с ним помечаются
/// is_ex_member_debt = true. Долги НЕ удаляются и НЕ закрываются —
/// финансовые обязательства остаются действительными.
class MarkDebtsAsExMemberUseCase {
  MarkDebtsAsExMemberUseCase({required DebtsRepository repository})
      : _repository = repository;

  final DebtsRepository _repository;

  Future<int> call({required String memberUserId}) async {
    try {
      return await _repository.markExMember(memberUserId: memberUserId);
    } catch (e, st) {
      AppLogger.e('MarkDebtsAsExMemberUseCase failed: $e', e, st);
      rethrow;
    }
  }
}
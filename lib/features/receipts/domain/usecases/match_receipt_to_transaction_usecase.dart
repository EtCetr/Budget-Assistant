import '../dtos/receipt_match_result.dart';
import '../dtos/transaction_match_candidate.dart';

/// Матчинг чека к транзакции: окно +/-48ч и +/-5% суммы.
/// Транзакции в audit_status='pending' не привязываются: если других нет -> сценарий Г.
class MatchReceiptToTransactionUseCase {
  ReceiptMatchResult call({
    required List<TransactionMatchCandidate> candidates,
    required int totalKop,
    required DateTime dateUtc,
  }) {
    final tolerance = (totalKop * 0.05).round();
    final inWindow = candidates.where((c) {
      final dh = c.dateUtc.difference(dateUtc).inHours.abs();
      final da = (c.amountKop - totalKop).abs();
      return dh <= 48 && da <= tolerance;
    }).toList();
    final verified = inWindow.where((c) => c.auditStatus != 'pending').toList();
    final pending = inWindow.where((c) => c.auditStatus == 'pending').toList();

    MatchScenario scenario;
    if (verified.isEmpty && pending.isNotEmpty) {
      scenario = MatchScenario.pendingBlocked;
    } else if (verified.isEmpty) {
      scenario = MatchScenario.none;
    } else if (verified.length == 1) {
      scenario = MatchScenario.single;
    } else {
      scenario = MatchScenario.multiple;
    }
    return ReceiptMatchResult(
      scenario: scenario,
      autoCandidates: verified,
      pendingCandidates: pending,
    );
  }
}
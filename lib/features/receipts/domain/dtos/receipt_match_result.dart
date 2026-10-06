import 'package:freezed_annotation/freezed_annotation.dart';
import 'transaction_match_candidate.dart';

part 'receipt_match_result.freezed.dart';

/// Сценарии матчинга (ТЗ 6.3.23): А=нет кандидатов, Б=один, В=несколько,
/// Г=все кандидаты в audit pending (привязка заблокирована).
enum MatchScenario { none, single, multiple, pendingBlocked }

@freezed
abstract class ReceiptMatchResult with _$ReceiptMatchResult {
  const factory ReceiptMatchResult({
    required MatchScenario scenario,
    required List<TransactionMatchCandidate> autoCandidates, // verified
    required List<TransactionMatchCandidate> pendingCandidates,
  }) = _ReceiptMatchResult;
}
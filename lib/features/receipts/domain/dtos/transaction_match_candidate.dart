import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_match_candidate.freezed.dart';

/// Кандидат на привязку чека (проекция транзакции, без E2E-полей).
@freezed
abstract class TransactionMatchCandidate with _$TransactionMatchCandidate {
  const factory TransactionMatchCandidate({
    required String id,
    required DateTime dateUtc,
    required int amountKop,
    required String auditStatus, // 'verified' | 'pending' | ...
    required bool hasReceipt,
  }) = _TransactionMatchCandidate;
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'parsed_row.dart';

part 'hold_confirmation_candidate.freezed.dart';

/// Действие пользователя.
enum HoldAction { confirm, skip }

/// Подтверждение hold-операции (audit_status='pending' → 'verified').
@freezed
abstract class HoldConfirmationCandidate with _$HoldConfirmationCandidate {
  const factory HoldConfirmationCandidate({
    required String id,
    required ParsedRow importedRow,
    required String existingTransactionId,
    required DateTime existingDate,
    required int existingAmountKopecks,
    required String? existingMerchantName,
    @Default(HoldAction.confirm) HoldAction selectedAction,
  }) = _HoldConfirmationCandidate;
}
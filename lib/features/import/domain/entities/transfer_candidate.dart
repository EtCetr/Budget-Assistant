import 'package:freezed_annotation/freezed_annotation.dart';
import 'parsed_row.dart';

part 'transfer_candidate.freezed.dart';

/// Сценарий детекции перевода.
enum TransferScenario { interbank, sbp }

/// Действие пользователя.
enum TransferAction { merge, keep }

/// Пара расход+доход между своими счетами.
@freezed
abstract class TransferCandidate with _$TransferCandidate {
  const factory TransferCandidate({
    required String id,
    required TransferScenario scenario,
    required ParsedRow expenseRow,
    required ParsedRow incomeRow,
    required int amountKopecks,
    required String sourceAccountId,
    required String targetAccountId,
    /// Разница во времени (для отображения).
    required Duration timeDifference,
    @Default(TransferAction.merge) TransferAction selectedAction,
  }) = _TransferCandidate;
}
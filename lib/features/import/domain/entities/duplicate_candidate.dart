import 'package:freezed_annotation/freezed_annotation.dart';
import 'parsed_row.dart';

part 'duplicate_candidate.freezed.dart';

/// Действие пользователя с дубликатом.
enum DuplicateAction { skip, replace, both }

/// Пара: импортируемая строка + существующая транзакция.
@freezed
abstract class DuplicateCandidate with _$DuplicateCandidate {
  const factory DuplicateCandidate({
    required String id,
    required ParsedRow importedRow,
    /// ID существующей транзакции в БД.
    required String existingTransactionId,
    required DateTime existingDate,
    required int existingAmountKopecks,
    required String? existingMerchantName,
    /// 0.0–1.0 степень совпадения.
    required double matchScore,
    @Default(DuplicateAction.skip) DuplicateAction selectedAction,
  }) = _DuplicateCandidate;
}
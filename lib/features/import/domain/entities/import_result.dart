import 'package:freezed_annotation/freezed_annotation.dart';
import 'parsed_row.dart';
import 'duplicate_candidate.dart';
import 'transfer_candidate.dart';
import 'hold_confirmation_candidate.dart';

part 'import_result.freezed.dart';

/// Результат парсинга + детекции. Передаётся через GoRouter extra.
@freezed
abstract class ImportResult with _$ImportResult {
  const factory ImportResult({
    required String bankName,
    required String bankCode,
    required String fileName,
    required int totalRows,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String targetAccountId,
    String? targetSpaceId,
    required List<ParsedRow> rows,
    @Default([]) List<DuplicateCandidate> duplicates,
    @Default([]) List<TransferCandidate> transfers,
    @Default([]) List<HoldConfirmationCandidate> holdConfirmations,
  }) = _ImportResult;
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'parsed_row.dart';

part 'secrecy_candidate.freezed.dart';

/// Кандидат в подарки (попал в период секретности).
@freezed
abstract class SecrecyCandidate with _$SecrecyCandidate {
  const factory SecrecyCandidate({
    required String id,
    required ParsedRow transaction,
    required String relatedHolidayId,
    required String relatedHolidayName,
    required DateTime relatedHolidayDate,
    /// 0.0–1.0 от DetectGiftCandidateUseCase.
    required double confidence,
    @Default(true) bool isSelectedByDefault,
    /// Категория, выбранная пользователем в UI.
    String? selectedCategoryId,
  }) = _SecrecyCandidate;
}
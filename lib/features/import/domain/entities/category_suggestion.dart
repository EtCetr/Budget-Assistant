import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_suggestion.freezed.dart';

/// Источник подсказки категоризации.
enum CategorySuggestionSource { userRule, history, bankMapping }

/// AI-подсказка категории для транзакции.
@freezed
abstract class CategorySuggestion with _$CategorySuggestion {
  const factory CategorySuggestion({
    required String categoryId,
    /// 0.0–1.0.
    required double confidence,
    required CategorySuggestionSource source,
  }) = _CategorySuggestion;
}
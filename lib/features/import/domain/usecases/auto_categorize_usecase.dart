import 'package:logger/logger.dart';
import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../entities/parsed_row.dart';
import '../entities/category_suggestion.dart';

/// Batch AI категоризация импортированных транзакций (ТЗ 6.3.26.11).
///
/// 3 уровня поиска:
/// 1. category_rules (пользовательские правила) → confidence = 1.0
/// 2. История транзакций (частота категорий) → confidence = частота
/// 3. Маппинг bank_category → confidence = 0.6
///
/// Порог применения: confidence >= 0.7
class AutoCategorizeUseCase {
  final AppDatabase _db;
  final Logger _logger;

  AutoCategorizeUseCase({
    required AppDatabase db,
    required Logger logger,
  })  : _db = db,
        _logger = logger;

  /// Возвращает подсказку категории для одной транзакции.
  Future<CategorySuggestion?> suggestFor({
    required String merchantName,
    String? bankCategory,
    required String userId,
    String? spaceId,
  }) async {
    try {
      final merchantLower = merchantName.toLowerCase().trim();

      // Уровень 1: category_rules (trigger_string — OPEN, LIKE поиск)
      final rule = await _findByRule(merchantLower, userId, spaceId);
      if (rule != null) return rule;

      // Уровень 2: история транзакций пользователя
      final history = await _findByHistory(merchantLower, userId);
      if (history != null) return history;

      // Уровень 3: маппинг bank_category
      if (bankCategory != null && bankCategory.isNotEmpty) {
        final bankMapping = await _findByBankCategory(bankCategory, userId, spaceId);
        if (bankMapping != null) return bankMapping;
      }

      return null;
    } catch (e, st) {
      _logger.e('AutoCategorizeUseCase.suggestFor failed',
          error: e, stackTrace: st);
      return null;
    }
  }

  /// Batch-обработка: применяет подсказки ко всем строкам.
  Future<List<ParsedRow>> categorizeAll({
    required List<ParsedRow> rows,
    required String userId,
    String? spaceId,
  }) async {
    final result = <ParsedRow>[];
    try {
      for (final row in rows) {
        final suggestion = await suggestFor(
          merchantName: row.merchantName,
          bankCategory: row.bankCategory,
          userId: userId,
          spaceId: spaceId,
        );
        if (suggestion != null && suggestion.confidence >= 0.7) {
          result.add(row.copyWith(assignedCategoryId: suggestion.categoryId));
        } else {
          result.add(row);
        }
      }
      _logger.i('AutoCategorize: обработано ${result.length} строк');
    } catch (e, st) {
      _logger.e('AutoCategorizeUseCase.categorizeAll failed',
          error: e, stackTrace: st);
      return rows;
    }
    return result;
  }

  Future<CategorySuggestion?> _findByRule(
    String merchantLower,
    String userId,
    String? spaceId,
  ) async {
    try {
      // trigger_string — OPEN (не E2E), можно искать LIKE
      final rules = await (_db.select(_db.categoryRules)
            ..where((r) => r.userId.equals(userId)))
          .get();

      for (final rule in rules) {
        final trigger = rule.triggerString.toLowerCase();
        if (merchantLower.contains(trigger) || trigger.contains(merchantLower)) {
          return CategorySuggestion(
            categoryId: rule.targetCategoryId,
            confidence: 1.0,
            source: CategorySuggestionSource.userRule,
          );
        }
      }
    } catch (e, st) {
      _logger.e('_findByRule failed', error: e, stackTrace: st);
    }
    return null;
  }

  Future<CategorySuggestion?> _findByHistory(
    String merchantLower,
    String userId,
  ) async {
    try {
      final history = await (_db.select(_db.transactions)
            ..where((t) =>
                t.userId.equals(userId) &
                t.merchantName.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(100))
          .get();

      final matching = history.where((t) {
        final m = t.merchantName?.toLowerCase() ?? '';
        return m.contains(merchantLower) || merchantLower.contains(m);
      }).toList();

      if (matching.isEmpty) return null;

      // Группируем по category_id, считаем частоту
      final counts = <String, int>{};
      for (final txn in matching) {
        final catId = txn.customCategoryId;
        if (catId != null) {
          counts[catId] = (counts[catId] ?? 0) + 1;
        }
      }

      if (counts.isEmpty) return null;

      final topEntry = counts.entries.reduce((a, b) => a.value > b.value ? a : b);
      final confidence = topEntry.value / matching.length;

      if (confidence >= 0.5) {
        return CategorySuggestion(
          categoryId: topEntry.key,
          confidence: confidence,
          source: CategorySuggestionSource.history,
        );
      }
    } catch (e, st) {
      _logger.e('_findByHistory failed', error: e, stackTrace: st);
    }
    return null;
  }

  Future<CategorySuggestion?> _findByBankCategory(
    String bankCategory,
    String userId,
    String? spaceId,
  ) async {
    try {
      // Ищем правило с bank_name = 'ANY' или совпадающим
      final rules = await (_db.select(_db.categoryRules)
            ..where((r) =>
                r.userId.equals(userId) &
                (r.bankName.equals('ANY') |
                    r.bankName.equals(bankCategory))))
          .get();

      for (final rule in rules) {
        if (rule.triggerString.toLowerCase() == bankCategory.toLowerCase()) {
          return CategorySuggestion(
            categoryId: rule.targetCategoryId,
            confidence: 0.6,
            source: CategorySuggestionSource.bankMapping,
          );
        }
      }
    } catch (e, st) {
      _logger.e('_findByBankCategory failed', error: e, stackTrace: st);
    }
    return null;
  }
}
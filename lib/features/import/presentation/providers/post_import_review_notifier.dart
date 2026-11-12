import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/import/domain/entities/category_suggestion.dart';
import 'package:budget_assistant/features/import/domain/entities/duplicate_candidate.dart';
import 'package:budget_assistant/features/import/domain/entities/finalize_outcome.dart';
import 'package:budget_assistant/features/import/domain/entities/hold_confirmation_candidate.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/transaction_scope_providers.dart';
import 'import_usecase_providers.dart';
import 'package:budget_assistant/core/providers/transactions_trigger_provider.dart';

/// Состояние экрана проверки импорта.
class PostImportReviewState {
  const PostImportReviewState({
    this.result,
    this.selectedRows = const {},
    this.duplicates = const [],
    this.holds = const [],
    this.rows = const [],
    this.suggestions = const {},
    this.suggestionsLoading = false,
    this.activeTab = 3,
    this.isFinalizing = false,
    this.scopeSpaceIds = const {},
    this.scopePersonal = true,
    this.scopesInitialized = false,
  });

  final ImportResult? result;
  final Set<int> selectedRows;
  final List<DuplicateCandidate> duplicates;
  final List<HoldConfirmationCandidate> holds;
  final List<ParsedRow> rows;
  final Map<int, CategorySuggestion?> suggestions;
  final bool suggestionsLoading;
  final int activeTab;
  final bool isFinalizing;

  /// Этап 23.6c: куда дополнительно записать импортированные операции.
  final Set<String> scopeSpaceIds;
  final bool scopePersonal;
  final bool scopesInitialized;

  PostImportReviewState copyWith({
    ImportResult? result,
    Set<int>? selectedRows,
    List<DuplicateCandidate>? duplicates,
    List<HoldConfirmationCandidate>? holds,
    List<ParsedRow>? rows,
    Map<int, CategorySuggestion?>? suggestions,
    bool? suggestionsLoading,
    int? activeTab,
    bool? isFinalizing,
    Set<String>? scopeSpaceIds,
    bool? scopePersonal,
    bool? scopesInitialized,
  }) {
    return PostImportReviewState(
      result: result ?? this.result,
      selectedRows: selectedRows ?? this.selectedRows,
      duplicates: duplicates ?? this.duplicates,
      holds: holds ?? this.holds,
      rows: rows ?? this.rows,
      suggestions: suggestions ?? this.suggestions,
      suggestionsLoading: suggestionsLoading ?? this.suggestionsLoading,
      activeTab: activeTab ?? this.activeTab,
      isFinalizing: isFinalizing ?? this.isFinalizing,
      scopeSpaceIds: scopeSpaceIds ?? this.scopeSpaceIds,
      scopePersonal: scopePersonal ?? this.scopePersonal,
      scopesInitialized: scopesInitialized ?? this.scopesInitialized,
    );
  }
}

class PostImportReviewNotifier extends Notifier<PostImportReviewState> {
  bool _disposed = false;

  @override
  PostImportReviewState build() {
    ref.onDispose(() => _disposed = true);
    return const PostImportReviewState();
  }

  void init(ImportResult result) {
    state = PostImportReviewState(
      result: result,
      selectedRows: result.rows.map((r) => r.rowIndex).toSet(),
      duplicates: result.duplicates,
      holds: result.holdConfirmations,
      rows: result.rows,
    );
    _loadSuggestions();
  }

  /// Этап 23.6c: по умолчанию отмечены все пространства (личное — всегда).
  void initScopes({
    required List<String> allSpaceIds,
    required String? baseSpaceId,
  }) {
    if (state.scopesInitialized) return;
    state = state.copyWith(
      scopeSpaceIds: allSpaceIds.toSet(),
      scopePersonal: true,
      scopesInitialized: true,
    );
  }

  void toggleScopeSpace(String spaceId, bool value) {
    MotionTokens.selection();
    final next = Set<String>.of(state.scopeSpaceIds);
    if (value) {
      next.add(spaceId);
    } else {
      next.remove(spaceId);
    }
    state = state.copyWith(scopeSpaceIds: next);
  }

  void setScopePersonal(bool value) {
    MotionTokens.selection();
    state = state.copyWith(scopePersonal: value);
  }

  Future<void> _loadSuggestions() async {
    final r = state.result;
    if (r == null) return;
    state = state.copyWith(suggestionsLoading: true);
    try {
      final useCase = ref.read(autoCategorizeUseCaseProvider);
      final userId = ref.read(currentUserIdProvider);
      final map = <int, CategorySuggestion?>{};
      for (final row in r.rows) {
        if (row.assignedCategoryId != null) continue;
        map[row.rowIndex] = await useCase.suggestFor(
          merchantName: row.merchantName,
          bankCategory: row.bankCategory,
          userId: userId,
          spaceId: r.targetSpaceId,
        );
      }
      if (!_disposed) {
        state = state.copyWith(suggestions: map, suggestionsLoading: false);
      }
    } catch (_) {
      if (!_disposed) state = state.copyWith(suggestionsLoading: false);
    }
  }

  void setTab(int tab) {
    MotionTokens.selection();
    state = state.copyWith(activeTab: tab);
  }

  void toggleRow(int rowIndex, bool value) {
    MotionTokens.selection();
    final next = Set<int>.of(state.selectedRows);
    if (value) {
      next.add(rowIndex);
    } else {
      next.remove(rowIndex);
    }
    state = state.copyWith(selectedRows: next);
  }

  void setDaySelected(List<int> indices, bool value) {
    MotionTokens.selection();
    final next = Set<int>.of(state.selectedRows);
    for (final i in indices) {
      if (value) {
        next.add(i);
      } else {
        next.remove(i);
      }
    }
    state = state.copyWith(selectedRows: next);
  }

  void toggleTransfer(int rowIndex) {
    MotionTokens.selection();
    state = state.copyWith(
        rows: _mapRow(rowIndex, (r) => r.copyWith(isTransfer: !r.isTransfer)));
  }

  void setCategory(int rowIndex, String? categoryId) {
    MotionTokens.selection();
    state = state.copyWith(
        rows: _mapRow(rowIndex, (r) => r.copyWith(assignedCategoryId: categoryId)));
  }

  void applySuggestion(int rowIndex) {
    final s = state.suggestions[rowIndex];
    if (s == null) return;
    MotionTokens.light();
    setCategory(rowIndex, s.categoryId);
  }

  void applyAllSuggestions() {
    MotionTokens.medium();
    var rows = state.rows;
    for (final entry in state.suggestions.entries) {
      final s = entry.value;
      if (s == null || s.confidence < 0.7) continue;
      final idx = entry.key;
      rows = [
        for (final r in rows)
          if (r.rowIndex == idx && r.assignedCategoryId == null)
            r.copyWith(assignedCategoryId: s.categoryId)
          else
            r
      ];
    }
    state = state.copyWith(rows: rows);
  }

  void setDuplicateAction(String id, DuplicateAction action) {
    MotionTokens.selection();
    state = state.copyWith(duplicates: [
      for (final d in state.duplicates)
        if (d.id == id) d.copyWith(selectedAction: action) else d
    ]);
  }

  void skipAllDuplicates() {
    MotionTokens.medium();
    state = state.copyWith(duplicates: [
      for (final d in state.duplicates)
        d.copyWith(selectedAction: DuplicateAction.skip)
    ]);
  }

  void setHoldAction(String id, HoldAction action) {
    MotionTokens.selection();
    state = state.copyWith(holds: [
      for (final h in state.holds)
        if (h.id == id) h.copyWith(selectedAction: action) else h
    ]);
  }

  List<ParsedRow> _mapRow(int rowIndex, ParsedRow Function(ParsedRow) f) {
    return [for (final r in state.rows) if (r.rowIndex == rowIndex) f(r) else r];
  }

  List<MapEntry<DateTime, List<ParsedRow>>> dayGroups() {
    final map = <DateTime, List<ParsedRow>>{};
    for (final row in state.rows) {
      final d = DateTime(row.date.year, row.date.month, row.date.day);
      (map[d] ??= []).add(row);
    }
    final keys = map.keys.toList()..sort((a, b) => b.compareTo(a));
    return [for (final k in keys) MapEntry(k, map[k]!)];
  }

  ({int count, int totalKopecks}) summary() {
    var count = 0;
    var total = 0;
    for (final row in state.rows) {
      if (!state.selectedRows.contains(row.rowIndex)) continue;
      count++;
      total += row.amountKopecks;
    }
    return (count: count, totalKopecks: total);
  }

  int get uncategorizedCount {
    var n = 0;
    for (final row in state.rows) {
      if (row.isTransfer) continue;
      if (row.assignedCategoryId == null) n++;
    }
    return n;
  }

  int get transferCount => state.rows.where((r) => r.isTransfer).length;

  Future<FinalizeOutcome?> finalize() async {
    final r = state.result;
    if (r == null) return null;
    MotionTokens.light();
    state = state.copyWith(isFinalizing: true);
    try {
      final userId = ref.read(currentUserIdProvider);
      final outcome = await ref.read(finalizeImportUseCaseProvider).call(
        importResult: r.copyWith(
          rows: state.rows,
          duplicates: state.duplicates,
          transfers: const [],
          holdConfirmations: state.holds,
        ),
        userId: userId,
        selectedRowIndices: state.selectedRows,
      );
      if (outcome != null) {
        // Этап 23.6c: связанные копии в отмеченных пространствах.
        await _createScopeCopies(outcome, userId, r.targetSpaceId);
        ref.read(transactionsTriggerProvider.notifier).bump();
      }
      return outcome;
    } catch (_) {
      MotionTokens.error();
      return null;
    } finally {
      if (!_disposed) state = state.copyWith(isFinalizing: false);
    }
  }

  Future<void> _createScopeCopies(
    FinalizeOutcome outcome,
    String userId,
    String? baseSpaceId,
  ) async {
    final extra =
        state.scopeSpaceIds.where((s) => s != baseSpaceId).toList();
    final includePersonal = state.scopePersonal && baseSpaceId != null;
    if (extra.isEmpty && !includePersonal) return;
    try {
      final useCase = ref.read(addTransactionCopiesUseCaseProvider);
      for (final c in outcome.created) {
        await useCase(
          transactionId: c.id,
          spaceIds: extra,
          userId: userId,
          includePersonal: includePersonal,
        );
      }
    } catch (e, st) {
      AppLogger.e('Import scope copies failed', e, st);
    }
  }
}

final postImportReviewProvider =
    NotifierProvider<PostImportReviewNotifier, PostImportReviewState>(
        PostImportReviewNotifier.new);
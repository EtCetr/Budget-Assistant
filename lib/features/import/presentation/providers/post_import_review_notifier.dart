import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/import/domain/entities/category_suggestion.dart';
import 'package:budget_assistant/features/import/domain/entities/duplicate_candidate.dart';
import 'package:budget_assistant/features/import/domain/entities/finalize_outcome.dart';
import 'package:budget_assistant/features/import/domain/entities/hold_confirmation_candidate.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_candidate.dart';
import 'import_usecase_providers.dart';

/// Состояние экрана проверки импорта.
class PostImportReviewState {
  const PostImportReviewState({
    this.result,
    this.selectedRows = const {},
    this.duplicates = const [],
    this.transfers = const [],
    this.holds = const [],
    this.rows = const [],
    this.suggestions = const {},
    this.suggestionsLoading = false,
    this.activeTab = 2,
    this.isFinalizing = false,
  });

  final ImportResult? result;
  final Set<int> selectedRows;
  final List<DuplicateCandidate> duplicates;
  final List<TransferCandidate> transfers;
  final List<HoldConfirmationCandidate> holds;
  final List<ParsedRow> rows;
  final Map<int, CategorySuggestion?> suggestions;
  final bool suggestionsLoading;

  /// 0 дубли, 1 переводы, 2 hold, 3 категории (дефолт).
  final int activeTab;
  final bool isFinalizing;

  PostImportReviewState copyWith({
    ImportResult? result,
    Set<int>? selectedRows,
    List<DuplicateCandidate>? duplicates,
    List<TransferCandidate>? transfers,
    List<HoldConfirmationCandidate>? holds,
    List<ParsedRow>? rows,
    Map<int, CategorySuggestion?>? suggestions,
    bool? suggestionsLoading,
    int? activeTab,
    bool? isFinalizing,
  }) {
    return PostImportReviewState(
      result: result ?? this.result,
      selectedRows: selectedRows ?? this.selectedRows,
      duplicates: duplicates ?? this.duplicates,
      transfers: transfers ?? this.transfers,
      holds: holds ?? this.holds,
      rows: rows ?? this.rows,
      suggestions: suggestions ?? this.suggestions,
      suggestionsLoading: suggestionsLoading ?? this.suggestionsLoading,
      activeTab: activeTab ?? this.activeTab,
      isFinalizing: isFinalizing ?? this.isFinalizing,
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
      transfers: result.transfers,
      holds: result.holdConfirmations,
      rows: result.rows,
    );
    _loadSuggestions();
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

  void setCategory(int rowIndex, String? categoryId) {
    MotionTokens.selection();
    state = state.copyWith(rows: _mapRow(rowIndex, (r) => r.copyWith(assignedCategoryId: categoryId)));
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

  void setTransferAction(String id, TransferAction action) {
    MotionTokens.selection();
    state = state.copyWith(transfers: [
      for (final t in state.transfers)
        if (t.id == id) t.copyWith(selectedAction: action) else t
    ]);
  }

  void mergeAllTransfers() {
    MotionTokens.medium();
    state = state.copyWith(transfers: [
      for (final t in state.transfers)
        t.copyWith(selectedAction: TransferAction.merge)
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

  /// Группировка строк по дням (UTC-дата), сортировка по убыванию.
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
      if (row.assignedCategoryId == null) n++;
    }
    return n;
  }

  Future<FinalizeOutcome?> finalize() async {
    final r = state.result;
    if (r == null) return null;
    MotionTokens.light();
    state = state.copyWith(isFinalizing: true);
    try {
      final userId = ref.read(currentUserIdProvider);
      return await ref.read(finalizeImportUseCaseProvider).call(
            importResult: r.copyWith(
              rows: state.rows,
              duplicates: state.duplicates,
              transfers: state.transfers,
              holdConfirmations: state.holds,
            ),
            userId: userId,
            selectedRowIndices: state.selectedRows,
          );
    } catch (_) {
      MotionTokens.error();
      return null;
    } finally {
      if (!_disposed) state = state.copyWith(isFinalizing: false);
    }
  }
}

final postImportReviewProvider =
    NotifierProvider<PostImportReviewNotifier, PostImportReviewState>(
        PostImportReviewNotifier.new);
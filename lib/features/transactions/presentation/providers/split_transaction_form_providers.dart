import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/split_position_draft.dart';
import '../../domain/models/transaction.dart';
import 'create_transaction_providers.dart';
import 'split_drafts_providers.dart';
import 'split_transaction_providers.dart';

final Logger _logger = Logger();

/// Состояние экрана разделения транзакции (ТЗ 6.3.15).
class SplitTransactionFormState {
  const SplitTransactionFormState({
    this.transactionId = '',
    this.source,
    this.positions = const <SplitPositionDraft>[],
    this.initialized = false,
    this.isDirty = false,
    this.draftAvailable = false,
    this.existingSplitsCount = 0,
  });

  final String transactionId;
  final Transaction? source;
  final List<SplitPositionDraft> positions;
  final bool initialized;
  final bool isDirty;
  final bool draftAvailable;
  final int existingSplitsCount;

  SplitTransactionFormState copyWith({
    String? transactionId,
    Transaction? source,
    List<SplitPositionDraft>? positions,
    bool? initialized,
    bool? isDirty,
    bool? draftAvailable,
    int? existingSplitsCount,
  }) {
    return SplitTransactionFormState(
      transactionId: transactionId ?? this.transactionId,
      source: source ?? this.source,
      positions: positions ?? this.positions,
      initialized: initialized ?? this.initialized,
      isDirty: isDirty ?? this.isDirty,
      draftAvailable: draftAvailable ?? this.draftAvailable,
      existingSplitsCount: existingSplitsCount ?? this.existingSplitsCount,
    );
  }
}

class SplitTransactionFormNotifier extends Notifier<SplitTransactionFormState> {
  Timer? _draftTimer;
  List<SplitPositionDraft>? _pendingDraft;
  int _posCounter = 0;

  @override
  SplitTransactionFormState build() {
    ref.onDispose(() => _draftTimer?.cancel());
    return const SplitTransactionFormState();
  }

  Future<void> init(String transactionId) async {
    _draftTimer?.cancel();
    _pendingDraft = null;
    state = const SplitTransactionFormState();
    try {
      final tx = await ref
          .read(transactionsRepositoryProvider)
          .getTransactionById(transactionId);
      if (tx == null) {
        state = const SplitTransactionFormState(initialized: true);
        return;
      }
      final splits = await ref
          .read(transactionsRepositoryProvider)
          .getSplitsForTransaction(transactionId);
      final fromSplits = splits
          .map(
            (s) => SplitPositionDraft(
              id: s.id,
              name: '',
              amount: s.amount,
              categoryId: s.categoryId,
              description: s.description ?? '',
              fromOcr: false,
            ),
          )
          .toList();
      final draft = await ref
          .read(splitDraftsRepositoryProvider)
          .getFreshPositions(transactionId);
      _pendingDraft = draft;
      state = SplitTransactionFormState(
        transactionId: transactionId,
        source: tx,
        positions: fromSplits,
        initialized: true,
        draftAvailable: draft != null,
        existingSplitsCount: splits.length,
      );
    } catch (e, st) {
      _logger.e('SplitForm init failed', error: e, stackTrace: st);
      state = const SplitTransactionFormState(initialized: true);
    }
  }

  Future<void> restoreDraft() async {
    final draft = _pendingDraft;
    if (draft == null) return;
    _pendingDraft = null;
    _touch(state.copyWith(positions: draft, draftAvailable: false));
  }

  Future<void> discardDraft() async {
    _pendingDraft = null;
    state = state.copyWith(draftAvailable: false);
    try {
      await ref
          .read(splitDraftsRepositoryProvider)
          .deleteByTransaction(state.transactionId);
    } catch (e, st) {
      _logger.w('Failed to delete split draft', error: e, stackTrace: st);
    }
  }

  void addPosition() {
    _posCounter++;
    final id = 'pos_${DateTime.now().microsecondsSinceEpoch}_$_posCounter';
    _touch(state.copyWith(positions: [
      ...state.positions,
      SplitPositionDraft(
        id: id,
        name: '',
        amount: 0,
        categoryId: null,
        description: '',
        fromOcr: false,
      ),
    ]));
  }

  /// Точечное обновление позиции: пересоздаём сущность конструктором
  /// (copyWith freezed не принимает nullable для non-null полей).
  void updatePosition(
    String id, {
    String? name,
    int? amount,
    String? categoryId,
    String? description,
  }) {
    _touch(state.copyWith(positions: [
      for (final p in state.positions)
        if (p.id == id)
          SplitPositionDraft(
            id: p.id,
            name: name ?? p.name,
            amount: amount ?? p.amount,
            categoryId: categoryId ?? p.categoryId,
            description: description ?? p.description,
            fromOcr: p.fromOcr,
          )
        else
          p,
    ]));
  }

  void removePosition(String id) {
    _touch(state.copyWith(
      positions: state.positions.where((p) => p.id != id).toList(),
    ));
  }

  void reorder(int oldIndex, int newIndex) {
    var to = newIndex;
    if (to > oldIndex) to--;
    final next = [...state.positions];
    final item = next.removeAt(oldIndex);
    next.insert(to, item);
    _touch(state.copyWith(positions: next));
  }

  void markSaved() {
    _draftTimer?.cancel();
    _pendingDraft = null;
    state = state.copyWith(isDirty: false, draftAvailable: false);
  }

  void _touch(SplitTransactionFormState next) {
    state = next.copyWith(isDirty: true);
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(seconds: 5), _saveDraft);
  }

  Future<void> _saveDraft() async {
    if (!state.isDirty || state.transactionId.isEmpty) return;
    try {
      await ref
          .read(splitDraftsRepositoryProvider)
          .savePositions(state.transactionId, state.positions);
    } catch (e, st) {
      _logger.w('Failed to autosave split draft', error: e, stackTrace: st);
    }
  }
}

final splitTransactionFormProvider =
    NotifierProvider<SplitTransactionFormNotifier, SplitTransactionFormState>(
  SplitTransactionFormNotifier.new,
);

/// Нераспределённый остаток (копейки): сумма транзакции минус позиции.
final splitRemainderKopecksProvider = Provider<int>((ref) {
  final state = ref.watch(splitTransactionFormProvider);
  final total = state.source?.amount ?? 0;
  var assigned = 0;
  for (final p in state.positions) {
    assigned += p.amount;
  }
  return total - assigned;
});

final splitFormValidationProvider = Provider<String?>((ref) {
  final state = ref.watch(splitTransactionFormProvider);
  final source = state.source;
  if (source == null) return SplitFormErrors.sourceNotFound;
  return ref.watch(validateSplitFormUseCaseProvider)(
    transactionAmountKopecks: source.amount,
    positions: state.positions,
  );
});

/// Тексты ошибок валидации сплита (домен не знает UI-строки экрана).
abstract final class SplitFormErrors {
  static const String sourceNotFound = 'Транзакция не найдена';
}
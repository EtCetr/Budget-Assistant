import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/import/domain/entities/import_secrecy_handoff.dart';
import 'package:budget_assistant/features/import/domain/entities/secrecy_candidate.dart';
import 'package:budget_assistant/features/import/domain/usecases/apply_secrecy_mode_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/build_secrecy_calendar_usecase.dart';
import 'post_import_review_providers.dart';
import 'import_usecase_providers.dart';

final applySecrecyModeUseCaseProvider = Provider<ApplySecrecyModeUseCase>((ref) {
  return ApplySecrecyModeUseCase(
    db: ref.watch(appDatabaseProvider),
    logger: Logger(printer: PrettyPrinter(methodCount: 2)),
  );
});

/// Состояние экрана секретности.
class ImportSecretsState {
  const ImportSecretsState({
    this.handoff,
    this.selectedIds = const {},
    this.categoryByCandidate = const {},
    this.secrecyDaysBefore = 7,
    this.year = 0,
    this.month = 0,
    this.isApplying = false,
  });

  final ImportSecrecyHandoff? handoff;
  final Set<String> selectedIds;
  final Map<String, String> categoryByCandidate;
  final int secrecyDaysBefore;
  final int year;
  final int month;
  final bool isApplying;

  ImportSecretsState copyWith({
    ImportSecrecyHandoff? handoff,
    Set<String>? selectedIds,
    Map<String, String>? categoryByCandidate,
    int? secrecyDaysBefore,
    int? year,
    int? month,
    bool? isApplying,
  }) {
    return ImportSecretsState(
      handoff: handoff ?? this.handoff,
      selectedIds: selectedIds ?? this.selectedIds,
      categoryByCandidate: categoryByCandidate ?? this.categoryByCandidate,
      secrecyDaysBefore: secrecyDaysBefore ?? this.secrecyDaysBefore,
      year: year ?? this.year,
      month: month ?? this.month,
      isApplying: isApplying ?? this.isApplying,
    );
  }
}

class ImportSecretsNotifier extends Notifier<ImportSecretsState> {
  bool _disposed = false;

  @override
  ImportSecretsState build() {
    ref.onDispose(() => _disposed = true);
    return const ImportSecretsState();
  }

  Future<void> init(ImportSecrecyHandoff handoff) async {
    final now = DateTime.now();
    var secrecyDays = 7;
    String? giftCategoryId;
    try {
      final userId = ref.read(currentUserIdProvider);
      final settings = await ref.read(appSettingsDaoProvider).getForUser(userId);
      secrecyDays = settings.secrecyDaysBefore;
      final categories = await ref.read(reviewCategoriesProvider.future);
      for (final c in categories) {
        if (c.name.toLowerCase().contains('подар')) {
          giftCategoryId = c.id;
          break;
        }
      }
    } catch (_) {}
    if (_disposed) return;

    final selected = <String>{};
    final cats = <String, String>{};
    for (final c in handoff.candidates) {
      if (c.isSelectedByDefault) selected.add(c.id);
      if (giftCategoryId != null) cats[c.id] = giftCategoryId;
    }
    state = ImportSecretsState(
      handoff: handoff,
      selectedIds: selected,
      categoryByCandidate: cats,
      secrecyDaysBefore: secrecyDays,
      year: now.year,
      month: now.month,
    );
  }

  void setMonth(int year, int month) {
    MotionTokens.light();
    state = state.copyWith(year: year, month: month);
  }

  void prevMonth() {
    var y = state.year;
    var m = state.month - 1;
    if (m < 1) {
      m = 12;
      y--;
    }
    setMonth(y, m);
  }

  void nextMonth() {
    var y = state.year;
    var m = state.month + 1;
    if (m > 12) {
      m = 1;
      y++;
    }
    setMonth(y, m);
  }

  List<SecrecyCalendarDay> calendarDays() {
    final h = state.handoff;
    if (h == null || state.year == 0) return const [];
    return ref.read(buildSecrecyCalendarUseCaseProvider).call(
          year: state.year,
          month: state.month,
          candidates: h.candidates,
          secrecyDaysBefore: state.secrecyDaysBefore,
        );
  }

  void toggle(String id) {
    MotionTokens.selection();
    final next = Set<String>.of(state.selectedIds);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = state.copyWith(selectedIds: next);
  }

  void setCategory(String candidateId, String? categoryId) {
    MotionTokens.selection();
    final next = Map<String, String>.of(state.categoryByCandidate);
    if (categoryId == null) {
      next.remove(candidateId);
    } else {
      next[candidateId] = categoryId;
    }
    state = state.copyWith(categoryByCandidate: next);
  }

  List<SecrecyCandidate> selectedCandidates() {
    final h = state.handoff;
    if (h == null) return const [];
    return [
      for (final c in h.candidates)
        if (state.selectedIds.contains(c.id))
          c.copyWith(selectedCategoryId: state.categoryByCandidate[c.id])
    ];
  }

  Future<bool> apply() async {
    final h = state.handoff;
    if (h == null) return false;
    MotionTokens.medium();
    state = state.copyWith(isApplying: true);
    try {
      return await ref.read(applySecrecyModeUseCaseProvider).call(
            selected: selectedCandidates(),
            transactionIdByRowIndex: h.transactionIdByRowIndex,
          );
    } catch (_) {
      MotionTokens.error();
      return false;
    } finally {
      if (!_disposed) state = state.copyWith(isApplying: false);
    }
  }
}

final importSecretsProvider =
    NotifierProvider<ImportSecretsNotifier, ImportSecretsState>(
        ImportSecretsNotifier.new);
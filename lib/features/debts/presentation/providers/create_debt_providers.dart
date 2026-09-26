import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/transactions/domain/entities/transaction_ui_model.dart';
import 'package:budget_assistant/features/transactions/domain/entities/transactions_filter_state.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_split.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/create_transaction_providers.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/transactions_log_providers.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_form_draft.dart';
import '../../domain/usecases/build_debt_draft_usecase.dart';
import '../../domain/usecases/validate_debt_form_usecase.dart';
import 'debts_repository_providers.dart';

final Logger _logger = Logger();

/// Член семьи для чекбокс-листа формы (имя в именительном падеже).
class FamilyMemberUi {
  const FamilyMemberUi({required this.userId, required this.displayName});
  final String userId;
  final String displayName;
}

final familyMembersProvider = FutureProvider<List<FamilyMemberUi>>((ref) async {
  final spaceId = ref.watch(currentSpaceIdProvider);
  if (spaceId == null) return const <FamilyMemberUi>[];
  final me = ref.watch(currentUserIdProvider);
  final memberships =
      await ref.watch(membershipsDaoProvider).getBySpaceId(spaceId);
  final out = <FamilyMemberUi>[];
  for (final m in memberships) {
    if (m.userId == me) continue;
    final user = await ref.watch(usersDaoProvider).getById(m.userId);
    out.add(FamilyMemberUi(
      userId: m.userId,
      displayName: user?.displayName ?? '',
    ));
  }
  return out;
});

/// Последние 50 транзакций за 90 дней для dropdown «Связи» (6.3.14.6).
final recentTransactionsForLinkProvider =
    FutureProvider<List<TransactionUiModel>>((ref) async {
  final now = DateTime.now();
  final filter = TransactionsFilterState(
    scope: TransactionsScope.mine,
    period: TransactionsPeriodPreset.custom,
    customFrom: now.subtract(const Duration(days: 90)),
    customTo: now,
  );
  return ref.watch(transactionsLogRepositoryProvider).fetchPage(
        filter: filter,
        currentUserId: ref.watch(currentUserIdProvider),
        currentSpaceId: null,
        limit: 50,
        offset: 0,
      );
});

final debtBaseCurrencyProvider = FutureProvider<String>((ref) async {
  final settings = await ref
      .watch(appSettingsDaoProvider)
      .getForUser(ref.watch(currentUserIdProvider));
  return settings.baseCurrency;
});

final editDebtForFormProvider =
    FutureProvider.family<Debt?, String>((ref, id) {
  return ref.watch(debtsRepositoryProvider).getById(id);
});

final splitByIdProvider =
    FutureProvider.family<TransactionSplit?, String>((ref, id) {
  return ref.watch(transactionsRepositoryProvider).getSplitById(id);
});

/// Состояние формы создания/редактирования долга (6.3.14).
class CreateDebtFormState {
  const CreateDebtFormState({
    this.debtId,
    this.debtType = 'payable',
    this.counterpartyType = 'family_member',
    this.selectedMemberIds = const <String>[],
    this.externalName = '',
    this.amountText = '',
    this.currency = 'RUB',
    this.categoryId,
    this.description = '',
    this.dueDate,
    this.linkedTransactionId,
    this.linkedSplitId,
    this.autoResolve = true,
    this.isDirty = false,
    this.fieldsLocked = false,
    this.initialized = false,
  });

  final String? debtId;
  final String debtType;
  final String counterpartyType;
  final List<String> selectedMemberIds;
  final String externalName;
  final String amountText;
  final String currency;
  final String? categoryId;
  final String description;
  final DateTime? dueDate;
  final String? linkedTransactionId;
  final String? linkedSplitId;
  final bool autoResolve;
  final bool isDirty;
  /// Префикс из транзакции/split: детали readonly (6.3.14.7).
  final bool fieldsLocked;
  final bool initialized;

  bool get isEdit => debtId != null;

  CreateDebtFormState copyWith({
    String? debtId,
    String? debtType,
    String? counterpartyType,
    List<String>? selectedMemberIds,
    String? externalName,
    String? amountText,
    String? currency,
    String? categoryId,
    bool clearCategory = false,
    String? description,
    DateTime? dueDate,
    bool clearDueDate = false,
    String? linkedTransactionId,
    String? linkedSplitId,
    bool? autoResolve,
    bool? isDirty,
    bool? fieldsLocked,
    bool? initialized,
  }) {
    return CreateDebtFormState(
      debtId: debtId ?? this.debtId,
      debtType: debtType ?? this.debtType,
      counterpartyType: counterpartyType ?? this.counterpartyType,
      selectedMemberIds: selectedMemberIds ?? this.selectedMemberIds,
      externalName: externalName ?? this.externalName,
      amountText: amountText ?? this.amountText,
      currency: currency ?? this.currency,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      description: description ?? this.description,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      linkedSplitId: linkedSplitId ?? this.linkedSplitId,
      autoResolve: autoResolve ?? this.autoResolve,
      isDirty: isDirty ?? this.isDirty,
      fieldsLocked: fieldsLocked ?? this.fieldsLocked,
      initialized: initialized ?? this.initialized,
    );
  }
}

class CreateDebtFormNotifier extends Notifier<CreateDebtFormState> {
  Timer? _draftTimer;

  @override
  CreateDebtFormState build() {
    ref.onDispose(() => _draftTimer?.cancel());
    return const CreateDebtFormState();
  }

  Future<void> init({
    String? debtId,
    String? transactionId,
    String? splitId,
  }) async {
    _draftTimer?.cancel();
    state = const CreateDebtFormState();
    try {
      if (debtId != null) {
        final debt = await ref.read(debtsRepositoryProvider).getById(debtId);
        if (debt != null) {
          final me = ref.read(currentUserIdProvider);
          final otherId =
              debt.debtorId == me ? debt.creditorId : debt.debtorId;
          state = CreateDebtFormState(
            debtId: debt.id,
            debtType: debt.directionFor(me) == DebtDirection.payable
                ? 'payable'
                : 'receivable',
            counterpartyType:
                debt.isExternal ? 'external' : 'family_member',
            selectedMemberIds:
                (!debt.isExternal && otherId != null) ? [otherId] : const [],
            externalName: debt.counterpartyNameDative ?? '',
            amountText:
                MoneyTextInputFormatter.kopecksToInputText(debt.amount),
            currency: debt.currency,
            categoryId: debt.categoryId,
            description: debt.description ?? '',
            dueDate: debt.dueDate,
            linkedTransactionId: debt.originalTransactionId,
            linkedSplitId: debt.splitId,
            autoResolve: debt.autoResolve,
            initialized: true,
          );
          return;
        }
      }
      if (transactionId != null) {
        final tx = await ref
            .read(transactionsRepositoryProvider)
            .getTransactionById(transactionId);
        if (tx != null) {
          final base =
              await ref.read(debtBaseCurrencyProvider.future);
          state = CreateDebtFormState(
            amountText:
                MoneyTextInputFormatter.kopecksToInputText(tx.amount),
            currency: tx.originalCurrency ?? base,
            categoryId: tx.customCategoryId,
            description: tx.comment ?? '',
            linkedTransactionId: tx.id,
            fieldsLocked: true,
            initialized: true,
          );
          return;
        }
      }
      if (splitId != null) {
        final split =
            await ref.read(splitByIdProvider(splitId).future);
        if (split != null) {
          final base =
              await ref.read(debtBaseCurrencyProvider.future);
          state = CreateDebtFormState(
            amountText:
                MoneyTextInputFormatter.kopecksToInputText(split.amount),
            currency: base,
            categoryId: split.categoryId,
            linkedSplitId: split.id,
            fieldsLocked: true,
            initialized: true,
          );
          return;
        }
      }
      final base = await ref.read(debtBaseCurrencyProvider.future);
      state = CreateDebtFormState(currency: base, initialized: true);
    } catch (e, st) {
      _logger.e('CreateDebtForm init failed', error: e, stackTrace: st);
      state = const CreateDebtFormState(initialized: true);
    }
  }

  void setDebtType(String v) => _touch(state.copyWith(debtType: v));
  void setCounterpartyType(String v) =>
      _touch(state.copyWith(counterpartyType: v));
  void toggleMember(String id) {
    final next = state.selectedMemberIds.contains(id)
        ? state.selectedMemberIds.where((m) => m != id).toList()
        : [...state.selectedMemberIds, id];
    _touch(state.copyWith(selectedMemberIds: next));
  }
  void setExternalName(String v) => _touch(state.copyWith(externalName: v));
  void setAmountText(String v) => _touch(state.copyWith(amountText: v));
  void setCurrency(String v) => _touch(state.copyWith(currency: v));
  void setCategoryId(String? v) => _touch(state.copyWith(
        categoryId: v,
        clearCategory: v == null,
      ));
  void setDescription(String v) => _touch(state.copyWith(description: v));
  void setDueDate(DateTime? v) => _touch(state.copyWith(
        dueDate: v,
        clearDueDate: v == null,
      ));
  void setLinkedTransaction(String? v) =>
      _touch(state.copyWith(linkedTransactionId: v));
  void setAutoResolve(bool v) => _touch(state.copyWith(autoResolve: v));

  void applyDraft(DebtFormDraft d) {
    _draftTimer?.cancel();
    state = CreateDebtFormState(
      debtType: d.debtType,
      counterpartyType: d.counterpartyType,
      selectedMemberIds: d.selectedMemberIds,
      externalName: d.externalNameDative,
      amountText: (d.amount == null || d.amount! <= 0)
          ? ''
          : MoneyTextInputFormatter.kopecksToInputText(d.amount!),
      currency: d.currency,
      categoryId: d.categoryId,
      description: d.description,
      dueDate: d.dueDate,
      linkedTransactionId: d.originalTransactionId,
      linkedSplitId: d.splitId,
      autoResolve: d.autoResolveOnLink,
      initialized: true,
    );
  }

  void markSaved() {
    _draftTimer?.cancel();
    state = state.copyWith(isDirty: false);
  }

  void _touch(CreateDebtFormState next) {
    state = next.copyWith(isDirty: true);
    _scheduleDraftSave();
  }

  void _scheduleDraftSave() {
    if (state.isEdit) return;
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(seconds: 5), _saveDraft);
  }

  Future<void> _saveDraft() async {
    if (!state.isDirty || state.isEdit) return;
    try {
      final userId = ref.read(currentUserIdProvider);
      final draft = ref.read(createDebtDraftProvider);
      await ref.read(debtsRepositoryProvider).saveDraft(userId, draft);
    } catch (e, st) {
      _logger.w('Failed to autosave debt draft', error: e, stackTrace: st);
    }
  }
}

final createDebtFormProvider =
    NotifierProvider<CreateDebtFormNotifier, CreateDebtFormState>(
  CreateDebtFormNotifier.new,
);

final buildDebtDraftUseCaseProvider = Provider<BuildDebtDraftUseCase>((ref) {
  return BuildDebtDraftUseCase();
});

final validateDebtFormUseCaseProvider =
    Provider<ValidateDebtFormUseCase>((ref) {
  return ValidateDebtFormUseCase();
});

/// Текущий черновик формы (для валидации и автосохранения).
final createDebtDraftProvider = Provider<DebtFormDraft>((ref) {
  final s = ref.watch(createDebtFormProvider);
  return ref.watch(buildDebtDraftUseCaseProvider)(
    debtId: s.debtId,
    debtType: s.debtType,
    counterpartyType: s.counterpartyType,
    selectedMemberIds: s.selectedMemberIds,
    externalName: s.externalName,
    amountKopecks: MoneyInputParser.parseKopecks(s.amountText),
    currency: s.currency,
    categoryId: s.categoryId,
    description: s.description,
    dueDate: s.dueDate,
    originalTransactionId: s.linkedTransactionId,
    splitId: s.linkedSplitId,
    autoResolve: s.autoResolve,
  );
});

final createDebtValidationProvider = Provider<String?>((ref) {
  return ref.watch(validateDebtFormUseCaseProvider)(
    ref.watch(createDebtDraftProvider),
  );
});
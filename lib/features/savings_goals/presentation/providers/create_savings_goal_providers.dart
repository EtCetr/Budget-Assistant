import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_providers.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/entities/savings_goal_form_draft.dart';
import '../widgets/emoji_selector_sheet.dart';
import 'savings_goals_providers.dart';
import 'savings_goals_repository_providers.dart';
import 'savings_goals_screen_providers.dart';

final Logger _logger = Logger();

class CreateSavingsGoalFormState {
  const CreateSavingsGoalFormState({
    this.goalId,
    this.name = '',
    this.emoji = '',
    this.amountText = '',
    this.currency = 'RUB',
    this.deadline,
    this.goalType = SavingsGoalType.virtual,
    this.linkedAccountId,
    this.autoReminderEnabled = true,
    this.visibility = SavingsGoalVisibility.personal,
    this.isDirty = false,
    this.currencyLocked = false,
  });

  final String? goalId;
  final String name;
  final String emoji;
  final String amountText;
  final String currency;
  final DateTime? deadline;
  final String goalType;
  final String? linkedAccountId;
  final bool autoReminderEnabled;
  final String visibility;
  final bool isDirty;
  final bool currencyLocked;

  CreateSavingsGoalFormState copyWith({
    String? goalId,
    String? name,
    String? emoji,
    String? amountText,
    String? currency,
    DateTime? deadline,
    bool clearDeadline = false,
    String? goalType,
    String? linkedAccountId,
    bool clearLinkedAccount = false,
    bool? autoReminderEnabled,
    String? visibility,
    bool? isDirty,
    bool? currencyLocked,
  }) {
    return CreateSavingsGoalFormState(
      goalId: goalId ?? this.goalId,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      amountText: amountText ?? this.amountText,
      currency: currency ?? this.currency,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      goalType: goalType ?? this.goalType,
      linkedAccountId:
          clearLinkedAccount ? null : (linkedAccountId ?? this.linkedAccountId),
      autoReminderEnabled: autoReminderEnabled ?? this.autoReminderEnabled,
      visibility: visibility ?? this.visibility,
      isDirty: isDirty ?? this.isDirty,
      currencyLocked: currencyLocked ?? this.currencyLocked,
    );
  }
}

class CreateSavingsGoalFormNotifier
    extends Notifier<CreateSavingsGoalFormState> {
  Timer? _draftTimer;

  @override
  CreateSavingsGoalFormState build() {
    ref.onDispose(() => _draftTimer?.cancel());
    return const CreateSavingsGoalFormState();
  }

  Future<void> init({String? goalId}) async {
    _draftTimer?.cancel();
    if (goalId == null) {
      state = const CreateSavingsGoalFormState();
      return;
    }
    try {
      final goal = await ref.read(editSavingsGoalProvider(goalId).future);
      if (goal == null) {
        state = CreateSavingsGoalFormState(goalId: goalId);
        return;
      }
      final split = splitGoalEmoji(goal.name, kSavingsEmojiPalette);
      state = CreateSavingsGoalFormState(
        goalId: goal.id,
        name: split.$2,
        emoji: split.$1,
        amountText: MoneyTextInputFormatter.kopecksToInputText(goal.targetAmount),
        currency: goal.currency,
        deadline: goal.deadline,
        goalType:
            goal.isVirtual ? SavingsGoalType.virtual : SavingsGoalType.linked,
        linkedAccountId: goal.linkedAccountId,
        autoReminderEnabled: goal.autoReminderEnabled,
        visibility: goal.spaceId == null
            ? SavingsGoalVisibility.personal
            : SavingsGoalVisibility.family,
        currencyLocked: goal.linkedAccountId != null,
      );
    } catch (e, st) {
      _logger.e('Failed to load savings goal for edit', error: e, stackTrace: st);
      state = CreateSavingsGoalFormState(goalId: goalId);
    }
  }

  void setName(String value) => _touch(state.copyWith(name: value));
  void setEmoji(String value) => _touch(state.copyWith(emoji: value));
  void setAmountText(String value) => _touch(state.copyWith(amountText: value));
  void setCurrency(String value) => _touch(state.copyWith(currency: value));
  void setDeadline(DateTime? value) => _touch(
        value == null
            ? state.copyWith(clearDeadline: true)
            : state.copyWith(deadline: value),
      );
  void setAutoReminder(bool value) =>
      _touch(state.copyWith(autoReminderEnabled: value));
  void setVisibility(String value) => _touch(state.copyWith(visibility: value));

  void setGoalType(String type) {
    if (type == SavingsGoalType.virtual) {
      final baseCurrency = ref.read(savingsBaseCurrencyProvider).value ?? 'RUB';
      _touch(state.copyWith(
        goalType: type,
        clearLinkedAccount: true,
        currencyLocked: false,
        currency: baseCurrency,
      ));
    } else {
      _touch(state.copyWith(goalType: type));
    }
  }

  /// ВАЖНО: НЕ читает linkedGoalAccountsProvider (иначе циклическая
  /// зависимость: форма -> список счетов -> форма). Валюту передаёт
  /// вызывающий виджет, который уже держит список счетов.
  void setLinkedAccount(String? accountId, {String? currency}) {
    if (accountId == null) {
      _touch(state.copyWith(clearLinkedAccount: true));
      return;
    }
    _touch(state.copyWith(
      linkedAccountId: accountId,
      currency: currency ?? state.currency,
      currencyLocked: currency != null,
    ));
  }

  void applyDraft(SavingsGoalFormDraft draft) {
    _draftTimer?.cancel();
    state = CreateSavingsGoalFormState(
      goalId: draft.goalId,
      name: draft.name,
      emoji: draft.emoji,
      amountText: (draft.targetAmount == null || draft.targetAmount! <= 0)
          ? ''
          : MoneyTextInputFormatter.kopecksToInputText(draft.targetAmount!),
      currency: draft.currency ?? 'RUB',
      deadline: draft.deadline,
      goalType: draft.goalType == SavingsGoalType.linked
          ? SavingsGoalType.linked
          : SavingsGoalType.virtual,
      linkedAccountId: draft.linkedAccountId,
      autoReminderEnabled: draft.autoReminderEnabled,
      visibility: draft.visibility == SavingsGoalVisibility.family
          ? SavingsGoalVisibility.family
          : SavingsGoalVisibility.personal,
      currencyLocked:
          draft.goalType == SavingsGoalType.linked && draft.linkedAccountId != null,
    );
  }

  void markSaved() {
    _draftTimer?.cancel();
    state = state.copyWith(isDirty: false);
  }

  void _touch(CreateSavingsGoalFormState next) {
    state = next.copyWith(isDirty: true);
    _scheduleDraftSave();
  }

  void _scheduleDraftSave() {
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(seconds: 5), _saveDraft);
  }

  Future<void> _saveDraft() async {
    if (!state.isDirty) return;
    try {
      final userId = ref.read(currentUserIdProvider);
      final draft = ref.read(buildSavingsGoalDraftUseCaseProvider)(
        goalId: state.goalId,
        name: state.name,
        emoji: state.emoji,
        targetAmountKopecks:
            MoneyInputParser.parseKopecks(state.amountText) ?? 0,
        currency: state.currency,
        deadline: state.deadline,
        goalType: state.goalType,
        linkedAccountId:
            state.goalType == SavingsGoalType.linked ? state.linkedAccountId : null,
        autoReminderEnabled: state.autoReminderEnabled,
        visibility: state.visibility,
      );
      await ref.read(savingsGoalsRepositoryProvider).saveDraft(userId, draft);
    } catch (e, st) {
      _logger.w('Failed to autosave savings goal draft', error: e, stackTrace: st);
    }
  }
}

final createSavingsGoalFormProvider =
    NotifierProvider<CreateSavingsGoalFormNotifier, CreateSavingsGoalFormState>(
  CreateSavingsGoalFormNotifier.new,
);

final editSavingsGoalProvider =
    FutureProvider.family<SavingsGoal?, String>((ref, goalId) {
  return ref.watch(savingsGoalsRepositoryProvider).getById(goalId);
});

final createGoalValidationErrorProvider = Provider<String?>((ref) {
  final form = ref.watch(createSavingsGoalFormProvider);
  final draft = ref.watch(buildSavingsGoalDraftUseCaseProvider)(
    goalId: form.goalId,
    name: form.name,
    emoji: form.emoji,
    targetAmountKopecks: MoneyInputParser.parseKopecks(form.amountText) ?? 0,
    currency: form.currency,
    deadline: form.deadline,
    goalType: form.goalType,
    linkedAccountId:
        form.goalType == SavingsGoalType.linked ? form.linkedAccountId : null,
    autoReminderEnabled: form.autoReminderEnabled,
    visibility: form.visibility,
  );
  return ref.watch(validateSavingsGoalFormUseCaseProvider)(draft);
});

final canUseFamilyVisibilityProvider = Provider<bool>((ref) {
  final spaces = ref.watch(userSpacesProvider).value ?? const [];
  return spaces.isNotEmpty;
});

/// Счета для привязки цели. Зависит от формы (фильтр family->shared),
/// но сама форма его НЕ читает (иначе цикл).
final linkedGoalAccountsProvider = Provider<List<Account>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final accountsAsync = ref.watch(accountsListProvider(userId));
  final form = ref.watch(createSavingsGoalFormProvider);
  final accounts = accountsAsync.value ?? const <Account>[];
  return accounts.where((a) {
    if (a.isArchived || a.isSystem) return false;
    const allowed = {'debit', 'savings', 'cash'};
    if (!allowed.contains(a.accountType)) return false;
    if (form.visibility == SavingsGoalVisibility.family && !a.isSharedBalance) {
      return false;
    }
    return true;
  }).toList();
});

final createGoalSpaceIdProvider = Provider<String?>((ref) {
  final form = ref.watch(createSavingsGoalFormProvider);
  if (form.visibility != SavingsGoalVisibility.family) return null;
  final current = ref.watch(currentSpaceIdProvider);
  if (current != null) return current;
  final spaces = ref.watch(userSpacesProvider).value ?? const [];
  return spaces.isEmpty ? null : spaces.first.id;
});

String kopecksToFormText(int kopecks) =>
    MoneyTextInputFormatter.kopecksToInputText(kopecks);

(String, String) splitGoalEmoji(String name, List<String> palette) {
  for (final emoji in palette) {
    if (name.startsWith('$emoji ')) {
      return (emoji, name.substring(emoji.length + 1).trim());
    }
    if (name == emoji) return (emoji, '');
  }
  return ('', name);
}
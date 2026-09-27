import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../../recurring_payments/domain/entities/recurring_transaction.dart';
import '../../../recurring_payments/presentation/providers/recurring_repository_providers.dart';
import '../../domain/entities/reminder_form_draft.dart';
import '../../domain/models/recurrence_settings.dart';
import '../../domain/usecases/build_reminder_draft_usecase.dart';
import '../../domain/usecases/validate_reminder_form_usecase.dart';

class CreateReminderFormNotifier extends Notifier<ReminderFormDraft> {
  @override
  ReminderFormDraft build() => const ReminderFormDraft();

  void load(ReminderFormDraft draft) => state = draft;
  void setTitle(String v) => state = state.copyWith(title: v);
  void setDescription(String v) =>
      state = state.copyWith(description: v.isEmpty ? null : v);
  void setPriority(String v) => state = state.copyWith(priority: v);
  void setRemindAt(DateTime v) => state = state.copyWith(remindAt: v);
  void setRecurrenceRule(String? v) =>
      state = state.copyWith(recurrenceRule: v);
  void setExpectedAmountKopecks(int? v) =>
      state = state.copyWith(expectedAmountKopecks: v);
  void setLinkedCategoryId(String? v) =>
      state = state.copyWith(linkedCategoryId: v);
  void setLinkedAccountId(String? v) =>
      state = state.copyWith(linkedAccountId: v);
  void setLinkedRecurringId(String? v) =>
      state = state.copyWith(linkedRecurringId: v);
  void setScope(String v) => state = state.copyWith(
        scope: v,
        assigneeId: v == 'personal' ? null : state.assigneeId,
      );
  void setAssigneeId(String? v) => state = state.copyWith(assigneeId: v);
  void setAutoComplete(bool v) =>
      state = state.copyWith(autoCompleteOnPayment: v);
}

final createReminderFormProvider =
    NotifierProvider<CreateReminderFormNotifier, ReminderFormDraft>(
  CreateReminderFormNotifier.new,
);

/// UI-состояние блока повторения (пресет + настройки RRULE-билдера).
class RecurrenceUiState {
  const RecurrenceUiState({this.preset = 'once', this.settings});
  final String preset;
  final RecurrenceSettings? settings;

  RecurrenceUiState copyWith({String? preset, RecurrenceSettings? settings}) {
    return RecurrenceUiState(
      preset: preset ?? this.preset,
      settings: settings ?? this.settings,
    );
  }
}

class CreateReminderRecurrenceNotifier extends Notifier<RecurrenceUiState> {
  @override
  RecurrenceUiState build() => const RecurrenceUiState();
  void setPreset(String preset) => state = state.copyWith(preset: preset);
  void setSettings(RecurrenceSettings settings) =>
      state = state.copyWith(preset: 'custom', settings: settings);
}

final createReminderRecurrenceProvider =
    NotifierProvider<CreateReminderRecurrenceNotifier, RecurrenceUiState>(
  CreateReminderRecurrenceNotifier.new,
);

/// Активные регулярки для dropdown связи.
final activeRecurringForLinkProvider =
    StreamProvider<List<RecurringTransaction>>((ref) {
  return ref.watch(recurringTransactionsRepositoryProvider).watchByStatus(
        userId: ref.watch(currentUserIdProvider),
        status: RecurringStatus.active,
      );
});

final validateReminderFormUseCaseProvider =
    Provider<ValidateReminderFormUseCase>((ref) {
  return ValidateReminderFormUseCase();
});

final buildReminderDraftUseCaseProvider =
    Provider<BuildReminderDraftUseCase>((ref) {
  return BuildReminderDraftUseCase();
});
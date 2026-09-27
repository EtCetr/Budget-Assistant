import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../../recurring_payments/presentation/providers/recurring_repository_providers.dart';
import '../../data/notifications/reminders_notification_service.dart';
import '../../domain/usecases/build_rrule_usecase.dart';
import '../../domain/usecases/clear_reminder_draft_usecase.dart';
import '../../domain/usecases/complete_reminder_usecase.dart';
import '../../domain/usecases/create_reminder_usecase.dart';
import '../../domain/usecases/delete_reminder_usecase.dart';
import '../../domain/usecases/format_rrule_usecase.dart';
import '../../domain/usecases/get_next_occurrences_usecase.dart';
import '../../domain/usecases/restore_reminder_draft_usecase.dart';
import '../../domain/usecases/save_reminder_draft_usecase.dart';
import '../../domain/usecases/schedule_reminders_usecase.dart';
import '../../domain/usecases/snooze_reminder_usecase.dart';
import '../../domain/usecases/undo_complete_reminder_usecase.dart';
import '../../domain/usecases/update_reminder_usecase.dart';
import 'reminders_repository_providers.dart';

final Logger _remindersLogger = Logger();

final remindersNotificationServiceProvider =
    Provider<RemindersNotificationService>((ref) {
  return RemindersNotificationService(logger: _remindersLogger);
});

final getNextOccurrencesUseCaseProvider =
    Provider<GetNextOccurrencesUseCase>((ref) {
  return GetNextOccurrencesUseCase(logger: _remindersLogger);
});

final buildRRuleUseCaseProvider = Provider<BuildRRuleUseCase>((ref) {
  return BuildRRuleUseCase();
});

final formatRRuleUseCaseProvider = Provider<FormatRRuleUseCase>((ref) {
  return FormatRRuleUseCase();
});

final scheduleRemindersUseCaseProvider =
    Provider<ScheduleRemindersUseCase>((ref) {
  return ScheduleRemindersUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    scheduler: ref.watch(remindersNotificationServiceProvider),
    nextOccurrences: ref.watch(getNextOccurrencesUseCaseProvider),
    logger: _remindersLogger,
  );
});

final createReminderUseCaseProvider = Provider<CreateReminderUseCase>((ref) {
  return CreateReminderUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    recurringRepository: ref.watch(recurringTransactionsRepositoryProvider),
    scheduler: ref.watch(scheduleRemindersUseCaseProvider),
    port: ref.watch(remindersNotificationServiceProvider),
    logger: _remindersLogger,
  );
});

final updateReminderUseCaseProvider = Provider<UpdateReminderUseCase>((ref) {
  return UpdateReminderUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    scheduler: ref.watch(scheduleRemindersUseCaseProvider),
    port: ref.watch(remindersNotificationServiceProvider),
    logger: _remindersLogger,
  );
});

final deleteReminderUseCaseProvider = Provider<DeleteReminderUseCase>((ref) {
  return DeleteReminderUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    port: ref.watch(remindersNotificationServiceProvider),
    logger: _remindersLogger,
  );
});

final completeReminderUseCaseProvider =
    Provider<CompleteReminderUseCase>((ref) {
  return CompleteReminderUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    port: ref.watch(remindersNotificationServiceProvider),
    logger: _remindersLogger,
  );
});

final undoCompleteReminderUseCaseProvider =
    Provider<UndoCompleteReminderUseCase>((ref) {
  return UndoCompleteReminderUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    scheduler: ref.watch(scheduleRemindersUseCaseProvider),
    port: ref.watch(remindersNotificationServiceProvider),
    logger: _remindersLogger,
  );
});

final snoozeReminderUseCaseProvider = Provider<SnoozeReminderUseCase>((ref) {
  return SnoozeReminderUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    scheduler: ref.watch(scheduleRemindersUseCaseProvider),
    port: ref.watch(remindersNotificationServiceProvider),
    logger: _remindersLogger,
  );
});

final saveReminderDraftUseCaseProvider =
    Provider<SaveReminderDraftUseCase>((ref) {
  return SaveReminderDraftUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    logger: _remindersLogger,
  );
});

final restoreReminderDraftUseCaseProvider =
    Provider<RestoreReminderDraftUseCase>((ref) {
  return RestoreReminderDraftUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    logger: _remindersLogger,
  );
});

final clearReminderDraftUseCaseProvider =
    Provider<ClearReminderDraftUseCase>((ref) {
  return ClearReminderDraftUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    logger: _remindersLogger,
  );
});

/// Поток намерений из уведомлений (тап / экшен в открытом app).
/// UI (Этап 14.3) подписывается и роутит на ReminderDetailsScreen.
final reminderNotificationIntentProvider =
    StreamProvider<ReminderNotificationIntent>((ref) {
  return RemindersNotificationService.intents;
});

/// Хук старта app: init плагина + запрос разрешений.
/// Перепланирование всех напоминаний вызывается UI отдельно
/// (remindersBootstrapProvider + scheduleRemindersUseCaseProvider).
final remindersBootstrapProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(remindersNotificationServiceProvider);
  await service.ensureReady();
  await service.requestPermissions();
});
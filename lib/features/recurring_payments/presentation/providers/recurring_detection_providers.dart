import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../../reminders/presentation/providers/reminders_repository_providers.dart';
import '../../data/datasources/recurring_detection_dao.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../../domain/usecases/add_recurring_payment_usecase.dart';
import '../../domain/usecases/calculate_confidence_usecase.dart';
import '../../domain/usecases/create_reminder_from_recurring_usecase.dart';
import '../../domain/usecases/detect_recurring_payments_usecase.dart';
import '../../domain/usecases/dismiss_all_candidates_usecase.dart';
import '../../domain/usecases/group_recurring_candidates_usecase.dart';
import '../../domain/usecases/restore_dismissed_candidates_usecase.dart';
import 'recurring_repository_providers.dart';

final Logger _detectionLogger = Logger();

final recurringDetectionDaoProvider = Provider<RecurringDetectionDao>((ref) {
  return RecurringDetectionDao(ref.watch(appDatabaseProvider));
});

final appSettingsDaoRecurringProvider = Provider<AppSettingsDao>((ref) {
  return AppSettingsDao(ref.watch(appDatabaseProvider));
});

final recurringDetectionCurrencyProvider = FutureProvider<String>((ref) async {
  final dao = ref.watch(appSettingsDaoRecurringProvider);
  final settings = await dao.getForUser(ref.watch(currentUserIdProvider));
  return settings.baseCurrency;
});

final calculateConfidenceUseCaseProvider =
    Provider<CalculateConfidenceUseCase>((ref) {
  return CalculateConfidenceUseCase();
});

final detectRecurringPaymentsUseCaseProvider =
    Provider<DetectRecurringPaymentsUseCase>((ref) {
  return DetectRecurringPaymentsUseCase(
    dao: ref.watch(recurringDetectionDaoProvider),
    repository: ref.watch(recurringTransactionsRepositoryProvider),
    confidence: ref.watch(calculateConfidenceUseCaseProvider),
    logger: _detectionLogger,
  );
});

final addRecurringPaymentUseCaseProvider =
    Provider<AddRecurringPaymentUseCase>((ref) {
  return AddRecurringPaymentUseCase(
    repository: ref.watch(recurringTransactionsRepositoryProvider),
    logger: _detectionLogger,
  );
});

final dismissAllCandidatesUseCaseProvider =
    Provider<DismissAllCandidatesUseCase>((ref) {
  return DismissAllCandidatesUseCase(
    repository: ref.watch(recurringTransactionsRepositoryProvider),
    settingsDao: ref.watch(appSettingsDaoRecurringProvider),
    logger: _detectionLogger,
  );
});

final restoreDismissedCandidatesUseCaseProvider =
    Provider<RestoreDismissedCandidatesUseCase>((ref) {
  return RestoreDismissedCandidatesUseCase(
    repository: ref.watch(recurringTransactionsRepositoryProvider),
    settingsDao: ref.watch(appSettingsDaoRecurringProvider),
    logger: _detectionLogger,
  );
});

final groupRecurringCandidatesUseCaseProvider =
    Provider<GroupRecurringCandidatesUseCase>((ref) {
  return GroupRecurringCandidatesUseCase();
});

final createReminderFromRecurringUseCaseProvider =
    Provider<CreateReminderFromRecurringUseCase>((ref) {
  return CreateReminderFromRecurringUseCase(
    repository: ref.watch(remindersRepositoryProvider),
    logger: _detectionLogger,
  );
});

/// Кандидаты на подтверждение (status = pending_confirmation).
final pendingCandidatesProvider =
    StreamProvider<List<RecurringTransaction>>((ref) {
  return ref.watch(recurringTransactionsRepositoryProvider).watchByStatus(
        userId: ref.watch(currentUserIdProvider),
        status: RecurringStatus.pendingConfirmation,
      );
});

/// Ключи уже активных регулярки (бейдж «уже добавлено»).
final activeCandidateKeysProvider = StreamProvider<Set<String>>((ref) {
  return ref
      .watch(recurringTransactionsRepositoryProvider)
      .watchByStatus(
        userId: ref.watch(currentUserIdProvider),
        status: RecurringStatus.active,
      )
      .map((rows) => {
            for (final r in rows)
              '${r.merchantNameNormalized}|${r.averageAmountBucket}',
          });
});

class SelectedCandidatesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  void toggle(String id) {
    final next = Set<String>.from(state);
    if (!next.add(id)) next.remove(id);
    state = next;
  }

  void setMany(List<String> ids, bool selected) {
    final next = Set<String>.from(state);
    if (selected) {
      next.addAll(ids);
    } else {
      next.removeAll(ids);
    }
    state = next;
  }

  void clear() => state = const {};
}

final selectedCandidatesProvider =
    NotifierProvider<SelectedCandidatesNotifier, Set<String>>(
  SelectedCandidatesNotifier.new,
);

/// Кандидаты, сгруппированные по системным категориям (ТЗ 6.3.9.5).
final groupedCandidatesProvider =
    Provider<List<RecurringCandidateGroup>>((ref) {
  final pending = ref.watch(pendingCandidatesProvider).value ?? const [];
  return ref.watch(groupRecurringCandidatesUseCaseProvider)(pending);
});

/// Сводка: обнаружено / выбрано / пропущено (ТЗ 6.3.9.4).
final detectionStatsProvider =
    Provider<({int found, int selected, int skipped})>((ref) {
  final pending = ref.watch(pendingCandidatesProvider).value ?? const [];
  final selected = ref.watch(selectedCandidatesProvider);
  final selectedCount = pending.where((c) => selected.contains(c.id)).length;
  return (
    found: pending.length,
    selected: selectedCount,
    skipped: pending.length - selectedCount,
  );
});

final autoDetectEnabledProvider = FutureProvider<bool>((ref) async {
  final dao = ref.watch(appSettingsDaoRecurringProvider);
  final settings = await dao.getForUser(ref.watch(currentUserIdProvider));
  return settings.autoDetectRecurring;
});

final infoBannerDismissedProvider = FutureProvider<bool>((ref) async {
  final dao = ref.watch(appSettingsDaoRecurringProvider);
  final settings = await dao.getForUser(ref.watch(currentUserIdProvider));
  return settings.recurringDetectionInfoDismissed;
});

/// Закрытие инфо-баннера (app_settings.recurring_detection_info_dismissed).
/// Значения захватываются через watch при создании замыкания.
final dismissInfoBannerProvider = Provider<Future<void> Function()>((ref) {
  final dao = ref.watch(appSettingsDaoRecurringProvider);
  final userId = ref.watch(currentUserIdProvider);
  return () => dao.updateForUser(
        userId,
        const AppSettingsCompanion(
          recurringDetectionInfoDismissed: Value(true),
        ),
      );
});
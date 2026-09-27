import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import 'package:budget_assistant/core/database/daos/memberships_dao.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../../calendar/presentation/providers/holidays_repository_providers.dart';
import '../../data/datasources/reminders_dao.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminders_repository.dart';
import '../../domain/usecases/format_snooze_history_usecase.dart';
import '../../domain/usecases/get_day_context_usecase.dart';
import 'reminders_repository_providers.dart';

final Logger _screenLogger = Logger();

final appSettingsDaoRemindersProvider = Provider<AppSettingsDao>((ref) {
  return AppSettingsDao(ref.watch(appDatabaseProvider));
});

final membershipsDaoRemindersProvider = Provider<MembershipsDao>((ref) {
  return MembershipsDao(ref.watch(appDatabaseProvider));
});

final formatSnoozeHistoryUseCaseProvider =
    Provider<FormatSnoozeHistoryUseCase>((ref) {
  return FormatSnoozeHistoryUseCase(logger: _screenLogger);
});

final getDayContextUseCaseProvider = Provider<GetDayContextUseCase>((ref) {
  return GetDayContextUseCase(
    holidaysRepository: ref.watch(holidaysRepositoryProvider),
    remindersRepository: ref.watch(remindersRepositoryProvider),
    logger: _screenLogger,
  );
});

enum RemindersTab { upcoming, history }

class RemindersTabNotifier extends Notifier<RemindersTab> {
  @override
  RemindersTab build() => RemindersTab.upcoming;
  void set(RemindersTab tab) => state = tab;
}

final remindersTabProvider =
    NotifierProvider<RemindersTabNotifier, RemindersTab>(
  RemindersTabNotifier.new,
);

class RemindersFilterNotifier extends Notifier<RemindersUpcomingFilter> {
  @override
  RemindersUpcomingFilter build() => RemindersUpcomingFilter.all;
  void set(RemindersUpcomingFilter filter) => state = filter;
}

final remindersFilterProvider =
    NotifierProvider<RemindersFilterNotifier, RemindersUpcomingFilter>(
  RemindersFilterNotifier.new,
);

/// memberships.id текущего пользователя в активном пространстве
/// (фильтр «Назначенные мне», ТЗ 6.3.10.14.3).
final myMembershipIdProvider = FutureProvider<String?>((ref) async {
  final spaceId = ref.watch(currentSpaceIdProvider);
  if (spaceId == null) return null;
  final userId = ref.watch(currentUserIdProvider);
  final rows =
      await ref.watch(membershipsDaoRemindersProvider).getBySpaceId(spaceId);
  for (final m in rows) {
    if (m.userId == userId) return m.id;
  }
  return null;
});

final remindersNowUtcProvider = Provider<DateTime>((ref) {
  return DateTime.now().toUtc();
});

final upcomingRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(remindersRepositoryProvider).watchUpcoming(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        filter: ref.watch(remindersFilterProvider),
        myMembershipId: ref.watch(myMembershipIdProvider).value,
        nowUtc: ref.watch(remindersNowUtcProvider),
      );
});

final historyRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(remindersRepositoryProvider).watchHistory(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
      );
});

final upcomingCountProvider = StreamProvider<int>((ref) {
  return ref.watch(remindersRepositoryProvider).watchUpcomingCount(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        nowUtc: ref.watch(remindersNowUtcProvider),
      );
});

final remindersBaseCurrencyProvider = FutureProvider<String>((ref) async {
  final dao = ref.watch(appSettingsDaoRemindersProvider);
  final settings = await dao.getForUser(ref.watch(currentUserIdProvider));
  return settings.baseCurrency;
});

/// Опции ответственных (membership.id -> имя) активного пространства.
final assigneeOptionsProvider = StreamProvider<List<AssigneeOption>>((ref) {
  final spaceId = ref.watch(currentSpaceIdProvider);
  if (spaceId == null) return Stream.value(const <AssigneeOption>[]);
  return ref.watch(remindersDaoProvider).watchAssigneeOptions(spaceId);
});

final assigneeNameMapProvider = Provider<Map<String, String>>((ref) {
  final options = ref.watch(assigneeOptionsProvider).value ?? const [];
  return {for (final o in options) o.membershipId: o.displayName};
});
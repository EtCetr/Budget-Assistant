import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';

class ActivityPeriodNotifier extends Notifier<ActivityPeriod> {
  @override
  ActivityPeriod build() => ActivityPeriod.month;
  void set(ActivityPeriod p) => state = p;
}

final activityPeriodProvider =
    NotifierProvider<ActivityPeriodNotifier, ActivityPeriod>(
        ActivityPeriodNotifier.new);

/// Операции по дням и участникам за выбранный период (фильтр — в SQL).
final dayUserCountsProvider = StreamProvider<List<DayUserCountRow>>((ref) {
  final scope = ref.watch(adminScopeProvider);
  if (scope == null) {
    return const Stream.empty();
  }
  final period = ref.watch(activityPeriodProvider);
  return ref.watch(adminDaoProvider).watchDayUserCounts(
        scope.spaceId,
        period.sinceEpoch(DateTime.now().toUtc()),
      );
});

/// Сколько операций сделал каждый участник за период.
final userCountsProvider = StreamProvider<List<UserCountRow>>((ref) {
  final scope = ref.watch(adminScopeProvider);
  if (scope == null) {
    return const Stream.empty();
  }
  final period = ref.watch(activityPeriodProvider);
  return ref.watch(adminDaoProvider).watchUserCounts(
        scope.spaceId,
        period.sinceEpoch(DateTime.now().toUtc()),
      );
});

final overallActivityStatsProvider = Provider<OverallActivityStats>((ref) {
  final scope = ref.watch(adminScopeProvider);
  final period = ref.watch(activityPeriodProvider);
  final dayRows = ref.watch(dayUserCountsProvider).value ?? const [];
  final members = scope == null
      ? const <MemberInfo>[]
      : ref.watch(membersStreamProvider(scope.spaceId)).value ??
          const <MemberInfo>[];
  final since =
      DateTime.now().toUtc().subtract(Duration(days: period.days));
  final active = members
      .where((m) =>
          m.status == MemberStatus.active &&
          m.lastActiveAt != null &&
          m.lastActiveAt!.isAfter(since))
      .length;
  final totalNotLeft =
      members.where((m) => m.status != MemberStatus.left).length;
  return const CalculateOverallActivityUseCase().call(
    dayRows: dayRows,
    activeMembers: active,
    totalMembers: totalNotLeft,
    daysInPeriod: period.days,
  );
});

final activityChartProvider = Provider<List<ChartDayData>>((ref) {
  final dayRows = ref.watch(dayUserCountsProvider).value ?? const [];
  return const BuildActivityChartUseCase().call(dayRows, DateTime.now());
});

final topActiveMembersProvider = Provider<List<TopMember>>((ref) {
  final scope = ref.watch(adminScopeProvider);
  final counts = ref.watch(userCountsProvider).value ?? const [];
  final members = scope == null
      ? const <MemberInfo>[]
      : ref.watch(membersStreamProvider(scope.spaceId)).value ??
          const <MemberInfo>[];
  return const GetTopActiveMembersUseCase().call(counts, members);
});

/// Карта userId -> количество операций за период (для карточек участников).
final memberPeriodCountsProvider = Provider<Map<String, int>>((ref) {
  final counts = ref.watch(userCountsProvider).value ?? const [];
  return {for (final c in counts) c.userId: c.count};
});
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/audit_log_usecases.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

/// Период журнала (6.3.35.3): SQL-диапазоны через since.
enum AuditLogPeriod {
  week,
  month,
  quarter,
  all;

  DateTime? get since {
    final now = DateTime.now().toUtc();
    return switch (this) {
      AuditLogPeriod.week => now.subtract(const Duration(days: 7)),
      AuditLogPeriod.month => now.subtract(const Duration(days: 30)),
      AuditLogPeriod.quarter => now.subtract(const Duration(days: 90)),
      AuditLogPeriod.all => null,
    };
  }

  String get label => switch (this) {
        AuditLogPeriod.week => 'неделю',
        AuditLogPeriod.month => 'месяц',
        AuditLogPeriod.quarter => 'квартал',
        AuditLogPeriod.all => 'всё время',
      };
}

/// Фильтр действий (6.3.35.5): список dbValue уходит в SQL WHERE.
enum AuditLogFilter {
  all,
  invitations,
  removals,
  roles,
  admin,
  dissolved;

  List<String>? get actions => switch (this) {
        AuditLogFilter.all => null,
        AuditLogFilter.invitations => [
            AuditAction.memberInvited.dbValue,
            AuditAction.memberJoined.dbValue,
            AuditAction.inviteGenerated.dbValue,
          ],
        AuditLogFilter.removals => [
            AuditAction.memberRemoved.dbValue,
            AuditAction.memberLeft.dbValue,
          ],
        AuditLogFilter.roles => [AuditAction.roleChanged.dbValue],
        AuditLogFilter.admin => [
            AuditAction.adminTransferred.dbValue,
            AuditAction.autoPromotion.dbValue,
            AuditAction.emergencyPromotion.dbValue,
          ],
        AuditLogFilter.dissolved => [AuditAction.spaceDissolved.dbValue],
      };

  String get label => switch (this) {
        AuditLogFilter.all => 'Все',
        AuditLogFilter.invitations => 'Приглашения',
        AuditLogFilter.removals => 'Удаления',
        AuditLogFilter.roles => 'Роли',
        AuditLogFilter.admin => 'Админ',
        AuditLogFilter.dissolved => 'Расформирование',
      };
}

class AuditPeriodNotifier extends Notifier<AuditLogPeriod> {
  @override
  AuditLogPeriod build() => AuditLogPeriod.month;
  void set(AuditLogPeriod p) => state = p;
}

final auditPeriodProvider =
    NotifierProvider<AuditPeriodNotifier, AuditLogPeriod>(AuditPeriodNotifier.new);

class AuditFilterNotifier extends Notifier<AuditLogFilter> {
  @override
  AuditLogFilter build() => AuditLogFilter.all;
  void set(AuditLogFilter f) => state = f;
}

final auditFilterProvider =
    NotifierProvider<AuditFilterNotifier, AuditLogFilter>(AuditFilterNotifier.new);

final getUserNameUseCaseProvider = Provider<GetUserNameUseCase>(
  (ref) => GetUserNameUseCase(ref.watch(adminDaoProvider)),
);
final formatAuditEntryUseCaseProvider = Provider<FormatAuditEntryUseCase>(
  (ref) => FormatAuditEntryUseCase(ref.watch(getUserNameUseCaseProvider)),
);
final calculateAuditStatsUseCaseProvider =
    Provider<CalculateAuditStatsUseCase>((ref) => const CalculateAuditStatsUseCase());
final exportAuditLogUseCaseProvider = Provider<ExportAuditLogUseCase>(
  (ref) => ExportAuditLogUseCase(
    dao: ref.watch(adminDaoProvider),
    names: ref.watch(getUserNameUseCaseProvider),
  ),
);
final logAuditActionUseCaseProvider = Provider<LogAuditActionUseCase>(
  (ref) => LogAuditActionUseCase(ref.watch(adminRepositoryProvider)),
);

/// Записи за период + фильтр (фильтрация строго в SQL).
final auditFilteredProvider = StreamProvider<List<AuditEntry>>((ref) {
  final scope = ref.watch(adminScopeProvider);
  if (scope == null) return const Stream.empty();
  final period = ref.watch(auditPeriodProvider);
  final filter = ref.watch(auditFilterProvider);
  return ref
      .watch(adminRepositoryProvider)
      .watchAuditFiltered(
        scope.spaceId,
        since: period.since,
        actionTypes: filter.actions,
      );
});

final auditStatsProvider = Provider<AuditStats>((ref) {
  final list = ref.watch(auditFilteredProvider).value;
  if (list == null) return AuditStats.empty;
  return ref.watch(calculateAuditStatsUseCaseProvider).call(list);
});

/// Группа записей за один локальный день (заголовки «Сегодня/Вчера/…»).
class AuditDayGroup {
  const AuditDayGroup({required this.day, required this.items});
  final DateTime day;
  final List<FormattedAuditEntry> items;
}

final auditGroupedProvider = FutureProvider<List<AuditDayGroup>>((ref) async {
  final entries = await ref.watch(auditFilteredProvider.future);
  final format = ref.watch(formatAuditEntryUseCaseProvider);
  final pf = ref.watch(privacyFormatterProvider);
  final mode = ref.watch(privacyModeProvider);
  final byDay = <String, List<FormattedAuditEntry>>{};
  final days = <String, DateTime>{};
  for (final e in entries) {
    final f = await format.call(e, pf, mode);
    final local = e.createdAt.toLocal();
    final key =
        '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    byDay.putIfAbsent(key, () => <FormattedAuditEntry>[]).add(f);
    days.putIfAbsent(key, () => DateTime(local.year, local.month, local.day));
  }
  final keys = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
  return [for (final k in keys) AuditDayGroup(day: days[k]!, items: byDay[k]!)];
});
import 'package:rxdart/rxdart.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/repositories/admin_repository.dart';

class WatchSpaceInfoUseCase {
  WatchSpaceInfoUseCase(this._repo);
  final AdminRepository _repo;
  Stream<SpaceInfo?> call(String spaceId) => _repo.watchSpaceInfo(spaceId);
}

class WatchActivityStatsUseCase {
  WatchActivityStatsUseCase(this._repo);
  final AdminRepository _repo;
  Stream<ActivityStats> call(String spaceId) => _repo.watchActivity(spaceId);
}

class WatchMembersUseCase {
  WatchMembersUseCase(this._repo);
  final AdminRepository _repo;
  Stream<List<MemberInfo>> call(String spaceId) => _repo.watchMembers(spaceId);
}

class WatchInvitationsUseCase {
  WatchInvitationsUseCase(this._repo);
  final AdminRepository _repo;
  Stream<List<InvitationInfo>> call(String spaceId) => _repo.watchInvitations(spaceId);
}

class WatchAuditLogUseCase {
  WatchAuditLogUseCase(this._repo);
  final AdminRepository _repo;
  Stream<List<AuditEntry>> call(String spaceId) => _repo.watchAudit(spaceId);
}

/// 3 типа критических алертов (ТОМ 6 §6.3.32): единственный админ, неактивные >30д, долги вышедших.
class GetCriticalAlertsUseCase {
  GetCriticalAlertsUseCase(this._repo);
  final AdminRepository _repo;

  Stream<List<CriticalAlert>> call(String spaceId) {
    try {
      return Rx.combineLatest3(
        _repo.watchMembers(spaceId),
        _repo.watchExMemberDebtCount(spaceId),
        _repo.watchInvitations(spaceId),
        (members, exDebts, _) {
          final alerts = <CriticalAlert>[];
          final admins = members.where((m) =>
              m.role == MemberRole.admin && m.status == MemberStatus.active).length;
          if (admins <= 1) {
            alerts.add(const CriticalAlert(
              type: CriticalAlertType.soloAdmin,
              message: 'В пространстве единственный админ. Передайте роль или назначьте второго.',
              affectedCount: 1,
            ));
          }
          final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 30));
          final inactive = members.where((m) =>
              m.status == MemberStatus.active &&
              (m.lastActiveAt == null || m.lastActiveAt!.isBefore(cutoff))).length;
          if (inactive > 0) {
            alerts.add(CriticalAlert(
              type: CriticalAlertType.inactiveMembers,
              message: 'Неактивны более 30 дней: $inactive уч.',
              affectedCount: inactive,
            ));
          }
          if (exDebts > 0) {
            alerts.add(CriticalAlert(
              type: CriticalAlertType.exMemberDebt,
              message: 'Открытые долги вышедших участников: $exDebts',
              affectedCount: exDebts,
            ));
          }
          return alerts;
        },
      );
    } catch (e, st) {
      AppLogger.e('GetCriticalAlerts failed', e, st);
      rethrow;
    }
  }
}

class GetMemberStatsUseCase {
  GetMemberStatsUseCase(this._repo);
  final AdminRepository _repo;

  Stream<MemberStats> call(String spaceId) => Rx.combineLatest2(
        _repo.watchMembers(spaceId),
        _repo.watchInvitations(spaceId),
        (members, invites) {
          final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 30));
          final now = DateTime.now().toUtc();
          return MemberStats(
            total: members.where((m) => m.status != MemberStatus.left).length,
            admins: members.where((m) => m.role == MemberRole.admin &&
                m.status == MemberStatus.active).length,
            suspended: members.where((m) => m.status == MemberStatus.suspended).length,
            inactive30d: members.where((m) => m.status == MemberStatus.active &&
                (m.lastActiveAt == null || m.lastActiveAt!.isBefore(cutoff))).length,
            pendingInvites: invites.where((i) =>
                i.status == 'active' && i.expiresAt.isAfter(now)).length,
          );
        },
      );
}
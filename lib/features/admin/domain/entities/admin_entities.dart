import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_entities.freezed.dart';

class AdminFailure implements Exception {
  final String message;
  const AdminFailure(this.message);
  @override
  String toString() => message;
}

enum MemberRole {
  admin, member;
  String get dbValue => name;
  String get label => this == admin ? 'Админ' : 'Участник';
  static MemberRole fromDb(String? v) =>
      MemberRole.values.firstWhere((e) => e.name == v, orElse: () => MemberRole.member);
}

enum MemberStatus {
  active, suspended, left;
  String get dbValue => name;
  String get label => switch (this) {
    MemberStatus.active => 'Активен',
    MemberStatus.suspended => 'Приостановлен',
    MemberStatus.left => 'Вышел',
  };
  static MemberStatus fromDb(String? v) =>
      MemberStatus.values.firstWhere((e) => e.name == v, orElse: () => MemberStatus.active);
}

/// Действия журнала аудита.
///
/// ВАЖНО (Этап 17/18, D18-8): в БД храним camelCase (dbValue = name).
/// Легаси-записи воркера Этапа 17 и псевдокод спеки 6.3.35 использовали
/// snake_case ('emergency_promotion' и т.п.) — fromDb понимает оба варианта.
enum AuditAction {
  roleChanged, memberSuspended, memberResumed, memberRemoved,
  adminTransferred, inviteGenerated, inviteRevoked, reminderSent, memberJoined, spaceDissolved,
  // Этап 18 (6.3.35/6.3.36):
  memberInvited, memberLeft, autoPromotion, emergencyPromotion, syncReminderSent,
  spaceRenamed, spaceBudgetChanged, spaceDataExported;

  String get dbValue => name;

  String get label => switch (this) {
    AuditAction.roleChanged => 'Изменена роль',
    AuditAction.memberSuspended => 'Участник приостановлен',
    AuditAction.memberResumed => 'Участник возобновлён',
    AuditAction.memberRemoved => 'Участник удалён',
    AuditAction.adminTransferred => 'Передача роли админа',
    AuditAction.inviteGenerated => 'Создано приглашение',
    AuditAction.inviteRevoked => 'Отозвано приглашение',
    AuditAction.reminderSent => 'Отправлено напоминание',
    AuditAction.memberJoined => 'Участник присоединился',
    AuditAction.spaceDissolved => 'Расформирование пространства',
    AuditAction.memberInvited => 'Приглашение отправлено',
    AuditAction.memberLeft => 'Участник вышел',
    AuditAction.autoPromotion => 'Авто-повышение',
    AuditAction.emergencyPromotion => 'Аварийное повышение',
    AuditAction.syncReminderSent => 'Напоминание о синхронизации',
    AuditAction.spaceRenamed => 'Пространство переименовано',
    AuditAction.spaceBudgetChanged => 'Изменён семейный бюджет',
    AuditAction.spaceDataExported => 'Экспорт данных пространства',
  };

  /// Легаси snake_case (воркер Этапа 17, спека 6.3.35).
  static const Map<String, AuditAction> _legacy = {
    'emergency_promotion': AuditAction.emergencyPromotion,
    'auto_promotion': AuditAction.autoPromotion,
    'member_invited': AuditAction.memberInvited,
    'member_joined': AuditAction.memberJoined,
    'member_removed': AuditAction.memberRemoved,
    'member_left': AuditAction.memberLeft,
    'role_changed': AuditAction.roleChanged,
    'admin_transfer': AuditAction.adminTransferred,
    'space_dissolved': AuditAction.spaceDissolved,
    'sync_reminder_sent': AuditAction.syncReminderSent,
  };

  static AuditAction fromDb(String? v) {
    if (v == null) return AuditAction.roleChanged;
    final legacy = _legacy[v];
    if (legacy != null) return legacy;
    return AuditAction.values.firstWhere(
      (e) => e.name == v,
      orElse: () => AuditAction.roleChanged,
    );
  }
}

enum CriticalAlertType { soloAdmin, inactiveMembers, exMemberDebt }

@freezed
abstract class MemberInfo with _$MemberInfo {
  const factory MemberInfo({
    required String id,
    required String spaceId,
    required String userId,
    required String displayName,
    String? email,
    required MemberRole role,
    required MemberStatus status,
    required DateTime joinedAt,
    DateTime? lastActiveAt,
    required int openDebtsCount,
    required int openDebtsAmountKopecks,
    required int tx30d,
  }) = _MemberInfo;
}

@freezed
abstract class MemberStats with _$MemberStats {
  const factory MemberStats({
    required int total,
    required int admins,
    required int suspended,
    required int inactive30d,
    required int pendingInvites,
  }) = _MemberStats;
}

@freezed
abstract class ActivityStats with _$ActivityStats {
  const factory ActivityStats({
    required int tx7d,
    required int tx30d,
    DateTime? lastTxAt,
    required int monthExpenseKopecks,
    required int monthIncomeKopecks,
  }) = _ActivityStats;
}

@freezed
abstract class SpaceInfo with _$SpaceInfo {
  const factory SpaceInfo({
    required String id,
    required String name,
    required DateTime createdAt,
    required int membersCount,
  }) = _SpaceInfo;
}

@freezed
abstract class CriticalAlert with _$CriticalAlert {
  const factory CriticalAlert({
    required CriticalAlertType type,
    required String message,
    required int affectedCount,
  }) = _CriticalAlert;
}

@freezed
abstract class InvitationInfo with _$InvitationInfo {
  const factory InvitationInfo({
    required String id,
    required String spaceId,
    required MemberRole role,
    required String status,
    required DateTime expiresAt,
    required DateTime createdAt,
    required String deepLink,
  }) = _InvitationInfo;
}

@freezed
abstract class AuditEntry with _$AuditEntry {
  const factory AuditEntry({
    required String id,
    required AuditAction action,
    required String actorUserId,
    String? targetId,
    required String metadataJson,
    required DateTime createdAt,
    required String syncStatus,
  }) = _AuditEntry;
}

@freezed
abstract class InviteBundle with _$InviteBundle {
  const factory InviteBundle({
    required String t,
    required String s,
    required String e,
    required String r,
    required int x,
  }) = _InviteBundle;

  factory InviteBundle.fromLink(String token) {
    try {
      final json = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(token))))
          as Map<String, dynamic>;
      return InviteBundle(
        t: json['t'] as String,
        s: json['s'] as String,
        e: json['e'] as String,
        r: json['r'] as String,
        x: json['x'] as int,
      );
    } catch (_) {
      throw const AdminFailure('Некорректная ссылка приглашения');
    }
  }
}

extension InviteBundleX on InviteBundle {
  String toLinkToken() =>
      base64Url.encode(utf8.encode(jsonEncode({'t': t, 's': s, 'e': e, 'r': r, 'x': x})));
}
import 'dart:convert';
import 'package:budget_assistant/core/logger.dart';
import 'package:crypto/crypto.dart';
import 'package:budget_assistant/features/admin/domain/usecases/space_settings_usecases.dart';
import 'package:budget_assistant/features/admin/data/crypto/invite_crypto_service.dart';
import 'package:budget_assistant/features/admin/data/daos/admin_dao.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/repositories/admin_repository.dart';
import 'package:uuid/uuid.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl({required AdminDao dao, required InviteCryptoService crypto})
      : _dao = dao,
        _crypto = crypto;

  final AdminDao _dao;
  final InviteCryptoService _crypto;
  static const Uuid _uuid = Uuid();

  @override
  Stream<List<MemberInfo>> watchMembers(String spaceId) => _dao.watchMembers(spaceId);
  @override
  Stream<SpaceInfo?> watchSpaceInfo(String spaceId) => _dao.watchSpaceInfo(spaceId);
  @override
  Stream<ActivityStats> watchActivity(String spaceId) => _dao.watchActivity(spaceId);
  @override
  Stream<List<InvitationInfo>> watchInvitations(String spaceId) =>
      _dao.watchInvitations(spaceId);
  @override
  Stream<List<AuditEntry>> watchAudit(String spaceId) => _dao.watchAudit(spaceId);

  @override
  Stream<List<AuditEntry>> watchAuditFiltered(String spaceId, {DateTime? since, List<String>? actionTypes}) =>
      _dao.watchAuditFiltered(spaceId, since: since, actionTypes: actionTypes);

  @override
  Future<void> logAudit({required String spaceId, required String actorId,
    required AuditAction action, String? targetId, Map<String, dynamic>? metadata}) {
    try {
      return _audit(spaceId, actorId, action, targetId,
          metadata == null ? '{}' : jsonEncode(metadata));
    } catch (e, st) {
      AppLogger.e('logAudit failed', e, st);
      rethrow;
    }
  }
  @override
  Stream<int> watchExMemberDebtCount(String spaceId) =>
      _dao.watchExMemberDebtCount(spaceId);

  @override
  Future<bool> isAdmin(String userId, String spaceId) async {
    try {
      final members = await _dao.watchMembers(spaceId).first;
      return members.any((m) =>
          m.userId == userId &&
          m.role == MemberRole.admin &&
          m.status == MemberStatus.active);
    } catch (e, st) {
      AppLogger.e('isAdmin failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> updateLastActive(String userId, String spaceId) async {
    try {
      await _dao.updateLastActive(userId, spaceId);
    } catch (e) {
      AppLogger.w('updateLastActive failed: $e');
    }
  }

  @override
  Future<void> changeRole({
    required String spaceId,
    required String actorId,
    required MemberInfo target,
    required MemberRole newRole,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      if (target.role == MemberRole.admin && newRole == MemberRole.member) {
        final admins = await _dao.countActiveAdmins(spaceId);
        if (admins <= 1) {
          throw const AdminFailure('Нельзя лишить прав последнего админа');
        }
      }
      await _dao.changeRole(target.id, newRole);
      await _audit(spaceId, actorId, AuditAction.roleChanged, target.userId,
          '{"from":"${target.role.dbValue}","to":"${newRole.dbValue}"}');
    } catch (e, st) {
      AppLogger.e('changeRole failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> suspend({
    required String spaceId,
    required String actorId,
    required MemberInfo target,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      if (target.role == MemberRole.admin) {
        throw const AdminFailure('Нельзя приостановить админа');
      }
      await _dao.setStatus(target.id, MemberStatus.suspended);
      await _audit(spaceId, actorId, AuditAction.memberSuspended, target.userId);
    } catch (e, st) {
      AppLogger.e('suspend failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> resume({
    required String spaceId,
    required String actorId,
    required MemberInfo target,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      await _dao.setStatus(target.id, MemberStatus.active);
      await _audit(spaceId, actorId, AuditAction.memberResumed, target.userId);
    } catch (e, st) {
      AppLogger.e('resume failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> remove({
    required String spaceId,
    required String actorId,
    required MemberInfo target,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      if (target.userId == actorId) {
        throw const AdminFailure('Нельзя удалить самого себя');
      }
      if (target.role == MemberRole.admin) {
        throw const AdminFailure('Сначала передайте роль админа или понизьте роль');
      }
      await _dao.setStatus(target.id, MemberStatus.left);
      await _dao.markExMemberDebts(target.userId, spaceId);
      await _audit(spaceId, actorId, AuditAction.memberRemoved, target.userId);
    } catch (e, st) {
      AppLogger.e('remove failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> transferAdmin({
    required String spaceId,
    required String actorId,
    required MemberInfo from,
    required MemberInfo to,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      if (from.userId != actorId) {
        throw const AdminFailure('Передать можно только свою роль');
      }
      if (to.status != MemberStatus.active) {
        throw const AdminFailure('Целевой участник неактивен');
      }
      await _dao.transferAdmin(from.id, to.id);
      await _audit(spaceId, actorId, AuditAction.adminTransferred, to.userId);
    } catch (e, st) {
      AppLogger.e('transferAdmin failed', e, st);
      rethrow;
    }
  }

  @override
  Future<InvitationInfo> generateInvite({
    required String spaceId,
    required String actorId,
    required MemberRole role,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      final packed = await _crypto.packSpaceSalt(spaceId: spaceId);
      final now = DateTime.now().toUtc();
      final bundle = InviteBundle(
        t: packed.token,
        s: spaceId,
        e: packed.encryptedSalt,
        r: role.dbValue,
        x: now.add(const Duration(hours: 24)).millisecondsSinceEpoch,
      );
      final inv = InvitationInfo(
        id: _uuid.v4(),
        spaceId: spaceId,
        role: role,
        status: 'active',
        expiresAt: DateTime.fromMillisecondsSinceEpoch(bundle.x, isUtc: true),
        createdAt: now,
        deepLink: 'budgetassistant://join?token=${bundle.toLinkToken()}',
      );
      await _dao.insertInvitation(inv, bundle.toLinkToken(), packed.encryptedSalt, actorId);
      await _audit(spaceId, actorId, AuditAction.inviteGenerated, inv.id);
      return inv;
    } catch (e, st) {
      AppLogger.e('generateInvite failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> revokeInvite({
    required String spaceId,
    required String actorId,
    required String inviteId,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      await _dao.revokeInvitation(inviteId);
      await _audit(spaceId, actorId, AuditAction.inviteRevoked, inviteId);
    } catch (e, st) {
      AppLogger.e('revokeInvite failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> sendReminder({
    required String spaceId,
    required String actorId,
    required MemberInfo target,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      await _dao.insertReminderNotification(
        id: _uuid.v4(),
        userId: target.userId,
        title: 'Напоминание от администратора',
        body: 'Пожалуйста, откройте приложение и синхронизируйте данные семейства.',
      );
      await _audit(spaceId, actorId, AuditAction.reminderSent, target.userId);
    } catch (e, st) {
      AppLogger.e('sendReminder failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> dissolveSpace({
    required String spaceId,
    required String actorId,
  }) async {
    try {
      await _guardAdmin(spaceId, actorId);
      final members = await _dao.watchMembers(spaceId).first;
      final txCount = await _dao.countSpaceTransactions(spaceId);
      await _dao.dissolveSpace(
        spaceId,
        _uuid.v4(),
        actorId,
        metadataJson: jsonEncode({
          'members_count': members.length,
          'transactions_count': txCount,
        }),
      );
      for (final m in members) {
        await _dao.insertNotificationFull(
          id: _uuid.v4(),
          userId: m.userId,
          spaceId: spaceId,
          type: 'space_dissolved',
          title: '🗑 Пространство расформировано',
          body: 'Администратор расформировал пространство. Ваши личные данные сохранены.',
        );
      }
      try {
        await _crypto.deleteSpaceKey(spaceId);
      } catch (e) {
        AppLogger.w('deleteSpaceKey failed: $e');
      }
    } catch (e, st) {
      AppLogger.e('dissolveSpace failed', e, st);
      rethrow;
    }
  }

  @override
  Future<String> acceptInvitation({
    required InviteBundle bundle,
    required String userId,
  }) async {
    try {
      if (DateTime.now().toUtc().millisecondsSinceEpoch > bundle.x) {
        throw const AdminFailure('Срок действия приглашения истёк');
      }
      final existing = await _dao.watchMembers(bundle.s).first;
      if (existing.any((e) => e.userId == userId && e.status != MemberStatus.left)) {
        throw const AdminFailure('Вы уже участник этого пространства');
      }
      final salt = await _crypto.unpackSpaceSalt(bundle);
      await _crypto.writeSpaceKey(bundle.s, salt);
      await _dao.joinSpace(
        spaceId: bundle.s,
        userId: userId,
        role: MemberRole.fromDb(bundle.r),
        membershipId: _uuid.v4(),
      );
      return bundle.s;
    } catch (e, st) {
      AppLogger.e('acceptInvitation failed', e, st);
      rethrow;
    }
  }

  @override
  Stream<SpaceSettingsRow?> watchSpaceSettings(String spaceId) =>
      _dao.watchSpaceSettings(spaceId);

  @override
  Stream<SpaceStatsRow> watchSpaceStats(String spaceId) =>
      _dao.watchSpaceStats(spaceId);

  @override
  Future<SpaceExportBundle> fetchSpaceExportBundle(String spaceId) =>
      _dao.fetchSpaceExportBundle(spaceId);

  @override
  Future<void> updateSpaceIdentity({required String spaceId, required String actorId,
    required String name, required String iconEmoji, required String iconColor,
    required String oldName}) async {
    try {
      await _guardAdmin(spaceId, actorId);
      await _dao.updateSpaceSettingsIdentity(spaceId, name, iconEmoji, iconColor);
      if (name != oldName) {
        await _audit(spaceId, actorId, AuditAction.spaceRenamed, spaceId,
            jsonEncode({
              'old_name_hash': sha256.convert(utf8.encode(oldName)).toString(),
              'new_name_hash': sha256.convert(utf8.encode(name)).toString(),
            }));
      }
    } catch (e, st) {
      AppLogger.e('updateSpaceIdentity failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> updateSpaceBudgetLimit({required String spaceId, required String actorId,
    required int? limitKopecks, required int? oldLimitKopecks}) async {
    try {
      await _guardAdmin(spaceId, actorId);
      await _dao.updateSpaceBudgetLimit(spaceId, limitKopecks);
      await _audit(spaceId, actorId, AuditAction.spaceBudgetChanged, spaceId,
          jsonEncode({
            'old_hash': sha256.convert(utf8.encode('${oldLimitKopecks ?? 0}')).toString(),
            'new_hash': sha256.convert(utf8.encode('${limitKopecks ?? 0}')).toString(),
          }));
    } catch (e, st) {
      AppLogger.e('updateSpaceBudgetLimit failed', e, st);
      rethrow;
    }
  }

  Future<void> _guardAdmin(String spaceId, String actorId) async {
    final ok = await isAdmin(actorId, spaceId);
    if (!ok) {
      throw const AdminFailure('Недостаточно прав: требуется роль админа');
    }
  }

  Future<void> _audit(
    String spaceId,
    String actorId,
    AuditAction action,
    String? targetId, [
    String metadata = '{}',
  ]) =>
      _dao.insertAuditFull(
        id: _uuid.v4(),
        spaceId: spaceId,
        actorId: actorId,
        action: action,
        targetId: targetId,
        metadataJson: metadata,
      );
}
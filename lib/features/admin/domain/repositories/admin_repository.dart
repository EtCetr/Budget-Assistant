import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/space_settings_usecases.dart';

abstract interface class AdminRepository {
  Stream<List<MemberInfo>> watchMembers(String spaceId);
  Stream<SpaceInfo?> watchSpaceInfo(String spaceId);
  Stream<ActivityStats> watchActivity(String spaceId);
  Stream<List<InvitationInfo>> watchInvitations(String spaceId);
  Stream<List<AuditEntry>> watchAudit(String spaceId);
  Stream<List<AuditEntry>> watchAuditFiltered(String spaceId, {DateTime? since, List<String>? actionTypes});
  Future<void> logAudit({required String spaceId, required String actorId,
    required AuditAction action, String? targetId, Map<String, dynamic>? metadata});
  Stream<int> watchExMemberDebtCount(String spaceId);
  Future<bool> isAdmin(String userId, String spaceId);
  Future<void> updateLastActive(String userId, String spaceId);
  Future<void> changeRole({required String spaceId, required String actorId,
      required MemberInfo target, required MemberRole newRole});
  Future<void> suspend({required String spaceId, required String actorId, required MemberInfo target});
  Future<void> resume({required String spaceId, required String actorId, required MemberInfo target});
  Future<void> remove({required String spaceId, required String actorId, required MemberInfo target});
  Future<void> transferAdmin({required String spaceId, required String actorId,
      required MemberInfo from, required MemberInfo to});
  Future<InvitationInfo> generateInvite({required String spaceId, required String actorId, required MemberRole role});
  Future<void> revokeInvite({required String spaceId, required String actorId, required String inviteId});
  Future<void> sendReminder({required String spaceId, required String actorId, required MemberInfo target});
  Future<void> dissolveSpace({required String spaceId, required String actorId});
  Stream<SpaceSettingsRow?> watchSpaceSettings(String spaceId);
  Stream<SpaceStatsRow> watchSpaceStats(String spaceId);
  Future<SpaceExportBundle> fetchSpaceExportBundle(String spaceId);
  Future<void> updateSpaceIdentity({required String spaceId, required String actorId,
    required String name, required String iconEmoji, required String iconColor,
    required String oldName});
  Future<void> updateSpaceBudgetLimit({required String spaceId, required String actorId,
    required int? limitKopecks, required int? oldLimitKopecks});
  Future<String> acceptInvitation({required InviteBundle bundle, required String userId});
}
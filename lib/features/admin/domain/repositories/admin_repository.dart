import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';

abstract interface class AdminRepository {
  Stream<List<MemberInfo>> watchMembers(String spaceId);
  Stream<SpaceInfo?> watchSpaceInfo(String spaceId);
  Stream<ActivityStats> watchActivity(String spaceId);
  Stream<List<InvitationInfo>> watchInvitations(String spaceId);
  Stream<List<AuditEntry>> watchAudit(String spaceId);
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
  Future<String> acceptInvitation({required InviteBundle bundle, required String userId});
}
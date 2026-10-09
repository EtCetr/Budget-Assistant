import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/repositories/admin_repository.dart';

class GenerateInviteUseCase {
  GenerateInviteUseCase(this._repo);
  final AdminRepository _repo;
  Future<InvitationInfo> call({required String spaceId, required String actorId,
      required MemberRole role}) async {
    try {
      return await _repo.generateInvite(spaceId: spaceId, actorId: actorId, role: role);
    } catch (e, st) {
      AppLogger.e('GenerateInvite failed', e, st);
      rethrow;
    }
  }
}

class RevokeInviteUseCase {
  RevokeInviteUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({required String spaceId, required String actorId, required String inviteId}) async {
    try {
      await _repo.revokeInvite(spaceId: spaceId, actorId: actorId, inviteId: inviteId);
    } catch (e, st) {
      AppLogger.e('RevokeInvite failed', e, st);
      rethrow;
    }
  }
}

/// Принятие инвайта: HKDF(token) -> AES-GCM decrypt(encrypted_salt) -> SecureStorage -> membership.
class AcceptInvitationUseCase {
  AcceptInvitationUseCase(this._repo);
  final AdminRepository _repo;
  Future<String> call({required String linkToken, required String userId}) async {
    try {
      final bundle = InviteBundle.fromLink(linkToken);
      return await _repo.acceptInvitation(bundle: bundle, userId: userId);
    } catch (e, st) {
      AppLogger.e('AcceptInvitation failed', e, st);
      rethrow;
    }
  }
}
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/repositories/admin_repository.dart';

class CheckAdminAccessUseCase {
  CheckAdminAccessUseCase(this._repo);
  final AdminRepository _repo;
  Future<bool> call(String userId, String spaceId) async {
    try {
      return await _repo.isAdmin(userId, spaceId);
    } catch (e, st) {
      AppLogger.e('CheckAdminAccess failed', e, st);
      rethrow;
    }
  }
}

class ChangeMemberRoleUseCase {
  ChangeMemberRoleUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({required String spaceId, required String actorId,
      required MemberInfo target, required MemberRole newRole}) async {
    try {
      await _repo.changeRole(spaceId: spaceId, actorId: actorId, target: target, newRole: newRole);
    } catch (e, st) {
      AppLogger.e('ChangeMemberRole failed', e, st);
      rethrow;
    }
  }
}

class SuspendMemberUseCase {
  SuspendMemberUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({required String spaceId, required String actorId, required MemberInfo target}) async {
    try {
      await _repo.suspend(spaceId: spaceId, actorId: actorId, target: target);
    } catch (e, st) {
      AppLogger.e('SuspendMember failed', e, st);
      rethrow;
    }
  }
}

class ResumeMemberUseCase {
  ResumeMemberUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({required String spaceId, required String actorId, required MemberInfo target}) async {
    try {
      await _repo.resume(spaceId: spaceId, actorId: actorId, target: target);
    } catch (e, st) {
      AppLogger.e('ResumeMember failed', e, st);
      rethrow;
    }
  }
}

class RemoveMemberUseCase {
  RemoveMemberUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({required String spaceId, required String actorId, required MemberInfo target}) async {
    try {
      await _repo.remove(spaceId: spaceId, actorId: actorId, target: target);
    } catch (e, st) {
      AppLogger.e('RemoveMember failed', e, st);
      rethrow;
    }
  }
}

class TransferAdminRoleUseCase {
  TransferAdminRoleUseCase(this._repo);
  final AdminRepository _repo;
  // D17-6: PIN-подтверждение — долг Этапа 21 (сейчас confirm-диалог в UI).
  Future<void> call({required String spaceId, required String actorId,
      required MemberInfo from, required MemberInfo to}) async {
    try {
      await _repo.transferAdmin(spaceId: spaceId, actorId: actorId, from: from, to: to);
    } catch (e, st) {
      AppLogger.e('TransferAdminRole failed', e, st);
      rethrow;
    }
  }
}

class UpdateLastActiveAtUseCase {
  UpdateLastActiveAtUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call(String userId, String spaceId) => _repo.updateLastActive(userId, spaceId);
}

class SendReminderUseCase {
  SendReminderUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({required String spaceId, required String actorId, required MemberInfo target}) async {
    try {
      await _repo.sendReminder(spaceId: spaceId, actorId: actorId, target: target);
    } catch (e, st) {
      AppLogger.e('SendReminder failed', e, st);
      rethrow;
    }
  }
}
class DissolveSpaceUseCase {
  DissolveSpaceUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({required String spaceId, required String actorId}) async {
    try {
      await _repo.dissolveSpace(spaceId: spaceId, actorId: actorId);
    } catch (e, st) {
      AppLogger.e('DissolveSpace failed', e, st);
      rethrow;
    }
  }
}
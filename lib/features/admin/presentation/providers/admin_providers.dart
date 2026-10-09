import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/providers/database_providers.dart';
import 'package:budget_assistant/core/providers/security_providers.dart' as sec;
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/admin/data/crypto/invite_crypto_service.dart';
import 'package:budget_assistant/features/admin/data/daos/admin_dao.dart';
import 'package:budget_assistant/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/repositories/admin_repository.dart';
import 'package:budget_assistant/features/admin/domain/usecases/dashboard_usecases.dart';
import 'package:budget_assistant/features/admin/domain/usecases/invites_usecases.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_usecases.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_providers.dart';

/// userId + spaceId текущего админ-контекста.
/// D17-14: в проекте два currentSpaceIdProvider (router + security) — читаем оба,
/// фолбэк на первое активное пространство пользователя.
class AdminScope {
  const AdminScope({required this.userId, required this.spaceId});
  final String userId;
  final String spaceId;
}

final adminScopeProvider = Provider<AdminScope?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  var spaceId = ref.watch(currentSpaceIdProvider);
  if (spaceId == null) {
    final secSpace = ref.watch(sec.currentSpaceIdProvider);
    if (secSpace is String) {
      spaceId = secSpace;
    }
  }
  if (spaceId == null) {
    final spaces = ref.watch(userSpacesProvider).value ?? const [];
    if (spaces.isNotEmpty) {
      spaceId = spaces.first.id;
    }
  }
  if (spaceId == null) {
    return null;
  }
  return AdminScope(userId: userId, spaceId: spaceId);
});

final adminDaoProvider = Provider<AdminDao>(
    (ref) => AdminDao(ref.watch(appDatabaseProvider)));

final inviteCryptoServiceProvider =
    Provider<InviteCryptoService>((ref) => InviteCryptoService());

final adminRepositoryProvider = Provider<AdminRepository>((ref) =>
    AdminRepositoryImpl(
      dao: ref.watch(adminDaoProvider),
      crypto: ref.watch(inviteCryptoServiceProvider),
    ));

final checkAdminAccessUseCaseProvider = Provider<CheckAdminAccessUseCase>(
    (ref) => CheckAdminAccessUseCase(ref.watch(adminRepositoryProvider)));
final changeMemberRoleUseCaseProvider = Provider<ChangeMemberRoleUseCase>(
    (ref) => ChangeMemberRoleUseCase(ref.watch(adminRepositoryProvider)));
final suspendMemberUseCaseProvider = Provider<SuspendMemberUseCase>(
    (ref) => SuspendMemberUseCase(ref.watch(adminRepositoryProvider)));
final resumeMemberUseCaseProvider = Provider<ResumeMemberUseCase>(
    (ref) => ResumeMemberUseCase(ref.watch(adminRepositoryProvider)));
final removeMemberUseCaseProvider = Provider<RemoveMemberUseCase>(
    (ref) => RemoveMemberUseCase(ref.watch(adminRepositoryProvider)));
final transferAdminRoleUseCaseProvider = Provider<TransferAdminRoleUseCase>(
    (ref) => TransferAdminRoleUseCase(ref.watch(adminRepositoryProvider)));
final updateLastActiveAtUseCaseProvider = Provider<UpdateLastActiveAtUseCase>(
    (ref) => UpdateLastActiveAtUseCase(ref.watch(adminRepositoryProvider)));
final sendReminderUseCaseProvider = Provider<SendReminderUseCase>(
    (ref) => SendReminderUseCase(ref.watch(adminRepositoryProvider)));
final dissolveSpaceUseCaseProvider = Provider<DissolveSpaceUseCase>(
    (ref) => DissolveSpaceUseCase(ref.watch(adminRepositoryProvider)));
final generateInviteUseCaseProvider = Provider<GenerateInviteUseCase>(
    (ref) => GenerateInviteUseCase(ref.watch(adminRepositoryProvider)));
final revokeInviteUseCaseProvider = Provider<RevokeInviteUseCase>(
    (ref) => RevokeInviteUseCase(ref.watch(adminRepositoryProvider)));
final acceptInvitationUseCaseProvider = Provider<AcceptInvitationUseCase>(
    (ref) => AcceptInvitationUseCase(ref.watch(adminRepositoryProvider)));

final adminAccessProvider = FutureProvider.family<bool, AdminScope>(
    (ref, scope) => ref
        .watch(checkAdminAccessUseCaseProvider)
        .call(scope.userId, scope.spaceId));

final membersStreamProvider =
    StreamProvider.family<List<MemberInfo>, String>((ref, spaceId) =>
        WatchMembersUseCase(ref.watch(adminRepositoryProvider)).call(spaceId));
final memberStatsProvider =
    StreamProvider.family<MemberStats, String>((ref, spaceId) =>
        GetMemberStatsUseCase(ref.watch(adminRepositoryProvider)).call(spaceId));
final spaceInfoProvider =
    StreamProvider.family<SpaceInfo?, String>((ref, spaceId) =>
        WatchSpaceInfoUseCase(ref.watch(adminRepositoryProvider)).call(spaceId));
final activityStatsProvider =
    StreamProvider.family<ActivityStats, String>((ref, spaceId) =>
        WatchActivityStatsUseCase(ref.watch(adminRepositoryProvider)).call(spaceId));
final criticalAlertsProvider =
    StreamProvider.family<List<CriticalAlert>, String>((ref, spaceId) =>
        GetCriticalAlertsUseCase(ref.watch(adminRepositoryProvider)).call(spaceId));
final invitationsStreamProvider =
    StreamProvider.family<List<InvitationInfo>, String>((ref, spaceId) =>
        WatchInvitationsUseCase(ref.watch(adminRepositoryProvider)).call(spaceId));
final auditLogProvider =
    StreamProvider.family<List<AuditEntry>, String>((ref, spaceId) =>
        WatchAuditLogUseCase(ref.watch(adminRepositoryProvider)).call(spaceId));
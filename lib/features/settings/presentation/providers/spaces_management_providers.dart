// lib/features/settings/presentation/providers/spaces_management_providers.dart
// Этап 21 (ТЗ 6.3.51): провайдеры экрана управления пространствами.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/spaces/domain/entities/space_membership_info.dart';
import 'package:budget_assistant/features/spaces/domain/usecases/leave_space_usecase.dart';

final leaveSpaceUseCaseProvider = Provider<LeaveSpaceUseCase>(
  (ref) => LeaveSpaceUseCase(db: ref.watch(appDatabaseProvider)),
);

/// Все пространства пользователя: активные (membership active + space active)
/// и расформированные (space dissolved) для секции архива.
final spacesManagementProvider =
    StreamProvider<List<SpaceMembershipInfo>>((ref) async* {
  final userId = ref.watch(currentUserIdProvider);
  final db = ref.watch(appDatabaseProvider);
  await for (final memberships
      in db.membershipsDao.watchAllByUserId(userId)) {
    final result = <SpaceMembershipInfo>[];
    for (final m in memberships) {
      final space = await db.spacesDao.getById(m.spaceId);
      if (space == null) continue;
      final pairActive = m.status == 'active' && space.status == 'active';
      final pairDissolved = space.status == 'dissolved';
      if (!pairActive && !pairDissolved) continue;
      final memberCount =
          pairActive ? await db.membershipsDao.countActiveMembers(space.id) : 0;
      result.add(SpaceMembershipInfo(
        spaceId: space.id,
        spaceName: space.name,
        iconEmoji: space.iconEmoji,
        iconColor: space.iconColor,
        spaceStatus: space.status,
        dissolvedAt: space.dissolvedAt,
        role: m.role,
        joinedAt: m.joinedAt,
        memberCount: memberCount,
      ));
    }
    result.sort((a, b) => a.isDissolved == b.isDissolved
        ? a.joinedAt.compareTo(b.joinedAt)
        : (a.isDissolved ? 1 : -1));
    yield result;
  }
});
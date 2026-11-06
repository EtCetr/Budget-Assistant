// lib/features/spaces/domain/usecases/leave_space_usecase.dart
// Этап 21 (ТЗ 6.3.51.3 / 6.3.39.6): выход из пространства — 4 сценария.
// D17-12: расформирование = soft-delete (status='dissolved'), строки живут.
import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';

enum LeaveSpaceScenario { simpleLeave, autoPromote, chooseSuccessor, dissolveSolo }

class LeaveSpaceEvaluation {
  const LeaveSpaceEvaluation({
    required this.scenario,
    this.candidates = const [],
  });

  final LeaveSpaceScenario scenario;

  /// Кандидаты в преемники (>2 участников, я — единственный админ).
  final List<Membership> candidates;
}

class LeaveSpaceUseCase {
  const LeaveSpaceUseCase({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  Future<LeaveSpaceEvaluation> evaluate({
    required String userId,
    required String spaceId,
  }) async {
    try {
      final mine = await (_db.select(_db.memberships)
            ..where((t) =>
                t.userId.equals(userId) &
                t.spaceId.equals(spaceId) &
                t.status.equals('active')))
          .getSingleOrNull();
      if (mine == null) {
        throw StateError('Нет активного членства в пространстве $spaceId');
      }
      if (mine.role != 'admin') {
        return const LeaveSpaceEvaluation(
          scenario: LeaveSpaceScenario.simpleLeave,
        );
      }
      final admins = await (_db.select(_db.memberships)
            ..where((t) =>
                t.spaceId.equals(spaceId) &
                t.status.equals('active') &
                t.role.equals('admin')))
          .get();
      if (admins.length > 1) {
        return const LeaveSpaceEvaluation(
          scenario: LeaveSpaceScenario.simpleLeave,
        );
      }
      final members = await (_db.select(_db.memberships)
            ..where((t) =>
                t.spaceId.equals(spaceId) & t.status.equals('active')))
          .get();
      if (members.length == 1) {
        return const LeaveSpaceEvaluation(
          scenario: LeaveSpaceScenario.dissolveSolo,
        );
      }
      if (members.length == 2) {
        return const LeaveSpaceEvaluation(
          scenario: LeaveSpaceScenario.autoPromote,
        );
      }
      return LeaveSpaceEvaluation(
        scenario: LeaveSpaceScenario.chooseSuccessor,
        candidates: members.where((m) => m.userId != userId).toList(),
      );
    } catch (e, st) {
      AppLogger.e('LeaveSpaceUseCase.evaluate failed', e, st);
      rethrow;
    }
  }

  /// Простой выход (member или админ с другими админами).
  Future<void> simpleLeave({
    required String userId,
    required String spaceId,
  }) =>
      _leave(
        userId: userId,
        spaceId: spaceId,
        promoteUserId: null,
        dissolve: false,
      );

  /// 2 участника: оставшийся автоматически становится админом.
  Future<void> leaveWithAutoPromote({
    required String userId,
    required String spaceId,
  }) async {
    final rest = await (_db.select(_db.memberships)
          ..where((t) =>
              t.spaceId.equals(spaceId) &
              t.status.equals('active') &
              t.userId.equals(userId).not()))
        .getSingle();
    await _leave(
      userId: userId,
      spaceId: spaceId,
      promoteUserId: rest.userId,
      dissolve: false,
    );
  }

  /// >2 участников: повышаем выбранного преемника и выходим.
  Future<void> leaveWithSuccessor({
    required String userId,
    required String spaceId,
    required String successorUserId,
  }) =>
      _leave(
        userId: userId,
        spaceId: spaceId,
        promoteUserId: successorUserId,
        dissolve: false,
      );

  /// Я один: расформирование пространства (D17-12).
  Future<void> dissolveSolo({
    required String userId,
    required String spaceId,
  }) =>
      _leave(
        userId: userId,
        spaceId: spaceId,
        promoteUserId: null,
        dissolve: true,
      );

  Future<void> _leave({
    required String userId,
    required String spaceId,
    String? promoteUserId,
    required bool dissolve,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      await _db.transaction(() async {
        if (promoteUserId != null) {
          await (_db.update(_db.memberships)
                ..where((t) =>
                    t.spaceId.equals(spaceId) &
                    t.userId.equals(promoteUserId) &
                    t.status.equals('active')))
              .write(MembershipsCompanion(
            role: const Value('admin'),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ));
        }
        if (dissolve) {
          await (_db.update(_db.spaces)..where((t) => t.id.equals(spaceId)))
              .write(SpacesCompanion(
            status: const Value('dissolved'),
            dissolvedAt: Value(now),
            dissolvedBy: Value(userId),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ));
          await (_db.update(_db.memberships)
                ..where((t) =>
                    t.spaceId.equals(spaceId) & t.status.equals('active')))
              .write(MembershipsCompanion(
            status: const Value('left'),
            leftAt: Value(now),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ));
        } else {
          await (_db.update(_db.memberships)
                ..where((t) =>
                    t.spaceId.equals(spaceId) &
                    t.userId.equals(userId) &
                    t.status.equals('active')))
              .write(MembershipsCompanion(
            status: const Value('left'),
            leftAt: Value(now),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ));
        }
        // ТЗ 6.3.39.6.e.ii: мои транзакции пространства -> архив.
        await _db.customStatement(
          'UPDATE transactions SET is_archived_for_space = 1, sync_status = ?, updated_at = ? WHERE space_id = ? AND user_id = ? AND is_archived_for_space = 0',
          [
            Variable.withString('pending'),
            Variable.withInt(now.millisecondsSinceEpoch ~/ 1000),
            Variable.withString(spaceId),
            Variable.withString(userId),
          ],
        );
      });
      AppLogger.i(
        'Space $spaceId left (dissolve=$dissolve, promote=$promoteUserId)',
      );
    } catch (e, st) {
      AppLogger.e('LeaveSpaceUseCase failed', e, st);
      rethrow;
    }
  }
}
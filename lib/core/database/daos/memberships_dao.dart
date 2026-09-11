import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/memberships.dart';

part 'memberships_dao.g.dart';

@DriftAccessor(tables: [Memberships])
class MembershipsDao extends DatabaseAccessor<AppDatabase>
    with _$MembershipsDaoMixin {
  MembershipsDao(super.db);

  Future<List<Membership>> getByUserId(String userId) {
    return (select(
      memberships,
    )..where((t) => t.userId.equals(userId) & t.status.equals('active'))).get();
  }

  Stream<List<Membership>> watchByUserId(String userId) {
    return (select(memberships)
          ..where((t) => t.userId.equals(userId) & t.status.equals('active')))
        .watch();
  }

  Future<List<Membership>> getBySpaceId(String spaceId) {
    return (select(memberships)
          ..where((t) => t.spaceId.equals(spaceId) & t.status.equals('active')))
        .get();
  }

  Future<bool> isAdmin(String userId, String spaceId) async {
    final membership =
        await (select(memberships)..where(
              (t) => t.userId.equals(userId) & t.spaceId.equals(spaceId),
            ))
            .getSingleOrNull();
    return membership?.role == 'admin';
  }

  Future<int> updateLastActive(String id) {
    return (update(memberships)..where((t) => t.id.equals(id))).write(
      // MembershipsCompanion — от имени таблицы!
      MembershipsCompanion(
        lastActiveAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value('pending'),
      ),
    );
  }

  Future<void> upsert(Membership membership) {
    return into(
      memberships,
    ).insertOnConflictUpdate(membership.toCompanion(true));
  }

  Future<int> leave(String id) {
    return (update(memberships)..where((t) => t.id.equals(id))).write(
      MembershipsCompanion(
        status: const Value('left'),
        leftAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value('pending'),
      ),
    );
  }
}

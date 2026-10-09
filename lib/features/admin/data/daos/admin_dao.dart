import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';

/// DAO админ-контура. Свои таблицы — type-safe Drift; чужие — customSelect
/// (Drift парсит таблицы из SQL сам для реактивности watch()).
class AdminDao {
  AdminDao(this._db);
  final AppDatabase _db;

  static const String _memberSql = '''
    SELECT m.id AS id, m.space_id AS space_id, m.user_id AS user_id,
           COALESCE(u.display_name, 'Без имени') AS display_name, u.email AS email,
           m.role AS role, m.status AS status, m.joined_at AS joined_at,
           m.last_active_at AS last_active_at,
           (SELECT COUNT(*) FROM debts d
             WHERE d.debtor_id = m.user_id AND d.space_id = m.space_id AND d.resolution_status = 'active') AS open_debts_count,
           (SELECT COALESCE(SUM(d.amount), 0) FROM debts d
             WHERE d.debtor_id = m.user_id AND d.space_id = m.space_id AND d.resolution_status = 'active') AS open_debts_amount,
           (SELECT COUNT(*) FROM transactions t
             WHERE t.user_id = m.user_id AND t.space_id = m.space_id AND t.date > ?) AS tx30d
    FROM memberships m LEFT JOIN users u ON u.id = m.user_id
    WHERE m.space_id = ?
    ORDER BY CASE m.role WHEN 'admin' THEN 0 ELSE 1 END, m.joined_at ASC
  ''';

  Stream<List<MemberInfo>> watchMembers(String spaceId) {
    final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 30));
    return _db.customSelect(_memberSql, variables: [
      Variable.withInt(cutoff.millisecondsSinceEpoch ~/ 1000),
      Variable.withString(spaceId),
    ]).watch().map((rows) => rows.map((r) => MemberInfo(
          id: r.read<String>('id'),
          spaceId: r.read<String>('space_id'),
          userId: r.read<String>('user_id'),
          displayName: r.read<String>('display_name'),
          email: r.readNullable<String>('email'),
          role: MemberRole.fromDb(r.readNullable<String>('role')),
          status: MemberStatus.fromDb(r.readNullable<String>('status')),
          joinedAt: r.read<DateTime>('joined_at'),
          lastActiveAt: r.readNullable<DateTime>('last_active_at'),
          openDebtsCount: r.read<int>('open_debts_count'),
          openDebtsAmountKopecks: r.read<int>('open_debts_amount'),
          tx30d: r.read<int>('tx30d'),
        )).toList());
  }

  Stream<SpaceInfo?> watchSpaceInfo(String spaceId) => _db.customSelect(
        '''SELECT s.id AS id, s.name AS name, s.created_at AS created_at,
            (SELECT COUNT(*) FROM memberships m
              WHERE m.space_id = s.id AND m.status = 'active') AS mc
           FROM spaces s WHERE s.id = ?''',
        variables: [Variable.withString(spaceId)],
      ).watch().map((rows) => rows.isEmpty ? null : SpaceInfo(
            id: rows.first.read<String>('id'),
            name: rows.first.read<String>('name'),
            createdAt: rows.first.read<DateTime>('created_at'),
            membersCount: rows.first.read<int>('mc'),
          ));

  Stream<ActivityStats> watchActivity(String spaceId) {
    final now = DateTime.now().toUtc();
    final d7 = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000;
    final d30 = now.subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000;
    final m0 = DateTime.utc(now.year, now.month, 1).millisecondsSinceEpoch ~/ 1000;
    return _db.customSelect(
      '''SELECT SUM(CASE WHEN date >= ? THEN 1 ELSE 0 END) AS tx7d,
                COUNT(*) AS tx30d, MAX(date) AS last_tx,
                SUM(CASE WHEN type = 'expense' AND date >= ? THEN amount ELSE 0 END) AS exp_m,
                SUM(CASE WHEN type = 'income'  AND date >= ? THEN amount ELSE 0 END) AS inc_m
         FROM transactions WHERE space_id = ? AND date >= ?''',
      variables: [
        Variable.withInt(d7), Variable.withInt(m0), Variable.withInt(m0),
        Variable.withString(spaceId), Variable.withInt(d30),
      ],
    ).watch().map((rows) {
      final r = rows.first;
      final last = r.readNullable<int>('last_tx');
      return ActivityStats(
        tx7d: r.readNullable<int>('tx7d') ?? 0,
        tx30d: r.readNullable<int>('tx30d') ?? 0,
        lastTxAt: last == null ? null : DateTime.fromMillisecondsSinceEpoch(last * 1000, isUtc: true),
        monthExpenseKopecks: r.readNullable<int>('exp_m') ?? 0,
        monthIncomeKopecks: r.readNullable<int>('inc_m') ?? 0,
      );
    });
  }

  Stream<int> watchExMemberDebtCount(String spaceId) => _db.customSelect(
        '''SELECT COUNT(*) AS c FROM debts
           WHERE space_id = ? AND is_ex_member_debt = 1 AND resolution_status != 'resolved' ''',
        variables: [Variable.withString(spaceId)],
      ).watch().map((rows) => rows.first.read<int>('c'));

  Stream<List<InvitationInfo>> watchInvitations(String spaceId) =>
      (_db.select(_db.invitations)
            ..where((t) => t.spaceId.equals(spaceId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch()
          .map((rows) => rows
              .map((r) => InvitationInfo(
                    id: r.id, spaceId: r.spaceId,
                    role: MemberRole.fromDb(r.role), status: r.status,
                    expiresAt: r.expiresAt, createdAt: r.createdAt,
                    deepLink: 'budgetassistant://join?token=${r.token}',
                  ))
              .toList());

  Stream<List<AuditEntry>> watchAudit(String spaceId, {int limit = 50}) =>
      (_db.select(_db.adminAuditLog)
            ..where((t) => t.spaceId.equals(spaceId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .watch()
          .map((rows) => rows
              .map((r) => AuditEntry(
                    id: r.id, action: AuditAction.fromDb(r.actionType),
                    actorUserId: r.actorUserId, targetId: r.targetId,
                    metadataJson: r.metadataJson, createdAt: r.createdAt,
                  ))
              .toList());

  Future<void> insertInvitation(InvitationInfo inv, String token, String encryptedSalt, String actorId) =>
      _db.into(_db.invitations).insert(InvitationsCompanion.insert(
            id: inv.id, spaceId: inv.spaceId, token: token, encryptedSalt: encryptedSalt,
            role: Value(inv.role.dbValue), status: const Value('active'),
            createdBy: actorId, expiresAt: inv.expiresAt,
            createdAt: DateTime.now().toUtc(), updatedAt: DateTime.now().toUtc(),
          ));

  Future<void> revokeInvitation(String id) => (_db.update(_db.invitations)
        ..where((t) => t.id.equals(id)))
      .write(InvitationsCompanion(status: const Value('revoked'), updatedAt: Value(DateTime.now().toUtc())));

  Future<void> insertAuditFull({required String id, required String spaceId, required String actorId,
      required AuditAction action, String? targetId, String metadataJson = '{}'}) =>
      _db.into(_db.adminAuditLog).insert(AdminAuditLogCompanion.insert(
            id: id, spaceId: spaceId, actorUserId: actorId, actionType: action.dbValue,
            targetId: Value(targetId), metadataJson: Value(metadataJson),
            createdAt: DateTime.now().toUtc(),
          ));

  Future<int> countActiveAdmins(String spaceId) async {
    final rows = await _db.customSelect(
      '''SELECT COUNT(*) AS c FROM memberships
         WHERE space_id = ? AND role = 'admin' AND status = 'active' ''',
      variables: [Variable.withString(spaceId)],
    ).get();
    return rows.first.read<int>('c');
  }

  Future<void> updateLastActive(String userId, String spaceId) => _db.customUpdate(
        'UPDATE memberships SET last_active_at = ?, sync_status = \'pending\' WHERE user_id = ? AND space_id = ?',
        variables: [
          Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
          Variable.withString(userId), Variable.withString(spaceId),
        ],
      );

  Future<void> changeRole(String membershipId, MemberRole role) => _db.customUpdate(
        "UPDATE memberships SET role = ?, updated_at = ?, sync_status = 'pending' WHERE id = ?",
        variables: [
          Variable.withString(role.dbValue),
          Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
          Variable.withString(membershipId),
        ],
      );

  Future<void> setStatus(String membershipId, MemberStatus status) => _db.customUpdate(
        "UPDATE memberships SET status = ?, updated_at = ?, sync_status = 'pending' WHERE id = ?",
        variables: [
          Variable.withString(status.dbValue),
          Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
          Variable.withString(membershipId),
        ],
      );

  Future<void> transferAdmin(String fromMembershipId, String toMembershipId) =>
      _db.transaction(() async {
        await changeRole(fromMembershipId, MemberRole.member);
        await changeRole(toMembershipId, MemberRole.admin);
      });

  Future<void> markExMemberDebts(String userId, String spaceId) => _db.customUpdate(
        "UPDATE debts SET is_ex_member_debt = 1, sync_status = 'pending' "
        'WHERE debtor_id = ? AND space_id = ? AND resolution_status = \'active\'',
        variables: [Variable.withString(userId), Variable.withString(spaceId)],
      );

  Future<void> insertReminderNotification({required String id, required String userId,
      required String title, required String body}) =>
      _db.customInsert(
        "INSERT INTO notifications (id, user_id, type, title, body, is_read, created_at, updated_at, sync_status) "
        'VALUES (?, ?, ?, ?, ?, 0, ?, ?, \'pending\')',
        variables: [
          Variable.withString(id), Variable.withString(userId),
          Variable.withString('admin_reminder'), Variable.withString(title),
          Variable.withString(body),
          Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
          Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
        ],
      );

  /// D17-12: soft-delete группы (status='dissolved'), только при 1 участнике (guard в repo).
  Future<void> dissolveSpace(String spaceId, String auditId, String actorId) =>
      _db.transaction(() async {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
        await _db.customUpdate(
          "UPDATE spaces SET status = 'dissolved', updated_at = ?, sync_status = 'pending' WHERE id = ?",
          variables: [Variable.withInt(now), Variable.withString(spaceId)],
        );
        await _db.customUpdate(
          "UPDATE memberships SET status = 'left', left_at = ?, updated_at = ?, sync_status = 'pending' WHERE space_id = ? AND status = 'active'",
          variables: [
            Variable.withInt(now), Variable.withInt(now), Variable.withString(spaceId),
          ],
        );
        await insertAuditFull(
          id: auditId, spaceId: spaceId, actorId: actorId,
          action: AuditAction.spaceDissolved, targetId: spaceId,
        );
      });

  Future<void> joinSpace({required String spaceId, required String userId,
      required MemberRole role, required String membershipId}) =>
      _db.transaction(() async {
        await _db.customInsert(
          "INSERT OR IGNORE INTO spaces (id, name, created_at, updated_at, sync_status, encryption_salt) "
          "VALUES (?, 'Семейное пространство (ожидает синка)', ?, ?, 'pending', 'stub_salt')",
          variables: [
            Variable.withString(spaceId),
            Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
            Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
          ],
        );
        await _db.customInsert(
          "INSERT OR IGNORE INTO memberships (id, space_id, user_id, role, status, joined_at, "
          "created_at, updated_at, sync_status) VALUES (?, ?, ?, ?, 'active', ?, ?, ?, 'pending')",
          variables: [
            Variable.withString(membershipId), Variable.withString(spaceId),
            Variable.withString(userId), Variable.withString(role.dbValue),
            Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
            Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
            Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
          ],
        );
      });
}
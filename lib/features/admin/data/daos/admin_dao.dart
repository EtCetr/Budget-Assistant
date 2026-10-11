import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';
import 'package:budget_assistant/features/admin/domain/usecases/space_settings_usecases.dart';

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
           m.left_at AS left_at,           (SELECT COUNT(*) FROM debts d
             WHERE d.debtor_id = m.user_id AND d.space_id = m.space_id AND d.resolution_status = 'active') AS open_debts_count,
           (SELECT COALESCE(SUM(d.amount), 0) FROM debts d
             WHERE d.debtor_id = m.user_id AND d.space_id = m.space_id AND d.resolution_status = 'active') AS open_debts_amount,
           (SELECT COUNT(*) FROM transactions t
             WHERE t.user_id = m.user_id AND t.space_id = m.space_id AND t.date > ?) AS tx30d,
             (SELECT COUNT(*) FROM transactions t
               WHERE t.user_id = m.user_id AND t.space_id = m.space_id
                 AND (m.left_at IS NULL OR t.date < m.left_at)) AS tx_before_left    FROM memberships m LEFT JOIN users u ON u.id = m.user_id
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
          leftAt: r.readNullable<DateTime>('left_at'),
          txBeforeLeft: r.read<int>('tx_before_left'),        )).toList());
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
        syncStatus: r.syncStatus,
                  ))
              .toList());

  /// Этап 18 (6.3.35): период и фильтр действий уходят в SQL WHERE (фильтры только в SQL).
  Stream<List<AuditEntry>> watchAuditFiltered(String spaceId, {DateTime? since, List<String>? actionTypes}) {
    final q = _db.select(_db.adminAuditLog)..where((t) => t.spaceId.equals(spaceId));
    if (since != null) q.where((t) => t.createdAt.isBiggerOrEqualValue(since));
    if (actionTypes != null && actionTypes.isNotEmpty) q.where((t) => t.actionType.isIn(actionTypes));
    q.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return q.watch().map((rows) => rows.map((r) => AuditEntry(
      id: r.id, action: AuditAction.fromDb(r.actionType),
      actorUserId: r.actorUserId, targetId: r.targetId,
      metadataJson: r.metadataJson, createdAt: r.createdAt,
      syncStatus: r.syncStatus,
    )).toList());
  }

  /// Имя пользователя для рендера аудита (имена НЕ хранятся в metadata_json).
  Future<String?> userNameById(String userId) async {
    final rows = await _db.customSelect(
      'SELECT display_name AS n, email AS e FROM users WHERE id = ?',
      variables: [Variable.withString(userId)],
    ).get();
    if (rows.isEmpty) return null;
    final n = rows.first.readNullable<String>('n');
    if (n != null && n.trim().isNotEmpty) return n;
    final e = rows.first.readNullable<String>('e');
    if (e != null && e.trim().isNotEmpty) return e;
    return null;
  }

  /// Этап 18 (6.3.34): операции по дням и участникам (стек-бар) — фильтры в SQL.
  Stream<List<DayUserCountRow>> watchDayUserCounts(String spaceId, int sinceEpoch) =>
      _db
          .customSelect(
            'SELECT strftime(\'%Y-%m-%d\', date, \'unixepoch\', \'localtime\') AS day, '
            'user_id, COUNT(*) AS c FROM transactions '
            'WHERE space_id = ? AND date >= ? GROUP BY day, user_id',
            variables: [
              Variable.withString(spaceId),
              Variable.withInt(sinceEpoch),
            ],
            readsFrom: {_db.transactions},
          )
          .watch()
          .map((rows) => [
                for (final r in rows)
                  DayUserCountRow(
                    day: r.read<String>('day'),
                    userId: r.read<String>('user_id'),
                    count: r.read<int>('c'),
                  ),
              ]);

  /// Этап 18 (6.3.34): сколько операций сделал каждый участник за период.
  Stream<List<UserCountRow>> watchUserCounts(String spaceId, int sinceEpoch) =>
      _db
          .customSelect(
            'SELECT user_id, COUNT(*) AS c FROM transactions '
            'WHERE space_id = ? AND date >= ? GROUP BY user_id',
            variables: [
              Variable.withString(spaceId),
              Variable.withInt(sinceEpoch),
            ],
            readsFrom: {_db.transactions},
          )
          .watch()
          .map((rows) => [
                for (final r in rows)
                  UserCountRow(
                    userId: r.read<String>('user_id'),
                    count: r.read<int>('c'),
                  ),
              ]);

  /// Этап 18 (6.3.36): identity пространства + семейный лимит.
  Stream<SpaceSettingsRow?> watchSpaceSettings(String spaceId) =>
      (_db.select(_db.spaces)..where((t) => t.id.equals(spaceId)))
          .watchSingleOrNull()
          .map((r) => r == null
              ? null
              : SpaceSettingsRow(
                  id: r.id,
                  name: r.name,
                  iconEmoji: r.iconEmoji,
                  iconColor: r.iconColor,
                  monthlyBudgetLimit: r.monthlyBudgetLimit,
                  createdAt: r.createdAt,
                  syncStatus: r.syncStatus,
                ));

  Stream<SpaceStatsRow> watchSpaceStats(String spaceId) => _db.customSelect(
        'SELECT (SELECT COUNT(*) FROM accounts a WHERE a.space_id = ? AND a.is_archived = 0) AS acc, '
        '(SELECT COUNT(*) FROM transactions t WHERE t.space_id = ?) AS tx, '
        '(SELECT COALESCE(SUM(a.current_balance), 0) FROM accounts a '
        ' WHERE a.space_id = ? AND a.include_in_family_balance = 1) AS bal',
        variables: [
          Variable.withString(spaceId),
          Variable.withString(spaceId),
          Variable.withString(spaceId),
        ],
        readsFrom: {_db.accounts, _db.transactions},
      ).watch().map((rows) {
        final r = rows.first;
        return SpaceStatsRow(
          accountsCount: r.read<int>('acc'),
          transactionsCount: r.read<int>('tx'),
          familyBalanceKopecks: r.read<int>('bal'),
        );
      });

  Future<int> countSpaceTransactions(String spaceId) async {
    final rows = await _db.customSelect(
      'SELECT COUNT(*) AS c FROM transactions WHERE space_id = ?',
      variables: [Variable.withString(spaceId)],
      readsFrom: {_db.transactions},
    ).get();
    return rows.first.read<int>('c');
  }

  Future<void> updateSpaceSettingsIdentity(
          String spaceId, String name, String iconEmoji, String iconColor) =>
      (_db.update(_db.spaces)..where((t) => t.id.equals(spaceId))).write(
            SpacesCompanion(
              name: Value(name),
              iconEmoji: Value<String?>(iconEmoji),
              iconColor: Value<String?>(iconColor),
              updatedAt: Value(DateTime.now().toUtc()),
              syncStatus: const Value('pending'),
            ),
          );

  Future<void> updateSpaceBudgetLimit(String spaceId, int? limitKopecks) =>
      (_db.update(_db.spaces)..where((t) => t.id.equals(spaceId))).write(
            SpacesCompanion(
              monthlyBudgetLimit: Value<int?>(limitKopecks),
              updatedAt: Value(DateTime.now().toUtc()),
              syncStatus: const Value('pending'),
            ),
          );

  Future<void> insertNotificationFull({required String id, required String userId,
      required String spaceId, required String type, required String title,
      required String body}) =>
      _db.customInsert(
        "INSERT INTO notifications (id, user_id, space_id, type, title, body, is_read, created_at, updated_at, sync_status) "
        "VALUES (?, ?, ?, ?, ?, ?, 0, ?, ?, 'pending')",
        variables: [
          Variable.withString(id), Variable.withString(userId),
          Variable.withString(spaceId), Variable.withString(type),
          Variable.withString(title), Variable.withString(body),
          Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
          Variable.withInt(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000),
        ],
      );

  /// Этап 18 (6.3.36.7): данные для XLSX-экспорта (5 листов).
  Future<SpaceExportBundle> fetchSpaceExportBundle(String spaceId) async {
    final members = await _db.customSelect(
      "SELECT COALESCE(u.display_name, 'Без имени') AS name, m.role AS role, m.status AS status, m.joined_at AS joined "
      'FROM memberships m LEFT JOIN users u ON u.id = m.user_id WHERE m.space_id = ? '
      'ORDER BY m.joined_at ASC',
      variables: [Variable.withString(spaceId)],
      readsFrom: {_db.memberships, _db.users},
    ).get();
    final accounts = await _db.customSelect(
      'SELECT bank_name AS bank, account_type AS type, current_balance AS bal, currency AS cur '
      'FROM accounts WHERE space_id = ? AND is_archived = 0 ORDER BY bank_name ASC',
      variables: [Variable.withString(spaceId)],
      readsFrom: {_db.accounts},
    ).get();
    final txs = await _db.customSelect(
      'SELECT date AS d, type AS type, amount AS amount, merchant_name AS merchant, comment AS comment '
      'FROM transactions WHERE space_id = ? ORDER BY date DESC LIMIT 5000',
      variables: [Variable.withString(spaceId)],
      readsFrom: {_db.transactions},
    ).get();
    final goals = await _db.customSelect(
      'SELECT name AS name, target_amount AS target, current_amount AS cur, status AS status '
      'FROM savings_goals WHERE space_id = ? ORDER BY created_at DESC',
      variables: [Variable.withString(spaceId)],
      readsFrom: {_db.savingsGoals},
    ).get();
    final debts = await _db.customSelect(
      "SELECT COALESCE(cu.display_name, 'Внешний контрагент') AS creditor, "
      "COALESCE(du.display_name, 'Внешний контрагент') AS debtor, d.amount AS amount, d.resolution_status AS status "
      'FROM debts d LEFT JOIN users cu ON cu.id = d.creditor_id LEFT JOIN users du ON du.id = d.debtor_id '
      'WHERE d.space_id = ? ORDER BY d.created_at DESC',
      variables: [Variable.withString(spaceId)],
      readsFrom: {_db.debts, _db.users},
    ).get();
    return SpaceExportBundle(
      members: [
        for (final r in members)
          ExportMemberRow(
            name: r.read<String>('name'),
            role: r.read<String>('role'),
            status: r.read<String>('status'),
            joinedAt: r.read<DateTime>('joined'),
          ),
      ],
      accounts: [
        for (final r in accounts)
          ExportAccountRow(
            bank: r.read<String>('bank'),
            type: r.read<String>('type'),
            balanceKopecks: r.read<int>('bal'),
            currency: r.read<String>('cur'),
          ),
      ],
      transactions: [
        for (final r in txs)
          ExportTxRow(
            date: r.read<DateTime>('d'),
            type: r.read<String>('type'),
            amountKopecks: r.read<int>('amount'),
            merchant: r.readNullable<String>('merchant'),
            comment: r.readNullable<String>('comment'),
          ),
      ],
      goals: [
        for (final r in goals)
          ExportGoalRow(
            name: r.read<String>('name'),
            targetKopecks: r.read<int>('target'),
            currentKopecks: r.read<int>('cur'),
            status: r.read<String>('status'),
          ),
      ],
      debts: [
        for (final r in debts)
          ExportDebtRow(
            creditor: r.read<String>('creditor'),
            debtor: r.read<String>('debtor'),
            amountKopecks: r.read<int>('amount'),
            status: r.read<String>('status'),
          ),
      ],
    );
  }

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

  /// Heartbeat с троттлингом (D17-16): не трогаем строку чаще раза в 5 минут —
  /// меньше pending-строк для синка.
  Future<void> updateLastActive(String userId, String spaceId) {
    final now = DateTime.now().toUtc();
    final epoch = now.millisecondsSinceEpoch ~/ 1000;
    final cutoff =
        now.subtract(const Duration(minutes: 5)).millisecondsSinceEpoch ~/ 1000;
    return _db.customUpdate(
      'UPDATE memberships SET last_active_at = ?, sync_status = \'pending\' '
      'WHERE user_id = ? AND space_id = ? '
      'AND (last_active_at IS NULL OR last_active_at < ?)',
      variables: [
        Variable.withInt(epoch),
        Variable.withString(userId),
        Variable.withString(spaceId),
        Variable.withInt(cutoff),
      ],
    );
  }

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

  /// Этап 18 (6.3.36.8, D18-7): полное атомарное расформирование пространства.
  Future<void> dissolveSpace(String spaceId, String auditId, String actorId,
          {String metadataJson = '{}'}) =>
      _db.transaction(() async {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
        await _db.customUpdate(
          "UPDATE spaces SET status = 'dissolved', dissolved_at = ?, dissolved_by = ?, updated_at = ?, sync_status = 'pending' WHERE id = ?",
          variables: [
            Variable.withInt(now), Variable.withString(actorId),
            Variable.withInt(now), Variable.withString(spaceId),
          ],
        );
        await _db.customUpdate(
          "UPDATE memberships SET status = 'left', left_at = ?, updated_at = ?, sync_status = 'pending' WHERE space_id = ? AND status = 'active'",
          variables: [
            Variable.withInt(now), Variable.withInt(now), Variable.withString(spaceId),
          ],
        );
        await _db.customUpdate(
          "UPDATE debts SET is_ex_member_debt = 1, sync_status = 'pending' WHERE space_id = ? AND resolution_status = 'active'",
          variables: [Variable.withString(spaceId)],
        );
        await _db.customUpdate(
          "UPDATE budget_limits SET status = 'cancelled', sync_status = 'pending' WHERE space_id = ?",
          variables: [Variable.withString(spaceId)],
        );
        await _db.customUpdate(
          "UPDATE invitations SET status = 'revoked', updated_at = ?, sync_status = 'pending' WHERE space_id = ? AND used_at IS NULL",
          variables: [Variable.withInt(now), Variable.withString(spaceId)],
        );
        await insertAuditFull(
          id: auditId, spaceId: spaceId, actorId: actorId,
          action: AuditAction.spaceDissolved, targetId: spaceId,
          metadataJson: metadataJson,
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

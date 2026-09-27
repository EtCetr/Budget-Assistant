import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../domain/repositories/holidays_repository.dart';

part 'holidays_dao.g.dart';

@DriftAccessor(tables: [Holidays])
class HolidaysDao extends DatabaseAccessor<AppDatabase>
    with _$HolidaysDaoMixin {
  HolidaysDao(super.db);

  Stream<List<HolidayDb>> watchPresets() {
    return (select(holidays)
      ..where((h) => h.isPreset.equals(true))
      ..orderBy([(h) => OrderingTerm.asc(h.date)]))
        .watch();
  }

  Stream<List<HolidayDb>> watchPersonal({
    required String userId,
    String? spaceId,
    required HolidaysScope scope,
  }) {
    return (select(holidays)
      ..where((h) =>
          h.isPreset.equals(false) & _scope(userId, spaceId, scope, h))
      ..orderBy([(h) => OrderingTerm.asc(h.date)]))
        .watch();
  }

  Stream<List<HolidayDb>> watchAllEnabled({
    required String userId,
    String? spaceId,
  }) {
    final mine = hUserId(userId) & hSpaceNull();
    final family = spaceId == null ? const Constant(false) : hSpace(spaceId);
    return (select(holidays)
      ..where((h) => h.isEnabled.equals(true) & (h.isPreset.equals(true) | mine | family))
      ..orderBy([(h) => OrderingTerm.asc(h.date)]))
        .watch();
  }

  Future<HolidayDb?> getById(String id) {
    return (select(holidays)..where((h) => h.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertHoliday(HolidayDb row) {
    return into(holidays).insert(row);
  }

  Future<int> updateHoliday(HolidayDb row) {
    return (update(holidays)..where((h) => h.id.equals(row.id))).write(
      HolidaysCompanion(
        spaceId: Value(row.spaceId),
        userId: Value(row.userId),
        name: Value(row.name),
        date: Value(row.date),
        isAnnuallyRecurring: Value(row.isAnnuallyRecurring),
        iconEmoji: Value(row.iconEmoji),
        colorHex: Value(row.colorHex),
        isPreset: Value(row.isPreset),
        isEnabled: Value(row.isEnabled),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: Value(row.syncStatus),
      ),
    );
  }

  Future<int> deleteById(String id) {
    return (delete(holidays)..where((h) => h.id.equals(id))).go();
  }

  Future<int> setEnabled(String id, bool enabled) {
    return (update(holidays)..where((h) => h.id.equals(id))).write(
      HolidaysCompanion(
        isEnabled: Value(enabled),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Expression<bool> hUserId(String userId) => holidays.userId.equals(userId);
  Expression<bool> hSpaceNull() => holidays.spaceId.isNull();
  Expression<bool> hSpace(String spaceId) => holidays.spaceId.equals(spaceId);

  Expression<bool> _scope(
    String userId,
    String? spaceId,
    HolidaysScope scope,
    Holidays h,
  ) {
    final mine = h.userId.equals(userId) & h.spaceId.isNull();
    final family = spaceId == null ? const Constant(false) : h.spaceId.equals(spaceId);
    switch (scope) {
      case HolidaysScope.all:
        return mine | family;
      case HolidaysScope.personal:
        return mine;
      case HolidaysScope.family:
        return family;
    }
  }
}
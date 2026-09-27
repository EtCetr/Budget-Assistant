import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/repositories/holidays_repository.dart';
import '../datasources/holidays_dao.dart';

class HolidaysRepositoryImpl implements HolidaysRepository {
  HolidaysRepositoryImpl({required HolidaysDao dao, required Logger logger})
      : _dao = dao,
        _logger = logger;

  final HolidaysDao _dao;
  final Logger _logger;

  @override
  Stream<List<Holiday>> watchPresets() {
    try {
      return _dao.watchPresets().map((rows) => rows.map(_map).toList());
    } catch (e, st) {
      _logger.e('watchPresets failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<Holiday>> watchPersonal({
    required String userId,
    String? spaceId,
    required HolidaysScope scope,
  }) {
    try {
      return _dao
          .watchPersonal(userId: userId, spaceId: spaceId, scope: scope)
          .map((rows) => rows.map(_map).toList());
    } catch (e, st) {
      _logger.e('watchPersonal failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<Holiday>> watchAllEnabled({
    required String userId,
    String? spaceId,
  }) {
    try {
      return _dao
          .watchAllEnabled(userId: userId, spaceId: spaceId)
          .map((rows) => rows.map(_map).toList());
    } catch (e, st) {
      _logger.e('watchAllEnabled failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Holiday?> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      return row == null ? null : _map(row);
    } catch (e, st) {
      _logger.e('getById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> insert(Holiday holiday) async {
    try {
      await _dao.insertHoliday(_toDb(holiday));
    } catch (e, st) {
      _logger.e('insert failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> update(Holiday holiday) async {
    try {
      await _dao.updateHoliday(_toDb(holiday));
    } catch (e, st) {
      _logger.e('update failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteById(String id) async {
    try {
      await _dao.deleteById(id);
    } catch (e, st) {
      _logger.e('deleteById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> setEnabled(String id, bool enabled) async {
    try {
      await _dao.setEnabled(id, enabled);
    } catch (e, st) {
      _logger.e('setEnabled failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Holiday _map(HolidayDb db) {
    return Holiday(
      id: db.id,
      spaceId: db.spaceId,
      userId: db.userId,
      name: db.name,
      date: db.date,
      isAnnuallyRecurring: db.isAnnuallyRecurring,
      iconEmoji: db.iconEmoji,
      colorHex: db.colorHex,
      isPreset: db.isPreset,
      isEnabled: db.isEnabled,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: db.syncStatus,
    );
  }

  HolidayDb _toDb(Holiday h) {
    return HolidayDb(
      id: h.id,
      spaceId: h.spaceId,
      userId: h.userId,
      name: h.name,
      date: h.date,
      isAnnuallyRecurring: h.isAnnuallyRecurring,
      iconEmoji: h.iconEmoji,
      colorHex: h.colorHex,
      isPreset: h.isPreset,
      isEnabled: h.isEnabled,
      createdAt: h.createdAt,
      updatedAt: h.updatedAt,
      syncStatus: h.syncStatus,
    );
  }
}
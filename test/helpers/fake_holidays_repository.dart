import 'package:budget_assistant/features/calendar/domain/entities/holiday.dart';
import 'package:budget_assistant/features/calendar/domain/repositories/holidays_repository.dart';

/// Этап 24: заглушка репозитория праздников.
class FakeHolidaysRepository implements HolidaysRepository {
  final Map<String, Holiday> holidays = <String, Holiday>{};
  final List<String> calls = <String>[];
  final List<({String id, bool enabled})> enabledUpdates =
      <({String id, bool enabled})>[];
  Object? error;

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Stream<List<Holiday>> watchPresets() {
    _enter('watchPresets');
    return Stream.value(
      holidays.values.where((h) => h.isPreset).toList(),
    );
  }

  @override
  Stream<List<Holiday>> watchPersonal({
    required String userId,
    String? spaceId,
    required HolidaysScope scope,
  }) {
    _enter('watchPersonal');
    return Stream.value(
      holidays.values.where((h) => !h.isPreset).toList(),
    );
  }

  @override
  Stream<List<Holiday>> watchAllEnabled({
    required String userId,
    String? spaceId,
  }) {
    _enter('watchAllEnabled');
    return Stream.value(
      holidays.values.where((h) => h.isEnabled).toList(),
    );
  }

  @override
  Future<Holiday?> getById(String id) async {
    _enter('getById');
    return holidays[id];
  }

  @override
  Future<void> insert(Holiday holiday) async {
    _enter('insert');
    holidays[holiday.id] = holiday;
  }

  @override
  Future<void> update(Holiday holiday) async {
    _enter('update');
    holidays[holiday.id] = holiday;
  }

  @override
  Future<void> deleteById(String id) async {
    _enter('deleteById');
    holidays.remove(id);
  }

  @override
  Future<void> setEnabled(String id, bool enabled) async {
    _enter('setEnabled');
    enabledUpdates.add((id: id, enabled: enabled));
    final h = holidays[id];
    if (h != null) holidays[id] = h.copyWith(isEnabled: enabled);
  }
}

/// Фабрика праздника для тестов.
Holiday makeHoliday({
  required String id,
  String name = 'День рождения',
  DateTime? date,
  bool isAnnuallyRecurring = true,
  bool isPreset = false,
  bool isEnabled = true,
  String? userId = 'u1',
  String? spaceId,
}) =>
    Holiday(
      id: id,
      spaceId: spaceId,
      userId: userId,
      name: name,
      date: date ?? DateTime.utc(2026, 7, 15),
      isAnnuallyRecurring: isAnnuallyRecurring,
      isPreset: isPreset,
      isEnabled: isEnabled,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
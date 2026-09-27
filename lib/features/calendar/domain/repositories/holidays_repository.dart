import '../entities/holiday.dart';

/// Область видимости личных праздников (ТЗ 6.3.8.5).
enum HolidaysScope { all, personal, family }

abstract interface class HolidaysRepository {
  /// Пресеты РФ (is_preset = TRUE), сортировка по дате.
  Stream<List<Holiday>> watchPresets();
  Stream<List<Holiday>> watchPersonal({
    required String userId,
    String? spaceId,
    required HolidaysScope scope,
  });
  /// Все включённые (пресеты + личные/семейные) для маркеров календаря.
  Stream<List<Holiday>> watchAllEnabled({
    required String userId,
    String? spaceId,
  });
  Future<Holiday?> getById(String id);
  Future<void> insert(Holiday holiday);
  Future<void> update(Holiday holiday);
  Future<void> deleteById(String id);
  Future<void> setEnabled(String id, bool enabled);
}
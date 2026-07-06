// lib/features/profile/data/datasources/users_local_datasource.dart
import 'package:drift/drift.dart'; // ✅ ДОБАВИТЬ для Value
import 'package:logger/logger.dart'; // ✅ Заменить logging на logger
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/profile/domain/models/user_dto.dart';

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

class UsersLocalDataSource {
  final AppDatabase _db;
  UsersLocalDataSource(this._db);

  Future<UserDto?> getUserById(String id) async {
    try {
      final query = _db.select(_db.users)..where((t) => t.id.equals(id));
      final row = await query.getSingleOrNull();
      if (row == null) return null;
      return _mapRowToDto(row);
    } catch (e, st) {
      _log.e(
        '❌ Failed to fetch user $id from local DB',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> insertUser(UserDto dto) async {
    try {
      await _db.into(_db.users).insert(_mapDtoToCompanion(dto));
      _log.i('✅ User ${dto.id} saved locally (sync_status=pending)');
    } catch (e, st) {
      _log.e('❌ Failed to insert user ${dto.id}', error: e, stackTrace: st);
      rethrow;
    }
  }

    UsersCompanion _mapDtoToCompanion(UserDto dto) {
    return UsersCompanion.insert(
      // Обязательные поля (без Value)
      id: dto.id,
      email: dto.email,
      displayName: dto.displayName,
      createdAt: dto.createdAt.toUtc(),
      updatedAt: dto.updatedAt.toUtc(),

      // Nullable поля (оборачиваем в Value)
      displayNameDative: Value(dto.displayNameDative),
      avatarUrl: Value(dto.avatarUrl),

      // Поле с default значением (оборачиваем в Value)
      syncStatus: Value(dto.syncStatus),
    );
  }

  // ✅ Drift генерирует класс `User` (ед. число) для таблицы `Users`
  UserDto _mapRowToDto(User row) {
    return UserDto(
      id: row.id,
      email: row.email,
      displayName: row.displayName,
      displayNameDative: row.displayNameDative,
      avatarUrl: row.avatarUrl,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      syncStatus: row.syncStatus,
    );
  }
}

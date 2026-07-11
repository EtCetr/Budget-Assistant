import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/users.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  /// Получить пользователя по ID
  Future<User?> getById(String id) {
    return (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Stream: наблюдать за изменениями пользователя
  Stream<User?> watchById(String id) {
    return (select(users)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Создать или обновить пользователя (upsert)
  Future<void> upsert(User user) {
    return into(users).insertOnConflictUpdate(user.toCompanion(true));
  }

  /// Получить всех пользователей (для admin-функционала)
  Future<List<User>> getAll() => select(users).get();

  /// Пометить как pending для синхронизации
  Future<int> markAsPending(String id) {
    return (update(users)..where((t) => t.id.equals(id))).write(
      const UsersCompanion(syncStatus: Value('pending')),
    );
  }

  /// Удалить пользователя (каскадно удалит memberships, app_settings и т.д.)
  Future<int> deleteById(String id) {
    return (delete(users)..where((t) => t.id.equals(id))).go();
  }
}

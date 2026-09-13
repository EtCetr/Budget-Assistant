import '../entities/user_space.dart';

/// Контракт репозитория пространств (Multi-group).
///
/// Домен не знает про Drift.
abstract interface class SpacesRepository {
  /// Реактивный список активных пространств пользователя
  /// (memberships status='active' + spaces status='active').
  Stream<List<UserSpace>> watchUserSpaces(String userId);

  /// Создаёт пространство и membership владельца с ролью admin
  /// в одной локальной транзакции (Offline-First, sync_status='pending').
  Future<UserSpace> createSpaceWithAdminMembership({
    required String userId,
    required String name,
  });

  /// Подключает личные транзакции пользователя (space_id IS NULL)
  /// к пространству. Возвращает количество обновлённых строк.
  /// Обновлённые строки уходят в sync_status='pending'.
  Future<int> attachPersonalTransactionsToSpace({
    required String userId,
    required String spaceId,
  });
}
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../domain/entities/user_space.dart';
import '../../domain/repositories/spaces_repository.dart';

/// Drift-реализация репозитория пространств.
class SpacesRepositoryImpl implements SpacesRepository {
  SpacesRepositoryImpl({
    required AppDatabase db,
    required Logger logger,
    required Uuid uuid,
  })  : _db = db,
        _logger = logger,
        _uuid = uuid;

  final AppDatabase _db;
  final Logger _logger;
  final Uuid _uuid;

  @override
  Stream<List<UserSpace>> watchUserSpaces(String userId) {
    return _db.membershipsDao.watchByUserId(userId).asyncMap((memberships) async {
      final result = <UserSpace>[];
      for (final membership in memberships) {
        final space = await _db.spacesDao.getById(membership.spaceId);
        if (space != null && space.status == 'active') {
          result.add(UserSpace(id: space.id, name: space.name));
        }
      }
      return result;
    });
  }

  @override
  Future<UserSpace> createSpaceWithAdminMembership({
    required String userId,
    required String name,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final spaceId = _uuid.v4();
      final salt = _randomHex(32);
      await _db.transaction(() async {
        // ВАЖНО: в Companion.insert() обязательные поля (без дефолта)
        // передаются обычными значениями, Value<> — только опциональные.
        await _db.into(_db.spaces).insert(
              SpacesCompanion.insert(
                id: spaceId,
                name: name,
                encryptionSalt: salt,
              ),
            );
        await _db.into(_db.memberships).insert(
              MembershipsCompanion.insert(
                id: _uuid.v4(),
                userId: userId,
                spaceId: spaceId,
                role: const Value('admin'),
                status: const Value('active'),
                joinedAt: now,
                lastActiveAt: Value(now),
              ),
            );
      });
      _logger.i('Space created: $spaceId (owner=$userId)');
      return UserSpace(id: spaceId, name: name);
    } catch (e, st) {
      _logger.e('SpacesRepository.createSpace failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<int> attachPersonalTransactionsToSpace({
    required String userId,
    required String spaceId,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final updated = await (_db.update(_db.transactions)
            ..where((t) => t.userId.equals(userId) & t.spaceId.isNull()))
          .write(TransactionsCompanion(
            spaceId: Value(spaceId),
            syncStatus: const Value(SyncStatus.pending),
            updatedAt: Value(now),
          ));
      _logger.i(
        'Attached $updated personal transactions to space $spaceId (user=$userId)',
      );
      return updated;
    } catch (e, st) {
      _logger.e(
        'SpacesRepository.attachPersonalTransactions failed',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Соль пространства (для будущей HKDF-деривации группового ключа, Этап 17).
  String _randomHex(int byteLength) {
    final random = Random.secure();
    final bytes = List<int>.generate(byteLength, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
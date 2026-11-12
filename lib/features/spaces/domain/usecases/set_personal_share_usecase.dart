import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'attach_personal_transactions_usecase.dart';

/// Этап 23.6c: личный флаг «Подключить мои личные транзакции».
/// Включение = разовое присоединение личных операций (space_id IS NULL)
/// к пространству. Выключение меняет только флаг: данные не удаляются.
class SetPersonalShareUseCase {
  SetPersonalShareUseCase({
    required AppDatabase db,
    required AttachPersonalTransactionsUseCase attach,
    required Logger logger,
  })  : _db = db,
        _attach = attach,
        _logger = logger;

  final AppDatabase _db;
  final AttachPersonalTransactionsUseCase _attach;
  final Logger _logger;

  /// Сколько личных операций будет подключено (для диалога).
  Future<int> countPersonal({required String userId}) async {
    try {
      final row = await _db.customSelect(
        'SELECT COUNT(*) AS c FROM transactions '
        'WHERE user_id = ? AND space_id IS NULL',
        variables: [Variable.withString(userId)],
      ).getSingle();
      return row.read<int>('c');
    } catch (e, st) {
      _logger.e('countPersonal failed', error: e, stackTrace: st);
      return 0;
    }
  }

  Future<bool> isEnabled({
    required String userId,
    required String spaceId,
  }) async {
    final row = await (_db.select(_db.personalShareFlags)
          ..where((t) => t.userId.equals(userId) & t.spaceId.equals(spaceId)))
        .getSingleOrNull();
    return row?.isEnabled ?? false;
  }

  Future<int> call({
    required String userId,
    required String spaceId,
    required bool enabled,
    bool performAttach = true,
  }) async {
    try {
      var attached = 0;
      if (enabled && performAttach) {
        final result = await _attach(userId: userId, spaceId: spaceId);
        switch (result) {
          case Success(:final value):
            attached = value;
          case Error(:final failure):
            throw Exception(failure.message);
        }
      }
      await _upsertFlag(userId: userId, spaceId: spaceId, enabled: enabled);
      return attached;
    } catch (e, st) {
      _logger.e('SetPersonalShare failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> _upsertFlag({
    required String userId,
    required String spaceId,
    required bool enabled,
  }) async {
    final now = DateTime.now().toUtc();
    final existing = await (_db.select(_db.personalShareFlags)
          ..where((t) => t.userId.equals(userId) & t.spaceId.equals(spaceId)))
        .getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.personalShareFlags)
            ..where((t) => t.id.equals(existing.id)))
          .write(PersonalShareFlagsCompanion(
        isEnabled: Value(enabled),
        lastAttachedAt: enabled ? Value(now) : const Value.absent(),
        updatedAt: Value(now),
        syncStatus: const Value('pending'),
      ));
      return;
    }
    await _db.into(_db.personalShareFlags).insert(
          PersonalShareFlagsCompanion.insert(
            id: const Uuid().v4(),
            userId: userId,
            spaceId: spaceId,
            isEnabled: Value(enabled),
            lastAttachedAt: enabled ? Value(now) : const Value.absent(),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
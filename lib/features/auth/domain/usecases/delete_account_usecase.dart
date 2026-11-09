// lib/features/auth/domain/usecases/delete_account_usecase.dart
// Этап 21 (ТЗ 6.3.39.7): локальная часть удаления аккаунта.
// D21-29: Supabase RPC delete_user_account — TODO(25); здесь стираем
// локальную БД и ключи SecureStorage, signOut выполняет экран.
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';

class DeleteAccountUseCase {
  const DeleteAccountUseCase({
    required AppDatabase db,
    required SecureStorageService storage,
  })  : _db = db,
        _storage = storage;

  final AppDatabase _db;
  final SecureStorageService _storage;

  Future<void> call() async {
    try {
      // FK выключены на время wipe: порядок таблиц не гарантирован.
      await _db.customStatement('PRAGMA foreign_keys = OFF');
      for (final table in _db.allTables) {
        await _db.delete(table).go();
      }
      await _db.customStatement('PRAGMA foreign_keys = ON');
      await _storage.deleteAll();
      AppLogger.i('Local account data wiped');
    } catch (e, st) {
      AppLogger.e('DeleteAccountUseCase failed', e, st);
      rethrow;
    }
  }
}
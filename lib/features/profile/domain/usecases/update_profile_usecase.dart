// lib/features/profile/domain/usecases/update_profile_usecase.dart
// Этап 21 (ТЗ 6.3.39.3): обновление имени, дательного падежа, аватара.
// display_name / display_name_dative — [E2E] при sync (Этап 25);
// avatar_path — [LOCAL], не синхронизируется.
import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  Future<void> call({
    required String userId,
    required String displayName,
    required String displayNameDative,
    String? avatarPath,
    bool clearAvatar = false,
  }) async {
    try {
      await (_db.update(_db.users)..where((t) => t.id.equals(userId))).write(
        UsersCompanion(
          displayName: Value(displayName),
          displayNameDative: Value(displayNameDative),
          avatarPath: clearAvatar
              ? const Value(null)
              : (avatarPath == null
                  ? const Value.absent()
                  : Value(avatarPath)),
          updatedAt: Value(DateTime.now().toUtc()),
          syncStatus: const Value('pending'),
        ),
      );
      AppLogger.i('Profile updated: $userId');
    } catch (e, st) {
      AppLogger.e('UpdateProfileUseCase failed', e, st);
      rethrow;
    }
  }
}
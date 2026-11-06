// lib/features/settings/domain/usecases/update_app_settings_usecase.dart
// Этап 21 (ТЗ 6.3.28/6.3.38): единая точка обновления app_settings.
// D21-11: Companion в сигнатуре — прагматичное отклонение (прецедент:
// biometric_onboarding_screen); все правки идут через dao.updateForUser
// (sync_status='pending', Offline-First).
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';

class UpdateAppSettingsUseCase {
  const UpdateAppSettingsUseCase({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  Future<void> call({
    required String userId,
    required AppSettingsCompanion changes,
  }) async {
    try {
      await _db.appSettingsDao.updateForUser(userId, changes);
    } catch (e, st) {
      AppLogger.e('UpdateAppSettingsUseCase failed', e, st);
      rethrow;
    }
  }
}
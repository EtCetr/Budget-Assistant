// lib/features/settings/presentation/providers/settings_providers.dart
// Этап 21: реактивный доступ к строке app_settings + usecase обновления.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/settings/domain/usecases/update_app_settings_usecase.dart';

/// Сырая строка app_settings текущего пользователя (реактивно).
/// Если строки ещё нет — идемпотентно создаётся с дефолтами (getForUser).
final appSettingsRowProvider = StreamProvider<AppSetting?>((ref) async* {
  final userId = ref.watch(currentUserIdProvider);
  final db = ref.watch(appDatabaseProvider);
  try {
    await db.appSettingsDao.getForUser(userId);
    yield* db.appSettingsDao.watchForUser(userId);
  } catch (e, st) {
    AppLogger.e('appSettingsRowProvider failed', e, st);
    rethrow;
  }
});

final updateAppSettingsUseCaseProvider = Provider<UpdateAppSettingsUseCase>(
  (ref) => UpdateAppSettingsUseCase(db: ref.watch(appDatabaseProvider)),
);
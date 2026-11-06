// lib/features/settings/presentation/providers/settings_providers.dart
// Этап 21: реактивный доступ к app_settings + usecase-провайдеры хаба настроек.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/settings/domain/usecases/clear_local_cache_usecase.dart';
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

final clearLocalCacheUseCaseProvider = Provider<ClearLocalCacheUseCase>(
  (ref) => ClearLocalCacheUseCase(db: ref.watch(appDatabaseProvider)),
);

/// Версия приложения для секции «О приложении» (D21-17).
final appVersionProvider = FutureProvider<String>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return '${info.version} (build ${info.buildNumber})';
  } catch (e, st) {
    AppLogger.e('Failed to read app version', e, st);
    return '—';
  }
});
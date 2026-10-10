import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import '../database/daos/app_settings_dao.dart';

part 'database_providers.g.dart';

@riverpod
class AppDatabaseNotifier extends _$AppDatabaseNotifier {
  @override
  AppDatabase build() => AppDatabase();
}

/// Этап 18: единая точка доступа к DAO настроек (PIN-гейты, экраны настроек).
final appSettingsDaoProvider = Provider<AppSettingsDao>(
  (ref) => AppSettingsDao(ref.watch(appDatabaseProvider)),
);
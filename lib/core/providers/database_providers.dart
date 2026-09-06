import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';

part 'database_providers.g.dart';

@riverpod
class AppDatabaseNotifier extends _$AppDatabaseNotifier {
  @override
  AppDatabase build() => AppDatabase();
}

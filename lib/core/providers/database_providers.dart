// lib/core/providers/database_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';

part 'database_providers.g.dart';

@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

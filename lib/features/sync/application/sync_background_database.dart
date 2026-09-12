import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:budget_assistant/core/database/app_database.dart';

/// Открывает локальную БД в background isolate WorkManager.
@pragma('vm:entry-point')
Future<GeneratedDatabase> openSyncDatabaseInBackground() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'budget_assistant.sqlite'));

  return AppDatabase.forBackground(NativeDatabase.createInBackground(file));
}

import 'package:flutter/widgets.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/import/data/datasources/import_drafts_dao.dart';

/// Имя фоновой задачи очистки черновиков импорта (ТОМ 2 §23).
const String cleanImportDraftsTaskName =
    'budget_assistant_clean_import_drafts';

/// Хендлер задачи: удаляет черновики старше 7 дней.
/// Выполняется в background-изоляторе WorkManager.
Future<bool> handleCleanImportDraftsTask() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final db = AppDatabase();
    final dao = ImportDraftsDao(db);
    final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 7));
    final deleted = await dao.deleteOlderThan(cutoff);
    AppLogger.i('CleanImportDrafts: deleted=$deleted');
    return true;
  } catch (e, st) {
    AppLogger.e('CleanImportDrafts failed', e, st);
    return false;
  }
}
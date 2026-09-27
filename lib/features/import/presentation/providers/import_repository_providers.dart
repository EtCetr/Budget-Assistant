import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/import/data/datasources/import_drafts_dao.dart';
import 'package:budget_assistant/features/import/data/datasources/parser_configs_dao.dart';
import 'package:budget_assistant/features/import/data/repositories/import_repository_impl.dart';
import 'package:budget_assistant/features/import/domain/repositories/import_repository.dart';

/// DAO для конфигураций парсеров банков.
final parserConfigsDaoProvider = Provider<ParserConfigsDao>((ref) {
  final db = AppDatabase();
  return ParserConfigsDao(db);
});

/// DAO для черновиков импорта.
final importDraftsDaoProvider = Provider<ImportDraftsDao>((ref) {
  final db = AppDatabase();
  return ImportDraftsDao(db);
});

/// Репозиторий импорта.
final importRepositoryProvider = Provider<ImportRepository>((ref) {
  return ImportRepositoryImpl(
    db: AppDatabase(),
    parserConfigsDao: ref.read(parserConfigsDaoProvider),
    importDraftsDao: ref.read(importDraftsDaoProvider),
    logger: Logger(printer: PrettyPrinter(methodCount: 2)),
  );
});
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/import/data/datasources/import_accounts_dao.dart';
import 'package:budget_assistant/features/import/domain/entities/parser_config.dart';
import 'package:budget_assistant/features/import/domain/usecases/auto_detect_columns_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/fetch_parser_configs_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/import_transactions_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/parse_import_file_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/preview_import_data_usecase.dart';
import 'import_repository_providers.dart';
import 'import_usecase_providers.dart';

final _importLoggerProvider = Provider<Logger>((ref) {
  return Logger(printer: PrettyPrinter(methodCount: 2));
});

final fetchParserConfigsUseCaseProvider =
    Provider<FetchParserConfigsUseCase>((ref) {
  return FetchParserConfigsUseCase(
    repository: ref.watch(importRepositoryProvider),
    logger: ref.watch(_importLoggerProvider),
  );
});

final autoDetectColumnsUseCaseProvider =
    Provider<AutoDetectColumnsUseCase>((ref) {
  return AutoDetectColumnsUseCase(logger: ref.watch(_importLoggerProvider));
});

final parseImportFileUseCaseProvider = Provider<ParseImportFileUseCase>((ref) {
  return ParseImportFileUseCase(
    autoDetect: ref.watch(autoDetectColumnsUseCaseProvider),
    logger: ref.watch(_importLoggerProvider),
  );
});

final previewImportDataUseCaseProvider =
    Provider<PreviewImportDataUseCase>((ref) {
  return PreviewImportDataUseCase();
});

final importTransactionsUseCaseProvider =
    Provider<ImportTransactionsUseCase>((ref) {
  return ImportTransactionsUseCase(
    parseUseCase: ref.watch(parseImportFileUseCaseProvider),
    duplicates: ref.watch(detectDuplicatesUseCaseProvider),
    transfers: ref.watch(detectTransfersUseCaseProvider),
    categorize: ref.watch(autoCategorizeUseCaseProvider),
    settingsDao: ref.watch(appSettingsDaoProvider),
    logger: ref.watch(_importLoggerProvider),
  );
});

final importAccountsDaoProvider = Provider<ImportAccountsDao>((ref) {
  return ImportAccountsDao(ref.watch(appDatabaseProvider));
});

/// Целевые счета: (userId, spaceId, familyOnly).
final importTargetAccountsProvider = FutureProvider.family
    <List<Account>, (String, String?, bool)>((ref, params) {
  return ref.watch(importAccountsDaoProvider).getTargetAccounts(
        userId: params.$1,
        spaceId: params.$2,
        familyOnly: params.$3,
      );
});

/// Кэш списка банков для STEP 1.
final parserConfigsListProvider = FutureProvider<List<ParserConfig>>((ref) {
  return ref.watch(fetchParserConfigsUseCaseProvider).call();
});
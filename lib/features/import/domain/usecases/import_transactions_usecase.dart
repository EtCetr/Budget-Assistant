import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import '../entities/column_mapping.dart';
import '../entities/duplicate_candidate.dart';
import '../entities/hold_confirmation_candidate.dart';
import '../entities/import_options.dart';
import '../entities/import_result.dart';
import '../entities/parser_config.dart';
import '../entities/transfer_candidate.dart';
import 'auto_categorize_usecase.dart';
import 'detect_duplicates_usecase.dart';
import 'detect_transfers_usecase.dart';
import 'parse_import_file_usecase.dart';

/// Оркестратор запуска импорта (ТЗ 6.3.25.19):
/// парсинг → автокатегоризация → дубликаты/hold → переводы → ImportResult.
/// Записи в БД НЕТ — финализация на PostImportReviewScreen (15.4).
class ImportTransactionsUseCase {
  final ParseImportFileUseCase _parseUseCase;
  final DetectDuplicatesUseCase _duplicates;
  final DetectTransfersUseCase _transfers;
  final AutoCategorizeUseCase _categorize;
  final AppSettingsDao _settingsDao;
  final Logger _logger;

  ImportTransactionsUseCase({
    required ParseImportFileUseCase parseUseCase,
    required DetectDuplicatesUseCase duplicates,
    required DetectTransfersUseCase transfers,
    required AutoCategorizeUseCase categorize,
    required AppSettingsDao settingsDao,
    required Logger logger,
  })  : _parseUseCase = parseUseCase,
        _duplicates = duplicates,
        _transfers = transfers,
        _categorize = categorize,
        _settingsDao = settingsDao,
        _logger = logger;

  Future<ImportResult?> call({
    required String storedPath,
    required String format,
    required ParserConfig config,
    required ColumnMapping mapping,
    required String targetAccountId,
    required String? targetSpaceId,
    required String userId,
    required ImportOptions options,
  }) async {
    try {
      final settings = await _settingsDao.getForUser(userId);
      final parsed = await _parseUseCase.reparse(
        storedPath: storedPath,
        format: format,
        configJson: config.configJson,
        mapping: mapping,
      );
      if (!parsed.isSuccess) {
        _logger.w('Импорт: парсинг не дал строк (${parsed.error})');
        return null;
      }

      var rows = parsed.rows;
      if (options.autoCategorize) {
        rows = await _categorize.categorizeAll(
          rows: rows,
          userId: userId,
          spaceId: targetSpaceId,
        );
      }

      var duplicates = const <DuplicateCandidate>[];
      var holds = const <HoldConfirmationCandidate>[];
      if (options.detectDuplicates) {
        final analysis = await _duplicates.call(
          importedRows: rows,
          accountId: targetAccountId,
          toleranceDays: settings.duplicateDateToleranceDays,
        );
        duplicates = analysis.duplicates;
        holds = analysis.holdConfirmations;
      }

      var transfers = const <TransferCandidate>[];
      if (options.detectTransfers) {
        transfers = await _transfers.call(
          importedRows: rows,
          sourceAccountId: targetAccountId,
          interbankToleranceDays: settings.duplicateDateToleranceDays,
          sbpToleranceMinutes: settings.transferTimeToleranceMinutes,
        );
      }

      _logger.i('Импорт: ${rows.length} строк, ${duplicates.length} дублей, '
          '${transfers.length} переводов, ${holds.length} hold');
      return ImportResult(
        bankName: config.bankName,
        bankCode: config.bankCode,
        fileName: p.basename(storedPath),
        totalRows: parsed.totalRows,
        periodStart: parsed.periodStart ?? rows.first.date,
        periodEnd: parsed.periodEnd ?? rows.first.date,
        targetAccountId: targetAccountId,
        targetSpaceId: targetSpaceId,
        rows: rows,
        duplicates: duplicates,
        transfers: transfers,
        holdConfirmations: holds,
        options: options,
      );
    } catch (e, st) {
      _logger.e('ImportTransactionsUseCase failed', error: e, stackTrace: st);
      return null;
    }
  }
}
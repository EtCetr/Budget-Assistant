import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import '../entities/column_mapping.dart';
import '../entities/duplicate_candidate.dart';
import '../entities/hold_confirmation_candidate.dart';
import '../entities/import_options.dart';
import '../entities/import_result.dart';
import '../entities/parser_config.dart';
import '../entities/transfer_profile.dart';
import 'auto_categorize_usecase.dart';
import 'detect_duplicates_usecase.dart';
import 'mark_transfers_usecase.dart';
import 'parse_import_file_usecase.dart';

/// Оркестратор запуска импорта (ТЗ 6.3.25.19):
/// парсинг -> автокатегоризация -> дубликаты/hold -> пометка переводов -> ImportResult.
/// Переводы НЕ объединяются: строки помечаются isTransfer и создаются type='transfer'.
class ImportTransactionsUseCase {
  final ParseImportFileUseCase _parseUseCase;
  final DetectDuplicatesUseCase _duplicates;
  final MarkTransfersUseCase _markTransfers;
  final AutoCategorizeUseCase _categorize;
  final AppSettingsDao _settingsDao;
  final Logger _logger;

  ImportTransactionsUseCase({
    required ParseImportFileUseCase parseUseCase,
    required DetectDuplicatesUseCase duplicates,
    required MarkTransfersUseCase markTransfers,
    required AutoCategorizeUseCase categorize,
    required AppSettingsDao settingsDao,
    required Logger logger,
  })  : _parseUseCase = parseUseCase,
        _duplicates = duplicates,
        _markTransfers = markTransfers,
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
    TransferProfile transferProfile = const TransferProfile(),
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
      if (options.detectTransfers) {
        rows = _markTransfers(rows: rows, profile: transferProfile);
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
      final transferCount = rows.where((r) => r.isTransfer).length;
      _logger.i('Импорт: ${rows.length} строк, ${duplicates.length} дублей, '
          '$transferCount переводов, ${holds.length} hold');
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
        transfers: const [],
        holdConfirmations: holds,
        options: options,
      );
    } catch (e, st) {
      _logger.e('ImportTransactionsUseCase failed', error: e, stackTrace: st);
      return null;
    }
  }
}
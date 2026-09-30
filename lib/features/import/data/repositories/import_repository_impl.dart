import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/import/data/datasources/import_drafts_dao.dart';
import 'package:budget_assistant/features/import/data/datasources/parser_configs_dao.dart';
import 'package:budget_assistant/features/import/domain/entities/parser_config.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/repositories/import_repository.dart';

class ImportRepositoryImpl implements ImportRepository {
  final AppDatabase _db;
  final ParserConfigsDao _parserConfigsDao;
  final ImportDraftsDao _importDraftsDao;
  final Logger _logger;

  const ImportRepositoryImpl({
    required AppDatabase db,
    required ParserConfigsDao parserConfigsDao,
    required ImportDraftsDao importDraftsDao,
    required Logger logger,
  })  : _db = db,
        _parserConfigsDao = parserConfigsDao,
        _importDraftsDao = importDraftsDao,
        _logger = logger;

  // === Parser Configs ===

  @override
  Future<List<ParserConfig>> getParserConfigs() async {
    try {
      final rows = await _parserConfigsDao.getAll();
      return rows.map(_mapParserConfig).toList();
    } catch (e, st) {
      _logger.e('getParserConfigs failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<ParserConfig?> getParserConfigByBankCode(String bankCode) async {
    try {
      final row = await _parserConfigsDao.getByBankCode(bankCode);
      return row == null ? null : _mapParserConfig(row);
    } catch (e, st) {
      _logger.e('getParserConfigByBankCode failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<List<ParserConfig>> searchParserConfigs(String query) async {
    try {
      final rows = await _parserConfigsDao.searchByName(query);
      return rows.map(_mapParserConfig).toList();
    } catch (e, st) {
      _logger.e('searchParserConfigs failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<void> incrementParserUsage(String configId) async {
    try {
      await _parserConfigsDao.incrementUsageCount(configId);
    } catch (e, st) {
      _logger.e('incrementParserUsage failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<ParserConfig> createParserConfig(ParserConfig config) async {
    try {
      final dbRow = ParserConfigDb(
        id: config.id,
        bankName: config.bankName,
        bankCode: config.bankCode,
        isPopular: config.isPopular,
        usageCount: config.usageCount,
        supportedFormats: jsonEncode(config.supportedFormats),
        configJson: config.configJson,
        instructionText: config.instructionText,
        webExportUrl: config.webExportUrl,
        brandColor: config.brandColor,
        iconAsset: config.iconAsset,
        detectionPatterns: config.detectionPatterns,
        version: config.version,
        createdAt: config.createdAt,
        updatedAt: config.updatedAt,
        syncStatus: 'pending',
      );
      await _parserConfigsDao.insertOrReplace(dbRow);
      _logger.i('Создан новый банк: ${config.bankName}');
      return config;
    } catch (e, st) {
      _logger.e('createParserConfig failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  // === Import Drafts ===

  @override
  Future<void> saveImportDraft({
    required String userId,
    String? bankName,
    String? filePath,
    String? wizardStateJson,
    String? parsedDataJson,
    String? mappingJson,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final existing = await _importDraftsDao.getForUser(userId);
      final id = existing?.id ?? const Uuid().v4();
      await _importDraftsDao.upsert(ImportDraftDb(
        id: id,
        userId: userId,
        bankName: bankName ?? existing?.bankName,
        filePath: filePath ?? existing?.filePath,
        wizardStateJson: wizardStateJson ?? existing?.wizardStateJson,
        parsedDataJson: parsedDataJson ?? existing?.parsedDataJson,
        mappingJson: mappingJson ?? existing?.mappingJson,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ));
    } catch (e, st) {
      _logger.e('saveImportDraft failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<Map<String, dynamic>?> getImportDraft(String userId) async {
    try {
      final draft = await _importDraftsDao.getForUser(userId);
      if (draft == null) return null;
      final age = DateTime.now().toUtc().difference(draft.updatedAt);
      if (age.inHours > 24) return null;
      return {
        'id': draft.id,
        'bankName': draft.bankName,
        'filePath': draft.filePath,
        'wizardStateJson': draft.wizardStateJson,
        'parsedDataJson': draft.parsedDataJson,
        'mappingJson': draft.mappingJson,
        'updatedAt': draft.updatedAt.toIso8601String(),
      };
    } catch (e, st) {
      _logger.e('getImportDraft failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> deleteImportDraft(String userId) async {
    try {
      await _importDraftsDao.deleteForUser(userId);
    } catch (e, st) {
      _logger.e('deleteImportDraft failed', error: e, stackTrace: st);
    }
  }

  // === Transactions ===

  @override
  Future<void> createImportedTransactions({
    required List<ParsedRow> rows,
    required String accountId,
    required String userId,
    String? spaceId,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final companions = rows.map((row) {
        final type = row.amountKopecks < 0
            ? TransactionType.expense
            : TransactionType.income;
        return TransactionsCompanion.insert(
          id: const Uuid().v4(),
          accountId: accountId,
          userId: userId,
          spaceId: Value(spaceId),
          date: row.date.toUtc(),
          amount: row.amountKopecks.abs(),
          type: type,
          merchantName: Value(row.merchantName),
          bankCategory: Value(row.bankCategory),
          customCategoryId: Value(row.assignedCategoryId),
          bankTransactionId: Value(row.bankTransactionId),
          comment: Value(row.comment),
          originalCurrency: Value(row.originalCurrency),
          originalAmount: Value(row.originalAmountKopecks),
          createdAt: now,
          updatedAt: now,
          syncStatus: const Value(SyncStatus.pending),
        );
      }).toList();
      await _db.batch((b) => b.insertAll(_db.transactions, companions));
      _logger.i('Created ${companions.length} imported transactions');
    } catch (e, st) {
      _logger.e('createImportedTransactions failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> adjustAccountBalance({
    required String accountId,
    required int deltaKopecks,
  }) async {
    try {
      final account = await (_db.select(_db.accounts)
            ..where((a) => a.id.equals(accountId)))
          .getSingleOrNull();
      if (account == null) return;
      final newBalance = account.currentBalance + deltaKopecks;
      await (_db.update(_db.accounts)
            ..where((a) => a.id.equals(accountId)))
          .write(AccountsCompanion(
        currentBalance: Value(newBalance),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value('pending'),
      ));
      _logger.i(
          'Adjusted balance for $accountId by $deltaKopecks -> $newBalance');
    } catch (e, st) {
      _logger.e('adjustAccountBalance failed', error: e, stackTrace: st);
    }
  }

  // === Mapping ===

  ParserConfig _mapParserConfig(ParserConfigDb row) {
    List<String> formats = [];
    try {
      final decoded = jsonDecode(row.supportedFormats);
      if (decoded is List) {
        formats = decoded.cast<String>();
      }
    } catch (_) {
      formats = ['csv'];
    }
    return ParserConfig(
      id: row.id,
      bankName: row.bankName,
      bankCode: row.bankCode,
      isPopular: row.isPopular,
      usageCount: row.usageCount,
      supportedFormats: formats,
      configJson: row.configJson,
      instructionText: row.instructionText,
      webExportUrl: row.webExportUrl,
      brandColor: row.brandColor,
      iconAsset: row.iconAsset,
      detectionPatterns: row.detectionPatterns,
      version: row.version,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
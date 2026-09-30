import '../entities/parser_config.dart';
import '../entities/parsed_row.dart';

/// Абстракция для работы с данными импорта.
abstract class ImportRepository {
  // === Parser Configs ===
  Future<List<ParserConfig>> getParserConfigs();
  Future<ParserConfig?> getParserConfigByBankCode(String bankCode);
  Future<List<ParserConfig>> searchParserConfigs(String query);
  Future<void> incrementParserUsage(String configId);
  Future<ParserConfig> createParserConfig(ParserConfig config);

  // === Import Drafts ===
  Future<void> saveImportDraft({
    required String userId,
    String? bankName,
    String? filePath,
    String? wizardStateJson,
    String? parsedDataJson,
    String? mappingJson,
  });
  Future<Map<String, dynamic>?> getImportDraft(String userId);
  Future<void> deleteImportDraft(String userId);

  // === Transactions (создание при финализации) ===
  Future<void> createImportedTransactions({
    required List<ParsedRow> rows,
    required String accountId,
    required String userId,
    String? spaceId,
  });
  /// Обновить баланс счёта на дельту.
  Future<void> adjustAccountBalance({
    required String accountId,
    required int deltaKopecks,
  });
}
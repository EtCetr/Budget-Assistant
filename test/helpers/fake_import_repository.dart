import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/parser_config.dart';
import 'package:budget_assistant/features/import/domain/repositories/import_repository.dart';

/// Этап 24: заглушка репозитория импорта для доменных тестов.
class FakeImportRepository implements ImportRepository {
  List<ParserConfig> configs = <ParserConfig>[];
  List<ParserConfig> searchResults = <ParserConfig>[];
  Object? error;

  final List<String> calls = <String>[];
  String? lastSearchQuery;

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<List<ParserConfig>> getParserConfigs() async {
    _enter('getParserConfigs');
    return configs;
  }

  @override
  Future<ParserConfig?> getParserConfigByBankCode(String bankCode) async {
    _enter('getParserConfigByBankCode');
    for (final c in configs) {
      if (c.bankCode == bankCode) return c;
    }
    return null;
  }

  @override
  Future<List<ParserConfig>> searchParserConfigs(String query) async {
    _enter('searchParserConfigs');
    lastSearchQuery = query;
    return searchResults;
  }

  @override
  Future<void> incrementParserUsage(String configId) async {
    _enter('incrementParserUsage');
  }

  @override
  Future<ParserConfig> createParserConfig(ParserConfig config) async {
    _enter('createParserConfig');
    configs.add(config);
    return config;
  }

  @override
  Future<Map<String, dynamic>> createAccount({
    required String name,
    required String type,
    required String currency,
    required int initialBalance,
    required String userId,
    String? spaceId,
    String? bankName,
  }) async {
    _enter('createAccount');
    return {'id': 'acc-1', 'name': name};
  }

  @override
  Future<void> saveImportDraft({
    required String userId,
    String? bankName,
    String? filePath,
    String? wizardStateJson,
    String? parsedDataJson,
    String? mappingJson,
  }) async {
    _enter('saveImportDraft');
  }

  @override
  Future<Map<String, dynamic>?> getImportDraft(String userId) async {
    _enter('getImportDraft');
    return null;
  }

  @override
  Future<void> deleteImportDraft(String userId) async {
    _enter('deleteImportDraft');
  }

  @override
  Future<void> createImportedTransactions({
    required List<ParsedRow> rows,
    required String accountId,
    required String userId,
    String? spaceId,
  }) async {
    _enter('createImportedTransactions');
  }

  @override
  Future<void> adjustAccountBalance({
    required String accountId,
    required int deltaKopecks,
  }) async {
    _enter('adjustAccountBalance');
  }
}

/// Фабрика конфига банка для тестов.
ParserConfig makeParserConfig({
  required String id,
  String bankName = 'Т-Банк',
  String bankCode = 'tbank',
  bool isPopular = false,
  int version = 1,
}) =>
    ParserConfig(
      id: id,
      bankName: bankName,
      bankCode: bankCode,
      isPopular: isPopular,
      supportedFormats: const ['csv', 'xlsx', 'pdf'],
      configJson: '{}',
      version: version,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
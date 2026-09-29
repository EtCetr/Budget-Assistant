import 'package:logger/logger.dart';
import '../entities/parser_config.dart';
import '../repositories/import_repository.dart';

/// Загрузка схем банков (локальный кэш parser_configs до Этапа 25).
class FetchParserConfigsUseCase {
  final ImportRepository _repository;
  final Logger _logger;

  const FetchParserConfigsUseCase({
    required ImportRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<List<ParserConfig>> call() async {
    try {
      return await _repository.getParserConfigs();
    } catch (e, st) {
      _logger.e('FetchParserConfigsUseCase failed', error: e, stackTrace: st);
      return [];
    }
  }

  /// Локальный full-text search LIKE по bank_name (ТЗ 6.3.25.5).
  Future<List<ParserConfig>> search(String query) async {
    try {
      if (query.trim().isEmpty) return call();
      return await _repository.searchParserConfigs(query.trim());
    } catch (e, st) {
      _logger.e('FetchParserConfigsUseCase.search failed',
          error: e, stackTrace: st);
      return [];
    }
  }
}
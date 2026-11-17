import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/domain/usecases/fetch_parser_configs_usecase.dart';
import '../../../helpers/fake_import_repository.dart';

/// Этап 24: загрузка и поиск схем банков (локальный кэш до Этапа 25).
/// Ошибка репозитория не роняет мастер импорта — возвращается пустой список.
void main() {
  late FakeImportRepository repo;
  late FetchParserConfigsUseCase useCase;

  setUp(() {
    repo = FakeImportRepository();
    useCase = FetchParserConfigsUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );
  });

  test('список конфигов приходит из репозитория', () async {
    repo.configs = [
      makeParserConfig(id: 'pc_tbank'),
      makeParserConfig(id: 'pc_sber', bankName: 'Сбер', bankCode: 'sber'),
    ];

    final result = await useCase();

    expect(result.length, 2);
    expect(repo.calls, ['getParserConfigs']);
  });

  test('ошибка репозитория — пустой список без исключения', () async {
    repo.error = Exception('db down');

    expect(await useCase(), isEmpty);
  });

  test('пустой запрос возвращает весь список', () async {
    repo.configs = [makeParserConfig(id: 'pc_tbank')];

    final result = await useCase.search('   ');

    expect(result.length, 1);
    expect(repo.calls, ['getParserConfigs']);
  });

  test('непустой запрос обрезается и уходит в поиск', () async {
    repo.searchResults = [
      makeParserConfig(id: 'pc_sber', bankName: 'Сбер', bankCode: 'sber'),
    ];

    final result = await useCase.search('  сбер  ');

    expect(result.single.bankCode, 'sber');
    expect(repo.lastSearchQuery, 'сбер');
    expect(repo.calls, ['searchParserConfigs']);
  });

  test('ошибка поиска — пустой список', () async {
    repo.error = Exception('db down');

    expect(await useCase.search('сбер'), isEmpty);
  });
}
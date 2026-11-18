import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/find_or_create_product_alias_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/hash_product_name_usecase.dart';
import '../../../helpers/fake_product_aliases_repository.dart';

/// Этап 24: поиск/создание алиаса товара по SHA-256 (ТЗ 6.3.49).
/// Область: семейный алиас (space_id) или глобальный (NULL).
void main() {
  late FakeProductAliasesRepository repo;
  late HashProductNameUseCase hash;
  late FindOrCreateProductAliasUseCase useCase;

  setUp(() {
    repo = FakeProductAliasesRepository();
    hash = HashProductNameUseCase();
    useCase = FindOrCreateProductAliasUseCase(
      repo,
      hash,
      Logger(level: Level.off),
    );
  });

  test('нормализация: trim, lowercase, схлопывание пробелов', () {
    expect(
      FindOrCreateProductAliasUseCase.normalizeName('  Молоко   1  '),
      'молоко 1',
    );
  });

  test('новый алиас создаётся с usageCount 1, pending и UTC', () async {
    final alias = await useCase(
      originalName: 'Молоко',
      categoryId: 'c1',
      userId: 'u1',
    );

    expect(alias, isNotNull);
    expect(alias!.usageCount, 1);
    expect(alias.syncStatus, SyncStatus.pending);
    expect(alias.createdAt.isUtc, isTrue);
    expect(alias.originalNameHash, hash('Молоко'));
    expect(alias.normalizedName, 'молоко');
    expect(repo.aliases.length, 1);
  });

  test('найденный алиас увеличивает счётчик использования', () async {
    repo.aliases['a1'] = makeAlias(
      id: 'a1',
      hash: hash('Молоко'),
      usageCount: 5,
    );

    final alias = await useCase(
      originalName: 'Молоко',
      categoryId: 'c1',
      userId: 'u1',
    );

    expect(alias!.id, 'a1');
    expect(alias.usageCount, 6);
    expect(repo.incremented, ['a1']);
    expect(repo.calls, isNot(contains('createAlias')));
  });

  test('семейный алиас находится в своём пространстве', () async {
    repo.aliases['a1'] = makeAlias(
      id: 'a1',
      hash: hash('Молоко'),
      spaceId: 's1',
    );

    final alias = await useCase(
      originalName: 'Молоко',
      categoryId: 'c1',
      userId: 'u1',
      spaceId: 's1',
    );

    expect(alias!.id, 'a1');
  });

  test('глобальный алиас (NULL) находится в любом пространстве', () async {
    repo.aliases['a1'] = makeAlias(id: 'a1', hash: hash('Молоко'));

    final alias = await useCase(
      originalName: 'Молоко',
      categoryId: 'c1',
      userId: 'u1',
      spaceId: 's1',
    );

    expect(alias!.id, 'a1');
  });

  test('алиас чужого пространства не подходит — создаётся новый', () async {
    repo.aliases['a1'] = makeAlias(
      id: 'a1',
      hash: hash('Молоко'),
      spaceId: 's2',
    );

    final alias = await useCase(
      originalName: 'Молоко',
      categoryId: 'c1',
      userId: 'u1',
      spaceId: 's1',
    );

    expect(alias!.id, isNot('a1'));
    expect(repo.aliases.length, 2);
    expect(alias.spaceId, 's1');
  });

  test('личная область передаёт в поиск пустую строку', () async {
    await useCase(
      originalName: 'Молоко',
      categoryId: 'c1',
      userId: 'u1',
    );

    expect(repo.lastSpaceId, '');
  });

  test('повторный вызов не создаёт дубль', () async {
    await useCase(originalName: 'Молоко', categoryId: 'c1', userId: 'u1');
    await useCase(originalName: 'МОЛОКО', categoryId: 'c1', userId: 'u1');

    expect(repo.aliases.length, 1);
    expect(repo.aliases.values.single.usageCount, 2);
  });

  test('ошибка репозитория — null без исключения', () async {
    repo.error = Exception('db down');

    final alias = await useCase(
      originalName: 'Молоко',
      categoryId: 'c1',
      userId: 'u1',
    );

    expect(alias, isNull);
  });
}
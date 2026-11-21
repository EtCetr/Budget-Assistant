import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/create_loyalty_card_usecase.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/delete_loyalty_card_usecase.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/get_loyalty_card_by_id_usecase.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/update_loyalty_card_usecase.dart';
import '../../../helpers/fake_loyalty_cards_repository.dart';

/// Этап 24: CRUD карт (ТЗ 6.3.19.8 / 6.3.20.13).
/// Правка и удаление — только создатель; ошибки не летят наружу.
void main() {
  late FakeLoyaltyCardsRepository repo;
  late Logger logger;
  late CreateLoyaltyCardUseCase create;
  late GetLoyaltyCardByIdUseCase getById;
  late UpdateLoyaltyCardUseCase update;
  late DeleteLoyaltyCardUseCase delete;

  setUp(() {
    repo = FakeLoyaltyCardsRepository();
    logger = Logger(level: Level.off);
    create = CreateLoyaltyCardUseCase(repo: repo, logger: logger);
    getById = GetLoyaltyCardByIdUseCase(repo: repo, logger: logger);
    update = UpdateLoyaltyCardUseCase(repo: repo, logger: logger);
    delete = DeleteLoyaltyCardUseCase(repo: repo, logger: logger);
  });

  group('Создание', () {
    test('карта сохраняется и возвращается', () async {
      final card = makeCard(id: 'c1');

      final r = await create(card);

      expect(r, isA<Success<LoyaltyCard>>());
      expect((r as Success<LoyaltyCard>).value.id, 'c1');
      expect(repo.cards['c1'], isNotNull);
      expect(repo.calls, ['insert']);
    });

    test('ошибка репозитория — Error с сообщением', () async {
      repo.error = Exception('db down');

      final r = await create(makeCard(id: 'c1'));

      expect(r, isA<Error<LoyaltyCard>>());
      expect((r as Error<LoyaltyCard>).failure.message, contains('сохранить'));
    });
  });

  group('Чтение', () {
    test('существующая карта возвращается', () async {
      repo.cards['c1'] = makeCard(id: 'c1');

      final r = await getById('c1');

      expect((r as Success<LoyaltyCard?>).value?.id, 'c1');
    });

    test('отсутствующая карта — успех с null (не Error)', () async {
      final r = await getById('missing');

      expect(r, isA<Success<LoyaltyCard?>>());
      expect((r as Success<LoyaltyCard?>).value, isNull);
    });

    test('ошибка репозитория — Error', () async {
      repo.error = Exception('db down');

      expect(await getById('c1'), isA<Error<LoyaltyCard?>>());
    });
  });

  group('Обновление', () {
    test('своя карта обновляется', () async {
      repo.cards['c1'] = makeCard(id: 'c1');

      final r = await update(makeCard(id: 'c1', storeName: 'Лента'));

      expect(r, isA<Success<LoyaltyCard>>());
      expect(repo.cards['c1']!.storeName, 'Лента');
    });

    test('карта не найдена — Error', () async {
      final r = await update(makeCard(id: 'c1'));

      expect(r, isA<Error<LoyaltyCard>>());
      expect((r as Error<LoyaltyCard>).failure.message, contains('не найдена'));
      expect(repo.calls, isNot(contains('update')));
    });

    test('чужая карта — Error, запись не меняется', () async {
      repo.cards['c1'] = makeCard(id: 'c1', userId: 'other');

      final r = await update(makeCard(id: 'c1', storeName: 'Взлом'));

      expect(r, isA<Error<LoyaltyCard>>());
      expect(
        (r as Error<LoyaltyCard>).failure.message,
        contains('только её создатель'),
      );
      expect(repo.cards['c1']!.storeName, 'Пятёрочка');
    });

    test('ошибка репозитория — Error', () async {
      repo.cards['c1'] = makeCard(id: 'c1');
      repo.error = Exception('db down');

      expect(await update(makeCard(id: 'c1')), isA<Error<LoyaltyCard>>());
    });
  });

  group('Удаление', () {
    test('своя карта удаляется', () async {
      repo.cards['c1'] = makeCard(id: 'c1');

      final r = await delete(cardId: 'c1', currentUserId: 'u1');

      expect(r, isA<Success<bool>>());
      expect(repo.cards, isEmpty);
    });

    test('карта не найдена — Error', () async {
      final r = await delete(cardId: 'missing', currentUserId: 'u1');

      expect(r, isA<Error<bool>>());
      expect((r as Error<bool>).failure.message, contains('не найдена'));
    });

    test('чужая карта — Error, запись остаётся', () async {
      repo.cards['c1'] = makeCard(id: 'c1', userId: 'other');

      final r = await delete(cardId: 'c1', currentUserId: 'u1');

      expect(r, isA<Error<bool>>());
      expect(
        (r as Error<bool>).failure.message,
        contains('только её создатель'),
      );
      expect(repo.cards.length, 1);
    });

    test('ошибка репозитория — Error', () async {
      repo.cards['c1'] = makeCard(id: 'c1');
      repo.error = Exception('db down');

      expect(
        await delete(cardId: 'c1', currentUserId: 'u1'),
        isA<Error<bool>>(),
      );
    });
  });
}
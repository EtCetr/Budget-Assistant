import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/toggle_loyalty_card_favorite_usecase.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/toggle_loyalty_card_shared_usecase.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/update_loyalty_card_preferred_orientation_usecase.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/update_loyalty_card_sort_order_usecase.dart';
import '../../../helpers/fake_loyalty_cards_repository.dart';

/// Этап 24: тумблеры и LOCAL-поля карт (ТЗ 6.3.19.7 / 6.3.21.13.8).
/// sort_order и preferred_orientation не синхронизируются.
void main() {
  late FakeLoyaltyCardsRepository repo;
  late Logger logger;
  late ToggleLoyaltyCardFavoriteUseCase favorite;
  late ToggleLoyaltyCardSharedUseCase shared;
  late UpdateLoyaltyCardSortOrderUseCase sortOrder;
  late UpdateLoyaltyCardPreferredOrientationUseCase orientation;

  setUp(() {
    repo = FakeLoyaltyCardsRepository();
    logger = Logger(level: Level.off);
    favorite = ToggleLoyaltyCardFavoriteUseCase(repo: repo, logger: logger);
    shared = ToggleLoyaltyCardSharedUseCase(repo: repo, logger: logger);
    sortOrder = UpdateLoyaltyCardSortOrderUseCase(repo: repo, logger: logger);
    orientation = UpdateLoyaltyCardPreferredOrientationUseCase(
      repo: repo,
      logger: logger,
    );
  });

  group('Избранное', () {
    test('false переключается в true', () async {
      repo.cards['c1'] = makeCard(id: 'c1');

      final r = await favorite('c1');

      expect(r, isA<Success<bool>>());
      expect(repo.favoriteUpdates.single.value, isTrue);
      expect(repo.cards['c1']!.isFavorite, isTrue);
    });

    test('true переключается в false', () async {
      repo.cards['c1'] = makeCard(id: 'c1', isFavorite: true);

      await favorite('c1');

      expect(repo.favoriteUpdates.single.value, isFalse);
    });

    test('избранное доступно и для чужой карты (без проверки автора)',
        () async {
      repo.cards['c1'] = makeCard(id: 'c1', userId: 'other');

      expect(await favorite('c1'), isA<Success<bool>>());
    });

    test('карта не найдена — Error', () async {
      final r = await favorite('missing');

      expect(r, isA<Error<bool>>());
      expect((r as Error<bool>).failure.message, contains('не найдена'));
    });

    test('ошибка репозитория — Error', () async {
      repo.cards['c1'] = makeCard(id: 'c1');
      repo.error = Exception('db down');

      expect(await favorite('c1'), isA<Error<bool>>());
    });
  });

  group('Видимость (is_shared)', () {
    test('своя карта инвертирует флаг', () async {
      repo.cards['c1'] = makeCard(id: 'c1');

      final r = await shared(cardId: 'c1', currentUserId: 'u1');

      expect(r, isA<Success<bool>>());
      expect(repo.sharedUpdates.single.value, isFalse);
    });

    test('карта не найдена — Error', () async {
      final r = await shared(cardId: 'missing', currentUserId: 'u1');

      expect(r, isA<Error<bool>>());
      expect((r as Error<bool>).failure.message, contains('не найдена'));
    });

    test('чужая карта — Error без записи', () async {
      repo.cards['c1'] = makeCard(id: 'c1', userId: 'other');

      final r = await shared(cardId: 'c1', currentUserId: 'u1');

      expect(r, isA<Error<bool>>());
      expect(
        (r as Error<bool>).failure.message,
        contains('только создатель'),
      );
      expect(repo.sharedUpdates, isEmpty);
    });

    test('ошибка репозитория — Error', () async {
      repo.cards['c1'] = makeCard(id: 'c1');
      repo.error = Exception('db down');

      expect(
        await shared(cardId: 'c1', currentUserId: 'u1'),
        isA<Error<bool>>(),
      );
    });
  });

  group('Локальная сортировка', () {
    test('индекс в списке становится sort_order', () async {
      final r = await sortOrder(orderedCardIds: ['c3', 'c1', 'c2']);

      expect(r, isA<Success<bool>>());
      expect(
        repo.sortUpdates.map((e) => '${e.id}:${e.order}').toList(),
        ['c3:0', 'c1:1', 'c2:2'],
      );
    });

    test('пустой список — успех без обращений к репозиторию', () async {
      final r = await sortOrder(orderedCardIds: const []);

      expect(r, isA<Success<bool>>());
      expect(repo.calls, isEmpty);
    });

    test('ошибка репозитория — Error', () async {
      repo.error = Exception('db down');

      expect(
        await sortOrder(orderedCardIds: ['c1']),
        isA<Error<bool>>(),
      );
    });
  });

  group('Ориентация экрана', () {
    test('portrait сохраняется', () async {
      final r = await orientation(cardId: 'c1', orientation: 'portrait');

      expect(r, isA<Success<bool>>());
      expect(repo.orientationUpdates.single.orientation, 'portrait');
    });

    test('landscape сохраняется', () async {
      await orientation(cardId: 'c1', orientation: 'landscape');

      expect(repo.orientationUpdates.single.orientation, 'landscape');
    });

    test('null сбрасывает настройку', () async {
      final r = await orientation(cardId: 'c1', orientation: null);

      expect(r, isA<Success<bool>>());
      expect(repo.orientationUpdates.single.orientation, isNull);
    });

    test('неизвестная ориентация отклоняется без записи', () async {
      final r = await orientation(cardId: 'c1', orientation: 'diagonal');

      expect(r, isA<Error<bool>>());
      expect(
        (r as Error<bool>).failure.message,
        contains('Неизвестная ориентация'),
      );
      expect(repo.calls, isEmpty);
    });

    test('ошибка репозитория — Error', () async {
      repo.error = Exception('db down');

      expect(
        await orientation(cardId: 'c1', orientation: 'portrait'),
        isA<Error<bool>>(),
      );
    });
  });
}
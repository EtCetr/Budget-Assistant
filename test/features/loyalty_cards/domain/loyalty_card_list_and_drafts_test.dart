import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/loyalty_cards/data/seeds/default_popular_stores_seed.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card_form_draft.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/popular_store.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/get_loyalty_cards_stats_usecase.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/loyalty_card_draft_usecases.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/watch_loyalty_cards_usecase.dart';
import '../../../helpers/fake_loyalty_cards_repository.dart';

/// Этап 24: сводка, watch-делегирование (все фильтры в SQL, D20-2),
/// черновики формы и пресеты популярных магазинов.
void main() {
  late FakeLoyaltyCardsRepository repo;
  late Logger logger;
  late GetLoyaltyCardsStatsUseCase stats;
  late WatchLoyaltyCardsUseCase watch;
  late SaveLoyaltyCardDraftUseCase saveDraft;
  late RestoreLoyaltyCardDraftUseCase restoreDraft;
  late ClearLoyaltyCardDraftUseCase clearDraft;

  setUp(() {
    repo = FakeLoyaltyCardsRepository();
    logger = Logger(level: Level.off);
    stats = GetLoyaltyCardsStatsUseCase(repo: repo, logger: logger);
    watch = WatchLoyaltyCardsUseCase(repo: repo, logger: logger);
    saveDraft = SaveLoyaltyCardDraftUseCase(repo: repo, logger: logger);
    restoreDraft = RestoreLoyaltyCardDraftUseCase(repo: repo, logger: logger);
    clearDraft = ClearLoyaltyCardDraftUseCase(repo: repo, logger: logger);
  });

  group('Сводка', () {
    test('значения приходят из репозитория', () async {
      repo.statsResult =
          const LoyaltyCardsStats(total: 7, favorites: 2, family: 3);

      final s = await stats(userId: 'u1');

      expect(s.total, 7);
      expect(s.favorites, 2);
      expect(s.family, 3);
      expect(repo.lastUserId, 'u1');
    });

    test('пространство пробрасывается', () async {
      await stats(userId: 'u1', spaceId: 's1');

      expect(repo.lastSpaceId, 's1');
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(stats(userId: 'u1'), throwsA(isA<Exception>()));
    });
  });

  group('Watch списка', () {
    test('все фильтры уходят в репозиторий одним вызовом', () async {
      repo.cards['c1'] = makeCard(id: 'c1');

      final list = await watch(
        userId: 'u1',
        spaceId: 's1',
        scope: LoyaltyCardsScope.family,
        categoryFilter: LoyaltyCardCategoryFilter.pharmacy,
        onlyFavorite: true,
        searchQuery: 'лента',
      ).first;

      expect(list.length, 1);
      expect(repo.calls, ['watchCards']);
      expect(repo.lastScope, LoyaltyCardsScope.family);
      expect(repo.lastCategoryFilter, LoyaltyCardCategoryFilter.pharmacy);
      expect(repo.lastOnlyFavorite, isTrue);
      expect(repo.lastSearchQuery, 'лента');
      expect(repo.lastSpaceId, 's1');
    });

    test('значения по умолчанию: все категории, без избранного, без поиска',
        () async {
      await watch(userId: 'u1', scope: LoyaltyCardsScope.personal).first;

      expect(repo.lastCategoryFilter, LoyaltyCardCategoryFilter.all);
      expect(repo.lastOnlyFavorite, isFalse);
      expect(repo.lastSearchQuery, '');
      expect(repo.lastSpaceId, isNull);
    });

    test('ошибка репозитория пробрасывается синхронно', () {
      repo.error = Exception('db down');

      expect(
        () => watch(userId: 'u1', scope: LoyaltyCardsScope.personal),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Черновики формы', () {
    test('сохранение черновика', () async {
      final r = await saveDraft(
        userId: 'u1',
        draft: makeCardDraft(storeName: 'Лента'),
      );

      expect(r, isA<Success<bool>>());
      expect(repo.draft?.storeName, 'Лента');
    });

    test('ошибка сохранения — Error, наружу не летит', () async {
      repo.error = Exception('db down');

      final r = await saveDraft(userId: 'u1', draft: makeCardDraft());

      expect(r, isA<Error<bool>>());
      expect((r as Error<bool>).failure.message, contains('черновик'));
    });

    test('восстановление свежего черновика', () async {
      await saveDraft(userId: 'u1', draft: makeCardDraft(cardId: 'c1'));

      final r = await restoreDraft('u1');

      expect((r as Success<LoyaltyCardFormDraft?>).value?.cardId, 'c1');
    });

    test('черновика нет — успех с null', () async {
      final r = await restoreDraft('u1');

      expect(r, isA<Success<LoyaltyCardFormDraft?>>());
      expect((r as Success<LoyaltyCardFormDraft?>).value, isNull);
    });

    test('ошибка чтения — Error', () async {
      repo.error = Exception('db down');

      expect(await restoreDraft('u1'), isA<Error<LoyaltyCardFormDraft?>>());
    });

    test('очистка удаляет черновик', () async {
      await saveDraft(userId: 'u1', draft: makeCardDraft());

      final r = await clearDraft('u1');

      expect(r, isA<Success<bool>>());
      expect(repo.draft, isNull);
    });

    test('ошибка очистки — Error', () async {
      repo.error = Exception('db down');

      expect(await clearDraft('u1'), isA<Error<bool>>());
    });
  });

  group('Пресеты магазинов', () {
    test('полная карта сида превращается в пресет', () {
      final store = PopularStore.fromSeedMap({
        PopularStoreKeys.name: 'Лента',
        PopularStoreKeys.brandColor: '#003DA5',
        PopularStoreKeys.iconEmoji: '🛒',
        PopularStoreKeys.category: 'grocery',
      });

      expect(store.name, 'Лента');
      expect(store.brandColor, '#003DA5');
      expect(store.iconEmoji, '🛒');
      expect(store.category, LoyaltyCardCategory.grocery);
    });

    test('неизвестная категория откатывается в other', () {
      final store = PopularStore.fromSeedMap({
        PopularStoreKeys.name: 'Магазин',
        PopularStoreKeys.category: 'unknown_category',
      });

      expect(store.category, LoyaltyCardCategory.other);
    });

    test('пустая карта даёт безопасные значения по умолчанию', () {
      final store = PopularStore.fromSeedMap(const {});

      expect(store.name, '');
      expect(store.brandColor, '#000000');
      expect(store.iconEmoji, '💳');
      expect(store.category, LoyaltyCardCategory.other);
    });
  });
}
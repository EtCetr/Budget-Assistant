import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/loyalty_card.dart';
import 'loyalty_cards_usecase_providers.dart';

/// Состояние чипов-фильтров (Правило 20-2: чипы и сброс живут в одном нотифаере).
/// Single-select: избранное ИЛИ категория (ТЗ 6.3.19.5).
class LoyaltyCardsFilterState {
  const LoyaltyCardsFilterState({
    this.favorite = false,
    this.category = LoyaltyCardCategoryFilter.all,
  });

  final bool favorite;
  final LoyaltyCardCategoryFilter category;

  bool get isEmpty => !favorite && category == LoyaltyCardCategoryFilter.all;
}

class LoyaltyCardsFilterNotifier extends Notifier<LoyaltyCardsFilterState> {
  @override
  LoyaltyCardsFilterState build() => const LoyaltyCardsFilterState();

  void toggleFavorite() {
    state = LoyaltyCardsFilterState(favorite: !state.favorite);
  }

  /// Повторный тап по активному чипу сбрасывает фильтр (Правило 20-1).
  void selectCategory(LoyaltyCardCategoryFilter c) {
    state = state.category == c
        ? const LoyaltyCardsFilterState()
        : LoyaltyCardsFilterState(category: c);
  }

  void reset() => state = const LoyaltyCardsFilterState();
}

final loyaltyCardsFilterProvider =
    NotifierProvider<LoyaltyCardsFilterNotifier, LoyaltyCardsFilterState>(
  LoyaltyCardsFilterNotifier.new,
);

/// Область видимости списка (ТЗ 6.3.19.3), дефолт — семейная.
class LoyaltyCardsScopeNotifier extends Notifier<LoyaltyCardsScope> {
  @override
  LoyaltyCardsScope build() => LoyaltyCardsScope.family;

  void set(LoyaltyCardsScope scope) => state = scope;
}

final loyaltyCardsScopeProvider =
    NotifierProvider<LoyaltyCardsScopeNotifier, LoyaltyCardsScope>(
  LoyaltyCardsScopeNotifier.new,
);

/// Поиск с debounce 300 мс (ТЗ 6.3.19.4).
class LoyaltyCardsSearchNotifier extends Notifier<String> {
  Timer? _timer;

  @override
  String build() {
    ref.onDispose(() => _timer?.cancel());
    return '';
  }

  void set(String value) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () => state = value);
  }

  void clear() => set('');
}

final loyaltyCardsSearchProvider =
    NotifierProvider<LoyaltyCardsSearchNotifier, String>(
  LoyaltyCardsSearchNotifier.new,
);

/// Список карт: scope + фильтры + поиск уходят в SQL WHERE (DECISIONS).
final loyaltyCardsListProvider =
    StreamProvider.autoDispose<List<LoyaltyCard>>((ref) {
  final scope = ref.watch(loyaltyCardsScopeProvider);
  final filter = ref.watch(loyaltyCardsFilterProvider);
  final search = ref.watch(loyaltyCardsSearchProvider);
  final userId = ref.watch(currentUserIdProvider);
  final spaceId = ref.watch(currentSpaceIdProvider);
  return ref.watch(watchLoyaltyCardsUseCaseProvider).call(
        userId: userId,
        spaceId: spaceId,
        scope: scope,
        categoryFilter: filter.category,
        onlyFavorite: filter.favorite,
        searchQuery: search,
      );
});

/// Сводка (ТЗ 6.3.19.6); пересчитывается при изменении списка.
final loyaltyCardsStatsProvider =
    FutureProvider.autoDispose<LoyaltyCardsStats>((ref) async {
  ref.watch(loyaltyCardsListProvider);
  final userId = ref.watch(currentUserIdProvider);
  final spaceId = ref.watch(currentSpaceIdProvider);
  return ref
      .watch(getLoyaltyCardsStatsUseCaseProvider)
      .call(userId: userId, spaceId: spaceId);
});
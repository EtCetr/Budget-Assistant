import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../data/seeds/default_popular_stores_seed.dart';
import '../../domain/entities/loyalty_card.dart';
import '../../domain/entities/loyalty_card_form_data.dart';
import '../../domain/entities/loyalty_card_form_draft.dart';
import '../../domain/entities/popular_store.dart';
import 'loyalty_cards_usecase_providers.dart';

/// Популярные магазины: app_settings.popular_stores_json [LOCAL],
/// при пустой настройке — сид из ТЗ 6.3.20.13.5.
final popularStoresProvider = FutureProvider<List<PopularStore>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  try {
    final dao = AppSettingsDao(ref.watch(appDatabaseProvider));
    final row = await dao.getForUser(userId);
    final raw = row.popularStoresJson;
    if (raw == null || raw.isEmpty || raw == '[]') {
      return [
        for (final m in DefaultPopularStoresSeed.stores)
          PopularStore.fromSeedMap(m),
      ];
    }
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return [
      for (final m in list)
        PopularStore.fromSeedMap(m.map((k, v) => MapEntry(k, v.toString()))),
    ];
  } catch (_) {
    return [
      for (final m in DefaultPopularStoresSeed.stores)
        PopularStore.fromSeedMap(m),
    ];
  }
});

/// Состояние формы добавления/редактирования + автосейв черновика
/// каждые 5 сек (ТЗ 6.3.20.13.10). Вся логика — здесь, не в UI.
class AddLoyaltyCardFormNotifier extends Notifier<LoyaltyCardFormData> {
  Timer? _draftTimer;
  bool _dirty = false;

  @override
  LoyaltyCardFormData build() {
    ref.onDispose(() => _draftTimer?.cancel());
    return const LoyaltyCardFormData();
  }

  void loadFromCard(LoyaltyCard c) {
    state = LoyaltyCardFormData(
      cardId: c.id,
      storeName: c.storeName,
      barcodeType: c.barcodeType,
      barcodeData: c.barcodeData,
      brandColor: c.brandColor,
      iconAsset: c.iconAsset,
      category: c.category,
      visibility: c.spaceId != null ? 'family' : 'personal',
    );
  }

  void loadFromDraft(LoyaltyCardFormDraft d) {
    state = LoyaltyCardFormData(
      cardId: d.cardId,
      storeName: d.storeName,
      barcodeType: BarcodeType.values.firstWhere(
        (t) => t.name == d.barcodeType,
        orElse: () => BarcodeType.manual,
      ),
      barcodeData: d.barcodeData,
      brandColor: d.brandColor,
      iconAsset: d.iconAsset,
      category: LoyaltyCardCategory.values.firstWhere(
        (c) => c.name == d.category,
        orElse: () => LoyaltyCardCategory.other,
      ),
      visibility: d.visibility,
    );
  }

  void reset() => state = const LoyaltyCardFormData();

  void setStoreName(String v) {
    state = state.copyWith(storeName: v);
    _dirty = true;
  }

  void setBarcodeData(String v) {
    state = state.copyWith(barcodeData: v);
    _dirty = true;
  }

  void setBarcodeType(BarcodeType t) {
    state = state.copyWith(barcodeType: t);
    _dirty = true;
  }

  void setCategory(LoyaltyCardCategory c) {
    state = state.copyWith(category: c);
    _dirty = true;
  }

  void setBrandColor(String? color) {
    state = state.copyWith(brandColor: color);
    _dirty = true;
  }

  void setIconAsset(String? icon) {
    state = state.copyWith(iconAsset: icon);
    _dirty = true;
  }

  void setVisibility(String v) {
    state = state.copyWith(visibility: v);
    _dirty = true;
  }

  void applyPopularStore(PopularStore s) {
    state = state.copyWith(
      storeName: s.name,
      brandColor: s.brandColor,
      iconAsset: s.iconEmoji,
      category: s.category,
    );
    _dirty = true;
  }

  /// Автосейв черновика каждые 5 сек при наличии изменений.
  void startDraftAutosave(String userId) {
    _draftTimer?.cancel();
    _draftTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_dirty) return;
      _dirty = false;
      final s = state;
      final draft = LoyaltyCardFormDraft(
        cardId: s.cardId,
        storeName: s.storeName,
        barcodeType: s.barcodeType.name,
        barcodeData: s.barcodeData,
        category: s.category.name,
        brandColor: s.brandColor,
        iconAsset: s.iconAsset,
        visibility: s.visibility,
        updatedAt: DateTime.now().toUtc(),
      );
      await ref
          .read(saveLoyaltyCardDraftUseCaseProvider)
          .call(userId: userId, draft: draft);
    });
  }

  Future<void> stopAutosaveAndClearDraft(String userId) async {
    _draftTimer?.cancel();
    await ref.read(clearLoyaltyCardDraftUseCaseProvider).call(userId);
  }
}

final addLoyaltyCardFormProvider =
    NotifierProvider<AddLoyaltyCardFormNotifier, LoyaltyCardFormData>(
  AddLoyaltyCardFormNotifier.new,
);
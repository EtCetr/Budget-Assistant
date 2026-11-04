import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/seeds/default_popular_stores_seed.dart';
import 'loyalty_card.dart';

part 'popular_store.freezed.dart';

/// Пресет популярного магазина (ТЗ 6.3.20.13.5): подставляет имя,
/// бренд-цвет, эмодзи и категорию одним тапом.
@freezed
abstract class PopularStore with _$PopularStore {
  const factory PopularStore({
    required String name,
    required String brandColor,
    required String iconEmoji,
    required LoyaltyCardCategory category,
  }) = _PopularStore;

  static PopularStore fromSeedMap(Map<String, String> m) => PopularStore(
        name: m[PopularStoreKeys.name] ?? '',
        brandColor: m[PopularStoreKeys.brandColor] ?? '#000000',
        iconEmoji: m[PopularStoreKeys.iconEmoji] ?? '💳',
        category: LoyaltyCardCategory.values.firstWhere(
          (c) => c.name == m[PopularStoreKeys.category],
          orElse: () => LoyaltyCardCategory.other,
        ),
      );
}
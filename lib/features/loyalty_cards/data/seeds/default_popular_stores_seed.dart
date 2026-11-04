import 'dart:convert';

/// Популярные магазины (ТЗ 6.3.20.13.5).
///
/// Хранятся в app_settings.popular_stores_json — локальный JSON [LOCAL],
/// НЕ синхронизируется. Пока настройка пустая, используется этот сид.
abstract final class PopularStoreKeys {
  static const String name = 'name';
  static const String brandColor = 'default_brand_color';
  static const String iconEmoji = 'default_icon_emoji';
  static const String category = 'default_category';
}

abstract final class DefaultPopularStoresSeed {
  static const List<Map<String, String>> stores = [
    {
      'name': 'Пятёрочка',
      'default_brand_color': '#E30613',
      'default_icon_emoji': '🛒',
      'default_category': 'grocery',
    },
    {
      'name': 'Магнит',
      'default_brand_color': '#FF0000',
      'default_icon_emoji': '🛒',
      'default_category': 'grocery',
    },
    {
      'name': 'Перекрёсток',
      'default_brand_color': '#FF6600',
      'default_icon_emoji': '🛒',
      'default_category': 'grocery',
    },
    {
      'name': 'Лента',
      'default_brand_color': '#0057A6',
      'default_icon_emoji': '🛒',
      'default_category': 'grocery',
    },
    {
      'name': 'Ашан',
      'default_brand_color': '#E60000',
      'default_icon_emoji': '🛒',
      'default_category': 'grocery',
    },
    {
      'name': 'ВкусВилл',
      'default_brand_color': '#22B246',
      'default_icon_emoji': '🛒',
      'default_category': 'grocery',
    },
    {
      'name': 'Ригла',
      'default_brand_color': '#00A3E1',
      'default_icon_emoji': '💊',
      'default_category': 'pharmacy',
    },
    {
      'name': '36.6',
      'default_brand_color': '#E4002B',
      'default_icon_emoji': '💊',
      'default_category': 'pharmacy',
    },
    {
      'name': 'Zara',
      'default_brand_color': '#000000',
      'default_icon_emoji': '👕',
      'default_category': 'clothing',
    },
    {
      'name': 'H&M',
      'default_brand_color': '#E50010',
      'default_icon_emoji': '👕',
      'default_category': 'clothing',
    },
    {
      'name': 'Лукойл',
      'default_brand_color': '#E31E24',
      'default_icon_emoji': '⛽',
      'default_category': 'fuel',
    },
    {
      'name': 'Газпромнефть',
      'default_brand_color': '#0079C2',
      'default_icon_emoji': '⛽',
      'default_category': 'fuel',
    },
  ];

  /// JSON для записи в app_settings.popular_stores_json.
  static String toJsonString() => jsonEncode(stores);
}
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../domain/entities/loyalty_card.dart';

/// Метаданные категорий карт для UI (иконка/цвет/подпись).
abstract final class LoyaltyCardCategoryUi {
  static IconData icon(LoyaltyCardCategory c) => switch (c) {
        LoyaltyCardCategory.grocery => Icons.shopping_cart_outlined,
        LoyaltyCardCategory.pharmacy => Icons.local_pharmacy_outlined,
        LoyaltyCardCategory.clothing => Icons.checkroom_outlined,
        LoyaltyCardCategory.fuel => Icons.local_gas_station_outlined,
        LoyaltyCardCategory.other => Icons.storefront_outlined,
      };

  static Color color(LoyaltyCardCategory c) => switch (c) {
        LoyaltyCardCategory.grocery => AppColors.colorIncome,
        LoyaltyCardCategory.pharmacy => const Color(0xFF14B8A6),
        LoyaltyCardCategory.clothing => const Color(0xFFA855F7),
        LoyaltyCardCategory.fuel => AppColors.colorExpense,
        LoyaltyCardCategory.other => AppColors.textSecondary,
      };

  static String label(LoyaltyCardCategory c) => switch (c) {
        LoyaltyCardCategory.grocery => 'Продукты',
        LoyaltyCardCategory.pharmacy => 'Аптеки',
        LoyaltyCardCategory.clothing => 'Одежда',
        LoyaltyCardCategory.fuel => 'АЗС',
        LoyaltyCardCategory.other => 'Другое',
      };

  static IconData filterIcon(LoyaltyCardCategoryFilter f) => switch (f) {
        LoyaltyCardCategoryFilter.all => Icons.tune,
        LoyaltyCardCategoryFilter.grocery => icon(LoyaltyCardCategory.grocery),
        LoyaltyCardCategoryFilter.pharmacy => icon(LoyaltyCardCategory.pharmacy),
        LoyaltyCardCategoryFilter.clothing => icon(LoyaltyCardCategory.clothing),
        LoyaltyCardCategoryFilter.fuel => icon(LoyaltyCardCategory.fuel),
        LoyaltyCardCategoryFilter.other => icon(LoyaltyCardCategory.other),
      };

  static Color filterColor(LoyaltyCardCategoryFilter f) => switch (f) {
        LoyaltyCardCategoryFilter.all => AppColors.textSecondary,
        LoyaltyCardCategoryFilter.grocery => color(LoyaltyCardCategory.grocery),
        LoyaltyCardCategoryFilter.pharmacy => color(LoyaltyCardCategory.pharmacy),
        LoyaltyCardCategoryFilter.clothing => color(LoyaltyCardCategory.clothing),
        LoyaltyCardCategoryFilter.fuel => color(LoyaltyCardCategory.fuel),
        LoyaltyCardCategoryFilter.other => color(LoyaltyCardCategory.other),
      };

  static String filterLabel(LoyaltyCardCategoryFilter f) => switch (f) {
        LoyaltyCardCategoryFilter.all => 'Все',
        LoyaltyCardCategoryFilter.grocery => label(LoyaltyCardCategory.grocery),
        LoyaltyCardCategoryFilter.pharmacy => label(LoyaltyCardCategory.pharmacy),
        LoyaltyCardCategoryFilter.clothing => label(LoyaltyCardCategory.clothing),
        LoyaltyCardCategoryFilter.fuel => label(LoyaltyCardCategory.fuel),
        LoyaltyCardCategoryFilter.other => label(LoyaltyCardCategory.other),
      };
}
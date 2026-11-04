import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../domain/entities/product_analytics_models.dart';
import '../labels/product_analytics_strings.dart';

/// Метаданные тренда цены для UI (цвет/иконка/подпись).
abstract final class TrendUi {
  static Color color(PriceTrend t) => switch (t) {
        PriceTrend.rising => AppColors.colorExpense,
        PriceTrend.falling => AppColors.colorIncome,
        PriceTrend.stable => AppColors.textSecondary,
      };

  static IconData icon(PriceTrend t) => switch (t) {
        PriceTrend.rising => Icons.trending_up,
        PriceTrend.falling => Icons.trending_down,
        PriceTrend.stable => Icons.trending_flat,
      };

  static String label(PriceTrend t) => switch (t) {
        PriceTrend.rising => ProductAnalyticsStrings.trendRising,
        PriceTrend.falling => ProductAnalyticsStrings.trendFalling,
        PriceTrend.stable => ProductAnalyticsStrings.trendStable,
      };
}
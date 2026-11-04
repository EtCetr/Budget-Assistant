import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';

/// Сводка: всего / избранных / семейных (ТЗ 6.3.19.6).
/// Счётчики видны во всех privacy-режимах (метаданные).
class LoyaltyCardsStatsSummary extends StatelessWidget {
  const LoyaltyCardsStatsSummary({super.key, required this.stats});

  final AsyncValue<LoyaltyCardsStats> stats;

  @override
  Widget build(BuildContext context) {
    final s = stats.value;
    return Container(
      margin: const EdgeInsets.all(AppSpacing.spacing16),
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _counter(LoyaltyCardsStrings.statsTotal,
              s?.total.toString() ?? '—', AppColors.textPrimary),
          _counter(LoyaltyCardsStrings.statsFavorites,
              s?.favorites.toString() ?? '—', AppColors.colorWarning),
          _counter(LoyaltyCardsStrings.statsFamily,
              s?.family.toString() ?? '—', AppColors.colorIncome),
        ],
      ),
    );
  }

  Widget _counter(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
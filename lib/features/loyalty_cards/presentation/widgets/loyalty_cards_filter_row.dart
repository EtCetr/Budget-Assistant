import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';
import '../providers/loyalty_cards_providers.dart';
import 'loyalty_cards_category_ui.dart';

/// Чипы фильтров: избранное + категории. Single-select, сброс повторным
/// тапом (Правило 20). В hidden все чипы серые (ТЗ 6.3.19.5).
class LoyaltyCardsFilterRow extends ConsumerWidget {
  const LoyaltyCardsFilterRow({super.key});

  static const List<LoyaltyCardCategoryFilter> _categories = [
    LoyaltyCardCategoryFilter.grocery,
    LoyaltyCardCategoryFilter.pharmacy,
    LoyaltyCardCategoryFilter.clothing,
    LoyaltyCardCategoryFilter.fuel,
    LoyaltyCardCategoryFilter.other,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(loyaltyCardsFilterProvider);
    final mode = ref.watch(privacyModeProvider);
    final gray = mode == BalanceVisibilityMode.hidden;
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
        children: [
          _chip(
            label: LoyaltyCardsStrings.filterFavorite,
            icon: Icons.star_outline,
            selected: filter.favorite,
            color: gray ? AppColors.textSecondary : AppColors.colorWarning,
            onTap: () {
              MotionTokens.selection();
              ref.read(loyaltyCardsFilterProvider.notifier).toggleFavorite();
            },
          ),
          for (final c in _categories)
            _chip(
              label: LoyaltyCardCategoryUi.filterLabel(c),
              icon: LoyaltyCardCategoryUi.filterIcon(c),
              selected: filter.category == c,
              color: gray
                  ? AppColors.textSecondary
                  : LoyaltyCardCategoryUi.filterColor(c),
              onTap: () {
                MotionTokens.selection();
                ref
                    .read(loyaltyCardsFilterProvider.notifier)
                    .selectCategory(c);
              },
            ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required IconData icon,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.spacing8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.white : color),
            const SizedBox(width: AppSpacing.spacing4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        selected: selected,
        showCheckmark: false,
        selectedColor: color,
        backgroundColor: AppColors.surfaceCard,
        side: const BorderSide(color: AppColors.borderDivider),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
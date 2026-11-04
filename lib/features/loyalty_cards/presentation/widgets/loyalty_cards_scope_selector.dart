import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';
import '../providers/loyalty_cards_providers.dart';

/// Селектор области: личные / семейные (ТЗ 6.3.19.3).
class LoyaltyCardsScopeSelector extends ConsumerWidget {
  const LoyaltyCardsScopeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(loyaltyCardsScopeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
      child: Row(
        children: [
          _segment(
            label: LoyaltyCardsStrings.scopePersonal,
            icon: Icons.lock_outline,
            active: scope == LoyaltyCardsScope.personal,
            activeColor: AppColors.colorTransfer,
            onTap: () {
              MotionTokens.selection();
              ref.read(loyaltyCardsScopeProvider.notifier).set(
                    LoyaltyCardsScope.personal,
                  );
            },
          ),
          const SizedBox(width: AppSpacing.spacing8),
          _segment(
            label: LoyaltyCardsStrings.scopeFamily,
            icon: Icons.family_restroom,
            active: scope == LoyaltyCardsScope.family,
            activeColor: AppColors.colorIncome,
            onTap: () {
              MotionTokens.selection();
              ref
                  .read(loyaltyCardsScopeProvider.notifier)
                  .set(LoyaltyCardsScope.family);
            },
          ),
        ],
      ),
    );
  }

  Widget _segment({
    required String label,
    required IconData icon,
    required bool active,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: AppRadius.radiusFull,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing12,
            vertical: AppSpacing.spacing8,
          ),
          decoration: BoxDecoration(
            color: active ? activeColor : AppColors.surfaceCard,
            borderRadius: AppRadius.radiusFull,
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: active ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: AppSpacing.spacing8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: active ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../loyalty_cards_strings.dart';
import '../providers/loyalty_cards_providers.dart';

/// Раскрывающийся поиск по store_name (открытое поле, ТЗ 6.3.19.4).
class LoyaltyCardsSearchBar extends ConsumerWidget {
  const LoyaltyCardsSearchBar({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing8,
        AppSpacing.spacing16,
        0,
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.textPrimary),
        onChanged: (v) => ref.read(loyaltyCardsSearchProvider.notifier).set(v),
        decoration: InputDecoration(
          hintText: LoyaltyCardsStrings.searchHint,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () {
                  controller.clear();
                  ref.read(loyaltyCardsSearchProvider.notifier).clear();
                },
              );
            },
          ),
          filled: true,
          fillColor: AppColors.surfaceElevated,
          border: const OutlineInputBorder(
            borderRadius: AppRadius.radiusFull,
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../../domain/entities/popular_store.dart';
import '../loyalty_cards_strings.dart';

/// Горизонтальный список популярных магазинов (ТЗ 6.3.20.13.5):
/// тап подставляет имя, цвет, эмодзи и категорию.
class PopularStoresRow extends StatelessWidget {
  const PopularStoresRow({super.key, required this.stores, required this.onTap});

  final List<PopularStore> stores;
  final ValueChanged<PopularStore> onTap;

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: AppSpacing.spacing4),
          child: Text(
            LoyaltyCardsStrings.popularLabel,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stores.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.spacing8),
            itemBuilder: (context, i) {
              final s = stores[i];
              return InkWell(
                borderRadius:
                    const BorderRadius.all(Radius.circular(12)),
                onTap: () {
                  MotionTokens.selection();
                  onTap(s);
                },
                child: Container(
                  width: 72,
                  padding: const EdgeInsets.all(AppSpacing.spacing8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: AppColors.borderDivider),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(s.iconEmoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: AppSpacing.spacing4),
                      Text(
                        s.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
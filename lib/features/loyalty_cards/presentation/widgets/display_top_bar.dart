import 'package:flutter/material.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';

/// Полупрозрачная панель поверх контента (ТЗ 6.3.21.3).
/// Видимость управляет экран (auto-hide 3 сек).
class DisplayTopBar extends StatelessWidget {
  const DisplayTopBar({
    super.key,
    required this.card,
    required this.onClose,
    required this.onRotate,
    required this.onEdit,
  });

  final LoyaltyCard card;
  final VoidCallback onClose;
  final VoidCallback onRotate;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xB3000000),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
            label: const Text(
              LoyaltyCardsStrings.displayClose,
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Spacer(),
          if (card.syncStatus == SyncStatus.pending)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.cloud_off,
                  color: AppColors.colorPendingSync, size: 18),
            ),
          TextButton.icon(
            onPressed: onRotate,
            icon: const Icon(Icons.screen_rotation_outlined,
                color: Colors.white),
            label: const Text(
              LoyaltyCardsStrings.displayRotate,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            label: const Text(
              LoyaltyCardsStrings.displayEdit,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
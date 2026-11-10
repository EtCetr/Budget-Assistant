import 'package:flutter/material.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';

/// Long-press меню карты (ТЗ 6.3.19.8): 5 действий + контекстные.
/// Возвращает код действия; выполнение — в экране (UseCases).
/// Этап 22 (ТЗ 6.10.5): альтернатива drag-and-drop — «Переместить вверх/вниз».
/// Пункты перемещения показываются только если переданы onMoveUp/onMoveDown.
class LoyaltyCardLongPressMenu extends StatelessWidget {
  const LoyaltyCardLongPressMenu({
    super.key,
    required this.card,
    required this.isCreator,
    this.onMoveUp,
    this.onMoveDown,
  });

  final LoyaltyCard card;
  final bool isCreator;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isCreator)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text(LoyaltyCardsStrings.menuOpen),
              onTap: () => Navigator.pop(context, 'open'),
            )
          else
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text(LoyaltyCardsStrings.menuOpen),
              onTap: () => Navigator.pop(context, 'open'),
            ),
          if (isCreator)
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text(LoyaltyCardsStrings.menuEdit),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
          ListTile(
            leading: Icon(
              card.isFavorite ? Icons.star_border : Icons.star_outline),
            title: Text(card.isFavorite
                ? LoyaltyCardsStrings.menuFavoriteRemove
                : LoyaltyCardsStrings.menuFavoriteAdd),
            onTap: () => Navigator.pop(context, 'favorite'),
          ),
          // Этап 22: альтернатива drag-and-drop для TalkBack.
          if (onMoveUp != null)
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text('Переместить вверх'),
              onTap: () => Navigator.pop(context, 'move_up'),
            ),
          if (onMoveDown != null)
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text('Переместить вниз'),
              onTap: () => Navigator.pop(context, 'move_down'),
            ),
          if (isCreator)
            ListTile(
              leading: Icon(card.isShared
                  ? Icons.lock_outline
                  : Icons.family_restroom),
              title: Text(card.isShared
                  ? LoyaltyCardsStrings.menuMakePersonal
                  : LoyaltyCardsStrings.menuShareFamily),
              onTap: () => Navigator.pop(context, 'shared'),
            ),
          if (isCreator)
            ListTile(
              leading: const Icon(Icons.delete_outline,
                  color: Colors.redAccent),
              title: const Text(LoyaltyCardsStrings.menuDelete),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
        ],
      ),
    );
  }
}
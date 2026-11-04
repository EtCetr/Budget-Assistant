import 'package:flutter/material.dart';
import '../loyalty_cards_strings.dart';

/// Временные заглушки маршрутов добавления/показа карты.
/// TODO(20.4): заменить AddLoyaltyCardStubScreen на AddLoyaltyCardScreen
///   (файл add_loyalty_card_screen.dart, спека 6.3.20).
/// TODO(20.5): заменить LoyaltyCardDisplayStubScreen на
///   LoyaltyCardDisplayScreen (файл loyalty_card_display_screen.dart, спека 6.3.21).
class AddLoyaltyCardStubScreen extends StatelessWidget {
  const AddLoyaltyCardStubScreen({super.key, this.cardId});

  final String? cardId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cardId == null
            ? LoyaltyCardsStrings.addCard
            : LoyaltyCardsStrings.editTitle),
      ),
      body: const Center(child: Text(LoyaltyCardsStrings.stubAdd)),
    );
  }
}

class LoyaltyCardDisplayStubScreen extends StatelessWidget {
  const LoyaltyCardDisplayStubScreen({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(LoyaltyCardsStrings.stubDisplay)),
    );
  }
}